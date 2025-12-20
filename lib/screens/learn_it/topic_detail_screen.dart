import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../models/learn_it/learn_it_models.dart';
import '../../services/learn_it_service.dart';
import 'discussion_sheet.dart';
import 'loading_trivia_view.dart';

class TopicDetailScreen extends StatefulWidget {
  final Topic topic;
  final LearnedItem? initialItem;
  final bool isReviewMode;

  const TopicDetailScreen({
    super.key, 
    required this.topic,
    this.initialItem,
    this.isReviewMode = false,
  });

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  LearnedItem? _currentItem;
  bool _isLoading = false;
  bool _canMarkUnderstood = false;
  final ScrollController _scrollController = ScrollController();
  
  // Queue for multiple pending items
  List<LearnedItem> _pendingQueue = [];
  bool _enteredFromHistory = false;

  @override
  void initState() {
    super.initState();
    _enteredFromHistory = widget.initialItem != null;
    
    if (_enteredFromHistory) {
      _currentItem = widget.initialItem;
      _canMarkUnderstood = widget.isReviewMode; // Already understood?
      
      // If we entered with a pending item (from history), we might want to load the REST of the pending items too.
      if (!widget.isReviewMode && _currentItem != null) {
          _queueRemainingPending();
      }
    } else {
      // Check for pending items before generating new one
      _checkPendingAndLoad();
    }
    
    _scrollController.addListener(_onScroll);
  }

  Future<void> _queueRemainingPending() async {
    // Fetch all pending
    final pending = await LearnItService.instance.repository.getPendingItemsForTopic(widget.topic.id);
    // Filter out the current one
    if (mounted && _currentItem != null) {
        setState(() {
            _pendingQueue = pending.where((i) => i.id != _currentItem!.id).toList();
        });
    }
  }

  Future<void> _checkPendingAndLoad() async {
    // We can't show dialog in initState immediately, wait for build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final pending = await LearnItService.instance.repository.getPendingItemsForTopic(widget.topic.id);
        
        if (pending.isNotEmpty && mounted) {
          final count = pending.length;
          
          final resume = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Resume Learning?'),
              content: Text('You have $count pending concept(s) to complete.\n\nDo you want to resume them?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), // No, discard queue and generate new
                  child: const Text('No, New Concept'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true), // Yes, load queue
                  child: const Text('Yes, Resume'),
                ),
              ],
            ),
          );

          if (resume == true) {
             if (mounted) {
               setState(() {
                 // Load the first one immediately
                 _pendingQueue = List.from(pending);
                 _loadNextFromQueue();
               });
             }
          } else {
            // User chose NO. Should we clear pending items? No, just ignore them for now.
            // But next time they will appear again.
            // For now, proceed to generate NEW.
             _loadNextConcept(forceGenerate: true);
          }
        } else {
          _loadNextConcept(forceGenerate: true);
        }
      } catch (e) {
        _loadNextConcept(forceGenerate: true); // Fallback
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_canMarkUnderstood && _currentItem != null) {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
        setState(() {
          _canMarkUnderstood = true;
        });
      }
    }
  }

  void _loadNextFromQueue() {
      if (_pendingQueue.isEmpty) {
          // Queue finished!
          if (_enteredFromHistory) {
              // If we came from history and finished queue, we are done.
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All pending items completed!')));
              Navigator.pop(context); 
          } else {
              // If we came from Home loop, continue to generate NEW.
              _loadNextConcept(forceGenerate: true);
          }
          return;
      }

      final nextItem = _pendingQueue.removeAt(0);
      setState(() {
          _currentItem = nextItem;
          _isLoading = false;
          _canMarkUnderstood = false;
      });
      
      _checkScroll();
  }

  void _checkScroll() {
       WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
             // Reset scroll to top
             _scrollController.jumpTo(0);
             
             if (_scrollController.position.maxScrollExtent == 0) {
                 setState(() => _canMarkUnderstood = true);
             }
          }
       });
  }

  Future<void> _loadNextConcept({bool forceGenerate = false}) async {
    if (!forceGenerate && _pendingQueue.isNotEmpty) {
        _loadNextFromQueue();
        return;
    }

    setState(() {
      _isLoading = true;
      _currentItem = null;
      _canMarkUnderstood = false;
    });

    try {
      final item = await LearnItService.instance.generateNextConcept(widget.topic);
      if (mounted) {
        setState(() {
          _currentItem = item;
          _isLoading = false;
        });
        _checkScroll();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _markUnderstood() async {
    if (_currentItem == null) return;

    try {
      await LearnItService.instance.repository.markItemAsUnderstood(_currentItem!.id);
      
      // Load next
      await _loadNextConcept();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _openDiscussion() {
    if (_currentItem == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => DiscussionSheet(
          item: _currentItem!,
          scrollController: controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        actions: [
          if (_currentItem != null)
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: _openDiscussion,
              tooltip: 'Discuss',
            ),
        ],
      ),
      body: _isLoading
          ? LoadingTriviaView(topicId: widget.topic.id)
          : _currentItem == null
              ? const Center(child: Text('Failed to load.'))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentItem!.conceptTitle,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            MarkdownBody(
                              data: _currentItem!.contentBody,
                              selectable: true,
                              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                p: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(height: 100), // Bottom padding for button
                          ],
                        ),
                      ),
                    ),
                    if (!widget.isReviewMode)
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _canMarkUnderstood ? _markUnderstood : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              ),
                              child: Text(
                                _canMarkUnderstood ? 'I Understood This' : 'Read to the end',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}