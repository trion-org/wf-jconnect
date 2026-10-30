# JCN-116.3 — Lead của tôi & Khung chat: nhân viên xử lý lead thế nào? {#tong-quan}

Lead do JCN-116.2 giao về **Lead của tôi** (Màn 3) kèm thông báo N1; nhân viên mở **Khung chat** (Màn 5) để tư vấn, tạo đơn, rồi **bàn giao theo tag** (Màn 8) hoặc **Tôi nhả** (Màn 7) để lead quay lại JCN-116.2 chia tiếp.

- Ai cũng xem được hội thoại, nhưng chỉ người phụ trách được nhắn, đổi tag, tạo đơn và gửi thông tin thanh toán.[](source:spec)
- Gắn tag CSKH hoặc WFCĐ (tay hoặc tự động) làm lead tự nhả khỏi Sale và được chia cho bộ phận nhận.[](source:spec)
- Nhân viên chỉ thấy lead của mình: không có hàng chờ, không có nút Chia, không có Tôi nhận (cập nhật 29/10/2026).[](source:spec)
- Lead đã lên đơn hoặc đang có đơn chưa hoàn tất không nhả được.[](source:spec)

@answer scope="Spec đề xuất JCN-116.3, gộp lại 30/10/2026 · chưa tạo trên Jira · Phase 1 chỉ thông báo in-app"
@meta locale=vi
@source spec title="JCN-116.3 — Lead của tôi & Khung chat (bản 30/10/2026)"

## JCN-116.3 nằm ở đâu trong luồng JCN-116? {#vi-tri span=12}

JCN-116.3 là màn làm việc của nhân viên. Việc chia lead thuộc JCN-116.2; đồng bộ Pancake thuộc JCN-116.1; trạng thái làm việc thuộc JCN-116.5; Lên đơn chi tiết thuộc JCN-84 (ngoài phạm vi).[](source:spec)

@workflow id=luong-tong title="Vòng đời lead quanh màn nhân viên"
| lane chia | JCN-116.2 chia |
| lane nv | Nhân viên (116.3) |
| lane ra | Lối ra |
| giao | Chia lead | external | chia |
| n1 | Thông báo N1 | backend | chia |
| m3 | Lead của tôi (Màn 3) | frontend | nv |
| m5 | Khung chat (Màn 5) | frontend | nv |
| traloi | Trả lời trong 5 phút? | backend | nv |
| xuly | Xử lý được? | backend | nv |
| thuhoi | Tự nhả, chia lại | external | ra |
| don | Tạo đơn | backend | ra |
| rakhoi | Bàn giao / Tôi nhả | backend | ra |
| giao > n1 | |
| n1 > m3 | |
| m3 > m5 | Mở chat |
| m5 > traloi | |
| traloi > thuhoi | không | dashed |
| traloi > xuly | có |
| xuly > don | có | emphasis |
| xuly > rakhoi | không |

@steps id=luong-tong-steps
| s-giao | Chia lead | JCN-116.2 chia tự động hoặc Trưởng nhóm chia; cũng là điểm nhận lại lead sau Tôi nhả, đổi tag, quá giờ. | luong-tong | giao |
| s-n1 | Thông báo N1 | Nhân viên được giao nhận N1 kèm tên khách và hạn 5 phút (AC 20). | luong-tong | n1 |
| s-m3 | Lead của tôi (Màn 3) | Lead lên đầu danh sách với đồng hồ đếm ngược SLA. | luong-tong | m3 |
| s-m5 | Khung chat (Màn 5) | Nút Mở chat mở khung làm việc 3 cột. | luong-tong | m5 |
| s-traloi | Trả lời trong 5 phút? | Nhân viên phải trả lời khách trước khi hết SLA 5 phút. | luong-tong | traloi |
| s-thuhoi | Tự nhả, chia lại | Quá 5 phút: lead tự nhả, N3 gửi cho NV và Trưởng nhóm, JCN-116.2 chia lại. | luong-tong | thuhoi |
| s-xuly | Xử lý được? | Nhân viên tư vấn và cập nhật Trạng thái tư vấn, Trạng thái chốt đơn (Rule A4). | luong-tong | xuly |
| s-don | Tạo đơn | Tab Tạo đơn trong khung chat; quy tắc đơn dùng chung JCN-84. | luong-tong | don |
| s-rakhoi | Bàn giao / Tôi nhả | Sai bộ phận: đổi tag qua Màn 8. Không xử lý được: Tôi nhả qua Màn 7. Cả hai đưa lead về JCN-116.2 chia tiếp. | luong-tong | rakhoi |

