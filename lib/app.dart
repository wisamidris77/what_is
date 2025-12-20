import 'package:flutter/material.dart';
import 'screens/screens.dart';
import 'services/services.dart';
import 'main.dart' as main_file;

class WhatIsApp extends StatefulWidget {
  final bool showOnboarding;
  
  const WhatIsApp({super.key, this.showOnboarding = false});

  @override
  State<WhatIsApp> createState() => _WhatIsAppState();
}

class _WhatIsAppState extends State<WhatIsApp> {
  bool _isDarkMode = false;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _showOnboarding = widget.showOnboarding;
    _loadTheme();
    
    if (_showOnboarding) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _displayOnboarding();
      });
    }
  }

  Future<void> _loadTheme() async {
    final darkMode = StorageService.instance.isDarkMode();
    setState(() {
      _isDarkMode = darkMode;
    });
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
      _loadTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: main_file.navigatorKey,
      title: 'What is',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.black87,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black12,
          selectionHandleColor: Colors.black,
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(Colors.black),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white70,
          surface: Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white24,
          selectionHandleColor: Colors.white,
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(Colors.white),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(Colors.white),
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.white,
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.black);
            }
            return const IconThemeData(color: Colors.white70);
          }),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
