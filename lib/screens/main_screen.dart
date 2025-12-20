import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import 'settings_screen.dart';
import 'learn_it/learn_it_dashboard.dart';

// Conditionally import window_manager only for desktop
import 'package:window_manager/window_manager.dart' if (dart.library.html) 'dart:ui';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _inputController = TextEditingController();
  final _inputFieldKey = GlobalKey<InputFieldState>();
  
  AppMode _currentMode = AppMode.code;
  bool _showOverlay = false;
  String _responseText = '';
  bool _isStreaming = false;
  bool _inputEnabled = true;
  
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Only set up hotkey callbacks on desktop
    if (PlatformService.instance.isDesktop) {
      HotkeyService.instance.onHotkeyPressed = _handleHotkeyPressed;
      HotkeyService.instance.setClipboardCallback(_handleClipboardPaste);
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleHotkeyPressed(AppMode mode) {
    setState(() {
      _currentIndex = 0; // Switch to Assistant view
      _currentMode = mode;
      if (_showOverlay) {
        _resetState();
      }
    });
    
    if (PlatformService.instance.isDesktop) {
      _showWindow();
    }
    
    // Ensure focus and selection after window is shown
    Future.delayed(const Duration(milliseconds: 100), () {
      _inputFieldKey.currentState?.focusAndSelectAll();
    });
  }

  Future<void> _showWindow() async {
    if (PlatformService.instance.isDesktop) {
      await windowManager.show();
      await windowManager.focus();
    }
  }

  void _handleClipboardPaste(String text) {
    setState(() {
      _currentIndex = 0; // Switch to Assistant view
      _inputController.text = text;
    });
    
    // Ensure focus and selection after paste
    Future.delayed(const Duration(milliseconds: 100), () {
      _inputFieldKey.currentState?.focusAndSelectAll();
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
      _inputFieldKey.currentState?.requestFocus();
    });
  }

  Future<void> _handleDone() async {
    _resetState();
    if (PlatformService.instance.isDesktop) {
      await windowManager.hide();
    }
  }

  void _handleAnotherQuery() {
    _resetState();
  }

  Future<void> _hideApp() async {
    if (PlatformService.instance.isDesktop) {
      await windowManager.hide();
    } else {
      // On mobile, minimize or go to background
      SystemNavigator.pop();
    }
  }

  Future<void> _openSettings() async {
    await showDialog(
      context: context,
      builder: (context) => const SettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final isDesktop = PlatformService.instance.isDesktop;

    Widget assistantView = Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: AppMode.values.map((mode) {
                          final isSelected = mode == _currentMode;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _currentMode = mode;
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? onSurface.withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? onSurface.withOpacity(0.3)
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    mode.displayName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected
                                          ? onSurface
                                          : onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // Only show hide button on desktop
                  if (isDesktop) ...[
                    IconButton(
                      icon: const Icon(Icons.visibility_off_outlined),
                      onPressed: _hideApp,
                      tooltip: 'Hide',
                    ),
                    const SizedBox(width: 8),
                  ],
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: _openSettings,
                    tooltip: 'Settings',
                  ),
                ],
              ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.search, size: 22),
                  label: const Text(
                    'What is?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
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
    );

    Widget scaffold = Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assistant_outlined),
            selectedIcon: Icon(Icons.assistant),
            label: 'Assistant',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Learn It',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          assistantView,
          const LearnItDashboard(),
        ],
      ),
    );

    // Only add keyboard shortcuts on desktop
    if (isDesktop) {
      return CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): _handleDone,
        },
        child: Focus(
          autofocus: true,
          child: scaffold,
        ),
      );
    }

    return scaffold;
  }
}
