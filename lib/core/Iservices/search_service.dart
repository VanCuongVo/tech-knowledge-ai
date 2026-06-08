import '../../../domain/entities/knowledge.dart';

abstract interface class SearchService {
  List<Knowledge> search({
    required String question,
    required List<Knowledge> data,
  });
}
