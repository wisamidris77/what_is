import 'package:flutter/material.dart';
import '../models/models.dart';

class TabSelector extends StatelessWidget {
  final AppMode currentMode;
  final ValueChanged<AppMode> onModeChanged;

  const TabSelector({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: AppMode.values.map((mode) {
          final isSelected = mode == currentMode;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onModeChanged(mode),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.08))
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? (isDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.2))
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    mode.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark ? Colors.white60 : Colors.black54),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
