import 'package:knowflow_ai/domain/Irepositories/knowledge_repository.dart';

class AskAIUseCase {
  final KnowledgeRepository repository;

  AskAIUseCase(this.repository);

  Future<String> call(String question) {
    return repository.askQuestion(question);
  }
}
