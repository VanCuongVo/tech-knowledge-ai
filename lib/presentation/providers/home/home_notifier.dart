import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowflow_ai/domain/usecases/get_all_knowledge_usecase.dart';
import 'home_state.dart';

class HomeNotifier extends Notifier<HomeState> {
  final GetAllKnowledgeUseCase getAllKnowledgeUseCase;

  HomeNotifier(this.getAllKnowledgeUseCase);

  @override
  HomeState build() {
    // Automatically load data when the notifier is initialized
    Future.microtask(() => _loadData());
    return HomeState.initial().copyWith(isLoading: true);
  }

  Future<void> _loadData() async {
    if (!state.isLoading) {
      state = state.copyWith(isLoading: true);
    }
    try {
      final allItems = await getAllKnowledgeUseCase();
      final items = allItems.where((e) => e.imageUrl.isNotEmpty).toList();
      state = state.copyWith(items: items, isLoading: false, errorMessage: null);
    } catch (e) {
      print('Error loading knowledge: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refresh() async {
    await _loadData();
  }
}
