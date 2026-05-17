<!-- Synced from ../change-request-log.md @ 2026-05-17. Re-sync after default updates. -->

# Sổ Yêu cầu phát sinh (Change Request Log) — <tên dự án>

> Một file cho mỗi dự án. Chỉ thêm, không xoá. Mọi yêu cầu thay đổi từ khách sau khi ký SOW đều phải vào sổ này — bao gồm yêu cầu qua điện thoại, email, "chỉnh nhẹ tí thôi". Không có thay đổi scope ngầm.
>
> Tương ứng với `docs/FEATURE_INTAKE.md` input type "Change request" cho lane nội bộ. File này là **bề mặt khách hàng thấy** cho SOW § 9 Chính sách Change Request.

## Cách dùng

1. Khách gửi yêu cầu qua bất kỳ kênh nào.
2. Vendor ghi log thành một row mới ngay lập tức (§ Bảng log). Trạng thái: `new`.
3. Vendor phân loại trong vòng <N> ngày làm việc (§ Phân loại).
4. Nếu trong scope ban đầu → sửa miễn phí; trạng thái chuyển sang `in-progress` rồi `done`.
5. Nếu ngoài scope → vendor gửi ước lượng effort + giá (§ Ước lượng); trạng thái chuyển sang `quoted`. Khách duyệt → `accepted` → `in-progress`. Từ chối hoặc dời → `deferred` hoặc `rejected`.
6. Phản hồi khách dùng template tin nhắn (§ Template phản hồi).

## Phân loại

| Loại | Ý nghĩa | Lộ trình mặc định |
| --- | --- | --- |
| `bug` | Hành vi sai so với spec / AC đã duyệt | Trong scope. Sửa trong bảo hành. |
| `change-request` | Thay đổi hành vi đã duyệt | Theo effort: nhỏ = vendor chịu, lớn = báo giá |
| `new-feature` | Hành vi mới không có trong SOW § 4 ban đầu | Ngoài scope. Báo giá riêng. |
| `ux-improvement` | Tinh chỉnh UX (copy, layout, polish flow) | Báo giá trừ khi rất nhỏ (< 30 phút) |
| `clarification` | Câu hỏi về hành vi đã có | Miễn phí. Trả lời + link đến spec. |

Khi không rõ, nghiêng về `change-request` hoặc `new-feature` để khách phản biện. Ghi nhiều an toàn hơn ghi ít.

## Severity (chỉ cho bug)

Dùng cùng thang với `docs/templates/maintenance-proposal.md` § 6.

| | |
| --- | --- |
| S1 | Production không dùng được, mất dữ liệu, payment hỏng |
| S2 | Tính năng cốt lõi hỏng, có workaround |
| S3 | Giao diện, nhỏ |

## Ước lượng effort (cho non-bug)

| Tag | Giờ | Công việc điển hình |
| --- | --- | --- |
| XS | < 1h | Đổi copy, đổi màu |
| S | 1-4h | Một trường, một quy tắc validation, UI nhỏ |
| M | 4-16h | Màn hình mới dùng component có sẵn |
| L | 16-40h | Flow mới có thay đổi backend |
| XL | > 40h | Kích hoạt cuộc thảo luận SOW giai đoạn 2, không phải CR |

## Bảng log

| CR ID | Ngày tiếp nhận | Nguồn | Mô tả (một dòng) | Phân loại | Severity | Trong scope? | Effort | Trạng thái | Vào release | Đã phản hồi |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CR-001 | YYYY-MM-DD | <email/call/chat> | <một dòng> | `change-request` | — | không | S | quoted | — | YYYY-MM-DD |
| CR-002 | YYYY-MM-DD | <nguồn> | <một dòng> | `bug` | S2 | có | — | done | v1.1 | YYYY-MM-DD |
| CR-003 | YYYY-MM-DD | <nguồn> | <một dòng> | `new-feature` | — | không | M | deferred | phase-2 | YYYY-MM-DD |

Giá trị trạng thái: `new` · `classified` · `quoted` · `accepted` · `in-progress` · `done` · `deferred` · `rejected`

## Chi tiết per-CR (khi effort L+ hoặc có tranh luận)

Cho bất kỳ CR ước lượng L+ hoặc CR mà khách không đồng ý với phân loại, mở rộng dưới đây. CR XS / S có thể ở dạng một row trong log.

### CR-NNN: <tiêu đề>

