import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/car_repository.dart';
import 'intent_detector.dart';
import 'response_engine.dart';
import 'chat_context.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];

  final CarRepository _repo = CarRepository();
  final ChatContext _context = ChatContext();

  bool _botTyping = false;

  void _send() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(input, true));
      _botTyping = true;
      _controller.clear();
    });

    final intent = IntentDetector.detect(input);
    final reply = ResponseEngine.reply(input, intent, _context);

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _messages.add(
        _ChatMessage(
          '${reply.text}\n\nConfidence: ${reply.confidence}%',
          false,
        ),
      );
      _botTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CarModel>>(
      stream: _repo.getAllCars(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Car Assistant')),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) {
                    final m = _messages[i];
                    return Align(
                      alignment:
                      m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                          m.isUser ? Colors.deepPurple : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          m.text,
                          style: TextStyle(
                            color:
                            m.isUser ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (_botTyping)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      CircularProgressIndicator(strokeWidth: 2),
                      SizedBox(width: 12),
                      Text('Assistant is typing...'),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Ask about cars...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _send,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage(this.text, this.isUser);
}
