import 'package:equatable/equatable.dart';
import 'package:knowflow_ai/domain/entities/knowledge.dart';

class HomeState extends Equatable {
  final List<Knowledge> items;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    required this.items,
    required this.isLoading,
    this.errorMessage,
  });

  factory HomeState.initial() {
    return const HomeState(
      items: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  HomeState copyWith({
    List<Knowledge>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, errorMessage];
}
