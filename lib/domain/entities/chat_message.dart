import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant }

class ChatMessage extends Equatable {
  final String content;
  final MessageRole role;
  final DateTime createdAt;

  const ChatMessage({
    required this.content,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [content, role, createdAt];
}
