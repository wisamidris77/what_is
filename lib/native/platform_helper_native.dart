// Native/Desktop implementation with actual window_manager, system_tray, hotkey logic
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:system_tray/system_tray.dart';
import 'platform_helper.dart';
import '../services/services.dart';
import '../screens/screens.dart';
import '../main.dart';

SystemTray? _systemTray;
Menu? _menu;

class PlatformHelperImpl implements PlatformHelper {
  @override
  bool get isDesktop => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  @override
  Future<void> initializePlatform() async {
    if (!isDesktop) return;

    await hotKeyManager.unregisterAll();
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
    
    windowManager.addListener(TrayWindowListener());

    await HotkeyService.instance.registerAllHotkeys();
  }

  @override
  Future<void> showWindow() async {
    if (!isDesktop) return;
    await windowManager.show();
    await windowManager.focus();
  }

  @override
  Future<void> hideWindow() async {
    if (!isDesktop) return;
    await windowManager.hide();
  }

  @override
  Future<void> focusWindow() async {
    if (!isDesktop) return;
    await windowManager.focus();
  }

  @override
  Future<void> destroyWindow() async {
    if (!isDesktop) return;
    await windowManager.destroy();
  }

  @override
  void addWindowListener(dynamic listener) {
    if (!isDesktop) return;
    if (listener is WindowListener) {
      windowManager.addListener(listener);
    }
  }

  @override
  Future<void> updateSystemTrayMenu(bool isVisible) async {
    if (!isDesktop) return;
    if (_menu == null || _systemTray == null) return;
    
    await _menu!.buildFrom([
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

    await _systemTray!.setContextMenu(_menu!);
  }

  @override
  Future<void> registerHotkeys() async {
    if (!isDesktop) return;
    await HotkeyService.instance.registerAllHotkeys();
  }

  @override
  Future<void> unregisterHotkeys() async {
    if (!isDesktop) return;
    await HotkeyService.instance.unregisterAll();
  }
}

Future<void> _initializeSystemTray() async {
  _systemTray = SystemTray();
  _menu = Menu();
  
  String iconPath = r'c:\Users\wisam\Desktop\what_is\windows\runner\resources\app_icon.ico';
  final appDir = File(Platform.resolvedExecutable).parent;
  final neighborPath = '${appDir.path}\\app_icon.ico';

  if (File(neighborPath).existsSync()) {
    iconPath = neighborPath;
  }

  await _systemTray!.initSystemTray(
    title: 'What is',
    iconPath: iconPath,
    toolTip: 'What is - AI Assistant',
  );

  await PlatformHelperImpl().updateSystemTrayMenu(false);

  _systemTray!.registerSystemTrayEventHandler((eventName) {
    if (eventName == kSystemTrayEventClick) {
      windowManager.show();
      windowManager.focus();
    }
  });
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
    PlatformHelperImpl().updateSystemTrayMenu(true);
  }

  @override
  void onWindowBlur() {
    _checkVisibility();
  }

  @override
  void onWindowMinimize() {
    PlatformHelperImpl().updateSystemTrayMenu(false);
  }

  @override
  void onWindowRestore() {
    PlatformHelperImpl().updateSystemTrayMenu(true);
  }

  Future<void> _checkVisibility() async {
    final isVisible = await windowManager.isVisible();
    await PlatformHelperImpl().updateSystemTrayMenu(isVisible);
  }
}

PlatformHelper getPlatformHelper() => PlatformHelperImpl();
