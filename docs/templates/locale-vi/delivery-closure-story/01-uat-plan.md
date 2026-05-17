<!-- Synced from ../../delivery-closure-story/01-uat-plan.md @ 2026-05-17. Re-sync after default updates. -->

# Kế hoạch UAT — <story id>

## Phạm vi

REQ tokens được kiểm thử: `US-NNN.REQ-001`, `US-NNN.REQ-002`, ...
SC tokens được kiểm thử: `US-NNN.SC-001`, `US-NNN.SC-002`, ...

REQ tokens KHÔNG kiểm thử lần này: liệt kê kèm lý do
(e.g. "dời sang release N+1, xem `02-signoff.md` § Loại trừ").

## Hành trình kiểm thử

Mô tả từng bước hành trình người dùng qua bề mặt đang được nghiệm thu. Đánh số để các test case có thể trích số bước.

1. Actor đăng nhập với vai trò <role>.
2. Actor điều hướng đến <screen>.
3. Actor thực hiện <action>.
4. Actor xác minh <expected result>.
5. ...

## Test cases

| TC ID | Loại | Bước | Kết quả mong đợi | Kết quả |
| --- | --- | --- | --- | --- |
| US-NNN.TC-001 | Happy path | 1-5 | <expected> | pass |
| US-NNN.TC-002 | Edge — input rỗng (covers `US-NNN.SC-001`) | 1-3 | từ chối với 400 | pass |
| US-NNN.TC-003 | Edge — actor không có quyền (covers `US-NNN.SC-003`) | 1-2 | từ chối với 403 | fail |

Mỗi test case trích SC token ở cột Loại khi áp dụng. Mọi fail phải có link tới mục tiếp theo trong `overview.md` § Mục cần theo dõi.

## Giới hạn số lượng

Khuyến nghị ≤ 40 test case cho mỗi đợt UAT. Nếu cần nhiều hơn, tách thành nhiều đợt UAT (e.g. một đợt cho mỗi epic phase) thay vì để bảng phình to.

## Môi trường

| Mục | Giá trị |
| --- | --- |
| Build / commit | <git sha hoặc release tag> |
| Môi trường | staging / pre-prod / prod-like |
| Nguồn dữ liệu test | <fixture set, dump prod ẩn danh, seed mới, etc.> |
| Người quan sát | <tên hoặc vai trò chứng kiến đợt UAT> |
