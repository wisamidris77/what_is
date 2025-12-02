import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../models/models.dart';
import 'clipboard_service.dart';
import 'storage_service.dart';

class HotkeyService {
  static final HotkeyService instance = HotkeyService._internal();
  factory HotkeyService() => instance;
  HotkeyService._internal();

  final List<HotKey> _registeredHotkeys = [];
  Function(AppMode)? onHotkeyPressed;
  Function(String)? _clipboardCallback;

  void setClipboardCallback(Function(String) callback) {
    _clipboardCallback = callback;
  }

  Future<void> registerAllHotkeys() async {
    await hotKeyManager.unregisterAll();
    _registeredHotkeys.clear();

    await _registerAction('code', AppMode.code, defaultKey: KeyCode.keyC);
    await _registerAction('translate', AppMode.translate, defaultKey: KeyCode.keyT);
    await _registerAction('explain', AppMode.explain, defaultKey: KeyCode.keyE);
    await _registerPasteAction();
  }

  Future<void> _registerAction(String actionId, AppMode mode, {required KeyCode defaultKey}) async {
    final config = StorageService.instance.getHotkeyConfig(actionId);
    
    if (config != null && config['enabled'] == false) return;

    KeyCode key = defaultKey;
    List<KeyModifier> modifiers = [KeyModifier.control, KeyModifier.alt];

    if (config != null) {
      key = _parseKeyCode(config['keyCode']) ?? defaultKey;
      modifiers = _parseModifiers(config['modifiers']) ?? modifiers;
    }

    final hotkey = HotKey(key, modifiers: modifiers);
    
    await hotKeyManager.register(
      hotkey,
      keyDownHandler: (hotKey) async {
        await _handleHotkeyPress(mode, pasteClipboard: false);
      },
    );
    _registeredHotkeys.add(hotkey);
  }

  Future<void> _registerPasteAction() async {
    final config = StorageService.instance.getHotkeyConfig('paste');
    
    if (config != null && config['enabled'] == false) return;

    KeyCode key = KeyCode.keyV;
    List<KeyModifier> modifiers = [KeyModifier.control, KeyModifier.alt];

    if (config != null) {
      key = _parseKeyCode(config['keyCode']) ?? key;
      modifiers = _parseModifiers(config['modifiers']) ?? modifiers;
    }

    final hotkey = HotKey(key, modifiers: modifiers);

    await hotKeyManager.register(
      hotkey,
      keyDownHandler: (hotKey) async {
        await _handleHotkeyPress(null, pasteClipboard: true);
      },
    );
    _registeredHotkeys.add(hotkey);
  }

  Future<void> _handleHotkeyPress(AppMode? mode, {required bool pasteClipboard}) async {
    await windowManager.show();
    await windowManager.focus();
    
    if (mode != null) {
      onHotkeyPressed?.call(mode);
    }
    
    if (pasteClipboard) {
      final clipboardText = await ClipboardService.instance.getClipboardText();
      if (clipboardText != null && clipboardText.isNotEmpty) {
        _clipboardCallback?.call(clipboardText);
      }
    }
  }

  Future<void> unregisterAll() async {
    for (final hotkey in _registeredHotkeys) {
      await hotKeyManager.unregister(hotkey);
    }
    _registeredHotkeys.clear();
  }

  KeyCode? _parseKeyCode(String? keyName) {
    if (keyName == null) return null;
    try {
      return KeyCode.values.firstWhere((e) => e.name == keyName);
    } catch (_) {
      return null;
    }
  }

  List<KeyModifier>? _parseModifiers(List<dynamic>? modifierNames) {
    if (modifierNames == null) return null;
    try {
      return modifierNames.map((name) => KeyModifier.values.firstWhere((e) => e.name == name)).toList();
    } catch (_) {
      return null;
    }
  }
}
