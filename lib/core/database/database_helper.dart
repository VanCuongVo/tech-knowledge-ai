import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'knowflow.db');

    return await openDatabase(
      path,
      version: 5, // 1. Tăng version lên 5
      onCreate: _createDatabase,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS knowledge');
        await _createDatabase(db, newVersion);
      },
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE knowledge(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      category TEXT NOT NULL,
      description TEXT NOT NULL,
      keywords TEXT NOT NULL,
      imageUrl TEXT,
      embedding TEXT -- 2. Thêm cột lưu trữ Vector dạng chuỗi JSON
    )
  ''');

    await db.insert('knowledge', {
      'name': 'RTX 4060',
      'category': 'GPU',
      'description':
          'NVIDIA RTX 4060 với 8GB VRAM GDDR6, hỗ trợ DLSS 3 và Ray Tracing, phù hợp gaming 1080p.',
      'keywords': 'rtx,gpu,nvidia,4060,dlss,raytracing,gaming',
      'imageUrl': 'assets/images/rtx4060.jpg',
    });

    await db.insert('knowledge', {
      'name': 'RTX 4070',
      'category': 'GPU',
      'description':
          'NVIDIA RTX 4070 với 12GB VRAM, hiệu năng mạnh cho gaming 1440p và xử lý AI cơ bản.',
      'keywords': 'rtx,gpu,nvidia,4070,1440p,ai',
      'imageUrl': 'assets/images/rtx4070.jpg',
    });

    await db.insert('knowledge', {
      'name': 'Ryzen 5 7600',
      'category': 'CPU',
      'description':
          'AMD Ryzen 5 7600 gồm 6 nhân 12 luồng, socket AM5, phù hợp lập trình và gaming.',
      'keywords': 'amd,ryzen,cpu,7600,am5',
      'imageUrl': 'assets/images/ryzen7600.jpg',
    });

    await db.insert('knowledge', {
      'name': 'Intel Core i5-13400F',
      'category': 'CPU',
      'description':
          'Intel Core i5-13400F có 10 nhân 16 luồng, hiệu năng tốt cho học tập, lập trình và gaming.',
      'keywords': 'intel,cpu,i5,13400f',
      'imageUrl': 'assets/images/i513400f.jpg',
    });

    await db.insert('knowledge', {
      'name': 'Samsung 990 Pro',
      'category': 'SSD',
      'description':
          'SSD NVMe PCIe Gen4 tốc độ đọc lên đến 7450 MB/s, phù hợp cho gaming và workstation.',
      'keywords': 'ssd,samsung,990pro,nvme,pcie4',
      'imageUrl': 'assets/images/samsung990pro.jpg',
    });
  }
}
