import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowflow_ai/domain/usecases/get_all_knowledge_usecase.dart';
import 'package:knowflow_ai/injection/dependency_injection.dart';

import 'home_notifier.dart';
import 'home_state.dart';

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(() {
  final useCase = sl<GetAllKnowledgeUseCase>();
  return HomeNotifier(useCase);
});
