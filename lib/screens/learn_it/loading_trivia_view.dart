import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/learn_it/learn_it_models.dart';
import '../../services/learn_it_service.dart';

class LoadingTriviaView extends StatefulWidget {
  final String topicId;

  const LoadingTriviaView({super.key, required this.topicId});

  @override
  State<LoadingTriviaView> createState() => _LoadingTriviaViewState();
}

class _LoadingTriviaViewState extends State<LoadingTriviaView> {
  List<TriviaFact> _trivia = [];
  int _currentIndex = 0;
  bool _isFetching = false;
  
  Timer? _displayTimer;
  Timer? _progressTimer;
  
  static const int _displayDurationSeconds = 6;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchMoreTrivia();
  }

  @override
  void dispose() {
    _displayTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchMoreTrivia() async {
    if (_isFetching) return;
    
    setState(() => _isFetching = true);
    
    try {
      final newTrivia = await LearnItService.instance.getLoadingTrivia(widget.topicId);
      if (mounted) {
        setState(() {
          _trivia.addAll(newTrivia);
          _isFetching = false;
          
          // If this was the first fetch or we were empty, start the cycle
          if (_trivia.isNotEmpty && (_displayTimer == null || !_displayTimer!.isActive)) {
             _currentIndex = 0; // Reset index for new batch if we were empty
             _startDisplayCycle();
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  void _startDisplayCycle() {
    _displayTimer?.cancel();
    _progressTimer?.cancel();
    
    _showNext();
    
    _displayTimer = Timer.periodic(const Duration(seconds: _displayDurationSeconds), (timer) {
      _showNext();
    });
  }

  void _showNext() {
    if (_trivia.isEmpty) return;

    final currentFact = _trivia[_currentIndex];
    // Mark as shown in DB
    LearnItService.instance.markTriviaShown(currentFact.id);

    setState(() {
      _progressValue = 0.0;
    });

    // Reset progress animation
    _progressTimer?.cancel();
    const step = 50; // ms
    final totalSteps = (_displayDurationSeconds * 1000) / step;
    final increment = 1.0 / totalSteps;

    _progressTimer = Timer.periodic(const Duration(milliseconds: step), (timer) {
      if (mounted) {
        setState(() {
          _progressValue += increment;
          if (_progressValue >= 1.0) {
            _progressValue = 1.0;
            timer.cancel();
          }
        });
      }
    });

    // Check if we need more trivia
    // Logic: If we are nearing the end of our current local list, 
    // AND the total remaining in DB might be low (handled by service),
    // we trigger replenish.
    // Actually, `getLoadingTrivia` manages the "fetch 30" if DB is low.
    // Here we just need to make sure we have items to show locally.
    // If we are at the last item, loop back? Or fetch more?
    // User said "complete from where you started".
    // We linearly consume the list.
    
    if (_currentIndex >= _trivia.length - 1) {
      // Reached end of local buffer. Fetch more from DB (which should have been replenished).
      _fetchMoreTrivia();
      // Reset index to 0 of the NEW appended items?
      // Actually _fetchMoreTrivia appends. So we just increment index.
    }
    
    // Trigger replenish if we have few items left in local buffer
    if (_trivia.length - _currentIndex < 3) {
       LearnItService.instance.replenishTrivia(widget.topicId);
    }
    
    // Prepare index for NEXT tick
    setState(() {
        if (_trivia.length > _currentIndex + 1) {
            _currentIndex++;
        } else {
             // Stay on last or loop? 
             // If fetch is slow, we might loop or wait. 
             // Let's loop for safety but ideally fetch adds more.
             // _currentIndex = 0; 
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 48),
            
            if (_trivia.isNotEmpty) ...[
              Container(
                constraints: const BoxConstraints(minHeight: 100),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Text(
                    _trivia[_currentIndex].content,
                    key: ValueKey<String>(_trivia[_currentIndex].id),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: _progressValue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ] else ...[
               // Shimmer Placeholder
               Shimmer.fromColors(
                 baseColor: Colors.grey[300]!,
                 highlightColor: Colors.grey[100]!,
                 child: Column(
                   children: [
                     Container(height: 20, width: double.infinity, color: Colors.white),
                     const SizedBox(height: 8),
                     Container(height: 20, width: 200, color: Colors.white),
                   ],
                 ),
               ),
            ],
          ],
        ),
      ),
    );
  }
}
