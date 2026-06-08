abstract interface class GeminiService {
  Future<String> generateAnswer({required String prompt});
}
