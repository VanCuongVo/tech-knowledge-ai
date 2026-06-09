# KnowFlow AI - Kho Dữ Liệu Công Nghệ & Chatbot Thông Minh

[📄 Tài liệu dự án (Google Docs)](https://docs.google.com/document/d/16eTuFFsr_5_JLdgHL0RR1tn3RWt_xhp-rs9ngpG81iU/edit?usp=sharing)

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

## 🧠 Kiến Trúc AI & Kỹ Thuật Điều Khiển (RAG System)

Dự án áp dụng kỹ thuật **Retrieval-Augmented Generation (RAG)** kết hợp với các phương pháp tối ưu hóa Prompt và Search để điều khiển AI một cách chính xác, tránh hiện tượng "ảo giác" (Hallucination) và ép AI chỉ trả lời dựa trên dữ liệu nội bộ. Dưới đây là chi tiết các bước và kỹ thuật đã triển khai:

### 1. Chuẩn Bị & Băm Nhỏ Dữ Liệu (Text Chunking)
- **Nguồn dữ liệu:** Các file tài liệu (`.txt`, `.md`) được lưu trữ trong thư mục `assets/rag/`.
- **Kỹ thuật Chunking:** Đọc nội dung file và băm nhỏ thành các đoạn văn bản (chunk) có giới hạn độ dài (ví dụ: 400 ký tự). Kỹ thuật phân đoạn có **chồng lấn (overlap khoảng 80 ký tự)** được sử dụng để không làm mất đi ngữ nghĩa ở phần chuyển tiếp giữa các đoạn.

### 2. Sinh Vector Ngữ Nghĩa (Word Embedding)
- Mỗi đoạn văn bản sau khi được băm nhỏ sẽ được gửi đến mô hình `embedding-001` của Gemini.
- Mô hình này chuyển đổi văn bản thành một **Vector đa chiều (Embedding Vector)** đại diện cho ý nghĩa của câu.
- Các Vector này cùng với nội dung văn bản gốc được lưu trữ vào Local Database (SQLite).

### 3. Tìm Kiếm Kết Hợp (Hybrid Search & RRF)
Khi người dùng đặt câu hỏi, hệ thống sử dụng kỹ thuật **Hybrid Search** để truy xuất tài liệu liên quan nhất:
- **Lexical Search (Tìm kiếm từ khóa):** Loại bỏ các từ vô nghĩa (stop words) và đếm tần suất xuất hiện của từ khóa trong các đoạn văn bản.
- **Semantic Search (Tìm kiếm ngữ nghĩa):** Sinh Vector cho câu hỏi người dùng và tính toán độ tương đồng (**Cosine Similarity**) với Vector của các đoạn tài liệu trong Database.
- **Reciprocal Rank Fusion (RRF):** Kết hợp và đánh trọng số thứ hạng của cả hai phương pháp Lexical và Semantic Search để lấy ra 3 đoạn tài liệu có độ chính xác cao nhất. Kỹ thuật này giúp xử lý tốt ngay cả khi người dùng nhập sai chính tả hoặc dùng từ đồng nghĩa.

### 4. Tiêm Ngữ Cảnh & Prompt Engineering
- 3 đoạn tài liệu tốt nhất sẽ được gộp lại thành một khối ngữ cảnh (Context).
- **Kỹ thuật Grounding (Neo dữ liệu):** Sử dụng `System Prompt` được thiết kế nghiêm ngặt nhằm kiểm soát mô hình `gemini-2.5-flash`:
  - **CHỈ** được phép trả lời dựa trên ngữ cảnh được cung cấp.
  - **KHÔNG** sử dụng kiến thức bên ngoài để tự bịa ra câu trả lời.
  - Từ chối trả lời nếu câu hỏi nằm ngoài ngữ cảnh (ví dụ: *"Tôi chỉ có thể trả lời các câu hỏi liên quan đến dữ liệu công nghệ..."*).
- Câu hỏi người dùng và khối ngữ cảnh được kết hợp tiêm vào Prompt cuối cùng gửi cho AI.

### 5. Cơ Chế Chống Lỗi (Retry & Fallback)
- **Exponential Backoff:** Trong quá trình gọi API, nếu gặp lỗi vượt quá giới hạn request (Rate limit / Quota), hệ thống tự động chờ một khoảng thời gian tăng dần (2s, 4s, 6s...) và thử gọi lại (Retry).
- **Fallback an toàn:** Nếu API sinh Vector cho câu hỏi gặp sự cố (mất mạng, lỗi server), hệ thống tự động chuyển sang chỉ dùng Lexical Search 100% để đảm bảo ứng dụng không bị crash và người dùng vẫn có cơ hội nhận được câu trả lời.

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
