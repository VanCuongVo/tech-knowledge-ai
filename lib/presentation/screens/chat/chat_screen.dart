import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/chat/chat_provider.dart';
import '../../widgets/chat_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('KnowFlow AI')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (_, index) {
                final message = state.messages[index];

                return ChatBubble(
                  text: message.content,
                  isUser: message.role.name == 'user',
                );
              },
            ),
          ),

          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: controller)),

                IconButton(
                  onPressed: () {
                    ref
                        .read(chatProvider.notifier)
                        .sendMessage(controller.text);

                    controller.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
