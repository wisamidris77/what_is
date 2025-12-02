import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final AppMode currentMode;
  final VoidCallback onSubmit;
  final VoidCallback onReset;
  final bool enabled;

  const InputField({
    super.key,
    required this.controller,
    required this.currentMode,
    required this.onSubmit,
    required this.onReset,
    this.enabled = true,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void requestFocus() {
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.enter, control: true): widget.onSubmit,
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): widget.onReset,
        },
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          maxLines: 8,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
            height: 1.5,
          ),
          decoration: InputDecoration(
            hintText: widget.currentMode.placeholder,
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(20),
            suffixIcon: widget.enabled
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Ctrl+Enter to submit',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white30 : Colors.black26,
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
