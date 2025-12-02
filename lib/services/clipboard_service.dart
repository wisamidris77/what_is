import 'package:flutter/services.dart';

class ClipboardService {
  static final ClipboardService instance = ClipboardService._internal();
  factory ClipboardService() => instance;
  ClipboardService._internal();

  Future<String?> getClipboardText() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      return data?.text;
    } catch (e) {
      return null;
    }
  }

  Future<void> setClipboardText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
