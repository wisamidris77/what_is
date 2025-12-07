import 'dart:io';
import 'package:flutter/foundation.dart';

/// Service to detect platform capabilities and adjust features accordingly.
class PlatformService {
  static final PlatformService instance = PlatformService._internal();
  factory PlatformService() => instance;
  PlatformService._internal();

  /// Returns true if running on a desktop platform (Windows, macOS, Linux)
  bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Returns true if running on a mobile platform (Android, iOS)
  bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Returns true if running on web
  bool get isWeb => kIsWeb;

  /// Returns true if the platform supports system tray
  bool get supportsSystemTray => isDesktop;

  /// Returns true if the platform supports global hotkeys
  bool get supportsHotkeys => isDesktop;

  /// Returns true if the platform supports window management
  bool get supportsWindowManager => isDesktop;

  /// Returns the current platform name
  String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }
}
