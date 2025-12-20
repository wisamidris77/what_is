import 'package:flutter/material.dart';
import '../../models/learn_it/learn_it_models.dart';
import '../../services/learn_it_service.dart';
import 'topic_history_screen.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late Future<List<Topic>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _topicsFuture = LearnItService.instance.repository.getAllTopics();
    });
  }

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

  Color _getColor(String hex) {
    try {
      return Color(int.parse(hex));
    } catch (_) {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: _topicsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final topics = snapshot.data ?? [];
        if (topics.isEmpty) {
          return const Center(child: Text('No topics found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            final color = _getColor(topic.colorHex);
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final onSurface = Theme.of(context).colorScheme.onSurface;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: onSurface.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.5), width: 1.5),
                    ),
                    child: Icon(_getIconData(topic.iconKey), color: color, size: 24),
                  ),
                  title: Text(
                    topic.title,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  subtitle: Text(
                    'View history',
                    style: TextStyle(color: onSurface.withOpacity(0.6), fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(Icons.arrow_forward, color: onSurface),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicHistoryScreen(topic: topic),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}