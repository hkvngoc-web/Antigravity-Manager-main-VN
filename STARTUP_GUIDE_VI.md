# Hướng dẫn Khởi động Dự án Antigravity Tools (Windows)

Dự án này là một ứng dụng Desktop được xây dựng trên framework **Tauri**. Để chạy được nó, bạn cần bộ công cụ của cả Web (Node.js) và System (Rust).

## 1. Yêu cầu Hệ thống

### **A. Microsoft C++ Build Tools (Bắt buộc)**
Rust và Tauri cần trình biên dịch C++ của Windows để hoạt động.
1. Tải về [Visual Studio Installer](https://visualstudio.microsoft.com/visual-cpp-build-tools/).
2. Khi cài đặt, hãy chọn gói: **"Desktop development with C++"**.
3. Đảm bảo các thành phần sau được chọn (thường là mặc định):
   - MSVC v143 - VS 2022 C++ x64/x86 build tools
   - Windows 11 SDK (hoặc Windows 10 SDK)

### **B. Cài đặt Rust**
1. Truy cập [rustup.rs](https://rustup.rs/) và tải về tệp `rustup-init.exe`.
2. Chạy tệp tin và nhấn **Enter** để chọn cài đặt mặc định (Option 1).
3. **Quan trọng:** Sau khi cài xong, bạn **PHẢI tắt toàn bộ cửa sổ PowerShell đang mở và mở lại** để hệ thống nhận diện lệnh `rustc` và `cargo`.

## 2. Các bước Khởi động Dự án

Sau khi đã cài đặt xong các yêu cầu trên:

1. **Cài đặt thư viện Frontend:**
   ```powershell
   npm install
   ```
   *(Nếu gặp lỗi script disabled, hãy dùng: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`)*

2. **Khởi chạy ứng dụng ở chế độ Phát triển (Dev Mode):**
   ```powershell
   npm run tauri dev
   ```

## 3. Giải thích về lỗi bạn vừa gặp
- **Lỗi `cargo metadata` / `program not found`:** Đây là do hệ thống tìm lệnh `cargo` (trình quản lý gói của Rust) nhưng không thấy. Tauri cần Rust để biên dịch phần lõi (backend) của ứng dụng.
- **Lỗi `rustc` not recognized:** Xác nhận rằng Rust chưa được cài đặt hoặc biến môi trường chưa được cập nhật (cần khởi động lại Terminal).

## 4. Lưu ý quan trọng
- Lần đầu tiên chạy `npm run tauri dev`, Rust sẽ phải tải về rất nhiều thư viện (crates) và biên dịch chúng. Quá trình này có thể mất từ **5 - 15 phút** tùy vào cấu hình máy và tốc độ mạng. Những lần sau sẽ rất nhanh (chỉ vài giây).
