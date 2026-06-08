import 'package:knowflow_ai/data/knowledge_model.dart';

abstract interface class KnowledgeLocalDataSource {
  Future<List<KnowledgeModel>> getAllKnowledge();
}
