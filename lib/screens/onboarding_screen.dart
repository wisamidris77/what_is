import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _apiKeyController = TextEditingController();
  
  int _currentStep = 0;
  bool _obscureApiKey = true;
  bool _isValidating = false;
  String? _validationError;
  
  String _selectedProvider = 'gemini';
  String _selectedLanguage = 'Arabic';
  ResponseStyle _selectedStyle = ResponseStyle.normal;

  final List<String> _availableLanguages = [
    'Arabic',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Japanese',
    'Korean',
    'Chinese',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _validateAndContinue() async {
    if (_currentStep == 0) {
      final apiKey = _apiKeyController.text.trim();
      if (apiKey.isEmpty) {
        setState(() {
          _validationError = 'Please enter an API key';
        });
        return;
      }

      setState(() {
        _isValidating = true;
        _validationError = null;
      });

      final isValid = await AIService.instance.validateApiKey(apiKey, providerType: _selectedProvider);

      setState(() {
        _isValidating = false;
      });

      if (!isValid) {
        setState(() {
          _validationError = 'Invalid API key. Please check and try again.';
        });
        return;
      }

      await StorageService.instance.saveApiKey(apiKey);
      await AIService.instance.initializeProvider(apiKey, providerType: _selectedProvider);
    }

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    await StorageService.instance.setProviderType(_selectedProvider);
    await StorageService.instance.setTargetLanguage(_selectedLanguage);
    await StorageService.instance.setResponseStyle(_selectedStyle.name);
    await StorageService.instance.setOnboardingComplete(true);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _validationError = null;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Text(
                    'Welcome to What is',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Step ${_currentStep + 1} of 4',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildApiKeyStep(isDark),
                  _buildProviderStep(isDark),
                  _buildLanguageStep(isDark),
                  _buildStyleStep(isDark),
                ],
              ),
            ),
            
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
                children: [
                  if (_currentStep > 0)
                    TextButton.icon(
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('Back'),
                      style: TextButton.styleFrom(
                        foregroundColor: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isValidating ? null : _validateAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black87,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isValidating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_currentStep == 3 ? 'Get Started' : 'Continue'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyStep(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'API Key Setup',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Enter your Gemini API key to get started. You can get one from Google AI Studio.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureApiKey,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              labelText: 'Gemini API Key',
              hintText: 'Enter your API key',
              hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureApiKey ? Icons.visibility : Icons.visibility_off,
                  color: isDark ? Colors.white54 : Colors.black38,
                ),
                onPressed: () {
                  setState(() {
                    _obscureApiKey = !_obscureApiKey;
                  });
                },
              ),
            ),
          ),
          if (_validationError != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _validationError!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProviderStep(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'AI Provider',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choose your AI provider. More providers coming soon!',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 40),
          _buildProviderCard(
            'gemini',
            'Google Gemini',
            'Fast and powerful AI responses',
            Icons.auto_awesome,
            isDark,
          ),
        ],
      ),
   );
  }

  Widget _buildProviderCard(String value, String title, String description, IconData icon, bool isDark) {
    final isSelected = _selectedProvider == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedProvider = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05))
              : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.2))
                : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06)),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? (isDark ? Colors.white : Colors.black87)
                  : (isDark ? Colors.white54 : Colors.black38),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: isDark ? Colors.white : Colors.black87,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageStep(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Translation Language',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choose your default target language for translations.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 40),
          DropdownButtonFormField<String>(
            value: _selectedLanguage,
            dropdownColor: isDark ? const Color(0xFF3A3A3A) : Colors.white,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Target Language',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _availableLanguages.map((language) {
              return DropdownMenuItem(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedLanguage = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStyleStep(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Response Style',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choose how you want the AI to respond to your questions.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: ResponseStyle.values.map((style) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildStyleCard(style, isDark),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleCard(ResponseStyle style, bool isDark) {
    final isSelected = _selectedStyle == style;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedStyle = style;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05))
              : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.2))
                : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06)),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.displayName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    style.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: isDark ? Colors.white : Colors.black87,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
