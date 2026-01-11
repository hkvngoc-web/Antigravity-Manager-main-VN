# HỒ SƠ TỔNG HỢP DỰ ÁN ANTIGRAVITY TOOLS (TỪ A-Z)

**Phiên bản hiện tại**: v3.3.20  
**Ngày cập nhật**: 11/01/2026

---

## 1. GIỚI THIỆU CHUNG (OVERVIEW)

**Antigravity Tools** (hay Antigravity Manager) là một ứng dụng quản lý tài khoản và trung chuyển AI mạnh mẽ chạy trên Desktop. Nó đóng vai trò như một "trạm trung chuyển" (relay station) cục bộ, giúp người dùng:
1.  Quản lý hàng trăm tài khoản Google để tận dụng hạn mức miễn phí của Gemini API.
2.  Tự động luân chuyển (rotate) tài khoản khi gặp giới hạn tốc độ (Rate Limit).
3.  Cung cấp API Proxy cục bộ tương thích hoàn toàn với giao thức **OpenAI** và **Anthropic** (Claude).
4.  Định tuyến thông minh (Model Router): Chuyển hướng các yêu cầu từ Claude Code/Cursor sang Gemini hoặc z.ai (GLM) để tối ưu chi phí.

---

## 2. KIẾN TRÚC KỸ THUẬT (ARCHITECTURE)

Dự án được xây dựng theo mô hình **Tauri v2** hiện đại, kết hợp sức mạnh của Rust và tính linh hoạt của Web Frontend.

### 2.1. Cấu trúc Tổng quan
-   **Frontend (UI)**: React 19, Vite 7, TypeScript, TailwindCSS, DaisyUI.
-   **Backend (Core)**: Rust (Tauri v2), Tokio (Async Runtime), Axum (Web Server cho Proxy), Rusqlite (Database).
-   **Giao tiếp**: Tauri IPC (Inter-Process Communication) kết nối UI và Core.

### 2.2. Phân tích Chi tiết Backend (`src-tauri`)
Backend đảm nhiệm các tác vụ nặng và yêu cầu quyền hệ thống:
-   **Modules**:
    -   `proxy`: Chứa logic máy chủ HTTP (Axum) lắng nghe ở cổng 8045. Xử lý xác thực (Bearer Token), chuẩn hóa request/response giữa các định dạng (OpenAI <-> Gemini).
    -   `modules::tray`: Quản lý khay hệ thống (System Tray), cho phép ứng dụng chạy ngầm.
    -   `modules::database`: Quản lý SQLite để lưu trữ tài khoản, phiên làm việc.
    -   `commands`: Các hàm Rust được gọi từ Frontend (JS) như `add_account`, `start_proxy_service`.
-   **Cơ chế lưu trữ**: Sử dụng SQLite và tệp JSON cấu hình (`config.json`) trong thư mục dữ liệu người dùng (`AppData`).

### 2.3. Phân tích Chi tiết Frontend (`src`)
Giao diện người dùng nhẹ và nhanh:
-   **State Management**: Sử dụng `Zustand` (`useConfigStore`, `useAccountStore`).
-   **Internationalization (i18n)**: Hỗ trợ đa ngôn ngữ (EN, ZH, VI) thông qua `i18next`.
-   **Routing**: `React Router` điều hướng giữa các trang Dashboard, Accounts, Proxy, Settings.

---

## 3. CÀI ĐẶT & KHỞI ĐỘNG (SETUP)

### 3.1. Yêu cầu Môi trường
-   **Hệ điều hành**: Windows 10/11, macOS, Linux.
-   **Node.js**: Phiên bản 18 trở lên (Khuyên dùng Node 20 LTS).
-   **Rust**: Toolchain ổn định mới nhất (2021 edition).
-   **C++ Build Tools**: Bắt buộc trên Windows (qua Visual Studio Installer).

### 3.2. Quy trình Cài đặt (Windows)
1.  Cài đặt Rust: Tải `rustup-init.exe` từ rustup.rs.
2.  Cài đặt Build Tools: Chọn "Desktop development with C++" trong VS Installer.
3.  Cài đặt Dependencies Frontend: `npm install`.
4.  Chạy ứng dụng (Dev Mode): `npm run tauri dev`.

*(Chi tiết xem tệp `STARTUP_GUIDE_VI.md`)*

---