| Đến từ | Đi tới |
| --- | --- |
| JCN-116.2: chia tự động / thủ công, N1 | JCN-116.2: chia lại sau Tôi nhả, đổi tag; Lịch sử chia việc |
| JCN-116.1: trạng thái đơn, sự kiện giao thành công, tin nhắn khách | Lên đơn JCN-84 (ngoài phạm vi) |

## Khung chat cho ai làm gì? {#khung-chat}

Màn 5 là một màn 3 cột: danh sách khách · chat · panel phải 3 tab Thông tin / Tạo đơn / Đơn hàng (cập nhật 30/10/2026). Màn 6 cùng bố cục nhưng chỉ đọc.[](source:spec)

| Tình huống | Thấy gì | Làm được gì |
| --- | --- | --- |
| Người phụ trách | Đầy đủ 3 cột, bộ đếm SLA khi lead New | Nhắn, gửi hình, đổi tag, tạo đơn, gửi thông tin thanh toán {good:Toàn quyền} |
| Người khác (Màn 6) | Banner “Đang do NV phụ trách (nhận giờ)”; xem tab Thông tin và Đơn hàng | Ô nhập, gửi hình, Đổi tag, Tạo đơn, Gửi thanh toán bị khóa {bad:Chỉ đọc} |
| Lead Chờ nhận | Banner “Chờ nhận” | Trưởng nhóm thấy nút Chia; nhân viên chỉ xem, không có Tôi nhận (29/10/2026) |
| Ngoài cửa sổ nhắn tin (24 giờ / 7 ngày, #13) | Cảnh báo “Không gửi được — liên hệ khách kênh khác” | Ô nhập và các nút gửi bị khóa {caution:Khóa gửi} |
| Trưởng nhóm xem lead người khác | Khung chỉ đọc | Nút Lấy lại (JCN-116.2 Rule TC6) |

| Cột / tab | Nội dung chính |
| --- | --- |
| Trái — Danh sách khách | Tab Khách hàng / Nhân viên; tìm theo tên, SĐT, PSID (từ 2 ký tự); chip Của tôi, Chờ trả lời, Mới (24h); lọc tag, trạng thái xử lý. Mỗi dòng bỏ mã KH, thêm dòng “NV đang xử lý”, bỏ nhãn “Đã liên kết” (30/10/2026) |
| Giữa — Chat | Tin khách, tin nhân viên (tên NV + giờ gửi), tin hệ thống. Thanh công cụ: Gửi hình báo giá · File · Mẫu tin · Gửi thông tin thanh toán · Gửi tóm tắt đơn |
| Tab Thông tin | Người phụ trách + SLA · thông tin khách · Tag & trạng thái (cờ Khó tư vấn, nút Đổi tag / Bàn giao, Tôi nhả, Lịch sử chia việc) · đơn gần đây · ghi chú nội bộ tối đa 1000 ký tự · thông tin Pancake |
| Tab Tạo đơn | Form rút gọn tự điền từ khách; Lưu nháp hoặc Tạo đơn. Tạo xong: trạng thái Chờ check TT, Trạng thái chốt đơn = Đã lên đơn |
| Tab Đơn hàng | Chi tiết, Thanh toán, Đóng gói, Vận chuyển; chỉ xem (Kế toán, Kho, hãng vận chuyển cập nhật qua JCN-116.1) |

@facts
| Mỗi tin nhắn | Chữ HOẶC file; cần cả hai thì gửi 2 tin liên tiếp |
| Gửi thông tin thanh toán | Một tin gồm mã đơn, số tiền, ngân hàng, số tài khoản, chủ tài khoản, nội dung CK, QR nếu có; nhân viên không sửa được; ghi vào Hoạt động |
| Trạng thái tư vấn | Nhấp quảng cáo → cấp 1 → cấp 2 → bổ sung thông tin → xong |
| Trạng thái chốt đơn | Đang tư vấn → Chờ chốt → Đã chốt → Đã lên đơn; đồng bộ Pancake (JCN-116.1) |
| Ghi chú Khó tư vấn | Hiện đầu hội thoại kèm tên, giờ người nhả; nhiều lần nhả thì xem được ghi chú cũ |
| Tin tự động | Đơn Đã đóng gói thì JCN-116.1 gửi tin xuất kho |

## Đổi tag thì lead đi đâu? {#ban-giao span=12}

Tag quyết định bộ phận nhận. Tag đổi trong CRM là chuẩn và được đẩy sang Pancake; tag đổi trên Pancake không đổi tag CRM, trừ nhóm đặt 2 chiều (cập nhật 26/10/2026).[](source:spec)

@workflow id=luong-tag title="Gắn / đổi tag và bàn giao bộ phận"
| lane kichhoat | Kích hoạt |
| lane quyet | Kiểm tra |
| lane ketqua | Kết quả |
| tay | NV phụ trách đổi tag | frontend | kichhoat |
| tudong | Quy tắc tự gắn tag | backend | kichhoat |
| goiy | Chế độ gợi ý? | backend | quyet |
| ghichu | Sang Support kỹ thuật? | backend | quyet |
| giu | Giữ tag, ghi log | backend | ketqua |
| tunha | Tự nhả khỏi người cũ | backend | ketqua |
| sanSang | Bộ phận có ai Sẵn sàng? | backend | ketqua |
| chia | Chia cho NV mới | external | ketqua |
| hangcho | Hàng chờ bộ phận | database | ketqua |
| tudong > goiy | |
| goiy > giu | có |
| goiy > tunha | không |
| tay > ghichu | Màn 8 |
| ghichu > tunha | có ghi chú / không cần |
| tunha > sanSang | |
| sanSang > chia | có | emphasis |
| sanSang > hangcho | không |

@steps id=luong-tag-steps
| t-tay | NV phụ trách đổi tag | Chỉ người phụ trách (và Trưởng nhóm khi chia lại) đổi tag, qua popup Màn 8. Sale chọn Sale, WFCĐ hoặc CSKH. | luong-tag | tay |
| t-tudong | Quy tắc tự gắn tag | Mã giới thiệu hợp lệ → CSKH; đơn Sale giao thành công → CSKH; đến ngày hẹn upsale hoặc SIM sắp hết hạn → CSKH Upsale. | luong-tag | tudong |
| t-goiy | Chế độ gợi ý? | Bật chế độ gợi ý: tag giữ nguyên, lịch sử ghi “gợi ý: sẽ đổi sang …” (AC 16). | luong-tag | goiy |
| t-ghichu | Sang Support kỹ thuật? | Ghi chú bàn giao bắt buộc khi sang Support kỹ thuật; để trống thì báo lỗi, chưa chuyển (AC 18, AC 46). | luong-tag | ghichu |
| t-tunha | Tự nhả khỏi người cũ | Người cũ mất quyền nhắn và đổi tag, chỉ còn xem; lịch sử ghi “Bàn giao bộ phận”; phần việc thuộc đơn hàng không chuyển theo. Không tính lỗi quá giờ. | luong-tag | tunha |
| t-sansang | Bộ phận có ai Sẵn sàng? | JCN-116.2 chia tự động cho NV bộ phận nhận đang làm. | luong-tag | sanSang |
| t-chia | Chia cho NV mới | NV mới nhận N1; ghi chú bàn giao hiện đầu khung chat người nhận. | luong-tag | chia |
| t-hangcho | Hàng chờ bộ phận | Không có ai Sẵn sàng thì lead vào hàng chờ của bộ phận đó (Rule B6). | luong-tag | hangcho |

| Tag | Khi nào có | Người phụ trách mặc định |
| --- | --- | --- |
| Sale | Khách mới (mặc định sau tư vấn) | NV Sale |
| WFCĐ | Sale gắn khi khách muốn đăng ký WiFi cố định | NV hỗ trợ WFCĐ {caution:Tag con CSKH từ 30/10} |
| CSKH (nhóm gốc) | Khách giới thiệu, đơn Sale giao thành công, đơn của CSKH | Chỉ có CSKH → Upsale |
| CSKH Upsale | Khách giới thiệu, mua thêm, đến ngày hẹn, SIM sắp hết hạn | NV Upsale |
| CSKH Support | Hỗ trợ chung | NV CSKH |
| CSKH Support kỹ thuật | Sự cố kỹ thuật | NV CSKH, phối hợp Kỹ thuật (JCN-84/85) |
| CSKH Thu cước | Khách SIM thu cước (JCN-87) | NV CSKH thu cước |

@callout level=note title="Catalog tag là dữ liệu cấu hình (24/10/2026)"
Mỗi tag có màu, alias Pancake, nhóm, bộ phận nhận, ưu tiên, bật/tắt; tag có bộ phận nhận quyết định bàn giao. Tắt tag thì không chọn được nữa, khách đã gắn vẫn hiển thị (AC 15). Trưởng nhóm bấm Hoàn tác trên lịch sử đổi tag để đưa tag và người phụ trách về giá trị trước (AC 17).

## Quy tắc tự gắn tag và phân biệt khách CSKH {#tu-gan-tag}

| Nguồn | Điều kiện | Hành động |
| --- | --- | --- |
| Đến ngày hẹn upsale | Khách Ngưng dịch vụ, Ngày hẹn upsale = hôm nay (nhập khi hủy dịch vụ, JCN-83) | Tự gắn Upsale → chia tự động → N12 |
| SIM bán đứt sắp hết hạn | Hạn SIM trừ hôm nay = N ngày; hạn = ngày xuất hàng + 12 tháng (#20); N do Nguyệt cung cấp | Tự gắn Upsale → chia tự động → N12 |
| Khách giới thiệu | Có mã giới thiệu hợp lệ | Tự gắn CSKH → Upsale |
| Đơn Sale giao thành công | Sự kiện `order.delivered` | Tự đổi CSKH; Đang sử dụng; Loại dịch vụ Sim bán đứt / thu cước |
| NV CSKH thấy nhu cầu mua thêm | Đổi tag thủ công | Chuyển người phụ trách |

| Tổ hợp tag | Xử lý |
| --- | --- |
| Chỉ CSKH, chưa có đơn | Khách giới thiệu → Upsale |
| Chỉ CSKH, đã có đơn giao thành công / Đang sử dụng | Khách sau bán (đã chốt #31) |
| Chỉ WFCĐ | NV WFCĐ; thêm Trạng thái đăng ký và Trạng thái lắp đặt |
| Từ 2 tag trở lên | Quy tắc nhiều tag, còn mở (#1) {caution:Chưa chốt} |

Mọi lần đổi tag ghi lịch sử: thời điểm, người đổi, tag cũ → mới, tự động hay thủ công, lý do. Chuyển ngược CSKH → Sale chưa được quy định (#9).[](source:spec)

## Tài khoản CSKH khác Sale ở đâu? {#tai-khoan-cskh}

Rule B7 (cập nhật 30/10/2026) thêm vai trò **Nhân viên CSKH**: cùng quyền nhân viên, không có Trung tâm chia lead và Cài đặt chia việc. BA xác nhận WFCĐ là tag con của CSKH.[](source:spec)

| Khía cạnh | Tài khoản Sale | Tài khoản CSKH |
| --- | --- | --- |
| Lead nhìn thấy (Màn 3, Màn 9, cột trái Màn 5/6) | Lead mình phụ trách | Chỉ lead tag CSKH, gồm Support, Support kỹ thuật, Thu cước, Upsale, WFCĐ; lead Sale và chưa có tag không hiện {caution:Lọc theo tag} |
| Tag trên khung chat | Sale | CSKH › tiểu loại |
| Panel Thông tin | Trạng thái tư vấn, Trạng thái chốt đơn | Dịch vụ, Trạng thái xử lý, Số lần support, Vấn đề xử lý, Sản phẩm support |
| Màn 8 — lựa chọn Chuyển sang | Sale (mặc định) · WFCĐ · CSKH | CSKH (mặc định) · CSKH Support · CSKH WFCĐ; tag con khác: Upsale, Thu cước |
| Ô Mã giới thiệu | Có | Không có |
| Ô Vấn đề / yêu cầu của khách | Không có | Có, ghi chú tự do |
| Thẻ thống kê Màn 3 | Lead của mình | Chỉ lead CSKH của mình |

@callout level=open-question title="Cần đồng bộ sau quyết định WFCĐ thuộc CSKH"
JCN-116.2 Rule C3 (TR5, TR14, TR15), C5 dòng 8, C7 và Tag.md Phần C vẫn coi WFCĐ là bộ phận riêng. Còn mở: NV WFCĐ dùng chung Hàng chờ CSKH hay hàng chờ riêng; radio Màn 8 của CSKH có hiện Support kỹ thuật, Upsale, Thu cước không; CSKH có xem lead Sale đã chuyển sang sau bán (TR6) trong lịch sử không.

## Lead của tôi và thông báo chạy thế nào? {#lead-cua-toi}

Màn 3 chỉ có một tab **Của tôi**, xếp quá hạn SLA / chờ lâu nhất lên đầu. Cột Khách hiện tên, dòng “NV đang xử lý” và tag, bỏ mã KH (30/10/2026). Đầu trang có thanh trạng thái làm việc (ca · 🟢/🟡/🟠 · Tạm nghỉ, JCN-116.5) và chuông.[](source:spec)

@sequence id=thong-bao title="Thông báo quanh một lead mới giao (SLA 5 phút)"
| actor chia | JCN-116.2 chia lead | backend |
| actor tb | Khung thông báo | messagebus |
| actor nv | Nhân viên | frontend |
| actor tn | Trưởng nhóm | frontend |
| phase | Giao lead |
| chia | tb | Lead được giao |
| tb | nv | N1 + âm báo + toast | emphasis |
| phase | Chờ trả lời |
| tb | nv | N2 còn 1 phút |
| phase | Quá 5 phút chưa trả lời |
| chia | tb | Thu hồi quá giờ |
| tb | nv | N3 lead đã bị thu hồi |
| tb | tn | N3 lead đã bị thu hồi |
| chia | tb | Chia lại cho NV khác |
| tb | nv | N7 lead bị chia lại | dashed |

@steps id=thong-bao-steps
| b-giao | Lead được giao | N1 có âm báo; lead lên đầu Lead của tôi với đồng hồ đếm ngược. | thong-bao | chia |
| b-n1 | N1 + âm báo + toast | Nhấn thông báo mở thẳng đúng lead / hội thoại và đánh dấu đã đọc (AC 26). | thong-bao | nv |
| b-thuhoi | Thu hồi quá giờ | Hết 5 phút chưa trả lời: N3 cho NV và Trưởng nhóm, lead biến khỏi Lead của tôi (AC 21). | thong-bao | tn |
| b-chialai | Chia lại cho NV khác | NV cũ nhận N7. N3 và N7 vẫn gửi cả khi NV đã hết ca (AC 23). | thong-bao | chia |

| Thẻ (chỉ lead của mình, từ 00:00) | Số chính | Dòng phụ |
| --- | --- | --- |
| Nhận hôm nay | Lead được giao qua mọi đường | tự chia · Trưởng nhóm chia |
| Đang giữ | Lead đang phụ trách, chưa xong | tải `n/max_load`; đạt ngưỡng: chữ đỏ + “không được chia thêm” |
| Chưa trả lời | Lead New; số đỏ khi lớn hơn 0 | đồng hồ của lead gần hết giờ nhất, hoặc “—” |
| Đã tiếp nhận | Lead đã trả lời, đang tư vấn | chờ chốt n |
| Đã lên đơn hôm nay | Lead tạo đơn từ 00:00 | số đơn, nếu khác số lead |
| Đã nhả hôm nay | Lead mất quyền xử lý | tự nhả quá giờ · Tôi nhả; viền vàng khi có nhả quá giờ {caution:Cảnh báo chậm} |

Bấm một thẻ thì lọc lưới theo thẻ đó, bấm lại để bỏ lọc (AC 30). Thẻ tự cập nhật không cần tải lại trang (AC 31). Số 0 vẫn hiện “0”; không có số của người khác hay trung bình nhóm.

| Mã | Sự kiện | Gửi cho | Từ |
| --- | --- | --- | --- |
| N1 | Lead được giao | NV được giao (có âm báo) | 116.2 |
| N2 | Sắp hết SLA, còn 1 phút | NV giữ lead New | 116.2 |
| N3 | Lead bị thu hồi quá giờ | NV vừa giữ + Trưởng nhóm | 116.2 |
| N4 | Lead mới vào hàng chờ | Trưởng nhóm (âm báo, nút Chia, gom nhóm) | 116.2 |
| N5, N6, N8 | Bỏ (29/10/2026) {bad:Bỏ} | — | — |
| N7 | Lead bị chia lại | NV cũ | 116.2 |
| N9 | Khách nhắn tin mới | Người phụ trách | 116.1 |
| N10 | Đánh dấu Khó tư vấn / ghi chú mới | Trưởng nhóm | 116.2 |
| N11 | Cảnh báo quá tải / tồn đọng | Trưởng nhóm / người phụ trách | 116.2 |
| N12 | Lead Upsale mới | NV Upsale được chia | 116.3 |
| N13, N14, N15 | Lịch ca sửa, yêu cầu đổi ca, NV giữ lead bị bỏ ca | NV / Trưởng nhóm | 116.5 |

@callout level=warning title="Thanh tải: spec còn lệch nhau"
Rule NB1 (30/10/2026) bỏ thanh “Tải n/Tải tối đa” khỏi Màn 3, nhưng AC 25 và bảng 6.1 vẫn mô tả thanh tải “40/100”. Số tải hiện còn nằm ở dòng phụ thẻ Đang giữ. Hỏi BA trước khi làm hoặc viết test cho thanh tải.

## Nhả lead diễn ra thế nào? {#nha-lead span=12}

Nút Tôi nhả có ở Lead của tôi và khung chat, chỉ trên lead của mình.[](source:spec)

@workflow id=luong-nha title="Tôi nhả (Màn 7)"
| lane kiem | Kiểm tra |
| lane nhap | Popup Màn 7 |
| lane sau | Sau khi nhả |
| bam | Bấm Tôi nhả | frontend | kiem |
| codon | Đã lên đơn? | backend | kiem |
| khoa | Nút khóa | backend | kiem |
| lydo | Chọn lý do | frontend | nhap |
| canghichu | Khó tư vấn / Khác? | backend | nhap |
| ghichu | Nhập ghi chú | frontend | nhap |
| hangcho | Về hàng chờ | database | sau |
| chedo | Chế độ Tự động? | backend | sau |
| chialai | Chia lại ngay | external | sau |
| chotn | Chờ Trưởng nhóm | frontend | sau |
| bam > codon | |
| codon > khoa | có | dashed |
| codon > lydo | không |
| lydo > canghichu | |
| canghichu > ghichu | có |
| canghichu > hangcho | không |
| ghichu > hangcho | |
| hangcho > chedo | |
| chedo > chialai | có | emphasis |
| chedo > chotn | không |

@steps id=luong-nha-steps
| r-codon | Đã lên đơn? | Lead đã lên đơn hoặc đang có đơn chưa hoàn tất thì nút khóa; nhờ Trưởng nhóm chia lại (đề xuất, AC 33). | luong-nha | codon |
| r-lydo | Chọn lý do | Bắt buộc: Khó tư vấn · Sai bộ phận (Chuyển CSKH…) · Quá tải · Nghỉ/đột xuất · Khác. | luong-nha | lydo |
| r-ghichu | Nhập ghi chú | Bắt buộc với Khó tư vấn / Khác, tối đa 500 ký tự: khách cần gì, đã tư vấn gì, vướng ở đâu, hướng xử lý. | luong-nha | ghichu |
| r-hangcho | Về hàng chờ | Nhãn “Chờ nhận”, người phụ trách trống, người nhả mất quyền nhắn; Khó tư vấn gắn cờ ⚑ và gửi N10 cho Trưởng nhóm. | luong-nha | hangcho |
| r-chialai | Chia lại ngay | Loại người nhả 1 lần; tối đa 1 lần tự chia lại, nhả lần hai thì chờ Trưởng nhóm. | luong-nha | chialai |
| r-chotn | Chờ Trưởng nhóm | Chế độ Thủ công: Trưởng nhóm chia từ JCN-116.2. | luong-nha | chotn |

| Lý do | Ghi chú | Tính lỗi người nhả |
| --- | --- | --- |
| Khó tư vấn | Bắt buộc; gắn cờ ⚑, ghi chú hiện đầu khung chat người nhận | Không, nhưng được thống kê {good:Không lỗi} |
| Sai bộ phận / Chuyển CSKH | Không bắt buộc; lead về hàng chờ bộ phận mới (Upsale) | Không tính lỗi quá giờ {good:Không lỗi} |
| Quá tải · Nghỉ/đột xuất | Không bắt buộc | Spec không nói rõ |
| Khác | Bắt buộc | Spec không nói rõ |

Cờ ⚑ Khó tư vấn nổi bật ở mọi danh sách và lọc được. Nhiều lần nhả thì lưu đủ ghi chú theo thứ tự. Người phụ trách hoặc Trưởng nhóm gỡ cờ khi xong (giữ ghi chú cũ), hoặc đánh dấu + ghi chú mà không cần nhả.

## Các màn hình và trường dữ liệu {#man-hinh}

| Màn | Tên | Ai dùng | Điểm chính |
| --- | --- | --- | --- |
| Màn 3 | Lead của tôi | Sale / WFCĐ / CSKH | Một tab Của tôi; dải 6 thẻ; lưới Khách · Trạng thái tiếp nhận + SLA · Chốt đơn · Tư vấn · Chờ · ⚑ · Thao tác (Mở chat · Tôi nhả · Đổi tag). Rỗng: “Bạn chưa giữ lead nào” |
| Màn 4 | Thông báo (chuông + toast) | Mọi vai trò | Huy hiệu ẩn khi 0, “9+” khi lớn hơn 9 (đề xuất); danh sách mới nhất lên đầu; Đánh dấu đã đọc; gom nhóm; N2, N4 hết hiệu lực tự đóng |
| Màn 5 | Khung làm việc với khách | Người phụ trách | 3 cột + 3 tab; Màn 6 là bản chỉ đọc |
| Màn 7 | Popup Tôi nhả | Người phụ trách | `release_reason` select bắt buộc; `note` textarea tối đa 500 ký tự, bắt buộc khi Khó tư vấn / Khác |
| Màn 8 | Popup Bàn giao bộ phận | Chỉ người phụ trách | `current_tag` chỉ xem; `new_tag` radio bắt buộc; `referral_code` (chỉ Sale); `issue_note` (chỉ CSKH); `note` tối đa 500 ký tự, bắt buộc khi sang Support kỹ thuật |

Màn 8 hiện hệ quả trước khi xác nhận: “Lead sẽ tự nhả khỏi bạn và chia cho bộ phận; bạn không còn nhắn được.” Màn 7 cảnh báo: “Lead về Hàng chờ, gắn cờ Khó tư vấn; bạn không nhắn được; Trưởng nhóm và NV phù hợp sẽ được thông báo.”[](source:spec)

## QA cần kiểm gì? {#kiem-tra}

- [ ] Người không phụ trách mở hội thoại: xem được nội dung, tab Thông tin và Đơn hàng; không gửi tin, không thấy Đổi tag, Tạo đơn và Gửi thanh toán bị khóa (AC 1, 14, 41).
- [ ] Lead Chờ nhận: banner Chờ nhận; Trưởng nhóm thấy Chia, nhân viên không có nút nhận (AC 5, 28).
- [ ] Ngoài cửa sổ nhắn tin: ô nhập khóa và có cảnh báo (AC 4).
- [ ] Ghi chú Khó tư vấn của người nhả hiện đầu khung chat người nhận (AC 2).
- [ ] Mã giới thiệu hợp lệ tự gắn CSKH, lead nhả khỏi Sale và chia cho NV Upsale (AC 6).
- [ ] Sale gắn WFCĐ hoặc CSKH: lead nhả khỏi Sale, chia đúng bộ phận, lịch sử ghi Bàn giao (AC 7, 8).
- [ ] Sự kiện `order.delivered` của đơn Sale chuyển khách sang CSKH, Đang sử dụng (AC 10).
- [ ] Kiểm tra hằng ngày tự gắn CSKH Upsale khi đến ngày hẹn hoặc SIM còn N ngày (AC 11, 12).
- [ ] Chế độ gợi ý không đổi tag; Hoàn tác đưa tag và người phụ trách về giá trị trước (AC 16, 17).
- [ ] Sang Support kỹ thuật với Ghi chú bàn giao trống thì báo lỗi, chưa chuyển (AC 18, 46).
- [ ] Tag đổi trên Pancake không đổi tag CRM, có log bỏ qua (AC 19).
- [ ] N1 khi giao, N2 còn 1 phút, N3 khi quá 5 phút cho NV và Trưởng nhóm (AC 20, 21).
- [ ] NV hết ca không nhận thông báo, trừ N3 và N7; 5 lead vào hàng chờ cùng lúc chỉ tạo 1 thông báo gom cho Trưởng nhóm (AC 23, 24).
- [ ] Dải thẻ chỉ tính lead của mình, bấm thẻ lọc lưới, tự cập nhật khi có lead mới (AC 29, 30, 31).
- [ ] Tôi nhả Khó tư vấn bắt buộc ghi chú, gắn cờ ⚑, chế độ Tự động chia lại ngay và loại người nhả 1 lần (AC 32).
- [ ] Lead đã lên đơn: nút Tôi nhả bị khóa (AC 33).
- [ ] Tạo đơn đổi Trạng thái chốt đơn sang Đã lên đơn; Lưu nháp không đổi trạng thái (AC 38, 39).
- [ ] Gửi thông tin thanh toán tạo một tin đủ trường và ghi Hoạt động; NV không sửa được tài khoản (AC 37).
- [ ] Tài khoản CSKH chỉ thấy lead tag CSKH, Màn 8 không có Mã giới thiệu, panel hiện trường CSKH (AC 43, 44, 45).

@callout level=open-question title="Điểm còn mở cần chốt"
Màn 5: nội dung tin thanh toán (tài khoản cố định hay theo đơn, có QR, có ảnh); Tạo đơn đủ trường như JCN-84 hay rút gọn; NV xem đóng gói / vận chuyển mọi đơn hay chỉ đơn mình tạo; tab Nhân viên ở cột trái dùng để làm gì.
Khác: #1 nhiều tag · #3 WFCĐ lắp đặt xong · #9 chuyển ngược về Sale · #13 cửa sổ nhắn tin · #56 tag CRM chuẩn hay 2 chiều · #57 tag chưa ánh xạ · #34 giới hạn số lần nhả · N ngày hạn SIM.
