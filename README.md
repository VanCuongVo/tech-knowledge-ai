# KnowFlow AI - Kho Dữ Liệu Công Nghệ & Chatbot Thông Minh

KnowFlow AI là một ứng dụng di động được xây dựng bằng **Flutter**, kết hợp giữa kho dữ liệu thông tin phần cứng công nghệ (CPU, GPU, SSD) và Chatbot AI thông minh được tích hợp **Gemini API**. Dự án tuân thủ chặt chẽ **Clean Architecture** và sử dụng các thư viện quản lý trạng thái hiện đại.

---

## 🚀 Các Tính Năng Chính

1. **Kho Dữ Liệu Công Nghệ**:
   - Hiển thị danh sách các linh kiện phần cứng phổ biến như GPU (RTX 4060, RTX 4070), CPU (Ryzen 5 7600, i5-13400F), SSD (Samsung 990 Pro).
   - Hiển thị thông tin chi tiết: tên, danh mục (GPU/CPU/SSD), mô tả hiệu năng và từ khóa liên quan.
   - Hỗ trợ lưu trữ offline bằng SQLite thông qua thư viện `sqflite` (tự động fallback sang Mock Data khi chạy trên nền tảng Web).

2. **Hỏi Đáp Cùng Chatbot (KnowFlow AI)**:
   - Trò chuyện trực tiếp với AI thông qua cửa sổ chat.
   - AI được tích hợp sẵn từ khóa và dữ liệu nền tảng từ kho kiến thức phần cứng để cung cấp câu trả lời chính xác, thông minh.
   - Sử dụng mô hình **Gemini 2.5 Flash** cho tốc độ phản hồi cực nhanh.

---

## 🛠️ Công Nghệ Sử Dụng

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [Riverpod](https://riverpod.dev/) (hỗ trợ phân tách UI và logic nghiệp vụ một cách rõ ràng)
- **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it) (đăng ký các Service, Repository, UseCase dưới dạng Singleton)
- **Local Database**: [SQFlite](https://pub.dev/packages/sqflite) (quản lý lưu trữ SQLite cục bộ trên thiết bị di động)
- **AI Integration**: [Google Generative AI SDK](https://pub.dev/packages/google_generative_ai)
- **Environment Config**: [Flutter Dotenv](https://pub.dev/packages/flutter_dotenv) (quản lý khóa API bảo mật qua tệp `.env`)

---

## 📁 Cấu Trúc Thư Mục (Clean Architecture)

Dự án được cấu trúc theo 3 lớp chính trong thư mục `lib/`:

```
lib/
├── core/                  # Các cấu hình chung, cơ sở dữ liệu và triển khai dịch vụ (Service)
│   ├── database/          # DatabaseHelper khởi tạo và seeding SQLite
│   ├── Iservices/         # Giao diện (interface) dịch vụ (Gemini, Search)
│   └── services/          # Triển khai thực tế các dịch vụ (GeminiServiceImpl, SearchServiceImpl)
├── data/                  # Lớp dữ liệu (Models, Datasources, Repositories Implementation)
│   ├── datasources/       # Lấy dữ liệu từ SQLite (Local) hoặc Remote
│   ├── models/            # Ánh xạ cấu trúc dữ liệu từ DB (KnowledgeModel)
│   └── repositories/      # Triển khai Repository từ Domain
├── domain/                # Lớp nghiệp vụ (Entities, Repositories Interface, UseCases)
│   ├── entities/          # Đối tượng lõi hiển thị trên UI (Knowledge, Message)
│   ├── repositories/      # Giao diện Repository định nghĩa các hành vi dữ liệu
│   └── usecases/          # Logic xử lý cụ thể (AskAIUseCase, GetAllKnowledgeUseCase)
├── injection/             # Quản lý Dependency Injection (dependency_injection.dart)
├── presentation/          # Giao diện người dùng (UI - Screens, Providers, Widgets)
│   ├── providers/         # Quản lý trạng thái bằng Riverpod (HomeState, ChatState)
│   ├── screens/           # Các màn hình chính (HomeScreen, ChatScreen)
│   └── widgets/           # Các thành phần giao diện nhỏ (ChatBubble, v.v.)
└── main.dart              # Điểm khởi chạy ứng dụng
```

---

## 💻 Hướng Dẫn Cài Đặt & Chạy Ứng Dụng

Để chạy ứng dụng trên máy cá nhân, vui lòng làm theo các bước sau:

### 1. Yêu Cầu Hệ Thống
- Đã cài đặt [Flutter SDK](https://docs.flutter.dev/get-started/install) (phiên bản khuyên dùng `>= 3.11.5`).
- Thiết bị giả lập (Emulator/Simulator) hoặc thiết bị thật đã bật chế độ nhà phát triển (Developer Mode).

### 2. Cấu Hình Biến Môi Trường (API Key)
Ứng dụng sử dụng Gemini API. Bạn cần thiết lập khóa API để Chatbot hoạt động:
- Tạo tệp tin `.env` ở thư mục gốc của dự án (nếu chưa có).
- Thêm khóa API của bạn vào tệp tin theo định dạng sau:
  ```env
  GEMINI_API_KEY=YOUR_GEMINI_API_KEY_HERE
  MODEL_NAME=gemini-2.5-flash
  ```

### 3. Cài Đặt Thư Viện
Mở Terminal tại thư mục gốc của dự án và chạy lệnh:
```bash
flutter pub get
```

### 4. Đăng Ký Tài Nguyên (Assets)
Để hiển thị đầy đủ hình ảnh phần cứng trên giao diện, thư mục ảnh đã được đăng ký trong `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/data/cpus.json
    - .env
    - assets/images/
```

### 5. Chạy Ứng Dụng
Sử dụng dòng lệnh sau để khởi chạy:
```bash
flutter run
```
*Hoặc bấm nút **F5** trên Visual Studio Code/Android Studio.*

---

## 📝 Lưu Ý Khắc Phục Lỗi
- **Không hiển thị ảnh**: Nếu ảnh sản phẩm hiển thị icon lỗi `image_not_supported`, hãy đảm bảo bạn đã chạy `flutter pub get` sau khi sửa `pubspec.yaml` và thực hiện **Hot Restart** ứng dụng.
- **Chatbot không phản hồi**: Kiểm tra lại xem khóa `GEMINI_API_KEY` trong file `.env` đã chính xác và còn hạn sử dụng hay chưa.
