<!-- Synced from ../client-intake-brief.md @ 2026-05-17. Re-sync after default updates. -->

# Đánh giá khách hàng (Client Intake Brief) — <khách / tên dự án nháp>

Ngày: YYYY-MM-DD · Trạng thái: review | accepted | declined | parked

> Bước đầu sau cuộc trao đổi ban đầu với khách tiềm năng. Đầu ra là một trang nội bộ của vendor để quyết định: có tiến tới discovery + báo giá, hay từ chối?
>
> Có TRƯỚC `docs/templates/spec-intake.md` (là spec intake kỹ thuật SAU khi ký). Có TRƯỚC `docs/templates/proposal-sow.md` (cần độ rõ scope mà brief này khai thác).

## 1. Khách hàng

| | |
| --- | --- |
| Tên | <người + công ty> |
| Nguồn | <giới thiệu / inbound / cold> |
| Có người ra quyết định? | có / không — tên |
| Có quan hệ với vendor trước đó? | không có / dự án cũ: <ref> |

## 2. Nhu cầu khách đặt ra (một đoạn)

Khách đã nói muốn gì, theo lời của khách (paraphrase nếu trộn VN/EN, giữ nguyên ý).

## 3. Vấn đề kinh doanh đằng sau nhu cầu

Vấn đề thật sự khách đang cố giải quyết là gì? Nếu khách chỉ nói "giải pháp", hỏi trong discovery.

## 4. Người dùng mục tiêu

| Vai trò | Số lượng ước lượng | Tác vụ chính |
| --- | --- | --- |
| <vai trò> | <NN> | <tác vụ> |

## 5. Tính năng khách yêu cầu (nguyên gốc)

Danh sách bullet, đúng như khách diễn đạt. Chưa cần tinh chỉnh — đó là việc của discovery.

- <tính năng>
- <tính năng>

## 6. Loại dự án

Đánh dấu một. Quyết định độ sâu template và chọn lane.

- [ ] Landing page / website marketing
- [ ] Web app (mục đích đơn)
- [ ] SaaS MVP (multi-tenant)
- [ ] Internal tool / admin panel
- [ ] Tool tự động hoá / workflow
- [ ] AI app (UX dựa LLM)
- [ ] E-commerce
- [ ] Dashboard / analytics
- [ ] Mobile app
- [ ] Khác: ____

## 7. Độ phức tạp ước lượng

Đánh dấu một. Quyết định lane (theo `docs/FEATURE_INTAKE.md`).

- [ ] Thấp — một vai trò người dùng, không thanh toán, không tích hợp bên thứ ba ngoài auth + email
- [ ] Trung bình — đa vai trò, thanh toán đơn giản HOẶC 1-2 tích hợp, admin cơ bản
- [ ] Cao — multi-tenant HOẶC đa vai trò với phân quyền HOẶC checkout e-commerce HOẶC 3+ tích hợp HOẶC dữ liệu nhạy cảm (PII, tài chính, y tế)
- [ ] Rất cao — ngành chịu quản lý, real-time / streaming, mobile + web parity, > 10 tích hợp

## 8. Tiến độ

| Mục | Giá trị |
| --- | --- |
| Deadline khách đặt | YYYY-MM-DD |
| Lý do của deadline | <sự kiện / funding / mùa / tuỳ ý> |
| Vendor đánh giá khả thi | thực tế / sát / không khả thi |

## 9. Ngân sách

| Mục | Giá trị |
| --- | --- |
| Khoảng ngân sách khách nói | <khoảng số, loại tiền> |
| Vendor đánh giá so với scope | phù hợp / thiếu / dư |
| Hình thức thanh toán đã xác nhận | có / không |

Nếu "không nói ngân sách" hoặc "tuỳ báo giá rồi tính", flag trong § 12 — đi tiếp mà không có khoảng thường lãng phí thời gian cả hai bên.

## 10. Cờ đỏ

Đánh dấu mọi mục đúng. 2+ thường là từ chối hoặc đàm phán lại nặng.

