import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:system_tray/system_tray.dart';
import 'app.dart';
import 'services/services.dart';
import 'screens/screens.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final systemTray = SystemTray();
final menu = Menu();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hotKeyManager.unregisterAll();

  await StorageService.instance.initialize();

  await windowManager.ensureInitialized();

  double height = 900;
  try {
    final display = ui.PlatformDispatcher.instance.displays.first;
    height = (display.size.height / display.devicePixelRatio) * 0.8;
  } catch (_) {}

  final windowOptions = WindowOptions(
    size: Size(700, height),
    center: true,
    skipTaskbar: false,
    title: 'What is',
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.hide();
  });

  await _initializeSystemTray();
  
  // Add window listener
  windowManager.addListener(TrayWindowListener());

  final apiKey = await StorageService.instance.getApiKey();
  if (apiKey != null && apiKey.isNotEmpty) {
    try {
      final provider = StorageService.instance.getProviderType();
      await AIService.instance.initializeProvider(apiKey, providerType: provider);
    } catch (e) {
      debugPrint('Failed to initialize AI service: $e');
    }
  }

  await HotkeyService.instance.registerAllHotkeys();

  final isOnboardingComplete = StorageService.instance.isOnboardingComplete();
  
  runApp(WhatIsApp(showOnboarding: !isOnboardingComplete));
}

Future<void> _initializeSystemTray() async {
  String iconPath = r'c:\Users\wisam\Desktop\what_is\windows\runner\resources\app_icon.ico';
  final appDir = File(Platform.resolvedExecutable).parent;
  final neighborPath = '${appDir.path}\\app_icon.ico';

  if (File(neighborPath).existsSync()) {
    iconPath = neighborPath;
  }

  await systemTray.initSystemTray(
    title: 'What is',
    iconPath: iconPath,
    toolTip: 'What is - AI Assistant',
  );

  await updateSystemTrayMenu(false);

  systemTray.registerSystemTrayEventHandler((eventName) {
    if (eventName == kSystemTrayEventClick) {
      windowManager.show();
      windowManager.focus();
    }
  });
}

Future<void> updateSystemTrayMenu(bool isVisible) async {
  await menu.buildFrom([
    MenuItemLabel(
      label: isVisible ? 'Hide' : 'Show',
      onClicked: (menuItem) async {
        if (isVisible) {
          await windowManager.hide();
        } else {
          await windowManager.show();
          await windowManager.focus();
        }
        await updateSystemTrayMenu(!isVisible);
      },
    ),
    MenuSeparator(),
    MenuItemLabel(
      label: 'Settings',
      onClicked: (menuItem) async {
        await windowManager.show();
        await windowManager.focus();
        await _showSettingsDialog();
      },
    ),
    MenuSeparator(),
    MenuItemLabel(
      label: 'Exit',
      onClicked: (menuItem) async {
        await HotkeyService.instance.unregisterAll();
        await windowManager.destroy();
        exit(0);
      },
    ),
  ]);

  await systemTray.setContextMenu(menu);
}

Future<void> _showSettingsDialog() async {
  final context = navigatorKey.currentContext;
  if (context != null) {
    await showDialog<bool>(
      context: context,
      builder: (context) => const SettingsScreen(),
    );
  }
}

class TrayWindowListener extends WindowListener {
  @override
  void onWindowFocus() {
    updateSystemTrayMenu(true);
  }

  @override
  void onWindowBlur() {
    // Optional: You might want to keep it as 'Hide' if it's just blurred but still visible.
    // But usually we track visibility. 
    // Since we don't have a direct visibility callback, we assume focus implies visibility.
    // We can check isVisible() but that's async.
    // For now, let's leave blur alone or check visibility.
    _checkVisibility();
  }

  @override
  void onWindowMinimize() {
    updateSystemTrayMenu(false);
  }

  @override
  void onWindowRestore() {
    updateSystemTrayMenu(true);
  }

  Future<void> _checkVisibility() async {
    final isVisible = await windowManager.isVisible();
    await updateSystemTrayMenu(isVisible);
  }
}
