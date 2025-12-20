// Web stub implementation - empty logic for web platform
import 'platform_helper.dart';

class PlatformHelperImpl implements PlatformHelper {
  @override
  bool get isDesktop => false;

  @override
  Future<void> initializePlatform() async {}

  @override
  Future<void> showWindow() async {}

  @override
  Future<void> hideWindow() async {}

  @override
  Future<void> focusWindow() async {}

  @override
  Future<void> destroyWindow() async {}

  @override
  void addWindowListener(dynamic listener) {}

  @override
  Future<void> updateSystemTrayMenu(bool isVisible) async {}

  @override
  Future<void> registerHotkeys() async {}

  @override
  Future<void> unregisterHotkeys() async {}
}

PlatformHelper getPlatformHelper() => PlatformHelperImpl();