- [ ] Không có người ra quyết định trong cuộc trao đổi
- [ ] Muốn giá cố định cho scope mơ hồ
- [ ] So sánh với sản phẩm competitor lớn hơn nhiều như "chắc dễ copy"
- [ ] Đã có nhiều vendor trước đó được nhắc đến ("anh trước nghỉ rồi")
- [ ] Ngân sách < 30% của khoảng vendor bình thường cho loại dự án này
- [ ] Deadline bất khả thi bất kể ngân sách
- [ ] Yêu cầu bỏ qua hợp đồng / "cứ tin em đi"
- [ ] Muốn sở hữu component tái sử dụng của vendor
- [ ] Không diễn đạt được vấn đề kinh doanh, chỉ giải pháp
- [ ] Khăng khăng dùng stack mà vendor không bảo trì được

## 11. Cờ xanh

- [ ] Có chỉ số kinh doanh rõ ràng
- [ ] Sẵn sàng đánh đổi scope để vừa ngân sách/timeline
- [ ] Có tài sản sẵn (thương hiệu, nội dung, dữ liệu mẫu)
- [ ] Dự án trước với vendor đã ổn
- [ ] Sẵn sàng ký SOW và đặt cọc trước khi build
- [ ] Chỉ định một người ra quyết định

## 12. Câu hỏi mở cho Discovery

Câu hỏi vendor cần trả lời TRƯỚC khi tạo `docs/templates/proposal-sow.md`. Nhóm theo chủ đề để cuộc discovery nhanh hơn (dùng `docs/playbooks/discovery-interview-playbook.md` để chọn dạng).

- Mục tiêu kinh doanh: <câu hỏi>
- User & vai trò: <câu hỏi>
- Dữ liệu: <câu hỏi>
- Quy trình nghiệp vụ: <câu hỏi>
- Admin / phân quyền: <câu hỏi>
- Thanh toán / billing: <câu hỏi>
- Nội dung / media: <câu hỏi>
- Tích hợp bên thứ ba: <câu hỏi>
- Deadline / ngân sách: <câu hỏi>
- Tiêu chí thành công: <câu hỏi>

## 13. Đánh giá rủi ro ban đầu

| Rủi ro | Khả năng | Ảnh hưởng | Biện pháp giảm thiểu nếu nhận |
| --- | --- | --- | --- |
| Scope creep | <thấp/TB/cao> | <thấp/TB/cao> | SOW § 9 mạnh + CR log |
| Trễ thanh toán | | | Thanh toán theo mốc trong SOW § 8 |
| Trễ nội dung | | | Trách nhiệm khách trong SOW § 12 |
| Rủi ro kỹ thuật (tích hợp lạ) | | | Spike trong discovery trước SOW |

## 14. Đề xuất

Đánh dấu một.

- [ ] **Tiến tới discovery** — lên lịch cuộc discovery dùng `docs/playbooks/discovery-interview-playbook.md`. Sau đó tạo `docs/templates/proposal-sow.md`.
- [ ] **Tiến tới có điều kiện** — phải giải quyết <các mục> trước discovery (e.g. khoảng ngân sách, người ra quyết định có mặt).
- [ ] **Tạm gác** — thú vị nhưng thời điểm chưa đúng (dung lượng, fit). Đặt ngày follow-up: YYYY-MM-DD.
- [ ] **Từ chối** — không qua được kiểm tra cờ đỏ/ngân sách/khả thi. Gửi từ chối lịch sự.

Lý do đề xuất (một đoạn):

<text>

## 15. Phản hồi từ chối / tạm gác (nếu áp dụng)

```text
Tiêu đề: <dự án> — cảm ơn cuộc trao đổi

Chào <khách>,

Cảm ơn anh/chị đã chia sẻ chi tiết. Sau khi cân nhắc, em <chưa phù hợp /
chưa thể nhận trong quý này> vì <một lý do cụ thể — dung lượng / lệch
scope / lệch domain>.

<Nếu tạm gác: em rất sẵn lòng quay lại sau <ngày>. Em sẽ liên hệ lại lúc
đó.>
<Nếu từ chối: vài lựa chọn có thể phù hợp hơn: <giới thiệu hoặc công cụ
self-serve>.>

Chúc dự án thành công.

— <vendor>
```

---

**Tham chiếu**

- Discovery interview: `docs/playbooks/discovery-interview-playbook.md` (5 personas × 3 modes).
- Sau discovery: `docs/templates/proposal-sow.md`.
- Sau khi ký SOW: `docs/templates/spec-intake.md` → dẫn xuất `docs/product/*`.
- Bản gốc tiếng Anh: `docs/templates/client-intake-brief.md`.
