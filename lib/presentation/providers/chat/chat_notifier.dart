import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/usecases/ask_ai_usecase.dart';
import 'chat_state.dart';

class ChatNotifier extends Notifier<ChatState> {
  final AskAIUseCase askAIUseCase;

  ChatNotifier(this.askAIUseCase);

  @override
  ChatState build() {
    return ChatState.initial();
  }

  Future<void> sendMessage(String question) async {
    if (question.trim().isEmpty) {
      return;
    }

    final userMessage = ChatMessage(
      content: question,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      final answer = await askAIUseCase(question);

      final aiMessage = ChatMessage(
        content: answer,
        role: MessageRole.assistant,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      String errorMsg = "Đã xảy ra lỗi: $e";
      
      // Bắt các lỗi liên quan đến giới hạn API (Rate limit) của Gemini
      if (e.toString().contains('429') || 
          e.toString().contains('quota') || 
          e.toString().contains('exhausted')) {
        errorMsg = "Hệ thống AI đang nhận quá nhiều yêu cầu cùng lúc. Bạn vui lòng chờ một lát rồi hỏi lại nhé!";
      }

      final errorMessage = ChatMessage(
        content: errorMsg,
        role: MessageRole.assistant,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isLoading: false,
      );
    }
  }
}
