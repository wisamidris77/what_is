import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../models/models.dart';
import 'clipboard_service.dart';

class HotkeyService {
  static final HotkeyService instance = HotkeyService._internal();
  factory HotkeyService() => instance;
  HotkeyService._internal();

  final List<HotKey> _registeredHotkeys = [];
  Function(AppMode)? onHotkeyPressed;

  Future<void> registerAllHotkeys() async {
    await _registerHotkey(
      key: KeyCode.keyC,
      modifiers: [KeyModifier.control, KeyModifier.meta],
      mode: AppMode.code,
    );

    await _registerHotkey(
      key: KeyCode.keyT,
      modifiers: [KeyModifier.control, KeyModifier.meta],
      mode: AppMode.translate,
    );

    await _registerHotkey(
      key: KeyCode.keyE,
      modifiers: [KeyModifier.control, KeyModifier.meta],
      mode: AppMode.explain,
    );
  }

  Future<void> _registerHotkey({
    required KeyCode key,
    required List<KeyModifier> modifiers,
    required AppMode mode,
  }) async {
    final hotkey = HotKey(key, modifiers: modifiers);
    
    await hotKeyManager.register(
      hotkey,
      keyDownHandler: (hotKey) async {
        await _handleHotkeyPress(mode);
      },
    );
    
    _registeredHotkeys.add(hotkey);
  }

  Future<void> _handleHotkeyPress(AppMode mode) async {
    await windowManager.show();
    await windowManager.focus();
    
    onHotkeyPressed?.call(mode);
    
    final clipboardText = await ClipboardService.instance.getClipboardText();
    if (clipboardText != null && clipboardText.isNotEmpty) {
      _clipboardCallback?.call(clipboardText);
    }
  }

  Function(String)? _clipboardCallback;

  void setClipboardCallback(Function(String) callback) {
    _clipboardCallback = callback;
  }

  Future<void> unregisterAll() async {
    for (final hotkey in _registeredHotkeys) {
      await hotKeyManager.unregister(hotkey);
    }
    _registeredHotkeys.clear();
  }
}


