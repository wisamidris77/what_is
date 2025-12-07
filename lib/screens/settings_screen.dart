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
  
  String _selectedProvider = 'gemini';
  String _selectedLanguage = 'English';
  String _selectedTranslateLanguage = 'English';
  bool _isDarkMode = false;
  ResponseStyle _selectedStyle = ResponseStyle.normal;

  // Hotkey Configs - only used on desktop
  final Map<String, Map<String, dynamic>> _hotkeyConfigs = {};

  final List<String> _availableLanguages = [
    'English',
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
    final provider = StorageService.instance.getProviderType();
    final language = StorageService.instance.getTargetLanguage();
    final translateLanguage = StorageService.instance.getTranslateTargetLanguage();
    final darkMode = StorageService.instance.isDarkMode();
    final styleValue = StorageService.instance.getResponseStyle();
    final style = ResponseStyle.values.firstWhere(
      (s) => s.name == styleValue,
      orElse: () => ResponseStyle.normal,
    );

    // Load Hotkeys only on desktop
    if (PlatformService.instance.isDesktop) {
      _loadHotkeyConfigs();
    }

    setState(() {
      if (apiKey != null) {
        _apiKeyController.text = apiKey;
      }
      _selectedProvider = provider;
      _selectedLanguage = language;
      _selectedTranslateLanguage = translateLanguage;
      _isDarkMode = darkMode;
      _selectedStyle = style;
    });
  }

  void _loadHotkeyConfigs() {
    _loadHotkeyConfig('code', 'keyC');
    _loadHotkeyConfig('translate', 'keyT');
    _loadHotkeyConfig('explain', 'keyE');
    _loadHotkeyConfig('paste', 'keyV');
  }

  void _loadHotkeyConfig(String actionId, String defaultKey) {
    final config = StorageService.instance.getHotkeyConfig(actionId);
    if (config != null) {
      _hotkeyConfigs[actionId] = config;
    } else {
      _hotkeyConfigs[actionId] = {
        'keyCode': defaultKey,
        'modifiers': ['control', 'alt'],
        'enabled': true,
      };
    }
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

    final isValid = await AIService.instance.validateApiKey(apiKey, providerType: _selectedProvider);

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
      await AIService.instance.initializeProvider(apiKey, providerType: _selectedProvider);
    }
    
    await StorageService.instance.setProviderType(_selectedProvider);
    await StorageService.instance.setTargetLanguage(_selectedLanguage);
    await StorageService.instance.setTranslateTargetLanguage(_selectedTranslateLanguage);
    await StorageService.instance.setDarkMode(_isDarkMode);
    await StorageService.instance.setResponseStyle(_selectedStyle.name);

    // Save Hotkeys only on desktop
    if (PlatformService.instance.isDesktop) {
      for (final entry in _hotkeyConfigs.entries) {
        await StorageService.instance.setHotkeyConfig(entry.key, entry.value);
      }
      await HotkeyService.instance.registerAllHotkeys();
    }

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = PlatformService.instance.isDesktop;
    
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            TextButton(
              onPressed: _saveSettings,
              child: const Text('Save'),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('AI Provider', isDark),
              const SizedBox(height: 16),
              _buildProviderCard('gemini', 'Google Gemini', 'Fast and powerful AI responses', Icons.auto_awesome, isDark),
              const SizedBox(height: 12),
              _buildProviderCard('openai', 'OpenAI', 'GPT-4o-mini powered responses', Icons.psychology, isDark),
              
              const SizedBox(height: 32),
              _buildSectionHeader('AI Response Language', isDark),
              const SizedBox(height: 8),
              _buildDropdown(_selectedLanguage, (val) => setState(() => _selectedLanguage = val!), isDark),
              
              const SizedBox(height: 32),
              _buildSectionHeader('Translate Target Language', isDark),
              const SizedBox(height: 8),
              _buildDropdown(_selectedTranslateLanguage, (val) => setState(() => _selectedTranslateLanguage = val!), isDark),
              
              const SizedBox(height: 32),
              _buildSectionHeader('Response Style', isDark),
              const SizedBox(height: 16),
              ...ResponseStyle.values.map((style) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<ResponseStyle>(
                  title: Text(style.displayName),
                  subtitle: Text(
                    style.description,
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black38),
                  ),
                  value: style,
                  groupValue: _selectedStyle,
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedStyle = value);
                  },
                  activeColor: isDark ? Colors.white : Colors.black,
                ),
              )),

              // Only show Hotkeys section on desktop
              if (isDesktop) ...[
                const SizedBox(height: 32),
                _buildSectionHeader('Hotkeys', isDark),
                const SizedBox(height: 16),
                _buildHotkeyTile('Code Mode', 'code', isDark),
                _buildHotkeyTile('Translate Mode', 'translate', isDark),
                _buildHotkeyTile('Explain Mode', 'explain', isDark),
                _buildHotkeyTile('Paste from Clipboard', 'paste', isDark),
              ],
              
              const SizedBox(height: 32),
              _buildSectionHeader('API Key', isDark),
              const SizedBox(height: 8),
              TextField(
                controller: _apiKeyController,
                obscureText: _obscureApiKey,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Enter API Key',
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: isDark ? Colors.white : Colors.black),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureApiKey ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureApiKey = !_obscureApiKey),
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                cursorColor: isDark ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isTestingConnection ? null : _testConnection,
                    icon: _isTestingConnection
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.check_circle, size: 18),
                    label: const Text('Test Connection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                  if (_connectionStatus != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _connectionStatus!,
                        style: TextStyle(
                          fontSize: 13,
                          color: _connectionStatus!.contains('successful') ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotkeyTile(String label, String actionId, bool isDark) {
    final config = _hotkeyConfigs[actionId] ?? {};
    final enabled = config['enabled'] ?? true;
    final modifiers = (config['modifiers'] as List<dynamic>?)?.cast<String>() ?? ['control', 'alt'];
    final keyCode = config['keyCode'] as String? ?? 'keyC';

    final keyDisplay = '${modifiers.map((m) => m.toUpperCase()).join(' + ')} + ${keyCode.replaceAll('key', '').toUpperCase()}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Switch(
              value: enabled,
              onChanged: (val) {
                setState(() {
                  _hotkeyConfigs[actionId] = {
                    ...config,
                    'enabled': val,
                  };
                });
              },
              activeColor: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: enabled ? () => _showHotkeyEditor(actionId, isDark) : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: enabled
                        ? (isDark ? Colors.white24 : Colors.black26)
                        : (isDark ? Colors.white10 : Colors.black12),
                  ),
                ),
                child: Text(
                  keyDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: enabled
                        ? (isDark ? Colors.white : Colors.black87)
                        : (isDark ? Colors.white38 : Colors.black38),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showHotkeyEditor(String actionId, bool isDark) async {
    final config = _hotkeyConfigs[actionId] ?? {};
    String currentKeyName = config['keyCode'] ?? 'keyC';
    List<String> currentModifiers = (config['modifiers'] as List<dynamic>?)?.cast<String>() ?? ['control', 'alt'];
    
    String newKeyName = currentKeyName;
    
    bool hasControl = currentModifiers.contains('control');
    bool hasAlt = currentModifiers.contains('alt');
    bool hasShift = currentModifiers.contains('shift');
    bool hasMeta = currentModifiers.contains('meta');

    final availableKeys = [
      'keyA', 'keyB', 'keyC', 'keyD', 'keyE', 'keyF', 'keyG', 'keyH', 'keyI', 'keyJ',
      'keyK', 'keyL', 'keyM', 'keyN', 'keyO', 'keyP', 'keyQ', 'keyR', 'keyS', 'keyT',
      'keyU', 'keyV', 'keyW', 'keyX', 'keyY', 'keyZ',
      'digit0', 'digit1', 'digit2', 'digit3', 'digit4', 'digit5', 'digit6', 'digit7', 'digit8', 'digit9',
    ];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Hotkey',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Modifiers',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildModifierChip('Ctrl', hasControl, (val) => setStateDialog(() => hasControl = val), isDark),
                        _buildModifierChip('Alt', hasAlt, (val) => setStateDialog(() => hasAlt = val), isDark),
                        _buildModifierChip('Shift', hasShift, (val) => setStateDialog(() => hasShift = val), isDark),
                        _buildModifierChip('Meta', hasMeta, (val) => setStateDialog(() => hasMeta = val), isDark),
                      ],
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      value: newKeyName,
                      dropdownColor: isDark ? const Color(0xFF3A3A3A) : Colors.white,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'Key',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: isDark ? Colors.white : Colors.black),
                        ),
                      ),
                      items: availableKeys
                          .map((k) => DropdownMenuItem(
                                value: k,
                                child: Text(k.replaceAll('key', '').replaceAll('digit', '').toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (val) => setStateDialog(() => newKeyName = val ?? newKeyName),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                             final newModifiers = <String>[];
                             if (hasControl) newModifiers.add('control');
                             if (hasAlt) newModifiers.add('alt');
                             if (hasShift) newModifiers.add('shift');
                             if (hasMeta) newModifiers.add('meta');

                             setState(() {
                               _hotkeyConfigs[actionId] = {
                                 ...config,
                                 'keyCode': newKeyName,
                                 'modifiers': newModifiers,
                               };
                             });
                             Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.white : Colors.black,
                            foregroundColor: isDark ? Colors.black : Colors.white,
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModifierChip(String label, bool selected, ValueChanged<bool> onSelected, bool isDark) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      checkmarkColor: isDark ? Colors.black : Colors.white,
      selectedColor: isDark ? Colors.white : Colors.black,
      backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
      labelStyle: TextStyle(
        color: selected
            ? (isDark ? Colors.black : Colors.white)
            : (isDark ? Colors.white : Colors.black87),
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: selected
              ? Colors.transparent
              : (isDark ? Colors.white24 : Colors.black12),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildDropdown(String value, ValueChanged<String?> onChanged, bool isDark) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: isDark ? const Color(0xFF3A3A3A) : Colors.white,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: isDark ? Colors.white : Colors.black),
        ),
      ),
      items: _availableLanguages.map((language) {
        return DropdownMenuItem(value: language, child: Text(language));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildProviderCard(String value, String title, String description, IconData icon, bool isDark) {
    final isSelected = _selectedProvider == value;
    return InkWell(
      onTap: () => setState(() => _selectedProvider = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06)),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: isSelected ? (isDark ? Colors.white : Colors.black87) : (isDark ? Colors.white54 : Colors.black38)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                  Text(description, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: isDark ? Colors.white : Colors.black87),
          ],
        ),
      ),
    );
  }
}
