<!-- Synced from ../../delivery-closure-story/02-signoff.md @ 2026-05-17. Re-sync after default updates. -->

# Ký nghiệm thu — <story id>

## Người duyệt — Phía khách hàng

- Họ tên: <name>
- Chức danh: <role>
- Ngày: YYYY-MM-DD
- Hình thức ký: <duyệt qua email / chữ ký điện tử / phản hồi văn bản>

## Người duyệt — Phía thực hiện

- Họ tên: <name>
- Chức danh: <role>
- Ngày: YYYY-MM-DD

## Bao phủ REQ

| REQ ID | Mô tả một dòng | Bằng chứng |
| --- | --- | --- |
| US-NNN.REQ-001 | <mô tả một dòng> | `01-uat-plan.md#US-NNN.TC-001` |
| US-NNN.REQ-002 | <mô tả một dòng> | `01-uat-plan.md#US-NNN.TC-003` |

Mỗi REQ phải có ít nhất một link bằng chứng. Thiếu bằng chứng chặn việc ký nghiệm thu.

## Loại trừ

REQ tokens KHÔNG nằm trong đợt ký nghiệm thu này (e.g. dời sang release sau). Mỗi loại trừ trích decision đã dời.

| REQ loại trừ | Lý do | Dời tới | Link decision |
| --- | --- | --- | --- |
| US-NNN.REQ-005 | Ngoài scope release này | <release tag> | `docs/decisions/NNNN-*.md` |

## Điều kiện

Bất kỳ nghiệm thu có điều kiện ("ký với điều kiện sửa X trước ngày Y"). Bỏ trống nếu không có điều kiện.

| Điều kiện | Người chịu trách nhiệm | Hạn | Link theo dõi |
| --- | --- | --- | --- |
