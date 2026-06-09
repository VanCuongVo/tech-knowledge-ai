// trả lời câu hỏi dựa theo câu prompt
abstract interface class GeminiService {
  Future<String> generateAnswer({required String prompt});
  Future<List<double>> getEmbedding(String text);
}
