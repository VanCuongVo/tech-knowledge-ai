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
  });

  factory KnowledgeModel.fromJson(Map<String, dynamic> json) {
    return KnowledgeModel(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      description: json['description'],
      keywords: List<String>.from(json['keywords'] ?? []),
      rawData: jsonEncode(json),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'keywords': jsonEncode(keywords),
      'imageUrl': imageUrl,
    };
  }

  factory KnowledgeModel.fromMap(Map<String, dynamic> map) {
    return KnowledgeModel(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      keywords: List<String>.from(jsonDecode(map['keywords'])),
      rawData: jsonEncode(map),
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
