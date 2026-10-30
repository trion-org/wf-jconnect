# JCN-116.2 — Trung tâm chia lead: lead đi qua những bước nào? {#tong-quan}

Khi khách nhắn Fanpage, J-Connect **xác định bộ phận theo tag**, rồi **chọn nhân viên Sẵn sàng có chỉ số tải thấp nhất** trong bộ phận đó. Nhân viên phải trả lời trong **5 phút**, nếu không lead tự nhả và được chia lại tối đa 1 lần. Lead chưa có người nhận nằm ở Hàng chờ, và Trưởng nhóm xử lý mọi việc chia tay trên **Màn 20 — Trung tâm chia lead**.[](source:spec)

- Từ 29/10, nhân viên không tự nhận lead: bỏ nút Tôi nhận, ở chế độ Tự động hệ thống chia mọi lead mới cho đều.[](source:spec)
- Ở chế độ Thủ công, lead mới vào Hàng chờ, chưa chạy SLA, và chỉ Trưởng nhóm chia.[](source:spec)
- Tag chủ cho biết bộ phận nào chịu trách nhiệm; mọi lần đổi tag đều có mã TRxx, tác nhân và lý do (Phần C).[](source:spec)
- [Update 30/10] Màn 20 gom Màn 10 (Dashboard) và Màn 1 (Chia việc lead) vào một màn cho Trưởng nhóm và Quản trị.[](source:spec)

@answer scope="JCN-116.2 bản gộp 30/10/2026 · trạng thái Đề xuất, chưa tạo Jira · các tham số là mặc định hoặc giá trị tạm, chờ team duyệt"
@meta locale=vi
@source spec title="JCN-116.2 — Trung tâm chia lead (bản 30/10/2026)"

## JCN-116.2 nằm ở đâu trong luồng JCN-116? {#vi-tri}

JCN-116.2 là bước giữa: nhận khách đã đồng bộ từ JCN-116.1, giao cho nhân viên, rồi đẩy sang "Lead của tôi" ở JCN-116.3.[](source:spec)

| Ticket | Hướng | Nội dung trao đổi |
| --- | --- | --- |
| JCN-116.1 | Đến từ | Khách mới, khách nhắn lại (đồng bộ Pancake tạo hoặc khớp khách) |
| JCN-116.5 | Đến từ | Ai đang đi làm: ca làm việc và trạng thái online |
| JCN-116.3 | Đến từ và đi tới | Đến: Tôi nhả, đổi tag cần chia lại. Đi: thông báo N1, Lead của tôi, mở hội thoại |
| JCN-116.6 | Dùng chung | Catalog tag, quy tắc chuyển tag |

Mọi sự kiện chia, nhả, đổi tag và chốt đơn ghi vào `assignment_log`. Lịch sử (Màn 12), Dashboard và KPI đều đọc từ đây.

