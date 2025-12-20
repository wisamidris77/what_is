import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/learn_it/learn_it_models.dart';
import '../../services/learn_it_service.dart';
import 'topic_detail_screen.dart';

class TopicHistoryScreen extends StatefulWidget {
  final Topic topic;

  const TopicHistoryScreen({super.key, required this.topic});

  @override
  State<TopicHistoryScreen> createState() => _TopicHistoryScreenState();
}

class _TopicHistoryScreenState extends State<TopicHistoryScreen> {
  List<LearnedItem> _allItems = [];
  List<LearnedItem> _filteredItems = [];
  bool _isLoading = true;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final items = await LearnItService.instance.repository.getLearnedItemsForTopic(widget.topic.id);
      // Sort by date descending (newest first). Pending items (null learnedAt) usually go top or bottom?
      // Let's put Pending at top, then Newest understood.
      items.sort((a, b) {
        if (!a.isUnderstood && b.isUnderstood) return -1;
        if (a.isUnderstood && !b.isUnderstood) return 1;
        
        // Both pending or both understood
        // If understood, use learnedAt
        if (a.learnedAt != null && b.learnedAt != null) {
          return b.learnedAt!.compareTo(a.learnedAt!);
        }
        // If pending, maybe use ID or just keep as is
        return 0;
      });

      if (mounted) {
        setState(() {
          _allItems = items;
          _applyFilter();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    if (_dateRange == null) {
      _filteredItems = List.from(_allItems);
    } else {
      _filteredItems = _allItems.where((item) {
        if (item.learnedAt == null) return true; // Keep pending items visible? Or filter them too?
        // Let's keep pending items visible always as they are "Active". 
        // Or if filter is strictly date, maybe hide them? 
        // User asked "filter by date range only". Usually pending items don't have a date.
        // I'll show them if they fall in range (which is impossible if null) OR show them always.
        // Let's show them always to be safe, or user might lose them.
        return true; 
        // Wait, if I want to filter history, I probably want to see what I did in that week.
        // But pending items are "todo".
        // Let's check item.learnedAt.
        // return item.learnedAt!.isAfter(_dateRange!.start) && item.learnedAt!.isBefore(_dateRange!.end);
      }).toList();
      
      // Correct logic:
      _filteredItems = _allItems.where((item) {
        if (!item.isUnderstood) return true; // Always show pending
        if (item.learnedAt == null) return false;
        return item.learnedAt!.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) && 
               item.learnedAt!.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }
  }

  Future<void> _pickDateRange() async {
    final newRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );

    if (newRange != null) {
      setState(() {
        _dateRange = newRange;
        _applyFilter();
      });
    }
  }

  Future<void> _markUnderstood(LearnedItem item) async {
    await LearnItService.instance.repository.markItemAsUnderstood(item.id);
    _loadHistory(); // Reload to update status and sort
  }

  void _openItem(LearnedItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicDetailScreen(
          topic: widget.topic,
          initialItem: item,
          isReviewMode: item.isUnderstood, // If understood, review mode. If pending, active mode.
        ),
      ),
    ).then((_) => _loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.topic.title} History',
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: _pickDateRange,
            tooltip: 'Filter by Date',
          ),
          if (_dateRange != null)
             IconButton(
              icon: const Icon(Icons.filter_alt_off_outlined),
              onPressed: () {
                setState(() {
                  _dateRange = null;
                  _applyFilter();
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: onSurface.withOpacity(0.2)),
                      const SizedBox(height: 16),
                      Text(
                        'No history found.',
                        style: TextStyle(color: onSurface.withOpacity(0.5), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: item.isUnderstood 
                                ? onSurface.withOpacity(0.1) // Subtle border for done
                                : primaryColor, // Bold border for pending
                            width: item.isUnderstood ? 1 : 2,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          onTap: () => _openItem(item),
                          title: Text(
                            item.conceptTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              decoration: item.isUnderstood ? TextDecoration.lineThrough : null,
                              decorationColor: onSurface.withOpacity(0.3),
                              color: item.isUnderstood ? onSurface.withOpacity(0.6) : onSurface,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              item.isUnderstood
                                  ? (item.learnedAt != null 
                                      ? DateFormat.yMMMd().add_jm().format(item.learnedAt!) 
                                      : 'Completed')
                                  : 'PENDING',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: item.isUnderstood ? onSurface.withOpacity(0.4) : primaryColor,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          leading: item.isUnderstood
                              ? Icon(Icons.check_circle_outline, color: onSurface.withOpacity(0.3))
                              : Icon(Icons.circle_outlined, color: primaryColor),
                          trailing: item.isUnderstood
                              ? null
                              : IconButton(
                                  icon: Icon(Icons.check, weight: 800, color: primaryColor),
                                  onPressed: () => _markUnderstood(item),
                                  tooltip: 'Mark as Understood',
                                ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
