import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để sử dụng Clipboard, LogicalKeyboardKey, v.v.
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

  /// Hàm phụ trợ để thực hiện dán văn bản tại vị trí con trỏ hiện tại
  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      final text = clipboardData.text!;
      final value = controller.value;
      
      int start = value.selection.start;
      int end = value.selection.end;
      
      // Nếu chưa focus hoặc không có con trỏ, dán vào cuối văn bản
      if (start < 0 || end < 0) {
        start = value.text.length;
        end = value.text.length;
      }

      final newText = value.text.replaceRange(start, end, text);
      final newSelection = TextSelection.collapsed(offset: start + text.length);

      setState(() {
        controller.value = TextEditingValue(
          text: newText,
          selection: newSelection,
        );
      });
    }
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Nút Paste nhanh nội dung từ clipboard vào ô chat bằng click chuột
                IconButton(
                  onPressed: _pasteFromClipboard,
                  icon: const Icon(Icons.paste, color: Colors.blue),
                  tooltip: 'Dán từ clipboard',
                ),

                Expanded(
                  child: CallbackShortcuts(
                    bindings: {
                      // Bắt phím tắt Ctrl + V (cho Windows)
                      const SingleActivator(LogicalKeyboardKey.keyV, control: true): _pasteFromClipboard,
                      // Bắt phím tắt Cmd + V (cho macOS)
                      const SingleActivator(LogicalKeyboardKey.keyV, meta: true): _pasteFromClipboard,
                    },
                    child: TextField(
                      controller: controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn hoặc dán prompt...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                IconButton(
                  onPressed: () {
                    if (controller.text.trim().isEmpty) return;
                    ref
                        .read(chatProvider.notifier)
                        .sendMessage(controller.text);

                    controller.clear();
                  },
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
