import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscureApiKey = true;
  bool _isTestingConnection = false;
  String? _connectionStatus;
  
  String _selectedLanguage = 'Arabic';
  bool _isDarkMode = false;
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
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final apiKey = await StorageService.instance.getApiKey();
    final language = StorageService.instance.getTargetLanguage();
    final darkMode = StorageService.instance.isDarkMode();
    final styleValue = StorageService.instance.getResponseStyle();
    final style = ResponseStyle.values.firstWhere(
      (s) => s.name == styleValue,
      orElse: () => ResponseStyle.normal,
    );

    setState(() {
      if (apiKey != null) {
        _apiKeyController.text = apiKey;
      }
      _selectedLanguage = language;
      _isDarkMode = darkMode;
      _selectedStyle = style;
    });
  }

  Future<void> _testConnection() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      setState(() {
        _connectionStatus = 'Please enter an API key';
      });
      return;
    }

    setState(() {
      _isTestingConnection = true;
      _connectionStatus = null;
    });

    final isValid = await AIService.instance.validateApiKey(apiKey);

    setState(() {
      _isTestingConnection = false;
      _connectionStatus = isValid
          ? 'Connection successful!'
          : 'Invalid API key or connection failed';
    });
  }

  Future<void> _saveSettings() async {
    final apiKey = _apiKeyController.text.trim();
    
    if (apiKey.isNotEmpty) {
      await StorageService.instance.saveApiKey(apiKey);
      await AIService.instance.initializeProvider(apiKey);
    }
    
    await StorageService.instance.setTargetLanguage(_selectedLanguage);
    await StorageService.instance.setDarkMode(_isDarkMode);
    await StorageService.instance.setResponseStyle(_selectedStyle.name);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            Text(
              'AI Provider',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              obscureText: _obscureApiKey,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Enter Gemini API Key',
                hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
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
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isTestingConnection ? null : _testConnection,
                  icon: _isTestingConnection
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle, size: 18),
                  label: const Text('Test Connection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white12 : Colors.black87,
                    foregroundColor: isDark ? Colors.white : Colors.white,
                  ),
                ),
                if (_connectionStatus != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _connectionStatus!,
                      style: TextStyle(
                        fontSize: 13,
                        color: _connectionStatus!.contains('successful')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 32),
            Text(
              'Translation Target Language',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              dropdownColor: isDark ? const Color(0xFF3A3A3A) : Colors.white,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
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
            
            const SizedBox(height: 32),
            Text(
              'Response Style',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            ...ResponseStyle.values.map((style) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<ResponseStyle>(
                  title: Text(style.displayName),
                  subtitle: Text(
                    style.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black38,
                    ),
                  ),
                  value: style,
                  groupValue: _selectedStyle,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStyle = value;
                      });
                    }
                  },
                ),
              );
            }),
            
            const SizedBox(height: 32),
            Text(
              'Theme',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Light'),
                    value: false,
                    groupValue: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value ?? false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Dark'),
                    value: true,
                    groupValue: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value ?? true;
                      });
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black87,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
