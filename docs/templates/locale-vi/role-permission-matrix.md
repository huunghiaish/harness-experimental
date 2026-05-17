<!-- Synced from ../role-permission-matrix.md @ 2026-05-17. Re-sync after default updates. -->

# Ma trận Vai trò - Quyền hạn — <tên dự án>

Trạng thái: nháp | khách đã review | đã duyệt · Cập nhật cuối: YYYY-MM-DD

> Đóng băng cuối stage 6 (Visual & Behavioral Modeling) theo `docs/playbooks/solo-dev-client-delivery.md`. Sống tại `docs/visuals/diagrams/role-permission-matrix.md` trong repo dự án. Kiểm tra lại khi UAT.
>
> Ghi rõ AI ĐƯỢC LÀM GÌ trước khi code. Bắt lỗi phân quyền rẻ hơn 10 lần khi tìm ở ma trận so với tìm trong audit log production.

## Vai trò

| Vai trò | Phạm vi một dòng | Ghi chú |
| --- | --- | --- |
| guest | Khách không đăng nhập | Chỉ bề mặt public. |
| customer | End-user đã đăng nhập | Sở hữu data của mình. |
| staff | User vận hành | Đọc data của mọi người; ghi trong phạm vi đơn vị mình. |
| admin | Quản trị tenant | Quản lý staff và config trong một tenant. |
| superadmin | Vận hành cross-tenant | Vendor / chủ platform. |

Điều chỉnh theo dự án. Map mọi chức danh project-specific (Product Owner, Manager, Thu ngân, etc.) vào một trong các hàng trên, HOẶC thêm hàng mới nếu thật sự khác biệt. Vai trò không có grid quyền riêng = không phải vai trò — gộp lại.

## Tài nguyên

Liệt kê mọi entity / surface có ngữ nghĩa phân quyền. Một hàng cho mỗi tài nguyên.

| Tài nguyên | Mô tả một dòng |
| --- | --- |
| account | Bản ghi user của chính actor |
| product | Sản phẩm trong catalog |
| order | Đơn hàng của customer |
| ... | ... |

## Bảng quyền

Giá trị: `Y` = đầy đủ · `O` = chỉ của-mình · `N` = không · `C` = có điều kiện (trích bên dưới).
Action: C = Create, R = Read, U = Update, D = Delete. Thêm action tuỳ chỉnh thành cột mới (e.g. `Refund`, `Approve`).

| Tài nguyên | Vai trò | C | R | U | D | Tuỳ chỉnh: <action> | Trích dẫn |
| --- | --- | --- | --- | --- | --- | --- | --- |
| account | guest | N | N | N | N | — | — |
| account | customer | N | O | O | O | — | `US-NNN.REQ-001` |
| account | staff | N | Y | C¹ | N | — | `US-NNN.REQ-002` |
| account | admin | Y | Y | Y | C² | — | `US-NNN.REQ-003` |
| product | guest | N | Y | N | N | — | `US-NNN.REQ-004` |
| product | customer | N | Y | N | N | — | `US-NNN.REQ-004` |
| product | staff | Y | Y | Y | C³ | — | `US-NNN.REQ-005` |
| order | customer | Y | O | C⁴ | N | — | `US-NNN.REQ-006` |
| order | staff | N | Y | Y | N | `Refund: Y` | `US-NNN.REQ-007` |

## Điều kiện

Mỗi `C` trong bảng trích về một điều kiện đánh số.

1. Staff chỉ được update account khi có ticket hỗ trợ đang mở liên kết staff với account đó.
2. Admin chỉ được xoá account sau ân hạn 30 ngày và chỉ khi account không còn đơn hàng đang mở.
3. Staff chỉ được xoá product nếu không có order tham chiếu; nếu có thì soft-delete (set `archived=true`).
4. Customer chỉ được sửa order khi trạng thái còn `pending`. Sau đó chuyển qua flow change-request.

## Yêu cầu xác thực

| Bề mặt | Cần đăng nhập | Cần re-auth |
| --- | --- | --- |
| Xem catalog | không | — |
| Thêm giỏ hàng | không | — |
| Thanh toán | có | re-auth nếu order > <ngưỡng> |
| Admin dashboard | có | re-auth mọi session |
| Xoá tài khoản | có | re-auth + 2FA |

## Yêu cầu audit log

Mọi mutation đánh dấu bên dưới sinh entry audit log. Hành vi đọc thường không audit trừ khi đánh dấu.

| Tài nguyên × Action | Có audit? | Lưu giữ |
| --- | --- | --- |
| account × U / D | có | 7 năm |
| order × C / U / refund | có | 7 năm |
| product × C / U / D | có | 1 năm |

## Bao phủ token

Mọi hàng ở § Bảng quyền có ít nhất một giá trị khác `N` đều trích `US-NNN.REQ-MMM`. Hàng không trích = lỗ hổng — thêm REQ vào story hoặc giảm cell xuống `N`.

Kiểm tra bao phủ (chạy trước khi đóng băng):

- [ ] Mọi vai trò xuất hiện trong bảng (không thiếu vai trò).
- [ ] Mọi tài nguyên xuất hiện trong bảng (không thiếu tài nguyên).
- [ ] Mọi `C` có entry điều kiện đánh số.
- [ ] Mọi cell khác `N` trích `US-NNN.REQ-MMM`.
- [ ] § Yêu cầu xác thực bao phủ mọi bề mặt cần authenticate.
- [ ] § Yêu cầu audit log liệt kê mọi mutation cần lưu giữ.

## Lịch sử thay đổi

Chỉ thêm. Theo dõi mọi chỉnh sửa bảng sau lần khách review đầu tiên.

| Ngày | Thay đổi | Lý do | CR ID |
| --- | --- | --- | --- |
| YYYY-MM-DD | Thêm action tuỳ chỉnh `Refund` cho staff × order | Khách làm rõ trong UAT | CR-NNN |

## Ký nghiệm thu

Đóng băng tại:

- Hết stage 6 (trước story slicing) — đóng băng ban đầu, vendor tự xác nhận.
- UAT — khách xác nhận ma trận quyền khớp với hành vi thực tế.

| Mốc | Ngày | Người duyệt |
| --- | --- | --- |
| Đóng băng stage 6 | YYYY-MM-DD | <vendor lead> |
| Xác nhận UAT | YYYY-MM-DD | <tên ký signoff phía khách> |

---

**Tham chiếu**

- Playbook visual & behavioral modeling: `docs/playbooks/visual-and-behavioral-modeling.md`.
- Story tokens: `docs/HARNESS.md` § Traceability Tokens.
- UAT cross-check: `docs/templates/delivery-closure-story/01-uat-plan.md`.
- Bản gốc tiếng Anh: `docs/templates/role-permission-matrix.md`.
