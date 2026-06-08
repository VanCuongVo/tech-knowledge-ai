import 'dart:convert';
import 'package:knowflow_ai/data/models/knowledge_model.dart';
import 'knowledge_local_datasource.dart';

import 'package:knowflow_ai/core/database/database_helper.dart';

class KnowledgeLocalDataSourceImpl implements KnowledgeLocalDataSource {
  @override
  Future<List<KnowledgeModel>> getAllKnowledge() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('knowledge');

    return maps.map((map) {
      // Xử lý keywords dạng chuỗi cách nhau dấu phẩy từ DB
      List<String> keywordsList = [];
      if (map['keywords'] != null) {
        final keywordsStr = map['keywords'] as String;
        if (keywordsStr.startsWith('[')) {
          keywordsList = List<String>.from(jsonDecode(keywordsStr));
        } else {
          keywordsList = keywordsStr.split(',').map((e) => e.trim()).toList();
        }
      }

      return KnowledgeModel(
        id: map['id'],
        name: map['name'],
        category: map['category'],
        description: map['description'],
        keywords: keywordsList,
        rawData: jsonEncode(map),
        imageUrl: map['imageUrl'] ?? '',
      );
    }).toList();
  }
}
