enum AppMode {
  code,
  translate,
  explain;

  String get displayName {
    switch (this) {
      case AppMode.code:
        return 'Code';
      case AppMode.translate:
        return 'Translate';
      case AppMode.explain:
        return 'Explain';
    }
  }

  String get placeholder {
    switch (this) {
      case AppMode.code:
        return 'Paste code to analyze...';
      case AppMode.translate:
        return 'Enter text to translate...';
      case AppMode.explain:
        return 'What would you like explained?';
    }
  }
}
