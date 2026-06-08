import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:knowflow_ai/core/config/env.dart';
import 'package:knowflow_ai/core/Iservices/gemini_service.dart';

class GeminiServiceImpl implements GeminiService {
  late final GenerativeModel _model;

  GeminiServiceImpl() {
    _model = GenerativeModel(
      model: Env.modelName,
      apiKey: Env.geminiApiKey,
      generationConfig: GenerationConfig(temperature: 0.0),
    );
  }

  @override
  Future<String> generateAnswer({required String prompt}) async {
    final response = await _model.generateContent([Content.text(prompt)]);

    return response.text ?? '';
  }
}
