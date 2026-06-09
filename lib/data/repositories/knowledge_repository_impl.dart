import 'package:knowflow_ai/core/Iservices/gemini_service.dart';
import 'package:knowflow_ai/core/Iservices/search_service.dart';
import 'package:knowflow_ai/data/datasources/local/knowledge_local_datasource.dart';
import 'package:knowflow_ai/domain/entities/knowledge.dart';
import 'package:knowflow_ai/domain/repositories/knowledge_repository.dart';
import '../../core/constants/prompt_constants.dart';

class KnowledgeRepositoryImpl implements KnowledgeRepository {
  final GeminiService geminiService;
  final SearchService searchService;
  final KnowledgeLocalDataSource local;

  KnowledgeRepositoryImpl({
    required this.geminiService,
    required this.searchService,
    required this.local,
  });

  @override
  Future<List<Knowledge>> getAllKnowledge() async {
    return await local.getAllKnowledge();
  }

  @override
  Future<String> askQuestion(String question) async {
    final data = await local.getAllKnowledge();

    // 1. Tạo Vector Embedding cho câu hỏi của người dùng
    List<double>? queryEmbedding;
    try {
      queryEmbedding = await geminiService.getEmbedding(question);
    } catch (e) {
      print(
        'Lỗi sinh embedding câu hỏi: $e. Sẽ tự động dùng Lexical Search dự phòng.',
      );
    }

    // 2. Gọi search với tham số queryEmbedding để thực hiện Hybrid Search
    final results = searchService.search(
      question: question,
      data: data,
      queryEmbedding: queryEmbedding,
    );

    if (results.isEmpty) {
      return '''Tôi không tìm thấy thông tin trong cơ sở tri thức.''';
    }

    final context = results
        .map((e) {
          return e.description;
        })
        .join('\n\n');

    print('=== DỮ LIỆU GỬI LÊN GEMINI ===');
    print(context);
    print('==============================');

    final prompt =
        '''
${PromptConstants.systemPrompt}

DỮ LIỆU:

$context

CÂU HỎI:

$question
''';

    return geminiService.generateAnswer(prompt: prompt);
  }
}
