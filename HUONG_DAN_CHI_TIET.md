# Hướng Dẫn Chi Tiết Xây Dựng Dự Án KnowFlow AI

Chào bạn, đây là tài liệu hướng dẫn từng bước để xây dựng dự án **KnowFlow AI** từ đầu. Dự án này là một ứng dụng Flutter kết hợp với AI (Gemini) và cơ sở dữ liệu cục bộ (SQLite) tuân theo mô hình **Clean Architecture**.

---

## 📌 Phần 1: Khởi Tạo Dự Án & Cấu Hình Ban Đầu

### 1.1 Khởi tạo dự án Flutter
Mở Terminal/Command Prompt và chạy lệnh sau để tạo một dự án Flutter mới:
```bash
flutter create knowflow_ai
cd knowflow_ai
```

### 1.2 Thêm các thư viện (Dependencies)
Mở file `pubspec.yaml` và thêm các package cần thiết vào phần `dependencies`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_generative_ai: ^0.4.7 # Tích hợp Gemini AI
  flutter_dotenv: ^6.0.1       # Đọc biến môi trường (.env)
  equatable: ^2.0.7            # So sánh các object (dùng trong State/Model)
  get_it: ^9.2.1               # Dependency Injection (Quản lý khởi tạo)
  flutter_riverpod: ^3.3.1     # Quản lý State Management
  sqflite: ^2.4.2              # Cơ sở dữ liệu SQLite
  path: ^1.9.1                 # Thao tác với đường dẫn file
```
Sau đó chạy lệnh:
```bash
flutter pub get
```

### 1.3 Cấu hình biến môi trường (.env)
Tạo một file tên `.env` ở thư mục gốc của dự án (cùng cấp với `pubspec.yaml`) và thêm API key của bạn:
```env
GEMINI_API_KEY=ĐIỀN_API_KEY_CỦA_BẠN_VÀO_ĐÂY
MODEL_NAME=gemini-2.5-flash
```
Đừng quên khai báo file `.env` vào `pubspec.yaml` trong phần `assets`:
```yaml
flutter:
  assets:
    - .env
    - assets/images/
    - assets/data/
    - assets/rag/
```

---

## 📌 Phần 2: Cấu Trúc Thư Mục (Clean Architecture)

Tạo các thư mục trong thư mục `lib/` theo cấu trúc sau để phân chia rõ ràng trách nhiệm của từng phần code:

```text
lib/
├── core/                  # Các cấu hình chung, DB, Services (Gemini, Search)
├── data/                  # Xử lý lấy dữ liệu (API, SQLite)
├── domain/                # Chứa logic nghiệp vụ (Entities, UseCases)
├── injection/             # Cấu hình Dependency Injection (GetIt)
├── presentation/          # UI (Giao diện) và State Management (Riverpod)
└── main.dart              # Entry point của ứng dụng
```

---

## 📌 Phần 3: Xây Dựng Từng Lớp (Layer)

### 3.1. Lớp Domain (Trung tâm của ứng dụng)
Đây là lớp không phụ thuộc vào bất kỳ thư viện nào bên ngoài (như Flutter, SQLite).
- **Entities (`lib/domain/entities/`)**: Tạo các class định nghĩa dữ liệu cốt lõi (ví dụ: `Knowledge`, `Message`).
- **Repositories (`lib/domain/repositories/`)**: Định nghĩa các Interface (Hợp đồng) cho việc lấy dữ liệu (Ví dụ: `abstract class KnowledgeRepository { Future<List<Knowledge>> getAll(); }`).
- **Use Cases (`lib/domain/usecases/`)**: Định nghĩa các hành động cụ thể của người dùng (Ví dụ: `AskAIUseCase`, `GetAllKnowledgeUseCase`).

### 3.2. Lớp Data (Xử lý dữ liệu thực tế)
- **Models (`lib/data/models/`)**: Kế thừa từ Entities ở lớp Domain, thêm các hàm `fromJson`, `toJson` để làm việc với API hoặc SQLite.
- **Data Sources (`lib/data/datasources/`)**: Nơi thực sự viết code truy vấn SQLite (bằng `sqflite`) hoặc gọi API.
- **Repositories Impl (`lib/data/repositories/`)**: Triển khai (implement) các Repository Interface đã định nghĩa ở lớp Domain. Lớp này sẽ gọi đến Data Sources để lấy dữ liệu.

### 3.3. Lớp Core (Dịch vụ & Cấu hình)
- **Database (`lib/core/database/`)**: Tạo class `DatabaseHelper` dùng Singleton để khởi tạo SQLite, định nghĩa các bảng và hàm seed dữ liệu mặc định.
- **Services (`lib/core/services/`)**:
  - `GeminiServiceImpl`: Sử dụng `google_generative_ai` để gọi API tới Gemini.
  - `SearchServiceImpl`: Xử lý logic RAG (Retrieval-Augmented Generation) - Cắt đoạn tài liệu (chunking), tạo Vector (Embedding) và tìm kiếm (Hybrid Search).

### 3.4. Cấu hình Dependency Injection (GetIt)
Tạo file `lib/injection/dependency_injection.dart`:
```dart
import 'package:get_it/get_it.dart';
// ... import các class

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // 1. Services & DB
  sl.registerLazySingleton(() => DatabaseHelper.instance);
  sl.registerLazySingleton<GeminiService>(() => GeminiServiceImpl());
  
  // 2. Data Sources
  sl.registerLazySingleton<KnowledgeLocalDataSource>(() => KnowledgeLocalDataSourceImpl(sl()));

  // 3. Repositories
  sl.registerLazySingleton<KnowledgeRepository>(() => KnowledgeRepositoryImpl(sl()));

  // 4. Use Cases
  sl.registerLazySingleton(() => AskAIUseCase(sl()));
}
```

### 3.5. Lớp Presentation (Giao diện)
- **Providers (`lib/presentation/providers/`)**: Dùng Riverpod để quản lý trạng thái.
  - Tạo `StateNotifier` cho danh sách phần cứng (`HomeState`).
  - Tạo `StateNotifier` cho lịch sử chat và xử lý tin nhắn (`ChatState`).
- **Screens (`lib/presentation/screens/`)**:
  - `HomeScreen`: Hiển thị danh sách các linh kiện phần cứng, lấy dữ liệu từ `HomeProvider`.
  - `ChatScreen`: Giao diện chat với Gemini, có ô nhập text và danh sách `ChatBubble`.

---

## 📌 Phần 4: Kết Nối Mọi Thứ Trong `main.dart`

Sửa file `lib/main.dart` để khởi tạo mọi thứ trước khi chạy ứng dụng:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'injection/dependency_injection.dart';
import 'presentation/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load biến môi trường
  await dotenv.load(fileName: ".env");
  
  // Khởi tạo Dependency Injection
  await setupDependencies();

  // Bọc app bằng ProviderScope của Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KnowFlow AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
```

---

## 📌 Phần 5: Chạy Ứng Dụng

Sau khi đã hoàn thành các bước trên, hãy mở Emulator hoặc kết nối điện thoại và chạy:
```bash
flutter run
```

🎉 **Chúc mừng!** Bạn đã hiểu được toàn bộ luồng đi của kiến trúc và cách xây dựng dự án KnowFlow AI. Nếu cần giải thích kỹ hơn về từng file mã nguồn cụ thể, hãy yêu cầu nhé!
