abstract interface class KnowledgeRepository {
  Future<String> askQuestion(String question);
}
