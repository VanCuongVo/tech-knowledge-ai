import 'package:knowflow_ai/domain/entities/knowledge.dart';
import 'package:knowflow_ai/domain/repositories/knowledge_repository.dart';

class GetAllKnowledgeUseCase {
  final KnowledgeRepository repository;

  GetAllKnowledgeUseCase(this.repository);

  Future<List<Knowledge>> call() {
    return repository.getAllKnowledge();
  }
}
