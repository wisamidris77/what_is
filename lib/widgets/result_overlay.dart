import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ResultOverlay extends StatelessWidget {
  final bool isVisible;
  final String responseText;
  final bool isStreaming;
  final VoidCallback onDone;
  final VoidCallback onAnotherQuery;

  const ResultOverlay({
    super.key,
    required this.isVisible,
    required this.responseText,
    required this.isStreaming,
    required this.onDone,
    required this.onAnotherQuery,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: isVisible
          ? Container(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: responseText.isEmpty && isStreaming
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Thinking...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Markdown(
                            data: responseText,
                            selectable: true,
                            padding: const EdgeInsets.all(32),
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                fontSize: 15,
                                height: 1.6,
                                color: isDark ? Colors.white.withOpacity(0.87) : Colors.black87,
                              ),
                              h1: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              h2: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              h3: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              code: TextStyle(
                                backgroundColor: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.05),
                                color: isDark ? Colors.white : Colors.black87,
                                fontSize: 14,
                              ),
                              codeblockDecoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.black.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                  ),
                  if (!isStreaming && responseText.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.03)
                            : Colors.black.withOpacity(0.02),
                        border: Border(
                          top: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.06),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: onAnotherQuery,
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Another What is'),
                            style: TextButton.styleFrom(
                              foregroundColor: isDark ? Colors.white70 : Colors.black54,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: onDone,
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('Done'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.white : Colors.black87,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
