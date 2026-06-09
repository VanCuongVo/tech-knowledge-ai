import 'dart:convert';
import '../../../domain/entities/knowledge.dart';

class KnowledgeModel extends Knowledge {
  const KnowledgeModel({
    required super.id,
    required super.category,
    required super.name,
    required super.description,
    required super.keywords,
    required super.rawData,
    required super.imageUrl,
    super.embedding,
  });

  factory KnowledgeModel.fromJson(Map<String, dynamic> json) {
    List<double>? embeddingList;
    if (json['embedding'] != null) {
      if (json['embedding'] is String) {
        embeddingList = List<double>.from(
          jsonDecode(json['embedding']).map((e) => (e as num).toDouble()),
        );
      } else {
        embeddingList = List<double>.from(
          json['embedding'].map((e) => (e as num).toDouble()),
        );
      }
    }
    return KnowledgeModel(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      rawData: jsonEncode(json),
      imageUrl: json['imageUrl'] ?? '',
      embedding: embeddingList,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'category': category,
      'description': description,
      'keywords': jsonEncode(keywords),
      'imageUrl': imageUrl,
      'embedding': embedding != null
          ? jsonEncode(embedding)
          : null, // Lưu dưới dạng chuỗi JSON
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }

  factory KnowledgeModel.fromMap(Map<String, dynamic> map) {
    List<double>? embeddingList;
    if (map['embedding'] != null) {
      final embeddingStr = map['embedding'] as String;
      embeddingList = List<double>.from(
        jsonDecode(embeddingStr).map((e) => (e as num).toDouble()),
      );
    }
    return KnowledgeModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      keywords: List<String>.from(jsonDecode(map['keywords'])),
      rawData: jsonEncode(map),
      imageUrl: map['imageUrl'] ?? '',
      embedding: embeddingList,
    );
  }
}
