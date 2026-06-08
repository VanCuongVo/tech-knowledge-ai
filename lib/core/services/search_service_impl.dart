import 'package:knowflow_ai/core/Iservices/search_service.dart';
import '../../../domain/entities/knowledge.dart';

class SearchServiceImpl implements SearchService {
  @override
  List<Knowledge> search({
    required String question,
    required List<Knowledge> data,
  }) {
    final stopWords = [
      'là',
      'gì',
      'gì?',
      'như',
      'thế',
      'nào',
      'nào?',
      'và',
      'của',
      'có',
      'cho',
    ]; // loại bỏ các từ vô nghĩa
    final cleanQuestion = question.replaceAll(
      RegExp(r'[?,.!\"\n]'),
      ' ',
    ); // loại bỏ cách dấu
    final words = cleanQuestion
        .toLowerCase()
        .split(RegExp(r'\s+')) // xuống dòng
        .where((w) => !stopWords.contains(w) && w.isNotEmpty)
        .toList(); // lấy lên caai những từ hợp lệ và ko có dấu cách
    final scores = <Knowledge, int>{};

    for (final item in data) {
      int score = 0;
      final content = item.rawData.toLowerCase(); // lấy lên tùng data đc hỏi

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
