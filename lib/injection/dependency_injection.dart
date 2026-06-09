import 'package:get_it/get_it.dart';
import 'package:knowflow_ai/core/Iservices/gemini_service.dart';
import 'package:knowflow_ai/core/Iservices/rag_processor_service.dart';
import 'package:knowflow_ai/core/Iservices/search_service.dart';
import 'package:knowflow_ai/core/services/gemini_service_impl.dart';
import 'package:knowflow_ai/core/services/rag_processor_service_impl.dart';
import 'package:knowflow_ai/core/services/search_service_impl.dart';
import 'package:knowflow_ai/data/datasources/local/knowledge_local_datasource.dart';
import 'package:knowflow_ai/data/datasources/local/knowledge_local_datasource_impl.dart';
import 'package:knowflow_ai/data/repositories/knowledge_repository_impl.dart';
import 'package:knowflow_ai/domain/repositories/knowledge_repository.dart';

import 'package:knowflow_ai/domain/usecases/ask_ai_usecase.dart';

import 'package:knowflow_ai/domain/usecases/get_all_knowledge_usecase.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton<GeminiService>(() => GeminiServiceImpl());

  sl.registerLazySingleton<SearchService>(() => SearchServiceImpl());

  sl.registerLazySingleton<KnowledgeLocalDataSource>(
    () => KnowledgeLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<KnowledgeRepository>(
    () => KnowledgeRepositoryImpl(
      geminiService: sl(),
      searchService: sl(),
      local: sl(),
    ),
  );

  sl.registerLazySingleton(() => AskAIUseCase(sl()));
  sl.registerLazySingleton(() => GetAllKnowledgeUseCase(sl()));

  sl.registerLazySingleton<RAGProcessorService>(
    () => RAGProcessorServiceImpl(geminiService: sl(), localDataSource: sl()),
  );
}
