import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/learn_it/learn_it_models.dart';
import '../../services/learn_it_service.dart';

class TopicCreationDialog extends StatefulWidget {
  const TopicCreationDialog({super.key});

  @override
  State<TopicCreationDialog> createState() => _TopicCreationDialogState();
}

class _TopicCreationDialogState extends State<TopicCreationDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedIcon = 'school';
  String _selectedColor = '0xFF2196F3'; // Blue
  bool _isLoading = false;

  final List<String> _icons = [
    'school', 'code', 'lightbulb', 'science', 'history', 'language', 'business', 'music_note'
  ];

  final List<Color> _colors = [
    Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.pink, Colors.indigo
  ];

  IconData _getIconData(String key) {
    switch (key) {
      case 'school': return Icons.school;
      case 'code': return Icons.code;
      case 'lightbulb': return Icons.lightbulb;
      case 'science': return Icons.science;
      case 'history': return Icons.history_edu;
      case 'language': return Icons.translate;
      case 'business': return Icons.business;
      case 'music_note': return Icons.music_note;
      default: return Icons.school;
    }
  }

  Future<void> _createTopic() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final topic = Topic(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        iconKey: _selectedIcon,
        colorHex: _selectedColor,
        settings: TopicSettings(
          targetLanguage: 'en', // Could be from global settings
          includeSummary: true,
          includeExamples: true,
        ),
        createdAt: DateTime.now(),
      );

      await LearnItService.instance.repository.createTopic(topic);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Topic'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', hintText: 'e.g. Design Patterns'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', hintText: 'What is this topic about?'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              const Text('Icon', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _icons.map((iconKey) {
                  final isSelected = _selectedIcon == iconKey;
                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = iconKey),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black12 : Colors.transparent,
                        border: isSelected ? Border.all(color: Colors.black) : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(_getIconData(iconKey), size: 24),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colors.map((color) {
                  final colorHex = '0x${color.value.toRadixString(16).toUpperCase()}';
                  final isSelected = _selectedColor == colorHex;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = colorHex),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _showGenerateDialog,
          child: const Text('Generate from Prompt'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createTopic,
          child: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _showGenerateDialog() async {
    final promptController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Topic'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter a subject, and AI will fill in the details for you.'),
            const SizedBox(height: 16),
            TextField(
              controller: promptController,
              decoration: const InputDecoration(
                hintText: 'e.g., Quantum Physics for beginners',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, promptController.text),
            child: const Text('Generate'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => _isLoading = true);
      try {
        final data = await LearnItService.instance.generateTopicFromPrompt(result);
        
        setState(() {
          _titleController.text = data['title'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          
          if (data['iconKey'] != null && _icons.contains(data['iconKey'])) {
            _selectedIcon = data['iconKey'];
          }
          
          if (data['colorHex'] != null) {
            // Check if color is in our list, if not we might need to be flexible or default
            // For now, let's just trust it or default if it's wildly wrong, 
            // but the prompt asks for one of specific hexes.
            _selectedColor = data['colorHex'];
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Generation failed: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}
