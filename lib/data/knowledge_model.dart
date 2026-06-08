import 'dart:convert';
import '../../domain/entities/knowledge.dart';

class KnowledgeModel extends Knowledge {
  const KnowledgeModel({
    required super.id,
    required super.category,
    required super.name,
    required super.description,
    required super.keywords,
    required super.rawData,
  });

  factory KnowledgeModel.fromJson(Map<String, dynamic> json) {
    return KnowledgeModel(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      description: json['description'],
      keywords: List<String>.from(json['keywords'] ?? []),
      rawData: jsonEncode(json),
    );
  }
}
