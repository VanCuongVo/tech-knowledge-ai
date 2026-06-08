import '../../../domain/entities/knowledge.dart';

// Tìm kiếm những kiến thức liên quan bên trong file json
abstract interface class SearchService {
  List<Knowledge> search({
    required String question,
    required List<Knowledge> data,
  });
}
