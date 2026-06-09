abstract interface class RAGProcessorService {
  /// Khai báo hàm quét thư mục RAG, sinh vector và nạp vào DB
  Future<void> indexRagFolder();
}