- **Tiếp nhận**: YYYY-MM-DD qua <nguồn>
- **Lời khách nguyên văn**: > "<paste nguyên văn của khách>"
- **Phân loại**: <loại> — <lý do một dòng>
- **Có trong SOW ban đầu**: có / không (trích § 4 dòng nào nếu "có")
- **Module / story bị ảnh hưởng**: `docs/stories/.../US-NNN-name.md`, `docs/product/...`
- **Ước lượng effort**: <tag> (<giờ> giờ)
- **Giá** (nếu ngoài scope): <số tiền>
- **Rủi ro nếu nhận**: <ảnh hưởng tới timeline / tính năng khác>
- **Đề xuất**: làm ngay / dời sang phase 2 / từ chối
- **Ngày quyết định**: YYYY-MM-DD
- **Người quyết định**: <tên khách>
- **Vào release**: <release tag>

## Template phản hồi

Dùng làm điểm xuất phát; điều chỉnh giọng theo quan hệ với khách.

### Phản hồi A — Bug trong scope (sẽ sửa miễn phí)

```text
Tiêu đề: Re: <lời khách> — xác nhận bug, đang sửa

Chào <khách>,

Em đã ghi log thành CR-NNN. Lỗi này sai so với spec đã duyệt, nên đây
là bug trong bảo hành. Mục tiêu sửa trong <release tag, ngày dự kiến>.

Em sẽ cập nhật trạng thái CR-NNN khi bản sửa lên staging.

— <vendor>
```

### Phản hồi B — Change request (ngoài scope, báo giá)

```text
Tiêu đề: Re: <lời khách> — change request CR-NNN

Chào <khách>,

Em rất vui được làm phần này. Yêu cầu ngoài scope ban đầu (SOW § 4),
em gửi ước lượng:

- Nội dung: <một dòng>
- Effort: <tag> (<giờ> giờ)
- Giá: <số tiền>
- Ngày bàn giao sớm nhất: <ngày> (lùi <deliverable khác> khoảng <ảnh hưởng>)

Anh/chị trả lời "duyệt" để em bắt đầu, hoặc cho em biết muốn dời sang
phase 2 (giá per-CR rẻ hơn khi gom batch).

— <vendor>
```

### Phản hồi C — Tính năng mới (đề xuất dời sang phase 2)

```text
Tiêu đề: Re: <lời khách> — đề xuất sang phase 2

Chào <khách>,

Đây là tính năng mới, không phải bug hay điều chỉnh nhỏ. Làm ngay sẽ
lùi M3 khoảng <ảnh hưởng>, mốc mà hai bên đã thống nhất bảo vệ.

Đề xuất: gom CR-NNN cho batch phase 2 (sau M5). Em sẽ giữ danh sách
và mình quyết định cùng nhau sau khi launch — lúc đó anh/chị cũng có
phản hồi của user để ưu tiên.

Nếu thực sự gấp (doanh thu trọng yếu, quy định), anh/chị phản hồi giúp
em sẽ ước lượng lại bao gồm cả ảnh hưởng timeline.

— <vendor>
```

### Phản hồi D — Làm rõ (miễn phí, trỏ về spec)

```text
Tiêu đề: Re: <lời khách> — làm rõ

Chào <khách>,

Câu trả lời nhanh: <một dòng>. Đây là hành vi đã được duyệt theo
<section SOW hoặc link story>.

Em đã ghi log thành CR-NNN với trạng thái `done — clarification`. Nếu
anh/chị muốn đổi hành vi này, báo em em sẽ phân loại lại.

— <vendor>
```

### Phản hồi E — Sự cố Severity 1

```text
Tiêu đề: KHẨN — <vấn đề> — CR-NNN

Chào <khách>,

Em đã nhận lúc <timestamp>. Em đang điều tra ngay.

Tác động hiện tại: <ảnh hưởng tới user, blast radius nếu biết>
Workaround tạm thời: <nếu có, nếu không "chưa có — đang điều tra">
Cập nhật tiếp theo: trong vòng <N> giờ

— <vendor>
```

## Quy tắc audit

- Chỉ thêm, không xoá. Nếu CR bị phân loại sai, thêm row mới tham chiếu row gốc.
- CR được **đóng** chỉ khi trạng thái là `done`, `deferred`, hoặc `rejected` VÀ đã gửi phản hồi (timestamp ở cột cuối).
- Mỗi release, điền cột "Vào release" cho mọi CR `done`.
- Khi đóng dự án (`docs/templates/project-closure-story/`), báo cáo các CR `deferred` đang mở làm candidate phase 2.

---

**Tham chiếu**

- Lane nội bộ: `docs/FEATURE_INTAKE.md` § Input Types — Change request.
- SOW § 9 Chính sách Change Request: `docs/templates/proposal-sow.md`.
- Maintenance SLA cho cửa sổ phản hồi: `docs/templates/maintenance-proposal.md` § 5.
- Bản gốc tiếng Anh: `docs/templates/change-request-log.md`.
