<!-- Synced from ../../project-closure-story/01-handover-docs.md @ 2026-05-17. Re-sync after default updates. -->

# Chỉ mục tài liệu bàn giao — <tên dự án>

## Đọc theo thứ tự này

1. `README.md` — tổng quan dự án, lệnh chạy, quick start.
2. `docs/HARNESS.md` (nếu dùng harness) — mô hình vận hành.
3. `docs/product/*` — hợp đồng sản phẩm hiện hành.
4. `docs/decisions/*` — vì sao các lựa chọn quan trọng được đưa ra.
5. `docs/stories/epics/*` — story packet đang mở + gần đây.
6. `docs/TEST_MATRIX.md` — trạng thái bằng chứng (hành vi nào đã có proof, hành vi nào chưa).

## Các Decision còn hiệu lực

| Decision | Vì sao còn quan trọng hôm nay |
| --- | --- |
| `docs/decisions/NNNN-stack-selection.md` | Khoá stack runtime; muốn đổi cần decision thay thế. |
| `docs/decisions/NNNN-data-model.md` | <một dòng hệ quả người nhận bàn giao cần biết> |

Trích mỗi decision còn ràng buộc công việc hiện tại. Bỏ qua các decision đã bị thay thế.

## Story đang mở tại thời điểm bàn giao

| Story | Trạng thái | Token đang chạy | Chủ mới |
| --- | --- | --- | --- |
| `docs/stories/epics/EXX-name/US-NNN-slug.md` | in progress / blocked / awaiting review | `US-NNN.REQ-001`, `US-NNN.SC-003` | <tên> |

Chặn signoff với bất kỳ token đang chạy chưa được gán chủ.

## Bề mặt bảo trì

- Phụ thuộc lần cập nhật cuối: YYYY-MM-DD. Lần rà soát tiếp theo: YYYY-MM-DD.
- Nợ kỹ thuật đã ghi nhận: liệt kê link tới backlog row.
- Playbook định kỳ dự án này tham khảo:
  `docs/playbooks/<name>.md` × N lần dùng.

## Tích hợp bên ngoài

| Tích hợp | Mục đích | Tham chiếu credential | Liên hệ |
| --- | --- | --- | --- |
| <provider> | <làm gì cho app> | `02-credentials-handover.md#<row>` | <account manager của vendor> |

GIÁ TRỊ credential nằm ở secret store, không ở đây — row này chỉ trỏ tới row tham chiếu trong `02-credentials-handover.md`.
