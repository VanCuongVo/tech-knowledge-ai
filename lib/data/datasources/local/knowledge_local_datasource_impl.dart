import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:knowflow_ai/data/knowledge_model.dart';
import 'knowledge_local_datasource.dart';

class KnowledgeLocalDataSourceImpl implements KnowledgeLocalDataSource {
  @override
  Future<List<KnowledgeModel>> getAllKnowledge() async {
    final jsonString = await rootBundle.loadString('assets/data/cpus.json');

    final List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData.map((e) => KnowledgeModel.fromJson(e)).toList();
  }
}
