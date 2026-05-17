<!-- Synced from ../status-flow.md @ 2026-05-17. Re-sync after default updates. -->

# Sơ đồ trạng thái — <tên entity>

Trạng thái: nháp | khách đã review | đã duyệt · Cập nhật cuối: YYYY-MM-DD

> Đóng băng cuối stage 6 (Visual & Behavioral Modeling) theo `docs/playbooks/solo-dev-client-delivery.md`. Một file cho mỗi entity có trạng thái (order, application, ticket, subscription, etc.). Sống tại `docs/visuals/diagrams/status-flow-<entity>.md` trong repo dự án.
>
> Ghi lại máy trạng thái hợp lệ trước khi code. Bắt được lỗi "user kẹt ở trạng thái X vì không có transition ra" trước khi ship.

## Entity

| | |
| --- | --- |
| Tên entity | <e.g. order, application, ticket> |
| Tài nguyên sở hữu | <e.g. bảng orders> |
| Trường trạng thái | <e.g. cột `status`> |
| Trạng thái ban đầu | <e.g. `pending`> |

## Các trạng thái

Mọi trạng thái entity có thể giữ. Trạng thái không có transition đến = không thể đạt (xoá). Trạng thái không có transition đi = trạng thái cuối (đánh dấu).

| Trạng thái | Mô tả | Trạng thái cuối? |
| --- | --- | --- |
| pending | Chờ hành động đầu tiên | không |
| in-review | Đang được staff xem | không |
| approved | Đã duyệt, chờ giao | không |
| fulfilled | Đã giao | có |
| cancelled | Đã huỷ bởi khách hoặc staff | có |
| rejected | Bị từ chối khi review | có |

## Sơ đồ trạng thái (Mermaid)

```mermaid
stateDiagram-v2
    [*] --> pending
    pending --> in-review: customer submits
    pending --> cancelled: customer cancels
    in-review --> approved: staff approves
    in-review --> rejected: staff rejects
    approved --> fulfilled: ops ships
    approved --> cancelled: customer cancels (refund)
    fulfilled --> [*]
    cancelled --> [*]
    rejected --> [*]
```

Render qua `docs/playbooks/headless-browser-blank-screenshot.md` hoặc bất kỳ Mermaid viewer nào. Cập nhật sơ đồ KHI bảng transition phía dưới thay đổi — sơ đồ và bảng là hai view của cùng sự thật.

## Bảng transition

Nguồn chính. Mỗi transition hợp lệ là một hàng.

| Từ | Tới | Trigger | Vai trò được phép | Điều kiện tiên quyết | Tác động phụ | Token |
| --- | --- | --- | --- | --- | --- | --- |
| pending | in-review | submit | customer | đầy đủ trường bắt buộc | thông báo staff qua email | `US-NNN.REQ-001` |
| pending | cancelled | cancel | customer | — | không thông báo | `US-NNN.REQ-002` |
| in-review | approved | approve | staff | ghi chú review đã điền | thông báo khách; charge payment hold | `US-NNN.REQ-003` |
| in-review | rejected | reject | staff | lý do từ chối đã điền | thông báo khách; release payment hold | `US-NNN.REQ-004` |
| approved | fulfilled | ship | staff | xác nhận đã giao | thông báo khách kèm tracking | `US-NNN.REQ-005` |
| approved | cancelled | cancel | customer, staff | trong vòng 24h sau approve | hoàn tiền đầy đủ | `US-NNN.REQ-006` |

Mọi hàng transition trích ít nhất một `US-NNN.REQ-MMM`. Hàng không có token là lỗ hổng spec — thêm REQ vào story hoặc xoá hàng.

## Transition bị cấm

Cặp trạng thái có vẻ transitionable nhưng KHÔNG được phép. Ghi rõ để tránh bug âm thầm.

| Từ | Tới | Vì sao bị chặn |
| --- | --- | --- |
| fulfilled | * | Fulfilled là trạng thái cuối; trả hàng đi qua entity mới (return-order). |
| cancelled | pending | Không cho kích hoạt lại; khách tạo entity mới. |
| rejected | in-review | Không cho re-review; khách tạo application mới. |

## Cross-check Vai trò × Hành động

Đối chiếu với `docs/templates/role-permission-matrix.md` để đảm bảo mọi cột trigger ở trên có cell quyền tương ứng. Trigger gọi được bởi `staff` cần cell tài nguyên × hành động của staff khác `N`.

- [ ] Mọi "Vai trò được phép" khớp với grid RPM.
- [ ] Mọi "Tác động phụ" sửa entity khác (e.g. payment hold) cũng được phản ánh trong grid quyền của entity đó.

## Yêu cầu audit log

| Transition | Có audit? | Lưu giữ |
| --- | --- | --- |
| Bất kỳ transition vào trạng thái cuối | có | 7 năm |
| approved → cancelled (kèm hoàn tiền) | có | 7 năm |
| pending → cancelled | tuỳ chọn | 1 năm |

## Edge case & SLA

| Trường hợp | Hành vi | Ràng buộc thời gian |
| --- | --- | --- |
| Kẹt ở `in-review` > 7 ngày | Tự động thông báo staff manager | 7 ngày |
| Kẹt ở `approved` > 3 ngày | Tự động huỷ và hoàn tiền | 3 ngày |
| Payment fail giữa in-review → approved | Rollback về in-review; flag để thử lại | ngay lập tức |

## Kiểm tra bao phủ

Trước khi đóng băng:

- [ ] Mọi trạng thái có trong bảng § Các trạng thái.
- [ ] Mọi trạng thái trong sơ đồ xuất hiện ít nhất một lần ở § Bảng transition (Từ HOẶC Tới).
- [ ] Mọi trạng thái cuối đánh dấu `có` ở § Các trạng thái.
- [ ] Mọi transition trích `US-NNN.REQ-MMM`.
- [ ] Mọi vai trò được phép khớp với `docs/templates/role-permission-matrix.md`.
- [ ] Transition bị cấm đã liệt kê.
- [ ] SLA edge-case đã định nghĩa cho trạng thái không-cuối.

## Lịch sử thay đổi

| Ngày | Thay đổi | Lý do | CR ID |
| --- | --- | --- | --- |
| YYYY-MM-DD | Thêm `approved → cancelled` (trong vòng 24h) | Chính sách kinh doanh của khách | CR-NNN |

## Ký nghiệm thu

| Mốc | Ngày | Người duyệt |
| --- | --- | --- |
| Đóng băng stage 6 | YYYY-MM-DD | <vendor lead> |
| Xác nhận UAT | YYYY-MM-DD | <tên ký signoff phía khách> |

---

**Tham chiếu**

- Playbook visual & behavioral modeling: `docs/playbooks/visual-and-behavioral-modeling.md`.
- Ma trận Vai trò - Quyền hạn (cross-check): `docs/templates/role-permission-matrix.md`.
- Story tokens: `docs/HARNESS.md` § Traceability Tokens.
- UAT cross-check: `docs/templates/delivery-closure-story/01-uat-plan.md`.
- Bản gốc tiếng Anh: `docs/templates/status-flow.md`.
