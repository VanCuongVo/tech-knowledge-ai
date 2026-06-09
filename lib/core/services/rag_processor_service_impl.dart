import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle, AssetManifest;
import 'package:knowflow_ai/core/Iservices/gemini_service.dart';
import 'package:knowflow_ai/core/Iservices/rag_processor_service.dart'; // Import interface
import 'package:knowflow_ai/data/datasources/local/knowledge_local_datasource.dart';
import 'package:knowflow_ai/data/models/knowledge_model.dart';

class RAGProcessorServiceImpl implements RAGProcessorService {
  final GeminiService geminiService;
  final KnowledgeLocalDataSource localDataSource;

  RAGProcessorServiceImpl({
    required this.geminiService,
    required this.localDataSource,
  });

  @override
  Future<void> indexRagFolder() async {
    List<String> filePaths = [];
    try {
      // 1. Quét danh sách file trong assets/rag/ qua API AssetManifest mới
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      filePaths = manifest
          .listAssets()
          .where((String key) => key.startsWith('assets/rag/'))
          .toList();
    } catch (e) {
      print('Lỗi đọc AssetManifest: $e');
      return;
    }

    if (filePaths.isEmpty) {
      print('Không tìm thấy file nào trong assets/rag/');
      return;
    }

    // 2. Xóa sạch dữ liệu cũ trong DB để tránh trùng lặp
    await localDataSource.clearAllKnowledge();

    // 3. Xử lý từng file
    for (final path in filePaths) {
      try {
        final content = await rootBundle.loadString(path);

        final fileName = path
            .split('/')
            .last
            .replaceAll('.txt', '')
            .replaceAll('.md', '');
        String category = 'Document';
        if (fileName.toLowerCase().contains('cpu')) {
          category = 'CPU';
        } else if (fileName.toLowerCase().contains('gpu')) {
          category = 'GPU';
        }

        // 4. Phân đoạn văn bản (Text Chunking)
        final chunks = _chunkText(content, chunkSize: 400, overlap: 80);

        for (int i = 0; i < chunks.length; i++) {
          final chunkText = chunks[i];
          final chunkName = '$fileName (Đoạn ${i + 1})';

          // 5. Gọi Gemini sinh Vector Embedding cho đoạn văn bản này
          final textToEmbed =
              'Tài liệu: $chunkName. Thể loại: $category. Nội dung: $chunkText';
          
          List<double>? vector;
          try {
            vector = await geminiService.getEmbedding(textToEmbed);
          } catch (e) {
            print('Lỗi sinh vector cho chunk $chunkName: $e. Sẽ lưu không có vector.');
          }

          // 6. Lưu đoạn tài liệu kèm Vector tương ứng vào SQLite
          final knowledgeItem = KnowledgeModel(
            id: 0,
            name: chunkName,
            category: category,
            description: chunkText,
            keywords: fileName.toLowerCase().split('_'),
            rawData: jsonEncode({
              'source': path,
              'chunk_index': i,
              'content': chunkText,
            }),
            imageUrl: '',
            embedding: vector,
          );

          await localDataSource.insertKnowledge(knowledgeItem);
        }
      } catch (e) {
        print('Lỗi xử lý file $path: $e');
      }
    }
  }

  /// Hàm băm nhỏ văn bản có chồng lấn (overlap) giúp bảo toàn ngữ nghĩa
  List<String> _chunkText(
    String text, {
    required int chunkSize,
    required int overlap,
  }) {
    final List<String> chunks = [];
    if (text.length <= chunkSize) {
      return [text];
    }

    int start = 0;
    while (start < text.length) {
      int end = start + chunkSize;
      if (end > text.length) {
        end = text.length;
      }

      if (end < text.length) {
        final lastSpace = text.substring(start, end).lastIndexOf(' ');
        if (lastSpace != -1 && lastSpace > (chunkSize * 0.7)) {
          end = start + lastSpace;
        }
      }

      chunks.add(text.substring(start, end).trim());
      start = end - overlap;
      if (start < 0) start = 0;
      if (end >= text.length) break;
    }

    return chunks;
  }
}
