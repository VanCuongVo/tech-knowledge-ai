import 'package:knowflow_ai/core/Iservices/search_service.dart';
import '../../../domain/entities/knowledge.dart';

class SearchServiceImpl implements SearchService {
  @override
  List<Knowledge> search({
    required String question,
    required List<Knowledge> data,
  }) {
    final stopWords = ['là', 'gì', 'gì?', 'như', 'thế', 'nào', 'nào?', 'và', 'của', 'có', 'cho'];
    final cleanQuestion = question.replaceAll(RegExp(r'[?,.!\"\n]'), ' ');
    final words = cleanQuestion.toLowerCase().split(RegExp(r'\s+')).where((w) => !stopWords.contains(w) && w.isNotEmpty).toList();
    final scores = <Knowledge, int>{};

    for (final item in data) {
      int score = 0;
      final content = item.rawData.toLowerCase();

      for (final word in words) {
        if (content.contains(word)) {
          score++;
        }
      }

      if (score > 0) {
        scores[item] = score;
      }
    }

    final result = scores.entries.toList();

    result.sort((a, b) => b.value.compareTo(a.value));

    return result.take(3).map((e) => e.key).toList();
  }
}
