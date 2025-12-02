import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:system_tray/system_tray.dart';
import 'app.dart';
import 'services/services.dart';
import 'screens/screens.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.instance.initialize();

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(700, 900),
    center: true,
    skipTaskbar: false,
    title: 'What is',
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.hide();
  });

  await _initializeSystemTray();

  final apiKey = await StorageService.instance.getApiKey();
  if (apiKey != null && apiKey.isNotEmpty) {
    try {
      await AIService.instance.initializeProvider(apiKey);
    } catch (e) {
      debugPrint('Failed to initialize AI service: $e');
    }
  }

  await HotkeyService.instance.registerAllHotkeys();

  final isOnboardingComplete = StorageService.instance.isOnboardingComplete();
  
  runApp(WhatIsApp(showOnboarding: !isOnboardingComplete));
}

Future<void> _initializeSystemTray() async {
  final systemTray = SystemTray();
  final appPath = Platform.resolvedExecutable;
  final iconPath = appPath.replaceAll('what_is.exe', 'data\\flutter_assets\\assets\\icon.png');

  await systemTray.initSystemTray(
    title: 'What is',
    iconPath: iconPath,
    toolTip: 'What is - AI Assistant',
  );

  final menu = Menu();
  
  await menu.buildFrom([
    MenuItemLabel(
      label: 'Show',
      onClicked: (menuItem) async {
        await windowManager.show();
        await windowManager.focus();
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
      label: 'Quit',
      onClicked: (menuItem) async {
        await HotkeyService.instance.unregisterAll();
        await windowManager.destroy();
        exit(0);
      },
    ),
  ]);

  await systemTray.setContextMenu(menu);

  systemTray.registerSystemTrayEventHandler((eventName) {
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

