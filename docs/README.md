# J-Connect Documentation & Wireframes (GitHub Pages)

Thư mục này chứa toàn bộ các tài liệu đặc tả, sơ đồ tương tác luồng xử lý và Wireframe của module **M06 - CSKH & Support** được tối ưu hóa để chia sẻ trực tuyến qua **GitHub Pages**.

## 🌐 Đường dẫn truy cập

Trang được publish qua repo **public** [`trion-org/wf-jconnect`](https://github.com/trion-org/wf-jconnect):
```
https://trion-org.github.io/wf-jconnect/
```
Từ repo J_Connect, chạy `make pages` để đồng bộ `docs/` sang repo đó; GitHub Action ở repo đích tự deploy.

## 📁 Danh mục các trang

- `index.html`: Cổng điều hướng tổng hợp (Portal) theo phong cách hiện đại (hỗ trợ Dark/Light mode, tìm kiếm nhanh và gắn thẻ danh mục phỏng theo `flashtrend-bot`).
- `116-2-trung-tam-chia-lead.html`: Wireframe phân bổ lead tự động, rule xoay vòng Round-robin & trực ca.
- `116-3-lead-cua-toi-khung-chat.html`: Wireframe màn hình tác nghiệp telesale, nhận thông báo & chat.
- `116-5-ca-lam-viec-trang-thai.html`: Wireframe lịch trực ca, chấm công & trạng thái online nhận lead.
- `116-so-do-luong-lead-theo-tag.html`: Sơ đồ trực quan (Mermaid Interactive) 4 bước phân bổ theo tag.
- `116-6-quan-ly-tag-spec.html`: Tài liệu Spec chi tiết về danh mục và logic gán tag tự động.
- `116-6-quan-ly-tag-wireframe.html`: Wireframe giao diện cấu hình nhóm tag & phân quyền.
- `116-1-dong-bo-pancake.html`: Wireframe đồng bộ 2 chiều dữ liệu với Pancake POS.
- `116-so-sanh-webhook.html`: Phân tích đối soát giải pháp chia việc lead từ webhook.

## 🧭 Thư mục `flow/` — trang flow tương tác (Archify)

- `flow/116-2-trung-tam-chia-lead.html`, `flow/116-3-lead-cua-toi-khung-chat.html`, `flow/116-5-ca-lam-viec-trang-thai.html`: trang mô tả flow, dựng bằng [Archify](https://github.com/tt-a1i/archify).
- **Không sửa tay** file trong `flow/`. Nguồn nằm ở `tools/docs/<tên>.archify.md`; sửa nguồn rồi build lại:

```bash
tools/docs/build.sh                               # build mọi trang
tools/docs/build.sh 116-2-trung-tam-chia-lead     # build một trang
```

Lần đầu script tự clone Archify vào `~/.cache/archify` (cần `git`, `node` >= 18). Thêm trang mới: tạo `tools/docs/<tên>.archify.md`, build, rồi thêm thẻ vào `index.html`.