## 4. TÍNH NĂNG CHI TIẾT & CẤU HÌNH (FEATURES)

### 4.1. Quản lý Tài khoản (Account Management)
-   **Cơ chế hoạt động**: Sử dụng `refresh_token` để lấy `access_token` ngắn hạn từ Google.
-   **Nhập liệu**:
    -   Dán trực tiếp Token.
    -   OAuth 2.0: Mở trình duyệt để người dùng đăng nhập, callback về ứng dụng để lấy token an toàn.
    -   Import từ DB cũ: Quét thư mục cấu hình của các phiên bản Antigravity cũ.
-   **Quota Check**: Tự động kiểm tra RPM (Requests Per Minute) và RPD (Requests Per Day) của từng model.

### 4.2. Dịch vụ Proxy (Local API Gateway)
-   **Endpoint**: `http://127.0.0.1:8045`
-   **Routes**:
    -   `/v1/chat/completions`: Tương thích OpenAI.
    -   `/v1/messages`: Tương thích Anthropic.
    -   `/v1/models`: Danh sách model khả dụng.
-   **Tính năng LAN**: Bind vào `0.0.0.0` để chia sẻ proxy cho điện thoại/laptop khác trong mạng.

### 4.3. Model Router (Định tuyến thông minh)
Đây là tính năng "sát thủ" của Antigravity:
-   **Model Mapping**: Cho phép ánh xạ tên model ảo sang model thật.
    -   *Ví dụ*: Client gọi `claude-3-5-sonnet` -> Proxy chặn lại -> Chuyển thành `gemini-2.0-flash-thinking` -> Gửi lên Google -> Nhận phản hồi -> Giả mạo format Claude -> Trả về Client.
-   **z.ai Integration**: Tích hợp nhà cung cấp GLM (Zhipu AI) làm backup hoặc thay thế cho các tác vụ Claude native.
-   **Tiết kiệm chi phí**: Dùng Gemini Flash (miễn phí) để chạy các tác vụ nền của Claude Code (vốn tốn phí).

### 4.4. Giám sát (Monitor)
-   Ghi lại toàn bộ Request/Response Body.
-   Đếm Token (Input/Output).
-   Đo thời gian phản hồi (Latency).
-   Lọc theo trạng thái (200 OK, 4xx, 5xx).

---

## 5. HƯỚNG DẪN SỬ DỤNG NHANH (QUICK USAGE)

### 5.1. Tích hợp với Claude Code
```powershell
$env:ANTHROPIC_BASE_URL="http://127.0.0.1:8045"
$env:ANTHROPIC_API_KEY="sk-antigravity"
claude
```

### 5.2. Tích hợp với Cursor / VS Code
-   Mở Settings của Cline/Roo Code/Cursor.
-   Chọn API Provider: **OpenAI Compatible**.
-   Base URL: `http://127.0.0.1:8045/v1`.
-   API Key: `sk-antigravity`.
-   Model: `gemini-2.0-flash`.

---

## 6. XỬ LÝ SỰ CỐ (TROUBLESHOOTING)

| Vấn đề | Nguyên nhân | Cách khắc phục |
| :--- | :--- | :--- |
| **Lỗi `program not found` khi chạy npm** | Chưa cài Rust hoặc chưa thêm vào PATH | Cài Rust, khởi động lại máy/terminal. |
| **Lỗi 403 Forbidden** | Tài khoản Google bị khóa API | Xóa tài khoản lỗi, thêm tài khoản mới. |
| **Proxy không hoạt động** | Port 8045 bị chiếm dụng | Đổi cổng trong Cài đặt -> Proxy. |
| **Không tìm thấy tiếng Việt** | Chưa chuyển ngôn ngữ | Nhấn nút ngôn ngữ trên Navbar (EN->ZH->VI). |

---

## 7. MÃ NGUỒN & ĐÓNG GÓP (DEVELOPMENT)

Để thêm một ngôn ngữ mới hoặc sửa đổi tính năng:
1.  **Frontend**: Sửa trong `src/components` và `src/locales`.
2.  **Backend**: Sửa trong `src-tauri/src`.
3.  **Build**: Chạy `npm run tauri build` để đóng gói ra file `.exe` hoặc `.msi`.

---

*Tài liệu được tổng hợp bởi Trợ lý AI Antigravity dựa trên phân tích toàn diện mã nguồn dự án.*
