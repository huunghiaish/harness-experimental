<!-- Synced from ../proposal-sow.md @ 2026-05-17. Re-sync after default updates. -->

# Đề xuất & Phạm vi công việc — <tên dự án>

Ngày: YYYY-MM-DD · Hiệu lực: <NN> ngày · Phiên bản: v0.1

> Tài liệu một trang gửi khách hàng. Đọc kèm `docs/templates/client-intake-brief.md` (đánh giá nhanh trước khi báo giá) và `docs/templates/spec-intake.md` (intake kỹ thuật sau khi ký).

## 1. Khách hàng & Đơn vị thực hiện

| | |
| --- | --- |
| Khách hàng | <tên pháp lý + người liên hệ> |
| Đơn vị thực hiện | <tên đơn vị / solo dev + liên hệ> |
| Ngày hiệu lực | YYYY-MM-DD |
| Ngày dự kiến bắt đầu | YYYY-MM-DD |
| Ngày dự kiến bàn giao | YYYY-MM-DD |

## 2. Tóm tắt dự án

Một đoạn: chúng ta đang xây dựng cái gì, cho ai, và vì sao.

## 3. Mục tiêu & Tiêu chí thành công

- Mục tiêu kinh doanh 1.
- Mục tiêu kinh doanh 2.

Tiêu chí đo lường thành công (khách dùng để đánh giá "đã hoạt động đúng"):

- <chỉ số>

## 4. Phạm vi — Bao gồm

Liệt kê các tính năng và sản phẩm bàn giao nằm trong giá. Nhóm theo epic nếu nhiều hơn ~8 mục.

- <tính năng>
- <tính năng>

## 5. Phạm vi — KHÔNG bao gồm

Liệt kê rõ những gì không bao gồm để tránh tranh chấp về sau. Nếu khách yêu cầu một trong những mục này, đi theo quy trình Change Request (§ 9).

- <mục bị loại>
- <mục bị loại>

## 6. Sản phẩm bàn giao

| # | Sản phẩm | Hình thức | Khi nào |
| --- | --- | --- | --- |
| D1 | Quyền truy cập source code | Mời vào git repo | Kickoff |
| D2 | URL staging | Link hosted | Mốc M2 |
| D3 | Triển khai production | Link hosted | Mốc M4 |
| D4 | Tài liệu bàn giao | `docs/handover/*` | Mốc M5 |
| D5 | Thông tin tài khoản quản trị | Tham chiếu vault | Mốc M5 |

## 7. Mốc & Tiến độ

| M# | Tên | Đầu ra | Ngày dự kiến | Điều kiện thanh toán |
| --- | --- | --- | --- | --- |
| M0 | Kickoff | SOW ký + bắt đầu PRD-lite | <ngày> | Đặt cọc 30% |
| M1 | Khoá spec | PRD-lite + UX spec + Tech spec được duyệt | <ngày> | — |
| M2 | Build staging | Tính năng cốt lõi lên staging | <ngày> | Tiến độ 30% |
| M3 | UAT | Nghiệm thu UAT (`docs/stories/.../delivery-closure/`) | <ngày> | — |
| M4 | Production | Triển khai production + release note | <ngày> | Bàn giao 30% |
| M5 | Bàn giao | `docs/handover/*` hoàn tất | <ngày> | Bảo lưu 10% |

Tỉ lệ phần trăm điều chỉnh theo quy mô dự án. Khoản bảo lưu bảo vệ khách trong giai đoạn đầu chạy production và buộc đơn vị thực hiện đóng bàn giao đúng cách.

## 8. Điều khoản thanh toán

| Giai đoạn | Số tiền | Điều kiện |
| --- | --- | --- |
| Đặt cọc | NN% | Ký SOW |
| Tiến độ | NN% | Nghiệm thu M2 staging |
| Bàn giao | NN% | Triển khai production M4 |
| Bảo lưu | NN% | Hoàn tất bàn giao M5 |

- Loại tiền: <VND / USD>
- Chu kỳ xuất hóa đơn: <theo điều kiện / hàng tháng>
- Ân hạn quá hạn: <N> ngày. Sau ân hạn, công việc tạm dừng đến khi thanh toán.
- Hình thức thanh toán: <chuyển khoản / Stripe / etc.>

## 9. Chính sách Change Request (Yêu cầu phát sinh)

Mọi yêu cầu ngoài § 4 đi theo quy trình Change Request (`docs/templates/change-request-log.md`):

1. Đơn vị thực hiện phân loại yêu cầu (bug / change / new feature / UX / clarification).
2. Nếu trong scope ban đầu → xử lý không tính phí phát sinh.
3. Nếu ngoài scope → đơn vị thực hiện trả về ước lượng effort + giá trong <N> ngày làm việc.
4. Khách duyệt (hoặc dời sang SOW giai đoạn 2) trước khi bắt đầu công việc.
5. Không thay đổi bằng miệng — mọi CR đều phải ghi vào log.

