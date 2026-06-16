import 'dart:math'
    as math; // Nhớ import thư viện toán học để tính Cosine Similarity
import 'package:knowflow_ai/core/Iservices/search_service.dart';
import '../../../domain/entities/knowledge.dart';

class SearchServiceImpl implements SearchService {
  @override
  List<Knowledge> search({
    required String question,
    required List<Knowledge> data,
    List<double>? queryEmbedding,
  }) {
    // 1. Lexical Search (Tìm kiếm từ khóa dựa theo thuật toán cũ của bạn)
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
    ]; // loại bỏ các từ vô nghĩa
    final cleanQuestion = question.replaceAll(RegExp(r'[?,.!\"\n]'), ' ');
    final words = cleanQuestion
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => !stopWords.contains(w) && w.isNotEmpty)
        .toList();

    final lexicalScores = <Knowledge, int>{}; // khởi tạo ra một cái map
    for (final item in data) {
      int score = 0;
      final content = '${item.name} ${item.category} ${item.description} ${item.keywords.join(' ')}'.toLowerCase();
      for (final word in words) {
        if (content.contains(word)) {
          score++;
        }
      }
      if (score > 0) {
        lexicalScores[item] = score;
      }
    }

    final lexicalSorted = lexicalScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final lexicalList = lexicalSorted.map((e) => e.key).toList();

    // 2. Semantic Search (Tìm kiếm ngữ nghĩa tính khoảng cách Cosine Similarity)
    final semanticScores = <Knowledge, double>{};
    if (queryEmbedding != null) {
      for (final item in data) {
        if (item.embedding != null) {
          final similarity = _cosineSimilarity(queryEmbedding, item.embedding!);
          if (similarity > 0.0) {
            semanticScores[item] = similarity;
          }
        }
      }
    }

    final semanticSorted = semanticScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final semanticList = semanticSorted.map((e) => e.key).toList();

    // Dự phòng: Nếu không có câu hỏi dạng Vector hoặc không khớp ngữ nghĩa nào, dùng kết quả từ khóa
    if (queryEmbedding == null || semanticList.isEmpty) {
      return lexicalList.take(3).toList();
    }

    // 3. Xếp hạng lại bằng Reciprocal Rank Fusion (RRF) để kết hợp kết quả
    const int k = 60; // Hằng số chuẩn hóa của RRF
    final rrfScores = <Knowledge, double>{};
    final allCandidates = {...lexicalList, ...semanticList};

    for (final candidate in allCandidates) {
      double score = 0.0;

      // Hạng từ từ khóa (1-indexed)
      final lexicalRank = lexicalList.indexOf(candidate);
      if (lexicalRank != -1) {
        score += 1.0 / (k + (lexicalRank + 1));
      }

      // Hạng từ ngữ nghĩa (1-indexed)
      final semanticRank = semanticList.indexOf(candidate);
      if (semanticRank != -1) {
        score += 1.0 / (k + (semanticRank + 1));
      }

      rrfScores[candidate] = score;
    }

    // Sắp xếp các ứng viên theo điểm RRF giảm dần
    final rrfSorted = rrfScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Lấy 3 tài liệu tốt nhất
    return rrfSorted.take(3).map((e) => e.key).toList();
  }

  // Hàm toán học tính độ tương đồng Cosine giữa 2 Vector
  double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return 0.0;
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    if (normA == 0.0 || normB == 0.0) return 0.0;
    return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
  }
}
