import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../providers/theme_provider.dart';

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
  ResponseStyle _selectedStyle = ResponseStyle.normal;

  // Theme Settings
  ThemeMode _selectedThemeMode = ThemeMode.system;
  Color _selectedPrimaryColor = Colors.black;

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

  final List<Color> _accentColors = [
    Colors.black,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    const Color(0xFF1E1E1E), // Dark Grey
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
    final styleValue = StorageService.instance.getResponseStyle();
    final style = ResponseStyle.values.firstWhere((s) => s.name == styleValue, orElse: () => ResponseStyle.normal);

    // Initial Theme values from Provider
    final themeProvider = context.read<ThemeProvider>();

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
      _selectedStyle = style;
      _selectedThemeMode = themeProvider.themeMode;
      _selectedPrimaryColor = themeProvider.primaryColor;
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
      _connectionStatus = isValid ? 'Connection successful!' : 'Invalid API key or connection failed';
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
    await StorageService.instance.setResponseStyle(_selectedStyle.name);

    // Save Theme via Provider
    final themeProvider = context.read<ThemeProvider>();
    if (themeProvider.themeMode != _selectedThemeMode) {
      await themeProvider.setThemeMode(_selectedThemeMode);
    }
    if (themeProvider.primaryColor != _selectedPrimaryColor) {
      await themeProvider.setPrimaryColor(_selectedPrimaryColor);
    }

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final isDesktop = PlatformService.instance.isDesktop;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
          actions: [
            TextButton(onPressed: _saveSettings, child: const Text('Save')),
            const SizedBox(width: 16),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Appearance'),
              const SizedBox(height: 16),
              // Theme Mode
              DropdownButtonFormField<ThemeMode>(
                value: _selectedThemeMode,
                dropdownColor: theme.cardColor,
                decoration: InputDecoration(
                  labelText: 'Theme Mode',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text('System Default')),
                  DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedThemeMode = val);
                },
              ),
              const SizedBox(height: 16),
              // Accent Color
              const Text('Primary Color', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _accentColors.map((color) {
                  final isSelected = _selectedPrimaryColor.value == color.value;
                  return InkWell(
                    onTap: () => setState(() => _selectedPrimaryColor = color),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: onSurface, width: 2) : null,
                        boxShadow: [
                          if (isSelected) BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2),
                        ],
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('AI Provider'),
              const SizedBox(height: 16),
              _buildProviderCard('gemini', 'Google Gemini', 'Fast and powerful AI responses', Icons.auto_awesome),
              const SizedBox(height: 12),
              _buildProviderCard('openai', 'OpenAI', 'GPT-4o-mini powered responses', Icons.psychology),

              const SizedBox(height: 32),
              _buildSectionHeader('AI Response Language'),
              const SizedBox(height: 8),
              _buildDropdown(_selectedLanguage, (val) => setState(() => _selectedLanguage = val!)),

              const SizedBox(height: 32),
              _buildSectionHeader('Translate Target Language'),
              const SizedBox(height: 8),
              _buildDropdown(_selectedTranslateLanguage, (val) => setState(() => _selectedTranslateLanguage = val!)),

              const SizedBox(height: 32),
              _buildSectionHeader('Response Style'),
              const SizedBox(height: 16),
              ...ResponseStyle.values.map(
                (style) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RadioListTile<ResponseStyle>(
                    title: Text(style.displayName),
                    subtitle: Text(
                      style.description,
                      style: TextStyle(fontSize: 12, color: onSurface.withOpacity(0.6)),
                    ),
                    value: style,
                    groupValue: _selectedStyle,
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedStyle = value);
                    },
                    activeColor: primaryColor,
                  ),
                ),
              ),

              // Only show Hotkeys section on desktop
              if (isDesktop) ...[
                const SizedBox(height: 32),
                _buildSectionHeader('Hotkeys'),
                const SizedBox(height: 16),
                _buildHotkeyTile('Code Mode', 'code'),
                _buildHotkeyTile('Translate Mode', 'translate'),
                _buildHotkeyTile('Explain Mode', 'explain'),
                _buildHotkeyTile('Paste from Clipboard', 'paste'),
              ],

              const SizedBox(height: 32),
              _buildSectionHeader('API Key'),
              const SizedBox(height: 8),
              TextField(
                controller: _apiKeyController,
                obscureText: _obscureApiKey,
                decoration: InputDecoration(
                  hintText: 'Enter API Key',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureApiKey ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureApiKey = !_obscureApiKey),
                  ),
                ),
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
                      backgroundColor: primaryColor,
                      foregroundColor: theme.colorScheme.onPrimary,
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

  Widget _buildHotkeyTile(String label, String actionId) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final config = _hotkeyConfigs[actionId] ?? {};
    final enabled = config['enabled'] ?? true;
    final modifiers = (config['modifiers'] as List<dynamic>?)?.cast<String>() ?? ['control', 'alt'];
    final keyCode = config['keyCode'] as String? ?? 'keyC';

    final keyDisplay =
        '${modifiers.map((m) => m.toUpperCase()).join(' + ')} + ${keyCode.replaceAll('key', '').toUpperCase()}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: onSurface.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
            Switch(
              value: enabled,
              onChanged: (val) {
                setState(() {
                  _hotkeyConfigs[actionId] = {...config, 'enabled': val};
                });
              },
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: enabled ? () => _showHotkeyEditor(actionId) : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: enabled ? onSurface.withOpacity(0.3) : onSurface.withOpacity(0.1)),
                ),
                child: Text(
                  keyDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: enabled ? onSurface : onSurface.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showHotkeyEditor(String actionId) async {
    final theme = Theme.of(context);
    final config = _hotkeyConfigs[actionId] ?? {};
    String currentKeyName = config['keyCode'] ?? 'keyC';
    List<String> currentModifiers = (config['modifiers'] as List<dynamic>?)?.cast<String>() ?? ['control', 'alt'];

    String newKeyName = currentKeyName;

    bool hasControl = currentModifiers.contains('control');
    bool hasAlt = currentModifiers.contains('alt');
    bool hasShift = currentModifiers.contains('shift');
    bool hasMeta = currentModifiers.contains('meta');

    final availableKeys = [
      'keyA',
      'keyB',
      'keyC',
      'keyD',
      'keyE',
      'keyF',
      'keyG',
      'keyH',
      'keyI',
      'keyJ',
      'keyK',
      'keyL',
      'keyM',
      'keyN',
      'keyO',
      'keyP',
      'keyQ',
      'keyR',
      'keyS',
      'keyT',
      'keyU',
      'keyV',
      'keyW',
      'keyX',
      'keyY',
      'keyZ',
      'digit0',
      'digit1',
      'digit2',
      'digit3',
      'digit4',
      'digit5',
      'digit6',
      'digit7',
      'digit8',
      'digit9',
    ];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: theme.dialogBackgroundColor,
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Edit Hotkey', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    const Text('Modifiers', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildModifierChip('Ctrl', hasControl, (val) => setStateDialog(() => hasControl = val)),
                        _buildModifierChip('Alt', hasAlt, (val) => setStateDialog(() => hasAlt = val)),
                        _buildModifierChip('Shift', hasShift, (val) => setStateDialog(() => hasShift = val)),
                        _buildModifierChip('Meta', hasMeta, (val) => setStateDialog(() => hasMeta = val)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      value: newKeyName,
                      dropdownColor: theme.cardColor,
                      decoration: InputDecoration(
                        labelText: 'Key',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: availableKeys
                          .map(
                            (k) => DropdownMenuItem(
                              value: k,
                              child: Text(k.replaceAll('key', '').replaceAll('digit', '').toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setStateDialog(() => newKeyName = val ?? newKeyName),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final newModifiers = <String>[];
                            if (hasControl) newModifiers.add('control');
                            if (hasAlt) newModifiers.add('alt');
                            if (hasShift) newModifiers.add('shift');
                            if (hasMeta) newModifiers.add('meta');

                            setState(() {
                              _hotkeyConfigs[actionId] = {...config, 'keyCode': newKeyName, 'modifiers': newModifiers};
                            });
                            Navigator.pop(context);
                          },
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

  Widget _buildModifierChip(String label, bool selected, ValueChanged<bool> onSelected) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      checkmarkColor: theme.colorScheme.onPrimary,
      selectedColor: primaryColor,
      labelStyle: TextStyle(
        color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  Widget _buildDropdown(String value, ValueChanged<String?> onChanged) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: theme.cardColor,
      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
      items: _availableLanguages.map((language) {
        return DropdownMenuItem(value: language, child: Text(language));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildProviderCard(String value, String title, String description, IconData icon) {
    final isSelected = _selectedProvider == value;
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final onSurface = theme.colorScheme.onSurface;

    return InkWell(
      onTap: () => setState(() => _selectedProvider = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? primaryColor : onSurface.withOpacity(0.1), width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: isSelected ? primaryColor : onSurface.withOpacity(0.5)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(description, style: TextStyle(fontSize: 12, color: onSurface.withOpacity(0.6))),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: primaryColor),
          ],
        ),
      ),
    );
  }
}