## 10. Điều kiện nghiệm thu

Khách hàng nghiệm thu mỗi mốc khi:

- Các sản phẩm bàn giao tại § 6 cho mốc đó tồn tại và truy cập được.
- Các test case UAT của mốc đó pass (theo `docs/templates/delivery-closure-story/01-uat-plan.md`).
- Mọi bug đang mở được ghi log và gán mức độ. Severity 1 (chặn nghiệp vụ) phải sửa trước khi ký nghiệm thu; severity 2-3 có thể dời sang release sau.
- Ký nghiệm thu qua `docs/templates/delivery-closure-story/02-signoff.md`.

Khách có <N> ngày làm việc kể từ khi được thông báo bàn giao để rà soát và phản hồi (chấp nhận hoặc báo lỗi). Quá thời gian không phản hồi = mặc định chấp nhận.

## 11. Rủi ro & Giả định

| Loại | Mục | Biện pháp giảm thiểu |
| --- | --- | --- |
| Giả định | Khách cung cấp nội dung/copy trước M1 | Đơn vị thực hiện dùng placeholder; khách chấp nhận thấy placeholder trên staging |
| Giả định | Khách cấp quyền domain + DNS trước M3 | Đơn vị thực hiện chạy trên subdomain của vendor đến khi có quyền |
| Rủi ro | API bên thứ ba bị rate-limit hoặc down | Vendor cấu hình retry + fallback; SLA không bao phủ sự cố bên thứ ba |
| Rủi ro | Scope creep vượt 10% ước lượng | Mỗi CR được ước lượng lại; tổng CR > 10% kích hoạt cuộc thảo luận SOW giai đoạn 2 |

## 12. Trách nhiệm của khách hàng

- Cung cấp một người ra quyết định duy nhất (hoặc chuỗi escalation có tên).
- Cung cấp tài sản thương hiệu (logo, font, màu) trước M1 — xem `docs/playbooks/ui-design-system-contract.md` § Style Intake.
- Cung cấp nội dung/copy trước M1 (hoặc chấp nhận placeholder).
- Phản hồi câu hỏi của vendor trong <N> ngày làm việc. Câu trả lời chậm dời timeline 1:1.
- Cung cấp thông tin truy cập dịch vụ bên thứ ba (domain, email, payment, etc.) theo `docs/templates/project-closure-story/02-credentials-handover.md`.

## 13. Bảo hành & Hỗ trợ sau bàn giao

- Bảo hành bug: <N> ngày kể từ M4 deploy production. Bug tái hiện trên production trong scope ban đầu được sửa không tính phí.
- Ngoài phạm vi bảo hành: change request (§ 9), thêm tính năng, và bug do khách tự sửa code gây ra.
- Bảo trì dài hạn (tùy chọn): xem `docs/templates/maintenance-proposal.md`.

## 14. Sở hữu trí tuệ

- Sau khi thanh toán đủ: <vendor chuyển giao toàn bộ source code và tài sản / vendor giữ quyền với component tái sử dụng, khách nhận license vĩnh viễn>.
- Vendor có thể trưng bày dự án trong portfolio (ẩn danh hoặc có sự đồng ý của khách — chọn một).
- Thư viện bên thứ ba giữ nguyên license gốc.

## 15. Chấm dứt hợp đồng

Hai bên có thể chấm dứt với thông báo trước <N> ngày. Khi chấm dứt:

- Vendor bàn giao công việc đang dở dang ở trạng thái hiện tại.
- Khách thanh toán phần công việc đã hoàn thành tới ngày chấm dứt (chia tỉ lệ theo mốc).
- Chuyển giao IP áp dụng cho phần đã bàn giao.

## 16. Ký kết

| Bên | Tên | Chức danh | Chữ ký | Ngày |
| --- | --- | --- | --- | --- |
| Khách hàng | | | | |
| Đơn vị thực hiện | | | | |

---

**Tham chiếu**

- Tài liệu tiếp theo: `docs/templates/spec-intake.md` (sau khi ký SOW → chạy spec intake để dẫn xuất product docs).
- Tài liệu đóng dự án: `docs/templates/delivery-closure-story/` (UAT, signoff, client update — tại M3/M4).
- Tài liệu bàn giao: `docs/templates/project-closure-story/` (tại M5).
- Change requests: `docs/templates/change-request-log.md`.
- Bảo trì sau bàn giao: `docs/templates/maintenance-proposal.md`.
- Bản gốc tiếng Anh: `docs/templates/proposal-sow.md`.
