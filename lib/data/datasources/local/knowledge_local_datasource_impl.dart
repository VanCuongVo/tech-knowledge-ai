import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:knowflow_ai/data/knowledge_model.dart';
import 'knowledge_local_datasource.dart';

class KnowledgeLocalDataSourceImpl implements KnowledgeLocalDataSource {
  @override
  Future<List<KnowledgeModel>> getAllKnowledge() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/cpus.json',
    ); //lấy cái chuỗi data json trong assert

    final List<dynamic> jsonData = jsonDecode(jsonString); // parse obj

    return jsonData
        .map((e) => KnowledgeModel.fromJson(e))
        .toList(); // chuyển sang json
  }
}
