import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:knowflow_ai/core/config/env.dart';
import 'package:knowflow_ai/core/Iservices/gemini_service.dart';

class GeminiServiceImpl implements GeminiService {
  late final GenerativeModel _model;
  late final GenerativeModel _embeddingModel;

  GeminiServiceImpl() {
    _model = GenerativeModel(
      model: Env.modelName,
      apiKey: Env.geminiApiKey,
      generationConfig: GenerationConfig(temperature: 0.0),
    );

    _embeddingModel = GenerativeModel(
      model: 'gemini-embedding-001',
      apiKey: Env.geminiApiKey,
    );
  }

  Future<T> _withRetry<T>(Future<T> Function() action) async {
    const maxRetries = 3;
    int retryCount = 0;
    while (true) {
      try {
        return await action();
      } catch (e) {
        // Kiểm tra xem lỗi có phải do quá giới hạn request (Rate limit/Quota) không
        if (e.toString().contains('429') ||
            e.toString().contains('quota') ||
            e.toString().contains('exhausted') ||
            e is GenerativeAIException) {
          retryCount++;
          if (retryCount > maxRetries) {
            rethrow;
          }
          // Nghỉ một chút trước khi thử lại (2s, 4s, 6s...)
          await Future.delayed(Duration(seconds: 2 * retryCount));
        } else {
          rethrow;
        }
      }
    }
  }

  @override
  Future<String> generateAnswer({required String prompt}) async {
    return await _withRetry(() async {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? '';
    });
  }

  @override
  Future<List<double>> getEmbedding(String text) async {
    return await _withRetry(() async {
      final content = Content.text(text);
      final response = await _embeddingModel.embedContent(content);
      return response.embedding.values;
    });
  }
}
