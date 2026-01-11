# Hướng dẫn Sử dụng Hệ thống Antigravity Tools

## 1. Giới thiệu

**Antigravity Tools** là một ứng dụng quản lý tài khoản và proxy AI toàn diện, hỗ trợ quản lý hàng loạt tài khoản Google (Gemini), chuyển đổi giao thức (OpenAI/Anthropic sang Gemini), và định tuyến model thông minh.

Ứng dụng giúp bạn tận dụng tối đa hạn mức miễn phí của Gemini, đồng thời cung cấp khả năng tương thích với các công cụ AI phổ biến như Claude Code, Cursor, Cherry Studio thông qua giao thức chuẩn.

---

## 2. Các Tính năng Chính

### 2.1. Quản lý Tài khoản (Accounts)
Tại tab **Quản lý tài khoản**, bạn có thể:
- **Thêm tài khoản**:
    - **OAuth (Khuyên dùng)**: Đăng nhập trực tiếp bằng Google, tự động lấy Refresh Token.
    - **Refresh Token**: Dán thủ công token (hỗ trợ dán hàng loạt).
    - **Nhập từ CSDL**: Quét và nhập từ cơ sở dữ liệu của các phiên bản cũ hoặc IDE plugin.
- **Theo dõi hạn mức**: Xem hạn mức RPM/RPD của từng model (Flash, Pro, Image).
- **Làm mới**: Cập nhật trạng thái hạn mức mới nhất.
- **Bật/Tắt Proxy**: Kiểm soát tài khoản nào tham gia vào nhóm xử lý yêu cầu API.

### 2.2. Dịch vụ API Proxy (Proxy API)
Đây là trái tim của hệ thống, biến ứng dụng thành một máy chủ AI cục bộ.
- **Cổng mặc định**: `8045` (có thể đổi trong Cài đặt).
- **Địa chỉ Base URL**:
    - OpenAI Format: `http://127.0.0.1:8045/v1`
    - Anthropic Format: `http://127.0.0.1:8045/v1` (tương thích endpoint `/v1/messages`)
- **Đa giao thức**: Bạn có thể dùng bất kỳ ứng dụng nào hỗ trợ OpenAI hoặc Claude để kết nối. Antigravity sẽ tự động chuyển đổi yêu cầu sang Gemini API.

#### Tính năng nâng cao của Proxy:
- **z.ai (GLM) Provider**: Cho phép định tuyến các yêu cầu Claude (ví dụ từ Claude Code) sang z.ai để sử dụng các model GLM-4, trong khi vẫn dùng tài khoản Google cho các model Gemini.
- **MCP Server**: Hỗ trợ giao thức Model Context Protocol, cho phép tích hợp công cụ Tìm kiếm Web, Đọc trang web, và Thị giác (Vision) vào các AI Agent.
- **Cho phép LAN**: Bật tính năng này để các thiết bị khác trong cùng mạng Wifi có thể kết nối đến proxy của bạn.

### 2.3. Định tuyến Model (Model Router)
Tại **Cài đặt -> Proxy -> z.ai**, bạn có thể cấu hình "Ánh xạ Model":
- Hệ thống cho phép bạn định nghĩa quy tắc: "Khi tôi gọi model `claude-3-5-sonnet`, hãy thực sự dùng model `gemini-2.0-flash-thinking` của Google".
- Điều này cực kỳ hữu ích để đánh lừa các ứng dụng yêu cầu model cụ thể (như Claude Code) nhưng bạn lại muốn chạy bằng model miễn phí khác.

### 2.4. Bảng theo dõi (Monitor)
Tab **Theo dõi API** hiển thị nhật ký thời gian thực của mọi yêu cầu đi qua proxy.
- Xem nội dung Prompt gửi đi và phản hồi nhận về.
- Thống kê Token tiêu thụ.
- Giúp debug lỗi khi tích hợp với ứng dụng khác.

---

## 3. Tích hợp với Công cụ bên thứ 3

### 3.1. Claude Code CLI
1. Mở Terminal.
2. Thiết lập biến môi trường để trỏ về Antigravity:
   ```powershell
   # Windows PowerShell
   $env:ANTHROPIC_BASE_URL="http://127.0.0.1:8045"
   $env:ANTHROPIC_API_KEY="sk-antigravity" # Key bất kỳ hoặc key z.ai nếu cấu hình
   claude
   ```
3. Bây giờ `claude` CLI sẽ chạy qua Antigravity.

### 3.2. Cursor / VS Code (Cline/Roo Code)
- Chọn Provider là **OpenAI Compatible**.
- Base URL: `http://127.0.0.1:8045/v1`
- API Key: `sk-antigravity`
- Model ID: `gemini-2.0-flash-thinking-exp` (hoặc model bạn muốn dùng).

### 3.3. Python (OpenAI SDK)
```python
from openai import OpenAI

client = OpenAI(
    base_url="http://127.0.0.1:8045/v1",
    api_key="sk-antigravity"
)

response = client.chat.completions.create(
    model="gemini-2.0-flash", 
    messages=[{"role": "user", "content": "Xin chào!"}]
)
print(response.choices[0].message.content)
```

---

## 4. Xử lý sự cố thường gặp (F.A.Q)

**Q: Tại sao tôi không chạy được lệnh `npm run tauri dev`?**
A: Hãy đảm bảo bạn đã cài đặt Rust và C++ Build Tools theo hướng dẫn trong `startup_guide.md`. Thử xóa thư mục `src-tauri/target` và chạy lại.

**Q: Làm sao để đổi ngôn ngữ sang Tiếng Việt?**
A: Tại màn hình chính, nhìn lên góc trên bên phải, nhấn nút tròn có chữ **EN/ZH** (hoặc biểu tượng ngôn ngữ) liên tục cho đến khi hiện chữ **VI** (hoặc giao diện chuyển sang Tiếng Việt).

**Q: Lỗi "403 Forbidden" ở tài khoản?**
A: Token của tài khoản đó có thể đã hết hạn hoặc Google đã chặn truy cập API. Hãy thử xóa tài khoản đó và thêm lại bằng OAuth.

**Q: Tôi có cần giữ ứng dụng mở không?**
A: Có. Dịch vụ Proxy chạy ngầm bên trong ứng dụng. Nếu bạn tắt ứng dụng, proxy `localhost:8045` sẽ ngắt kết nối. Bạn có thể thu nhỏ ứng dụng xuống khay hệ thống (System Tray).
