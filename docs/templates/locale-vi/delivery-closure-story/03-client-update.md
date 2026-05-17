<!-- Synced from ../../delivery-closure-story/03-client-update.md @ 2026-05-17. Re-sync after default updates. -->

# Thông báo khách — <story id>

> **Không thông tin nhạy cảm, không PII.** Không paste credentials, access token, định danh cá nhân, hoặc bất kỳ thứ gì không nên xuất hiện trong log lưu trữ của kênh liên lạc.

## Kênh

<kênh thông báo — ví dụ: tool chat, email, ticketing inbox, hoặc bất kỳ kênh phân phối nào tổ chức đang dùng. Chọn một kênh cho mỗi thông báo; không cross-post>

## Người nhận

<danh sách phân phối, tên kênh, hoặc người nhận cụ thể>

## Tiêu đề

<tiêu đề một dòng — bao gồm story id, e.g. "US-NNN release sẵn sàng UAT">

## Nội dung

<tóm tắt hai-đến-năm câu về cái gì đã ship, kiểm tra gì trong release, và yêu cầu hành động tiếp theo nếu có>

Ví dụ các yêu cầu hành động:

- "Anh/chị vui lòng xác nhận nghiệm thu UAT trước <ngày> theo `01-uat-plan.md`."
- "Không cần hành động — release notes đính kèm. Tham chiếu: `US-NNN.REQ-001`."
- "Phát hiện bug ở <khu vực>; lên kế hoạch rollback vào <ngày>; sẽ cập nhật tiếp."

## Tham chiếu REQ (tuỳ chọn)

Nếu thông báo nêu rõ hành vi đã bàn giao, trích REQ token để khách có thể grep ngược lại story:

- `US-NNN.REQ-001` — <mô tả một dòng cái đã ship>.

## Đã gửi

- Ngày: YYYY-MM-DD
- Giờ: HH:MM (timezone)
- Người gửi: <tên hoặc nguồn automation>
- Link log kênh (nếu có): <permalink tới tin nhắn>
