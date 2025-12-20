import 'package:flutter/material.dart';
import '../../models/learn_it/learn_it_models.dart';
import '../../services/learn_it_service.dart';
import 'topic_creation_dialog.dart';
import 'topic_detail_screen.dart';

import 'package:flutter/material.dart';
import '../../models/learn_it/learn_it_models.dart';
import '../../services/learn_it_service.dart';
import 'topic_creation_dialog.dart';
import 'topic_detail_screen.dart';
import 'history_view.dart';

class LearnItDashboard extends StatefulWidget {
  const LearnItDashboard({super.key});

  @override
  State<LearnItDashboard> createState() => _LearnItDashboardState();
}

class _LearnItDashboardState extends State<LearnItDashboard> with SingleTickerProviderStateMixin {
  late Future<List<Topic>> _topicsFuture;
  late Future<int> _totalLearnedFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
        if (_tabController.indexIsChanging) {
             // Force rebuild to update FAB visibility if we wanted to
             setState(() {});
        }
    });
    _refresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      _topicsFuture = LearnItService.instance.repository.getAllTopics();
      _totalLearnedFuture = LearnItService.instance.repository.getTotalLearnedConceptsCount();
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

  Future<void> _showCreateDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const TopicCreationDialog(),
    );
    if (result == true) {
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Custom Tab Bar
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'My Topics'),
                Tab(text: 'History'),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Topics Tab
                Scaffold(
                  backgroundColor: Colors.transparent,
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: _showCreateDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('New Topic'),
                  ),
                  body: Column(
                    children: [
                       // Header Stats
                      FutureBuilder<int>(
                        future: _totalLearnedFuture,
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return Container(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatCard('Total Learned', '$count', Icons.check_circle_outline),
                                _buildStatCard('Daily Streak', '0', Icons.local_fire_department_outlined),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      Expanded(
                        child: FutureBuilder<List<Topic>>(
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
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                                    const SizedBox(height: 16),
                                    const Text('Start your learning journey!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _showCreateDialog,
                                      child: const Text('Create First Topic'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              itemCount: topics.length,
                              itemBuilder: (context, index) {
                                final topic = topics[index];
                                final color = _getColor(topic.colorHex);
                                
                                return Card(
                                  elevation: 0,
                                  color: color.withOpacity(0.1),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(color: color.withOpacity(0.3)),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    leading: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(_getIconData(topic.iconKey), color: color),
                                    ),
                                    title: Text(
                                      topic.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      topic.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Icon(Icons.chevron_right, color: color),
                                    onTap: () {
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(builder: (context) => TopicDetailScreen(topic: topic))
                                      ).then((_) => _refresh());
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // History Tab
                const HistoryView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
