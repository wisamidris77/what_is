// Platform interface - defines the contract for platform-specific features

abstract class PlatformHelper {
  Future<void> initializePlatform();
  Future<void> showWindow();
  Future<void> hideWindow();
  Future<void> focusWindow();
  Future<void> destroyWindow();
  void addWindowListener(dynamic listener);
  Future<void> updateSystemTrayMenu(bool isVisible);
  Future<void> registerHotkeys();
  Future<void> unregisterHotkeys();
  bool get isDesktop;
}
