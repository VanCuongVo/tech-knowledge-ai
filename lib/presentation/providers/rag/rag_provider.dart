import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowflow_ai/injection/dependency_injection.dart';
import 'package:knowflow_ai/core/Iservices/rag_processor_service.dart';
import 'package:knowflow_ai/presentation/providers/home/home_provider.dart';

enum RAGSyncStatus { idle, loading, success, error }

class RAGSyncState {
  final RAGSyncStatus status;
  final String? message;

  RAGSyncState({required this.status, this.message});

  RAGSyncState copyWith({RAGSyncStatus? status, String? message}) {
    return RAGSyncState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class RAGSyncNotifier extends Notifier<RAGSyncState> {
  @override
  RAGSyncState build() => RAGSyncState(status: RAGSyncStatus.idle);

  /// Tiến hành quét assets/rag/, tạo vector và nạp vào DB, sau đó tải lại trang chủ
  Future<void> syncRagFolder() async {
    state = state.copyWith(status: RAGSyncStatus.loading);
    try {
      final processor = sl<RAGProcessorService>();
      await processor.indexRagFolder();

      state = state.copyWith(status: RAGSyncStatus.success);
      ref
          .read(homeProvider.notifier)
          .refresh(); // Làm mới danh sách màn hình chính
    } catch (e) {
      state = state.copyWith(
        status: RAGSyncStatus.error,
        message: e.toString(),
      );
    }
  }
}

final ragSyncProvider = NotifierProvider<RAGSyncNotifier, RAGSyncState>(() {
  return RAGSyncNotifier();
});
