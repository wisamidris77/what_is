import 'package:flutter/material.dart';
import 'app.dart';
import 'services/services.dart';
import 'native/platform_helper.dart';
import 'native/platform_helper_export.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final platformHelper = getPlatformHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await StorageService.instance.initialize();
  await LearnItService.instance.initialize();

  // Platform-specific initialization
  if (platformHelper.isDesktop) {
    await platformHelper.initializePlatform();
  }

  final apiKey = await StorageService.instance.getApiKey();
  if (apiKey != null && apiKey.isNotEmpty) {
    try {
      final provider = StorageService.instance.getProviderType();
      await AIService.instance.initializeProvider(apiKey, providerType: provider);
    } catch (e) {
      debugPrint('Failed to initialize AI service: $e');
    }
  }

  final isOnboardingComplete = StorageService.instance.isOnboardingComplete();
  
  runApp(WhatIsApp(showOnboarding: !isOnboardingComplete));
}
