import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/ask_ai_usecase.dart';
import '../../../injection/dependency_injection.dart';
import 'chat_notifier.dart';
import 'chat_state.dart';

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(() {
  final useCase = sl<AskAIUseCase>();

  return ChatNotifier(useCase);
});
