import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../models/learn_it/learn_it_models.dart';
import '../../services/learn_it_service.dart';

class DiscussionSheet extends StatefulWidget {
  final LearnedItem item;
  final ScrollController scrollController;

  const DiscussionSheet({
    super.key,
    required this.item,
    required this.scrollController,
  });

  @override
  State<DiscussionSheet> createState() => _DiscussionSheetState();
}

class _DiscussionSheetState extends State<DiscussionSheet> {
  final _inputController = TextEditingController();
  final List<DiscussionMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  String _streamingResponse = '';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await LearnItService.instance.repository.getMessagesForItem(widget.item.id);
    if (mounted) {
      setState(() {
        _messages.addAll(history);
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    _inputController.clear();
    setState(() {
      _isSending = true;
      _streamingResponse = '';
      _messages.add(DiscussionMessage(
        id: 'temp_user',
        learnedItemId: widget.item.id,
        role: MessageRole.user,
        content: text,
        timestamp: DateTime.now(),
      ));
    });

    try {
      final stream = await LearnItService.instance.discussConcept(widget.item, text);
      
      await for (final chunk in stream) {
        if (mounted) {
          setState(() {
            _streamingResponse += chunk;
          });
        }
      }

      if (mounted) {
        setState(() {
          _messages.add(DiscussionMessage(
            id: 'temp_ai',
            learnedItemId: widget.item.id,
            role: MessageRole.assistant,
            content: _streamingResponse,
            timestamp: DateTime.now(),
          ));
          _streamingResponse = '';
          _isSending = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(DiscussionMessage(
            id: 'error',
            learnedItemId: widget.item.id,
            role: MessageRole.assistant,
            content: "Error: $e",
            timestamp: DateTime.now(),
          ));
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Discuss: ${widget.item.conceptTitle}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Chat Area
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isSending ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        // Streaming bubble
                        return _buildMessageBubble(
                          DiscussionMessage(
                            id: 'streaming',
                            learnedItemId: widget.item.id,
                            role: MessageRole.assistant,
                            content: _streamingResponse.isEmpty ? '...' : _streamingResponse,
                            timestamp: DateTime.now(),
                          ),
                          true
                        );
                      }
                      return _buildMessageBubble(_messages[index], false);
                    },
                  ),
          ),

          // Input Area
          Padding(
            padding: EdgeInsets.only(
              left: 16, 
              right: 16, 
              top: 16, 
              bottom: 16 + MediaQuery.of(context).viewInsets.bottom
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    enabled: !_isSending,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isSending ? null : _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(DiscussionMessage message, bool isStreaming) {
    final isUser = message.role == MessageRole.user;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isUser 
        ? Theme.of(context).primaryColor.withOpacity(0.1)
        : Theme.of(context).colorScheme.surfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(16),
              ),
            ),
            child: MarkdownBody(
              data: message.content,
              selectable: true,
            ),
          ),
          if (isStreaming) ...[
            const SizedBox(height: 4),
            const Text('AI is typing...', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ],
      ),
    );
  }
}
