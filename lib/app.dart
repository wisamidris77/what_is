import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';
import 'services/services.dart';
import 'providers/theme_provider.dart';
import 'main.dart' as main_file;

class WhatIsApp extends StatefulWidget {
  final bool showOnboarding;
  
  const WhatIsApp({super.key, this.showOnboarding = false});

  @override
  State<WhatIsApp> createState() => _WhatIsAppState();
}

class _WhatIsAppState extends State<WhatIsApp> {
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _showOnboarding = widget.showOnboarding;
    
    if (_showOnboarding) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _displayOnboarding();
      });
    }
  }

  Future<void> _displayOnboarding() async {
    final result = await showDialog<bool>(
      context: main_file.navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => const OnboardingScreen(),
    );
    
    if (result == true) {
      setState(() {
        _showOnboarding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final primaryColor = themeProvider.primaryColor;
        
        return MaterialApp(
          navigatorKey: main_file.navigatorKey,
          title: 'What is',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              secondary: primaryColor.withOpacity(0.8),
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: primaryColor,
              selectionColor: primaryColor.withOpacity(0.12),
              selectionHandleColor: primaryColor,
            ),
            radioTheme: RadioThemeData(
              fillColor: MaterialStateProperty.all(primaryColor),
            ),
            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.all(primaryColor),
            ),
            navigationBarTheme: NavigationBarThemeData(
              indicatorColor: primaryColor,
              iconTheme: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const IconThemeData(color: Colors.white);
                }
                return const IconThemeData(color: Colors.black54);
              }),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(
              primary: primaryColor,
              secondary: primaryColor.withOpacity(0.8),
              surface: const Color(0xFF1E1E1E),
            ),
            scaffoldBackgroundColor: const Color(0xFF1E1E1E),
            useMaterial3: true,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: primaryColor,
              selectionColor: primaryColor.withOpacity(0.24),
              selectionHandleColor: primaryColor,
            ),
            radioTheme: RadioThemeData(
              fillColor: MaterialStateProperty.all(primaryColor),
            ),
            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.all(primaryColor),
            ),
            navigationBarTheme: NavigationBarThemeData(
              indicatorColor: Colors.white,
              iconTheme: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return IconThemeData(color: primaryColor);
                }
                return const IconThemeData(color: Colors.white70);
              }),
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: const MainScreen(),
        );
      },
    );
  }
}
