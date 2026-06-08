import 'package:knowflow_ai/domain/entities/knowledge.dart';

abstract interface class KnowledgeRepository {
  Future<List<Knowledge>> getAllKnowledge();
  Future<String> askQuestion(String question);
}
