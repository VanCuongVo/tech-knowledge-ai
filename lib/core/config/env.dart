import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get geminiApiKey => (dotenv.env['GEMINI_API_KEY'] ?? '').trim();

  static String get modelName =>
      (dotenv.env['MODEL_NAME'] ?? 'gemini-2.5-flash').trim();
}
