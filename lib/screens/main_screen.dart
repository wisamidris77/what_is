import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _inputController = TextEditingController();
  final _inputFieldKey = GlobalKey<State<InputField>>();
  
  AppMode _currentMode = AppMode.code;
  bool _showOverlay = false;
  String _responseText = '';
  bool _isStreaming = false;
  bool _inputEnabled = true;

  @override
  void initState() {
    super.initState();
    
    HotkeyService.instance.onHotkeyPressed = _handleHotkeyPressed;
    HotkeyService.instance.setClipboardCallback(_handleClipboardPaste);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleHotkeyPressed(AppMode mode) {
    setState(() {
      _currentMode = mode;
      if (_showOverlay) {
        _resetState();
      }
    });
  }

  void _handleClipboardPaste(String text) {
    setState(() {
      _inputController.text = text;
    });
  }

  Future<void> _handleSubmit() async {
    final input = _inputController.text.trim();
    if (input.isEmpty || !AIService.instance.isInitialized) return;

    setState(() {
      _showOverlay = true;
      _responseText = '';
      _isStreaming = true;
      _inputEnabled = false;
    });

    try {
      final targetLanguage = StorageService.instance.getTargetLanguage();
      final responseStyleName = StorageService.instance.getResponseStyle();
      final responseStyle = ResponseStyle.values.firstWhere(
        (s) => s.name == responseStyleName,
        orElse: () => ResponseStyle.normal,
      );
      
      final responseStream = AIService.instance.getResponse(
        input,
        _currentMode,
        targetLanguage,
        responseStyle: responseStyle.promptModifier,
      );

      await for (final chunk in responseStream) {
        setState(() {
          _responseText += chunk;
        });
      }

      setState(() {
        _isStreaming = false;
      });

      await StorageService.instance.addToHistory(
        QueryHistory(
          prompt: input,
          response: _responseText,
          mode: _currentMode,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      setState(() {
        _responseText = 'Error: ${e.toString()}';
        _isStreaming = false;
      });
    }
  }

  void _resetState() {
    setState(() {
      _showOverlay = false;
      _responseText = '';
      _isStreaming = false;
      _inputEnabled = true;
      _inputController.clear();
    });
    
    Future.delayed(const Duration(milliseconds: 350), () {
      (_inputFieldKey.currentState as dynamic)?.requestFocus();
    });
  }

  void _handleDone() {
    _resetState();
  }

  void _handleAnotherQuery() {
    setState(() {
      _showOverlay = false;
      _responseText = '';
      _isStreaming = false;
      _inputEnabled = true;
      _inputController.clear();
    });
    
    Future.delayed(const Duration(milliseconds: 350), () {
      (_inputFieldKey.currentState as dynamic)?.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _handleDone,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  TabSelector(
                    currentMode: _currentMode,
                    onModeChanged: (mode) {
                      setState(() {
                        _currentMode = mode;
                      });
                    },
                  ),
                  const Spacer(),
                  InputField(
                    key: _inputFieldKey,
                    controller: _inputController,
                    currentMode: _currentMode,
                    onSubmit: _handleSubmit,
                    onReset: _resetState,
                    enabled: _inputEnabled,
                  ),
                ],
              ),
              ResultOverlay(
                isVisible: _showOverlay,
                responseText: _responseText,
                isStreaming: _isStreaming,
                onDone: _handleDone,
                onAnotherQuery: _handleAnotherQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
