import 'package:knowflow_ai/data/models/knowledge_model.dart';

abstract interface class KnowledgeLocalDataSource {
  Future<List<KnowledgeModel>> getAllKnowledge();
  Future<void> updateKnowledgeEmbedding(int id, List<double> embedding);
  Future<void> insertKnowledge(KnowledgeModel knowledge);
  Future<void> clearAllKnowledge();
}
