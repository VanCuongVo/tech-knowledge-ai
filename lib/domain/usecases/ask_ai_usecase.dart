import 'package:knowflow_ai/domain/repositories/knowledge_repository.dart';

class AskAIUseCase {
  final KnowledgeRepository repository;

  AskAIUseCase(this.repository);

  Future<String> call(String question) {
    return repository.askQuestion(question);
  }
}
