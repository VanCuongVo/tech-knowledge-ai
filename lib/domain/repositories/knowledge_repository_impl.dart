import 'package:knowflow_ai/core/Iservices/gemini_service.dart';
import 'package:knowflow_ai/core/Iservices/search_service.dart';
import 'package:knowflow_ai/data/datasources/local/knowledge_local_datasource.dart';
import 'package:knowflow_ai/domain/Irepositories/knowledge_repository.dart';
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
  Future<String> askQuestion(String question) async {
    final data = await local.getAllKnowledge();
    final results = searchService.search(question: question, data: data);

    if (results.isEmpty) {
      return '''Tôi không tìm thấy thông tin trong cơ sở tri thức.''';
    }

    final context = results
        .map((e) {
          return e.rawData;
        })
        .join('\n\n');

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
