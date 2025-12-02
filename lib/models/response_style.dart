enum ResponseStyle {
  normal,
  detailed,
  direct,
  funny;

  String get displayName {
    switch (this) {
      case ResponseStyle.normal:
        return 'Normal';
      case ResponseStyle.detailed:
        return 'Detailed';
      case ResponseStyle.direct:
        return 'Direct';
      case ResponseStyle.funny:
        return 'Funny';
    }
  }

  String get description {
    switch (this) {
      case ResponseStyle.normal:
        return 'Balanced responses with clear explanations';
      case ResponseStyle.detailed:
        return 'In-depth answers with examples and context';
      case ResponseStyle.direct:
        return 'Concise, straight to the point';
      case ResponseStyle.funny:
        return 'Engaging responses with humor and analogies';
    }
  }

  String get promptModifier {
    switch (this) {
      case ResponseStyle.normal:
        return '';
      case ResponseStyle.detailed:
        return 'Provide a comprehensive, detailed explanation with multiple examples and edge cases. ';
      case ResponseStyle.direct:
        return 'Be extremely concise and direct. Get straight to the point without lengthy explanations. ';
      case ResponseStyle.funny:
        return 'Use humor, witty analogies, and an engaging tone. Make the explanation entertaining while remaining accurate. ';
    }
  }
}