@callout level=note title="Trạng thái tài liệu"
Spec đang ở trạng thái Đề xuất. Công thức và hệ số chia là đề xuất BA, chờ team duyệt (#7). Nhiều ngưỡng còn "chờ Nguyệt", ghi là giá trị tạm ở các bảng dưới.

## Khách nhắn tin thì lead về bộ phận nào? {#dieu-huong}

Hệ thống xét bảng Rule C5 từ trên xuống, dòng đầu tiên khớp thì dừng. Rule C5 thay Rule A1 khi hai bảng khác nhau.[](source:spec)

@workflow id=routing-flow title="Điều hướng khi khách nhắn tin (Rule C5)"
| r-in | Khách nhắn tin | external |
| r-bl | Blacklist? | security |
| r-skip | Bỏ qua, ghi log | external |
| r-hs | Đã có hồ sơ? | backend |
| r-ma | Mã giới thiệu hợp lệ? | backend |
| r-sale | NV Sale (TR1) | frontend |
| r-ups | NV Upsale (TR2) | frontend |
| r-np | Người phụ trách đi làm? | backend |
| r-giu | Giữ người phụ trách | frontend |
| r-tag | Chia theo tag chủ | database |
| r-in > r-bl | |
| r-bl > r-skip | Có |
| r-bl > r-hs | Không |
| r-hs > r-ma | Chưa |
| r-hs > r-np | Có |
| r-ma > r-sale | Không |
| r-ma > r-ups | Có | emphasis |
| r-np > r-giu | Có | emphasis |
| r-np > r-tag | Không |

@steps id=routing-steps
| rs-bl | Blacklist? | Khách bị blacklist thì không chia, chỉ ghi log (C5-1, theo JCN-110 Rule 5). | routing-flow | r-bl |
| rs-ma | Mã giới thiệu hợp lệ? | Khách chưa có hồ sơ. Mã sai, hết hạn hoặc là mã của chính khách thì coi như không có mã: vào Sale và Sale thấy cảnh báo (EC1). | routing-flow | r-ma |
| rs-sale | NV Sale (TR1) | Hệ thống gắn tag `Sale` (`NEW_LEAD`), `customer_stage` = LEAD, rồi chia tự động cho Sale. | routing-flow | r-sale |
| rs-ups | NV Upsale (TR2) | Hệ thống gắn `CSKH › Upsale` (`REFERRAL_CODE`), ghi người giới thiệu, chia cho NV Upsale, không qua Sale. | routing-flow | r-ups |
| rs-np | Người phụ trách đi làm? | Người phụ trách đang 🟢, 🟡 Tạm nghỉ hoặc 🟠 Vắng ngắn thì giữ nguyên (C5-4); không trả lời kịp thì tự nhả theo SLA. | routing-flow | r-np |
| rs-tag | Chia theo tag chủ | Người phụ trách ⚪ Ngoài ca, 🔴 Nghỉ phép, nghỉ việc hoặc bị khóa thì chia cho NV cùng bộ phận đang 🟢 (C5-5), theo bảng dưới. | routing-flow | r-tag |

| Dòng C5 | Tình huống | Người nhận |
| --- | --- | --- |
| C5-5 | Có người phụ trách nhưng ⚪ Ngoài ca, 🔴 Nghỉ phép, nghỉ việc hoặc khóa | NV cùng bộ phận (cùng tag) đang 🟢 |
| C5-6 | Tag chủ CSKH, `entry_reason` là `REFERRAL_*`, chưa có đơn giao thành công | NV Upsale |
| C5-7 | Tag chủ CSKH, `customer_stage` = KHACH_DANG_DUNG, chưa có việc mở | Hàng chờ chung CSKH, chia cho NV CSKH rảnh; NV đó phân loại rồi gắn tiểu loại Support, Kỹ thuật, Thu cước hoặc Upsale (phương án B của #71) |
| C5-8 | Tag chủ WFCĐ | NV hỗ trợ WFCĐ |
| C5-9 | `customer_stage` = LEAD_DONG | Đóng chưa quá 30 ngày (đề xuất #72): mở lại lead cũ, về NV cũ nếu đang 🟢. Quá 30 ngày: chu kỳ lead mới (TR1) |
| C5-10 | Khách có nhiều việc mở | Người phụ trách việc ưu tiên cao nhất: `Support kỹ thuật > Thu cước > Support > Upsale > WFCĐ > Sale` (đã chốt #1) |
| C5-11 | Bộ phận nhận không có ai đi làm | Hàng chờ bộ phận đó + N4 cho Trưởng nhóm |

Rule A2 thêm hai điều kiện ở đầu vào: chỉ chia lead từ page **Webhook, Đang hoạt động** (lead page Polling chỉ lưu, nhãn "Chỉ lưu — không SLA"); mỗi hội thoại chỉ có **một lead mở**, tin đến sau đi theo lead đó.[](source:spec)

## Trong bộ phận, hệ thống chọn ai và SLA chạy thế nào? {#chon-nguoi}

Bộ chia chạy tuần tự, mỗi lần một lead. Sau mỗi lần giao, tải của người nhận được tính lại ngay.[](source:spec)

@workflow id=dispatch-flow title="Chọn người, SLA 5 phút và tự nhả (Rule A2–A4, A6)"
| d-dept | Đã biết bộ phận | external |
| d-co | Có ứng viên? | backend |
| d-q | Hàng chờ + N4 | database |
| d-tinh | Tính chỉ số tải | backend |
| d-giao | Giao lead + N1 | frontend |
| d-tl | Trả lời trong 5 phút? | backend |
| d-ok | Đã tiếp nhận | frontend |
| d-nha | Tự nhả | backend |
| d-lan | Đã tự chia lại 1 lần? | backend |
| d-lai | Chia lại ngay | backend |
| d-tn | Trưởng nhóm chia | frontend |
| d-dept > d-co | |
| d-co > d-q | Không |
| d-co > d-tinh | Có |
| d-tinh > d-giao | thấp nhất | emphasis |
| d-giao > d-tl | |
| d-tl > d-ok | Có | emphasis |
| d-tl > d-nha | Không |
| d-nha > d-lan | |
| d-lan > d-lai | Chưa |
| d-lan > d-tn | Rồi |

@steps id=dispatch-steps
| ds-co | Có ứng viên? | Ứng viên phải đủ cả 7 điều kiện ở bảng dưới. | dispatch-flow | d-co |
| ds-q | Hàng chờ + N4 | Không có ứng viên thì lead chờ ở Hàng chờ, đồng hồ SLA chưa chạy, Trưởng nhóm nhận N4. Hệ thống tự chia ngay khi có người Sẵn sàng. | dispatch-flow | d-q |
| ds-tinh | Tính chỉ số tải | Chọn NV có chỉ số tải sau khi nhận thấp nhất; hòa nhau thì chọn người nhận lead gần nhất cách đây lâu nhất. Ghi log giải thích (ứng viên, chỉ số tải, người được chọn). | dispatch-flow | d-tinh |
| ds-giao | Giao lead + N1 | Ghi `assigned_at`, bật SLA, gửi N1 cho người nhận. Còn 1 phút thì nhắc "sắp quá giờ" (N2). | dispatch-flow | d-giao |
| ds-tl | Trả lời trong 5 phút? | Trả lời là người phụ trách gửi ít nhất 1 tin qua khung chat; tin tự động không tính. Đồng hồ dừng khi Pancake sự cố hoặc page không ở chế độ Webhook. | dispatch-flow | d-tl |
| ds-nha | Tự nhả | Lead về Hàng chờ với nhãn New — quá giờ, NV cũ mất quyền nhắn, lịch sử ghi "Tự nhả — quá giờ". CSKH, WFCĐ, Support cũng tự nhả sau 5 phút và không có cảnh báo riêng (29/10). | dispatch-flow | d-nha |
| ds-lan | Đã tự chia lại 1 lần? | `max_auto_redistribute` = 1 lần cho mỗi lead. Đặt 0 thì mọi lead nhả đều chờ Trưởng nhóm. | dispatch-flow | d-lan |
| ds-lai | Chia lại ngay | Quay lại bước Có ứng viên, loại người vừa nhả đúng 1 lần. | dispatch-flow | d-lai |
| ds-tn | Trưởng nhóm chia | Nhả lần hai thì vào hàng chờ thủ công, Trưởng nhóm nhận N4, lịch sử ghi "Nhả lần 2 → hàng chờ". Trưởng nhóm chia tay ở Màn 20 (popup Màn 2). | dispatch-flow | d-tn |

| Điều kiện ứng viên (Rule A2, A6) | Nguồn |
| --- | --- |
| Thuộc bộ phận hoặc tag đích | Rule A2.1 |
| 🟢 Đang làm: trong ca, đã đăng nhập, có hoạt động trong 10 phút, không Tạm nghỉ hoặc Nghỉ phép (đã chốt #15) | JCN-116.5 |
| Đang ở trạng thái **Sẵn sàng**; Đang tiếp khách, Ăn trưa, Đi vệ sinh, Hết ca thì không được chia | JCN-116.5 Rule 4 |
| Tài khoản đang hoạt động, không bị khóa | Rule A2.3 |
| Không phải người vừa nhả đúng lead này (ẩn 1 lần, đã chốt #17) | Rule A2.4 |
| Mức tải dưới `max_load` (Tải tối đa theo bộ phận, tạm 100) | Rule A6.5 [Update 30/10] |
| Còn hơn `stop_before_shift_end_minutes` (mặc định 15 phút) mới hết ca | Rule A6 [Update 30/10] |

```text title="Công thức chia (Rule A3, đề xuất BA chờ duyệt #7)"
Tải của lead     = w_loai × t_xl
Tải hiện tại(NV) = Σ Tải của lead NV đang giữ, chưa xong
Suất chia(NV)    = w_nv
Chỉ số tải(NV)   = (Tải hiện tại + Tải của lead đang chia) ÷ Suất chia
→ chọn chỉ số THẤP NHẤT; hòa: người nhận lead gần nhất cách đây LÂU NHẤT
```

| Trọng số (mặc định, sửa ở Màn 11) | Sale | CSKH / WFCĐ / Support |
| --- | --- | --- |
| `w_loai` — loại khách | 1 | 3 |
| `t_xl` — thời gian xử lý (phút) | 10 | 30 |
| Tải của một lead | 1 × 10 = 10 | 3 × 30 = 90 |
| SLA tự nhả (`auto_release`, 29/10) | 5 phút, bật | 5 phút, bật |

`w_nv` là 1,0 với nhân viên chính thức và 0,5 với thử việc. `max_load` tạm 100 tương đương 10 lead Sale (10 × 10). `t_xl` chỉ dùng để tính tải, không phải thời hạn tự nhả. Đặt mọi trọng số = 1 thì chia đều thuần theo đầu người.[](source:spec)

## Nhiều lead đến cùng lúc thì chia thế nào? {#chia-lo}

Rule A7 dùng một thuật toán chia lô cho ba trường hợp: chế độ Tự động có nhiều lead dồn, Trưởng nhóm bấm Chia đều ở chế độ Thủ công, và tràn việc.[](source:spec) Lead được sắp chờ lâu nhất trước, lead New — quá giờ chen lên đầu cùng mức chờ. Mỗi lead được giao cho người có chỉ số tải sau khi nhận thấp nhất, rồi tải được cập nhật trước lead kế tiếp.

Ví dụ trong spec: A và B chính thức (suất 1,0), C thử việc (suất 0,5), chưa giữ lead nào, mỗi lead tải 1, có 7 lead đến cùng lúc.

| Lead | Chỉ số sau khi nhận (A / B / C) | Giao cho |
| --- | --- | --- |
| 1 | 1,0 / 1,0 / 2,0 | A (hòa A–B, A lâu nhất) |
| 2 | 2,0 / 1,0 / 2,0 | B |
| 3 | 2,0 / 2,0 / 2,0 | C (hòa cả ba, C lâu nhất) |
| 4 | 2,0 / 2,0 / 4,0 | A |
| 5 | 3,0 / 2,0 / 4,0 | B |
| 6 | 3,0 / 3,0 / 4,0 | A |
| 7 | 4,0 / 3,0 / 4,0 | B |

Kết quả A = 3, B = 3, C = 1. Mục tiêu theo tỉ lệ 1 : 1 : 0,5 là 7 × 1 ÷ 2,5 = 2,8 cho A và B, 7 × 0,5 ÷ 2,5 = 1,4 cho C.

| Sự kiện kích hoạt chia lại (Rule A6) | Ghi chú |
| --- | --- |
| Có lead mới | Chia ngay |
| Lead bị nhả (Tôi nhả hoặc quá SLA) | Chia lại ngay, loại người vừa nhả 1 lần, tối đa 1 lần mỗi lead |
| NV chuyển sang Sẵn sàng | Vào ca, hết Tạm nghỉ, hết Đang tiếp khách |
| NV xuống dưới Tải tối đa | Vừa xử lý xong hoặc nhả bớt lead |
| Đổi tag, bộ phận mới có người | Rule C3 |
| Trưởng nhóm bấm Chia tự động các lead đang chờ | Chỉ sau khi chuyển Thủ công → Tự động |

@callout level=note title="Tràn việc sang bộ phận hỗ trợ (đề xuất #82, mặc định tắt)"
Khi `overflow_enabled` bật, lead Sale chờ quá `overflow_wait_minutes` (tạm 5 phút) mà không Sale nào nhận được thì mở rộng ứng viên sang `overflow_dept` (tạm CSKH).
Tag chủ vẫn là Sale. NV hỗ trợ là người phụ trách tạm, thấy cảnh báo "khác bộ phận" và được thêm tag (#77). Trưởng nhóm nhận thông tin "n lead Sale đã chuyển cho CSKH hỗ trợ". Không áp dụng ở chế độ Thủ công.

Đề xuất #80 (chưa chốt): một NV không nhận quá M lead trong K phút liên tiếp, gợi ý M = 3, K = 5, để người vừa vào ca không bị dồn lead.[](source:spec)

## Chế độ Thủ công và chia tay ở Màn 20 khác gì Tự động? {#thu-cong}

Công tắc `dispatch_mode` đặt riêng từng bộ phận, mặc định Tự động. Chỉ Quản trị hoặc Trưởng nhóm đổi được, phải ghi lý do, và có lịch sử. Chế độ Thủ công được giữ lại (đã chốt #81, 29/10).[](source:spec)

| Tiêu chí | Tự động | Thủ công |
| --- | --- | --- |
| Lead mới | Hệ thống chia ngay {good:Mặc định} | Vào Hàng chờ "Chờ nhận" |
| SLA | Chạy khi lead được giao | Chưa chạy cho tới khi Trưởng nhóm chia |
| Ai chia | Hệ thống; Trưởng nhóm chia tay bất cứ lúc nào | Chỉ Trưởng nhóm |
| Nhiều lead | Chia lô Rule A7 tự chạy | Nút Chia đều + bản xem trước |
| Tràn việc | Có, nếu bật | Không {caution:Tắt} |
| Thông báo | N1 cho người nhận | N4 cho Trưởng nhóm khi lead vào hàng chờ |

Đổi chế độ không ảnh hưởng lead đã giao: lead đang giữ vẫn chạy SLA. Chuyển Thủ công → Tự động không tự chia hàng loạt; Trưởng nhóm bấm "Chia tự động các lead đang chờ".

@sequence id=manual-flow title="Trưởng nhóm chia đều ở chế độ Thủ công (Rule A5, A7, TB1–TB2)"
| actor tn | Trưởng nhóm | frontend |
| actor m20 | Màn 20 | frontend |
| actor boChia | Bộ chia | backend |
| actor nv | Nhân viên | frontend |
| actor log | assignment_log | database |
| phase | Bật chế độ Thủ công |
| tn | m20 | Đổi công tắc + lý do |
| m20 | log | Ghi lịch sử đổi chế độ |
| boChia | tn | N4: lead mới vào Hàng chờ | return |
| phase | Chia đều các lead đang chờ |
| tn | m20 | Tick lead, bấm Chia đều |
| m20 | boChia | Tính phân bổ Rule A7 |
| boChia | m20 | Bản xem trước lead → người nhận | return |
| tn | m20 | Sửa từng dòng, Xác nhận | emphasis |
| boChia | nv | Giao lead + N1, bật SLA 5 phút | emphasis |
| boChia | log | Ghi "Trưởng nhóm chia" |

@steps id=manual-steps
| ms-doi | Trưởng nhóm | Đổi chế độ ở thanh lọc Màn 20; lý do tối đa 500 ký tự, ghi vào lịch sử. | manual-flow | tn |
| ms-tinh | Bộ chia | Dùng đúng thuật toán chia lô Rule A7, cùng trọng số `w_nv` như chế độ Tự động. | manual-flow | boChia |
| ms-xac | Màn 20 | Popup Màn 2 hiện bản xem trước; Trưởng nhóm đổi người nhận từng dòng rồi Xác nhận mới giao. | manual-flow | m20 |
| ms-nv | Nhân viên | Người nhận thành Người phụ trách, nhận N1; tên và giờ nhận hiện ở mọi danh sách và đầu khung chat. | manual-flow | nv |

| Quy tắc chia tay (Rule TB1–TB3) | Hành vi |
| --- | --- |
| Chọn người nhận | Bất kỳ NV nào, kể cả Kế toán, CSKH; tag không tự đổi |
| Popup Màn 2 | Hiện bộ phận, trạng thái 🟢🟡🟠⚪🔴, số ca đang giữ, chỉ số tải, ★ gợi ý tải thấp nhất |
| NV đạt Tải tối đa hoặc khác bộ phận | Có cảnh báo, vẫn chọn được |
| NV vừa nhả lead đó | Ẩn ở lần này |
| Chia lại lead đang có người | Lý do bắt buộc; NV cũ nhận N7; lịch sử ghi từ → sang |
| Hệ thống chia trước | Trưởng nhóm nhận "Lead đã được chia"; ai trước hiệu lực trước |
| Lấy lại (TC6) | Trưởng nhóm thành người phụ trách, lý do bắt buộc, NV cũ nhận N16, không tính nhả |
| Phạm vi nhìn thấy | Trưởng nhóm: bộ phận mình + hàng chờ. Quản trị: tất cả. Nhân viên: không thấy hàng chờ, không có nút Chia |

@callout level=open-question title="Điểm còn mâu thuẫn ở Phần B (cần chốt)"
[Update 30/10] Wireframe đã ẩn 3 nút Chia cho nhân viên (n), Chia đều các lead đang chờ và Sắp theo tiềm năng ở Hàng chờ, nhưng Rule A5, A7, TB2 và AC 40, 57, 79 vẫn mô tả chúng.
Thứ tự tự chia từ hàng chờ chưa chốt: chờ lâu nhất trước hay theo tiềm năng (cấp 2, cấp 1, nhấp quảng cáo).
Nút Mở chat của Trưởng nhóm mâu thuẫn với JCN-116.3 (chỉ người phụ trách được nhắn).
Wireframe coi lead Nhấp quảng cáo là lead đã đóng, mâu thuẫn với TR1.
Rule TB2 ghi "NV nghỉ mờ, không chọn được", còn AC 55 cho chọn NV ⚪ Ngoài ca và 🔴 Nghỉ phép kèm cảnh báo.
Danh sách lý do của popup Chia lại cần chốt.

## Trưởng nhóm theo dõi, nhận cảnh báo và tính KPI thế nào? {#theo-doi}

Tồn đọng là khách chưa xử lý: New chưa có người, New đã chia nhưng chưa trả lời, New — quá giờ, và khách CSKH chờ quá ngưỡng.[](source:spec) Dashboard so lead mới với lead đã xử lý theo giờ hoặc ngày: lead mới vượt trung bình thì kết luận "Lead mới đổ về nhiều"; lead bình thường mà tồn tăng thì kết luận "Tiến độ xử lý chậm".

| Cảnh báo (Rule TC2) | Khi nào | Gửi cho |
| --- | --- | --- |
| Quá tải | Lead chưa có người nhận vượt `overload_threshold` (tạm 20) | Trưởng nhóm: banner, gợi ý điều NV team khác (N11) |
| Đầy tải [Update 30/10] | Mọi NV Sẵn sàng đã đạt Tải tối đa | Banner "Tất cả NV Sẵn sàng đã đầy tải" |
| Lead Sale quá giờ | Lead bị tự nhả | Trưởng nhóm Sale |
| Tồn đọng cá nhân | NV giữ lead chưa xử lý vượt ngưỡng (đề xuất) | NV + Trưởng nhóm |

Cảnh báo nhắc lại theo `reminder_interval` (đề xuất 15 phút) cho tới khi xử lý, và không gửi ngoài ca làm việc của người nhận.

| KPI Sale (Rule TC3, TC7) | Ai được tính |
| --- | --- |
| Sale nhận lead và chốt đơn | Chính Sale đó |
| Sale để quá giờ, lead bị nhả, NV khác chốt | NV khác; người để quá giờ không được tính |
| Định nghĩa "ai chốt" | Người phụ trách tại thời điểm đơn được chốt hoặc lên đơn |
| Lead xuyên ca | Mỗi `status_event` ghi `shift_id_at_event`; sửa ca sau đó không đổi KPI đã ghi |
| Không tính lỗi | Nhả do chuyển bộ phận, hết ca, Lấy lại, Khó tư vấn hợp lệ |
| Lead CSKH | Chưa quy định KPI, làm sau (#18) {caution:Chưa có} |

Bảng cá nhân tách riêng "Bị nhả quá giờ" và "Nhả (Khó tư vấn)"; nhả Khó tư vấn không tính lỗi. [Update 26/10] Rule TC8 thêm đánh giá chất lượng Sale theo kỳ (Tốt, Cần cải thiện, Chưa đạt) do Trưởng nhóm chốt; bị chốt Chưa đạt quá 3 lần thì gắn nhãn "Cần training". Màn "Đánh giá Sale" chưa có wireframe.[](source:spec)

## Tag của khách đổi khi nào, do ai? {#vong-doi-tag}

Phần C tách dữ liệu khách thành 4 lớp cộng lý do vào, để J-Connect tự quyết điều hướng kể cả khi bỏ web Pancake.[](source:spec)

| Lớp | Trả lời câu hỏi | Giá trị | Ai đổi |
| --- | --- | --- | --- |
| 1. Giai đoạn `customer_stage` | Khách ở giai đoạn nào? | LEAD · KHACH_DANG_DUNG · KHACH_NGUNG · LEAD_DONG | Hệ thống theo sự kiện |
| 2. Tag bộ phận | Bộ phận nào chịu trách nhiệm? | Sale · WFCĐ · CSKH + tiểu loại (Upsale, Support, Support kỹ thuật, Thu cước) | Hệ thống hoặc người phụ trách |
| 3. Trạng thái | Đang ở bước nào của bộ đó? | Theo bộ trạng thái của tag (Rule C6, C7) | Người phụ trách, hậu cần, hệ thống |
| 4. Cờ | Có gì cần chú ý? | Khó tư vấn · Cần training · Giới thiệu chưa xác minh · Khiếu nại | Người phụ trách, Trưởng nhóm, hệ thống |
| `entry_reason` | Vì sao khách ở bộ phận này? | `NEW_LEAD`, `REFERRAL_CODE`, `AFTER_SALE`… (13 mã đề xuất) | Hệ thống ghi mỗi lần đổi tag chủ |

@workflow id=tag-flow title="Tag chủ đi tiếp theo hướng nào (Rule C3, chiều đi)"
| t-new | Khách mới | external |
| t-sale | Sale | frontend |
| t-upgt | Upsale giới thiệu | frontend |
| t-wf | WFCĐ | frontend |
| t-dong | LEAD_DONG | database |
| t-cskh | CSKH chung | backend |
| t-sup | CSKH › Support | backend |
| t-kt | Support kỹ thuật | backend |
| t-thu | CSKH › Thu cước | backend |
| t-upmt | Upsale mua thêm | frontend |
| t-new > t-sale | TR1 |
| t-sale > t-upgt | TR3, TR4 |
| t-sale > t-wf | TR5 |
| t-sale > t-cskh | TR6 giao xong | emphasis |
| t-sale > t-dong | TR16 |
| t-cskh > t-sup | TR8 |
| t-sup > t-kt | TR9 |
| t-cskh > t-thu | TR10 |
| t-cskh > t-upmt | TR19, TR12, TR13 |

@steps id=tag-steps
| ts-sale | Sale | TR1: hệ thống gắn tag Sale ngay khi lead được chia (#66); "chưa có tag" chỉ là khoảnh khắc trước khi chia. Khách có mã giới thiệu hợp lệ vào thẳng Upsale (TR2, xem sơ đồ điều hướng). | tag-flow | t-sale |
| ts-upgt | Upsale giới thiệu | TR3: Sale nhập mã hợp lệ giữa chừng, lead tự nhả khỏi Sale, không tính quá giờ. TR4: Sale gắn tay khi chưa có mã, kèm cờ Giới thiệu chưa xác minh (#68). Tag là `CSKH › Upsale`. | tag-flow | t-upgt |
| ts-wf | WFCĐ | TR5: Sale đổi tag khi khách muốn đăng ký WiFi cố định; lead tự nhả khỏi Sale và chia cho NV WFCĐ. | tag-flow | t-wf |
| ts-cskh | CSKH chung | TR6: đơn Sale giao thành công thì hệ thống chuyển, `customer_stage` = KHACH_DANG_DUNG. Chưa chia ngay (#8); khách nhắn lại mới chia theo C5-7. Đang trò chuyện thì hoãn chuyển (bất biến I6). | tag-flow | t-cskh |
| ts-dong | LEAD_DONG | TR16: người phụ trách chọn Không mua + lý do, giữ tag, lead rời danh sách việc cần làm. | tag-flow | t-dong |
| ts-kt | Support kỹ thuật | TR9: NV Support chuyển, ghi chú bàn giao bắt buộc; sang Tech Support Inbox (JCN-84/85). | tag-flow | t-kt |
| ts-upmt | Upsale mua thêm | TR19: NV CSKH gắn khi khách đang dùng muốn mua thêm, không quay về Sale (#9). TR12, TR13: hệ thống gắn khi đến ngày hẹn upsale hoặc SIM còn N ngày hết hạn (tạm 30), gửi N12. Tag là `CSKH › Upsale`. | tag-flow | t-upmt |

| Chiều quay về | Mã | Tác nhân |
| --- | --- | --- |
| Upsale → CSKH chung khi đơn Upsale giao thành công | TR7 (bổ sung mới, #69) | Hệ thống |
| WFCĐ → CSKH chung khi lắp đặt thành công | TR14 (đề xuất #3) | Hệ thống |
| WFCĐ → Sale khi hủy đăng ký, khách chưa có đơn, sau khoảng chờ đề xuất 30 ngày | TR15 (ngoại lệ đã chốt #78) | Hệ thống |
| Support kỹ thuật → Support → CSKH chung khi xử lý xong | sau TR9, TR8 | NV Support |
| Thu cước → CSKH chung khi đã xác nhận thanh toán | sau TR10 | Hệ thống |
| LEAD_DONG → Sale khi khách nhắn lại | C5-9 | Hệ thống |

Ngoài sơ đồ: **TR17** (người phụ trách chuyển đúng bộ phận, có thể dùng Tôi nhả lý do "Sai bộ phận") và **TR18** (Trưởng nhóm đổi tay, lý do bắt buộc, có nút Hoàn tác) đi từ bất kỳ tag nào. TR11 (khách ngưng dịch vụ có hẹn upsale) chỉ đổi `customer_stage` = KHACH_NGUNG, chưa đổi tag.[](source:spec)

## Điều gì luôn phải đúng khi đổi tag? {#bat-bien}

| Bất biến (Rule C4) | Cách đảm bảo |
| --- | --- |
| I1 — Đúng một tag chủ, tối đa một tiểu loại | Nhu cầu thứ hai tạo việc riêng; hội thoại thuộc việc ưu tiên cao nhất (#1) |
| I2 — Sale chỉ giữ khách chưa có đơn giao thành công | Khách đã mua muốn mua thêm → Upsale (#9); ngoại lệ duy nhất là TR15 |
| I3 — Một hội thoại, một người trả lời chính | Người khác chỉ xem |
| I4 — Mỗi lần đổi tag chủ đều ghi lịch sử | Thời điểm, tác nhân, mã TRxx, tag cũ → mới, `entry_reason`, người phụ trách cũ → mới, lý do; Hoàn tác thêm dòng mới |
| I5 — Bộ trạng thái hiện theo tag hiện tại | Trạng thái bộ cũ ẩn khỏi màn nhưng giữ ở lịch sử |
| I6 — Không giật khách giữa câu chuyện | Người cũ vừa trao đổi trong 30 phút (đề xuất #70) thì hoãn chuyển tự động tới khi im lặng 30 phút, bấm Hoàn tất bàn giao, hoặc hết ca |
| I7 — Đơn hàng không chuyển theo lead | Hậu cần vẫn xử lý đơn; người mới chỉ xem |
| I8 — Sự kiện tự động idempotent | Sự kiện giao thành công đến lần hai hoặc đến trễ thì bỏ qua, ghi log "Sự kiện lặp" |
| I9 — Sự kiện đồng thời xử lý theo thứ tự thời gian | Tin đến trong lúc chuyển thuộc người phụ trách mới |

| Tình huống biên (Rule C9) | Xử lý |
| --- | --- |
| EC1 — Mã giới thiệu không hợp lệ | Vào Sale (TR1), Sale thấy cảnh báo, có thể gắn tay (TR4) |
| EC4 — Đơn hoàn hoặc trả hàng | Giữ CSKH, mở việc Support › Lên đơn đổi; quay về LEAD hay không thì chưa chốt (#75) |
| EC5 — Hai đơn Sale gần nhau | Đề xuất chỉ đổi tag khi không còn đơn Sale đang xử lý (#76) |
| EC6 — Sale gắn nhầm CSKH hoặc WFCĐ | Người gắn Hoàn tác trong 10 phút; Trưởng nhóm Hoàn tác bất kỳ lúc nào |
| EC11 — Người phụ trách bị khóa đúng lúc đổi tag | Bỏ bước hoãn, chuyển ngay, báo Trưởng nhóm |
| EC12 — Chế độ gợi ý đang bật | Chỉ ghi log "sẽ chuyển TRxx", không đổi tag thật |
| EC13 — Chia cho NV ngoài bộ phận | Tag chủ không đổi; người phụ trách tạm được thêm tag (đã chốt #77) |

## Màn hình nào dùng cho việc gì? {#man-hinh}

| Màn | Ai dùng | Mục đích |
| --- | --- | --- |
| Màn 20 — Trung tâm chia lead [Update 30/10] | Trưởng nhóm, Quản trị | Thanh lọc + công tắc chế độ, banner cảnh báo, 6 thẻ tổng quan, tab Tất cả lead đổ về · Hàng chờ (n) + Nhân viên đang trực · Lead đóng hôm nay · Lịch sử chia việc {good:Màn chính} |
| Màn 2 — Popup Chia cho nhân viên | Trưởng nhóm, Quản trị | Chọn người nhận cho một hoặc nhiều lead; lý do bắt buộc khi lead đã có người phụ trách |
| Popup Chia lại [Update 30/10] | Trưởng nhóm, Quản trị | Mở từ nút Chia lại ở bảng nhân viên; chuyển lead đang giữ của một NV sang người khác, NV cũ không bị tính nhả |
| Màn 12 — Lịch sử chia việc | Trưởng nhóm, Quản trị | Timeline theo lead: chia tự động kèm log giải thích, nhả, chia lô, tràn việc, đổi tag, trả lời đầu tiên, chốt đơn |
| Màn 9 — Danh sách khách Pancake | Nhân viên (theo quyền xem), Trưởng nhóm | Lọc theo Trạng thái đơn hàng, Trạng thái vận chuyển, tag, người phụ trách; cột người phụ trách hiện tên + giờ nhận hoặc "Chờ nhận" |
| Màn 11 — Cài đặt chia việc | Chỉ Quản trị | SLA, `auto_release`, `max_load`, `max_auto_redistribute`, trọng số, tràn việc; mọi thay đổi ghi lịch sử, áp dụng từ lần chia kế tiếp |
| Màn 3 — Lead của tôi (JCN-116.3) | Nhân viên | Lead mình phụ trách, Tôi nhả; tab Hàng chờ đã bỏ |
| Màn 10 Dashboard, Màn 1 Chia việc lead | — | Đã gộp vào Màn 20 {caution:Không dùng riêng} |
| Đánh giá Sale | Trưởng nhóm | Chốt mức đánh giá kỳ; chưa có wireframe |

Bấm một dòng ở bảng Nhân viên đang trực thì lưới Tất cả lead lọc theo NV đó, kèm chip bỏ lọc. Mọi số liệu trên Màn 20 cập nhật theo sự kiện, không cần tải lại trang.[](source:spec)

## QA cần kiểm những tiêu chí nào? {#nghiem-thu}

- [ ] AC 1, 6: lead mới chỉ chia cho Sale đi làm; 10 lead với 5 Sale cùng trọng số thì mỗi người nhận 2, Sale nghỉ nhận 0.
- [ ] AC 7: chỉ số tải so đúng công thức Rule A3 (xem cảnh báo dưới).
- [ ] AC 2, 3, 50: trả lời trong 5 phút thì sang Đã tiếp nhận; quá 5 phút thì tự nhả, nhãn New — quá giờ, NV cũ mất quyền nhắn.
- [ ] AC 4, 5, 11: khách có tag về người phụ trách đang làm; người phụ trách vắng thì chia cho NV cùng bộ phận, lịch sử ghi "Người phụ trách vắng".
- [ ] AC 12: lead page Polling có nhãn "Chỉ lưu — không SLA", không được chia.
- [ ] AC 13: CSKH quá 5 phút tự nhả, không có cảnh báo riêng, chia lại và loại người vừa nhả 1 lần.
- [ ] AC 14, 42, 48: NV Đang tiếp khách, còn dưới 15 phút hết ca, nghỉ phép hoặc khác bộ phận không nằm trong ứng viên.
- [ ] AC 15, 16, 83: chế độ Thủ công không tự chia, chưa chạy SLA; đổi chế độ không ảnh hưởng lead đã giao.
- [ ] AC 32, 36, 37: lead đến cùng lúc chia lần lượt; 7 lead cho A, B, C ra 3 / 3 / 1; hòa thì người nhận cách đây lâu nhất thắng.
- [ ] AC 33, 44, 45, 47: hàng chờ tự chia khi có người Sẵn sàng hoặc xuống dưới Tải tối đa, chờ lâu nhất trước.
- [ ] AC 34, 46, 77: NV đạt `max_load` không được chia; mọi người đầy tải thì hiện banner đầy tải.
- [ ] AC 35, 41, 49: lead nhả được chia lại ngay đúng 1 lần; nhả lần hai vào hàng chờ thủ công và Trưởng nhóm nhận N4.
- [ ] AC 38, 39: tràn việc sang CSKH chỉ ở chế độ Tự động; tag chủ vẫn là Sale.
- [ ] AC 43: hai tin đến cùng lúc không tạo lead trùng.
- [ ] AC 52, 53, 54, 56, 58: chia lại ghi từ → sang và gửi N7; chia cho Kế toán không đổi tag; NV đầy tải có cảnh báo nhưng chọn được; NV vừa nhả bị ẩn; hệ thống chia trước thì Trưởng nhóm nhận "Lead đã được chia".
- [ ] AC 59: hàng chờ vượt ngưỡng 20 thì Trưởng nhóm nhận N11.
- [ ] AC 63, 64, 71: KPI thuộc người phụ trách lúc chốt đơn; lead xuyên ca tính cho người chốt.
- [ ] AC 17–21, 24: mã giới thiệu hợp lệ đi thẳng Upsale; đơn Sale hoặc Upsale giao thành công thì về CSKH chung.
- [ ] AC 22, 23: hoãn chuyển tag khi NV vừa trò chuyện dưới 30 phút; sự kiện lặp bị bỏ qua.
- [ ] AC 30: mỗi lần đổi tag chủ có đủ thời điểm (giờ Tokyo), tác nhân, mã TRxx, tag cũ → mới, `entry_reason`, lý do.
- [ ] AC 80–82, 84: Màn 20 chứa thẻ, hàng chờ, bảng nhân viên và danh sách lead; nhân viên không thấy Màn 20.

@callout level=warning title="AC 7 lệch với công thức Rule A3"
AC 7 tính Lan = 10 ÷ 1,0 = 10 và Nam = 4 ÷ 0,5 = 8, nên giao cho Nam, nhưng phép tính này chưa cộng tải của lead đang chia.
Theo Rule A3 với một lead Sale (tải 10): Lan = (10 + 10) ÷ 1,0 = 20, Nam = (4 + 10) ÷ 0,5 = 28, nên lead về Lan. Nam chỉ thắng khi lead có tải dưới 2.
Cần BA chốt một cách tính trước khi viết test case.
