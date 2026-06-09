import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Debug Asset Manifest Keys', () async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);
      print('--- TAT CA ASSETS TRONG APP ---');
      for (final key in manifestMap.keys) {
        print(key);
      }
      print('-------------------------------');
      
      final filePaths = manifestMap.keys
          .where((String key) => key.startsWith('assets/rag/'))
          .toList();
      print('--- FILE PATHS TRONG assets/rag/ ---');
      print(filePaths);
      print('------------------------------------');
    } catch (e) {
      print('Lỗi đọc AssetManifest: $e');
    }
  });
}
