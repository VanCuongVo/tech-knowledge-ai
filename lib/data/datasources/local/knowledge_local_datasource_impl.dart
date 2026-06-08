import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:knowflow_ai/data/models/knowledge_model.dart';
import 'knowledge_local_datasource.dart';

import 'package:knowflow_ai/core/database/database_helper.dart';

class KnowledgeLocalDataSourceImpl implements KnowledgeLocalDataSource {
  @override
  Future<List<KnowledgeModel>> getAllKnowledge() async {
    if (kIsWeb) {
      // Mock data for Web to avoid sqflite errors
      final mockMaps = [
        {
          'id': 1,
          'name': 'RTX 4060',
          'category': 'GPU',
          'description': 'NVIDIA RTX 4060 với 8GB VRAM GDDR6, hỗ trợ DLSS 3 và Ray Tracing, phù hợp gaming 1080p.',
          'keywords': 'rtx,gpu,nvidia,4060,dlss,raytracing,gaming',
          'imageUrl': 'assets/images/rtx4060.jpg',
        },
        {
          'id': 2,
          'name': 'RTX 4070',
          'category': 'GPU',
          'description': 'NVIDIA RTX 4070 với 12GB VRAM, hiệu năng mạnh cho gaming 1440p và xử lý AI cơ bản.',
          'keywords': 'rtx,gpu,nvidia,4070,1440p,ai',
          'imageUrl': 'assets/images/rtx4070.jpg',
        },
        {
          'id': 3,
          'name': 'Ryzen 5 7600',
          'category': 'CPU',
          'description': 'AMD Ryzen 5 7600 gồm 6 nhân 12 luồng, socket AM5, phù hợp lập trình và gaming.',
          'keywords': 'amd,ryzen,cpu,7600,am5',
          'imageUrl': 'assets/images/ryzen7600.jpg',
        },
        {
          'id': 4,
          'name': 'Intel Core i5-13400F',
          'category': 'CPU',
          'description': 'Intel Core i5-13400F có 10 nhân 16 luồng, hiệu năng tốt cho học tập, lập trình và gaming.',
          'keywords': 'intel,cpu,i5,13400f',
          'imageUrl': 'assets/images/i513400f.jpg',
        },
        {
          'id': 5,
          'name': 'Samsung 990 Pro',
          'category': 'SSD',
          'description': 'SSD NVMe PCIe Gen4 tốc độ đọc lên đến 7450 MB/s, phù hợp cho gaming và workstation.',
          'keywords': 'ssd,samsung,990pro,nvme,pcie4',
          'imageUrl': 'assets/images/samsung990pro.jpg',
        },
      ];
      return mockMaps.map((map) {
        return KnowledgeModel(
          id: map['id'] as int,
          name: map['name'] as String,
          category: map['category'] as String,
          description: map['description'] as String,
          keywords: (map['keywords'] as String).split(','),
          rawData: jsonEncode(map),
          imageUrl: map['imageUrl'] as String,
        );
      }).toList();
    }

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
