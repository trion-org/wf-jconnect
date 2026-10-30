# JCN-116.5 — Ca làm việc & Trạng thái đi làm: ai được nhận lead lúc nào? {#tong-quan}

Chỉ nhân viên ở trạng thái **🟢 Đang làm** mới được chia lead tự động. Trạng thái này do hệ thống **tự tính** từ lịch ca đã phát hành, chấm công Vào ca, trạng thái tự chọn và hoạt động trong J-Connect.

- Lịch ca có hai nguồn chạy song song: Trưởng nhóm xếp (lưới, Import Excel) và nhân viên tự đăng ký trong kỳ đăng ký.[](source:spec)
- Khi `attendance_mode` = Bấm vào/ra (mặc định), nhân viên phải bấm **Vào ca** mới được chia lead (đã chốt #51).[](source:spec)
- JCN-116.2 Rule A2 điều kiện 2 đổi thành "NV có trạng thái 🟢 Đang làm"; chia thủ công vẫn chọn được người không 🟢 nhưng có cảnh báo.[](source:spec)
- Mọi giờ ca, giờ riêng, chấm công đều theo **giờ Tokyo (UTC+9)**; sửa ca hay sửa công sau đó không đổi KPI đã ghi.[](source:spec)

@answer scope="Spec đề xuất JCN-116.5, bản 30/10/2026 · chưa tạo trên Jira · ca mẫu và chỉ tiêu chờ công ty xác nhận"
@meta locale=vi
@source spec title="JCN-116.5 — Ca làm việc & Trạng thái đi làm (bản 30/10/2026)"

## 116.5 đứng ở đâu trong luồng JCN-116? {#vi-tri}

116.5 làm sau 116.1 và **trước 116.2**, vì chia tự động cần biết ai đang đi làm.[](source:spec) Số 116.5 do bổ sung sau, không phản ánh thứ tự làm.

@workflow id=luong-vi-tri title="Từ lịch ca đến chia lead"
| lane lap | Lập lịch |
| lane di | Đi làm |
| lane chia | Chia lead (116.2) |
| ca | Danh mục ca (Màn 13) | backend | lap |
| xep | Xếp lịch (Màn 14) | backend | lap |
| ph | Phát hành lịch | backend | lap |
| vao | Đăng nhập + Vào ca | frontend | di |
| tt | Trạng thái làm việc | backend | di |
| nl | Ngoại lệ Trưởng nhóm | frontend | di |
| auto | Chia tự động | external | chia |
| tay | Popup Chia thủ công | external | chia |
| ca > xep | |
| xep > ph | |
| ph > vao | Ca của tôi |
| vao > tt | |
| nl > tt | ngay |
| tt > auto | chỉ 🟢 | emphasis |
| tt > tay | cột Hôm nay |

@steps id=vi-tri-steps
| vt-ca | Danh mục ca (Màn 13) | Quản trị / HR tạo ca: tên, giờ, nghỉ giữa ca, bộ phận, màu, trạng thái. | luong-vi-tri | ca |
| vt-xep | Xếp lịch (Màn 14) | Trưởng nhóm xếp lưới NV × ngày, hoặc NV tự đăng ký (Rule 10). | luong-vi-tri | xep |
| vt-ph | Phát hành lịch | Lịch ở Nháp đến khi Phát hành; NV nhận "Lịch ca tuần … đã cập nhật". | luong-vi-tri | ph |
| vt-vao | Đăng nhập + Vào ca | Đăng nhập là tự Online; khi bật chấm công thì phải bấm Vào ca. | luong-vi-tri | vao |
| vt-tt | Trạng thái làm việc | Tự tính theo Rule 4, phát `work_status.changed`. | luong-vi-tri | tt |
| vt-nl | Ngoại lệ Trưởng nhóm | Màn 17: Thêm vào ca hôm nay, Đánh dấu nghỉ đột xuất, Bật nhận việc ngoài ca; hiệu lực ở lần chia kế tiếp. | luong-vi-tri | nl |
| vt-auto | Chia tự động | Chỉ chọn NV 🟢 Đang làm. | luong-vi-tri | auto |
| vt-tay | Popup Chia thủ công | Cột "Hôm nay" 🟢/🟡/🟠/⚪/🔴; chọn được NV không 🟢 nhưng có cảnh báo. | luong-vi-tri | tay |

## Danh mục ca, xếp lịch và chỉnh sửa ca theo luật nào? {#lap-lich}

| Luật | Nội dung chính | Ràng buộc |
| --- | --- | --- |
| Rule 1 — Danh mục ca | Một ngày xếp được nhiều ca (ca gãy); ca có thể qua nửa đêm | Ca đã có lịch không xoá, chỉ **ngừng dùng**; sửa giờ áp từ hôm sau, ghi lịch sử |
| Rule 2 — Xếp lịch | Chọn ô → chọn ca, kéo thả nhiều ô, Sao chép tuần trước, Áp mẫu lặp, Import Excel | Trưởng nhóm xếp nhóm mình, Quản trị xếp tất cả |
| Rule 2 — Phát hành | Lịch **Nháp** đến khi Phát hành | Sửa sau phát hành ghi lịch sử và báo NV bị đổi |
| Rule 2 — Đủ người tối thiểu | Hàng cuối lưới theo khung giờ, cấu hình theo bộ phận | Thiếu người hiện cảnh báo vàng {caution:Xếp bù trước} |
| Rule 2 — Chưa xếp lịch | Dùng **ca mặc định của bộ phận** (vd Hành chính T2–T6) | Ngoại lệ trong ngày qua Rule 6 |
| Rule 2c-A — Sửa ca danh mục (Màn 13b) | Áp dụng từ ngày mai (mặc định); "Từ hôm nay" nếu có quyền | **Bắt buộc lý do**, không cần duyệt; xem trước "Ảnh hưởng n NV, m lượt ca" |
| Rule 2c-A — Ngừng dùng | Ca đang có lịch tương lai | Bắt buộc chọn ca thay thế hoặc để NV về "chưa xếp" |
| Rule 2c-B — Sửa ô lịch (Màn 14c) | Đổi ca · Thêm ca thứ hai · Chỉnh giờ riêng ⏱ · Nghỉ (bỏ ca) | Lý do bắt buộc mọi lần sửa {good:Không cần duyệt} |
| Rule 2c-C — Quyền | Trưởng nhóm: nhóm mình, từ hôm nay; Quản trị: mọi bộ phận, kể cả ngày đã qua | NV **không tự sửa ca**, chỉ gửi yêu cầu (Rule 3) |
| Rule 2c-E — Lịch sử | Ai, khi nào, cũ → mới, lý do; Hoàn tác sửa gần nhất trong 10 phút | Hai người sửa cùng ô: người lưu sau nhận "Lịch vừa được {tên} sửa lúc {giờ} — tải lại" |

Ca mẫu đề xuất, chờ công ty xác nhận: **Hành chính** 08:30–17:30 (nghỉ 12:00–13:00) · **Sáng** 07:30–12:00 · **Chiều** 13:00–21:00.[](source:spec)

@callout level=warning title="Sửa ca hôm nay có hiệu lực ngay"
Trạng thái làm việc tính lại và lần chia kế tiếp dùng ca mới. Sửa lịch tương lai chỉ có tác dụng khi tới ngày đó.
Nếu NV đang giữ lead mà bị bỏ ca: popup cảnh báo, ví dụ "Lan đang giữ 4 lead — sau khi đổi sẽ không nhận lead mới; lead đang giữ giữ nguyên". Hệ thống chỉ cảnh báo, vẫn cho lưu.
**Giờ riêng** đổi giờ vào/ra của riêng ngày đó, không tạo ca mới; trạng thái làm việc tính theo giờ riêng.

## Import Excel lịch ca đi qua những bước nào? {#import-excel}

Import nhập cả tuần/tháng cho nhiều NV bằng một file ma trận giống lưới Màn 14.[](source:spec) Dòng lỗi không được nhập; Trưởng nhóm chọn nhập phần hợp lệ hoặc huỷ để sửa file.

@workflow id=luong-import title="Import Excel lịch ca (Màn 14b)"
| lane tai | Tải |
| lane kiem | Kiểm tra |
| lane nhap | Nhập |
| mau | Tải file mẫu | frontend | tai |
| len | Tải file lên | frontend | tai |
| dd | Đúng .xlsx, ≤ 5 MB? | backend | kiem |
| loi | Báo lỗi ngay | external | kiem |
| xt | Xem trước từng dòng | backend | kiem |
| ghide | Ghi đè lịch đã phát hành? | backend | nhap |
| lydo | Nhập lý do chung | frontend | nhap |
| nhap | Nhập dòng hợp lệ | backend | nhap |
| nhap2 | Lịch Nháp | database | nhap |
| mau > len | |
| len > dd | |
| dd > loi | không | dashed |
| dd > xt | có |
| xt > ghide | |
| ghide > lydo | có |
| ghide > nhap | không |
| lydo > nhap | |
| nhap > nhap2 | | emphasis |

@steps id=import-steps
| im-mau | Tải file mẫu | File `.xlsx` 3 sheet: Lịch ca · Danh mục ca · Hướng dẫn. Điền sẵn NV của bộ phận và ngày của kỳ; có bản "kèm lịch hiện tại". | luong-import | mau |
| im-len | Tải file lên | Kéo-thả hoặc chọn file; hiện tên file và số dòng đọc được. | luong-import | len |
| im-dd | Đúng .xlsx, ≤ 5 MB? | Tối đa 500 NV × 62 ngày mỗi lần. | luong-import | dd |
| im-loi | Báo lỗi ngay | Sai định dạng hoặc quá lớn thì không thực hiện thao tác nhập nào (AC 20). | luong-import | loi |
| im-xt | Xem trước từng dòng | Thẻ Hợp lệ · Cảnh báo · Lỗi, lý do từng dòng, nút Tải file lỗi (file gốc thêm cột "Lỗi"). | luong-import | xt |
| im-gd | Ghi đè lịch đã phát hành? | Chế độ mặc định: Ghi đè các ô có trong file; hoặc Chỉ điền ô đang trống. | luong-import | ghide |
| im-ld | Nhập lý do chung | Bắt buộc khi ghi đè lịch đã phát hành; không cần ai duyệt (AC 22). | luong-import | lydo |
| im-nhap | Nhập dòng hợp lệ | Import lặp lại cùng file cho kết quả như nhau, không nhân đôi ca. | luong-import | nhap |
| im-nhap2 | Lịch Nháp | Chưa báo NV cho đến khi Phát hành; ghi lịch sử import; Hoàn tác lần import gần nhất khi chưa phát hành. | luong-import | nhap2 |

| Giá trị ô | Ý nghĩa |
| --- | --- |
| Mã ca hợp lệ (`HC`, `SANG`, `CHIEU`…) | Gán ca |
| `HC@09:00-17:00` | Gán ca kèm giờ riêng của ngày đó |
| `SANG+CHIEU` | Hai ca (ca gãy); chồng giờ thì báo lỗi |
| Để trống | Giữ nguyên, không xoá lịch cũ {good:An toàn} |
| `NGHI` | Nghỉ (bỏ ca): nghỉ đột xuất, xoá ca của ngày đó |

| Kiểm tra | Kết quả nếu sai |
| --- | --- |
| Mã NV tồn tại, đang hoạt động, thuộc phạm vi quyền | Lỗi |
| Mã ca tồn tại, đang dùng, áp dụng cho bộ phận của NV | Lỗi |
| Ngày hợp lệ; ngày đã qua chỉ Quản trị được sửa | Lỗi với Trưởng nhóm |
| Hai ca trong một ngày không chồng giờ | Lỗi |
| Mã NV trùng dòng trong file | Lỗi ở dòng sau |
| NV có nghỉ phép đã duyệt ở ngày đó | Cảnh báo, giữ nguyên nghỉ phép {caution:Không ghi đè} |

@callout level=open-question title="Ô dấu trừ hay NGHI?"
Rule 2b (cập nhật 29/10/2026) bỏ ký hiệu `-` riêng, dùng `NGHI` để bỏ ca. AC 16 vẫn mô tả ô `-` xoá ca. Cần BA cập nhật AC 16 cho khớp.
Định dạng file (ma trận hay danh sách, #44) và cách xử lý dòng lỗi (#45) vẫn là điểm cần chốt; đề xuất hiện tại là ma trận và nhập phần hợp lệ.

## Nhân viên xin đổi ca, xin nghỉ và được duyệt thế nào? {#xin-doi-nghi}

NV gửi yêu cầu ở Màn 15; Trưởng nhóm **Duyệt / Từ chối** ở tab "Yêu cầu" của Màn 14. Duyệt xong lịch tự cập nhật và hai bên nhận thông báo.[](source:spec)

@steps id=yeu-cau-steps
| yc-gui | NV gửi yêu cầu | Đổi ca với đồng nghiệp, nghỉ cả ngày, nửa ngày sáng hoặc nửa ngày chiều; kèm lý do bắt buộc. |
| yc-kiem | Hệ thống kiểm tra | Không chọn ngày đã qua; đổi ca báo lỗi nếu chồng giờ hoặc làm bộ phận thiếu người tối thiểu. Xin nghỉ trùng ngày người khác hoặc thiếu người chỉ cảnh báo, vẫn cho gửi. |
| yc-duyet | Trưởng nhóm duyệt | Duyệt hoặc Từ chối; Từ chối thì ghi chú của người duyệt là bắt buộc. |
| yc-capnhat | Lịch tự cập nhật | Phát `leave.approved` khi duyệt nghỉ; ngày nghỉ phép NV ở 🔴 và không được chia lead. |
| yc-huy | Huỷ yêu cầu | NV huỷ được khi yêu cầu còn Chờ duyệt. |

| Popup | Trường đáng chú ý |
| --- | --- |
| Xin nghỉ | "Đến ngày" chỉ hiện khi nghỉ cả ngày (nghỉ nhiều ngày liên tiếp); ca bị ảnh hưởng tự lấy từ lịch |
| Xin đổi ca | "Đổi cùng" chỉ hiện đồng nghiệp **cùng bộ phận** có lịch ngày đó; xem trước ca mới của hai bên |
| Chi tiết yêu cầu | Loại · ngày · ca · người đổi cùng · lý do · trạng thái · người duyệt · nhật ký |

Nếu công ty đã có module nhân sự quản lý nghỉ phép, 116.5 lấy dữ liệu từ đó để không nhập hai nơi; đây là điểm 🔴 #36 cần chốt.[](source:spec)

## Trạng thái làm việc được tính theo thứ tự nào? {#trang-thai}

Hệ thống xét lần lượt từ trên xuống; điều kiện đầu tiên khớp quyết định trạng thái.[](source:spec) Nhân viên không cần bấm "Bắt đầu ca"; hoạt động là nhấp, gõ, mở hội thoại, gửi tín hiệu khoảng mỗi 60 giây khi tab đang dùng.

@workflow id=thu-tu-trang-thai title="Thứ tự tính trạng thái làm việc (Rule 4)"
| q1 | Nghỉ phép đã duyệt? | backend |
| s-np | Nghỉ phép | database |
| q2 | Đã vào ca? | backend |
| s-cv | Chưa vào ca / Hết ca | database |
| q3 | Chọn trạng thái bận? | backend |
| s-tn | Tạm nghỉ | database |
| q4 | Trong khung ca? | backend |
| s-nc | Ngoài ca | database |
| q5 | Có thao tác gần đây? | backend |
| s-vg | Vắng | database |
| s-dl | Đang làm | frontend |
| q1 > s-np | có |
| q1 > q2 | không |
| q2 > s-cv | chưa |
| q2 > q3 | rồi |
| q3 > s-tn | có |
| q3 > q4 | không |
| q4 > s-nc | không |
| q4 > q5 | có |
| q5 > s-vg | không |
| q5 > s-dl | có | emphasis |

@steps id=trang-thai-steps
| tt-q1 | Nghỉ phép đã duyệt? | Có yêu cầu nghỉ đã duyệt thì 🔴 Nghỉ phép, không chia lead. | thu-tu-trang-thai | q1 |
| tt-q2 | Đã vào ca? | Khi bật chấm công: chưa bấm Vào ca thì "⚪ Chưa vào ca"; đã Ra ca hoặc chọn Hết ca thì ⚪. | thu-tu-trang-thai | q2 |
| tt-q3 | Chọn trạng thái bận? | Đang tiếp khách · Ăn trưa · Đi vệ sinh · Tạm nghỉ 15/30/60 phút hoặc "Đến khi tôi quay lại" → 🟡. | thu-tu-trang-thai | q3 |
| tt-q4 | Trong khung ca? | Có dung sai vào sớm / trễ (`shift_early_minutes` 15, `shift_late_minutes` 0); dùng giờ riêng nếu có. Ngoài khung → ⚪ Ngoài ca. | thu-tu-trang-thai | q4 |
| tt-q5 | Có thao tác gần đây? | Không thao tác quá `idle_minutes` (mặc định 10 phút) → 🟠 Vắng; thao tác lại tự về 🟢. | thu-tu-trang-thai | q5 |
| tt-dl | Đang làm | 🟢 duy nhất được chia lead tự động. | thu-tu-trang-thai | s-dl |

| Trạng thái | Điều kiện | Được chia lead? |
| --- | --- | --- |
| 🟢 Đang làm | Trong ca, đã đăng nhập (và Vào ca nếu bật chấm công), có hoạt động trong `idle_minutes` | Có {good:Ứng viên} |
| 🟡 Tạm nghỉ | NV bấm Tạm nghỉ hoặc chọn trạng thái bận | Không |
| 🟠 Vắng | Trong ca nhưng không thao tác quá `idle_minutes`; đóng tab / đăng xuất cũng thành Vắng sau ngưỡng | Không, tự về 🟢 khi thao tác lại |
| ⚪ Ngoài ca | Không có ca hoặc đã hết ca | Không, trừ khi bật "Nhận việc ngoài ca" |
| 🔴 Nghỉ phép | Có yêu cầu nghỉ đã duyệt | Không |

| Ngoại lệ Trưởng nhóm (Rule 6, Màn 17) | Tác dụng |
| --- | --- |
| Thêm vào ca hôm nay | Làm bù, thay người; NV thành ứng viên ở lần chia kế tiếp |
| Đánh dấu nghỉ đột xuất | NV không được chia lead |
| Bật nhận việc ngoài ca | NV ⚪ vẫn được chia lead |

Tạm nghỉ hết giờ thì tự về Online khi NV thao tác, kèm nhắc "Bạn đã tạm nghỉ quá thời gian". Số lần và thời gian tạm nghỉ được ghi để Trưởng nhóm xem, không dùng tính lỗi.[](source:spec)

## Trạng thái ảnh hưởng chia lead, giờ Tokyo và bàn giao ca ra sao? {#chia-lead}

| Tình huống | Hành vi |
| --- | --- |
| Chia tự động (116.2 Rule A2) | Điều kiện 2 = NV có trạng thái 🟢 Đang làm |
| Popup Chia thủ công | Cột "Hôm nay"; NV không 🟢 vẫn chọn được, có cảnh báo {caution:Cảnh báo} |
| Dashboard tồn đọng | Lọc được theo ca |
| NV chuyển Vắng / Tạm nghỉ / Ngoài ca | Lead **chưa trả lời** tự nhả theo SLA (116.2); lead **đang tư vấn** giữ nguyên, báo Trưởng nhóm khi vắng quá ngưỡng |
| NV hết ca | Lead chưa trả lời tự nhả theo SLA, không tính lỗi nếu giao trong `ca_grace_minutes` cuối ca; lead đang tư vấn quá `handover_wait_minutes` thì Trưởng nhóm được cảnh báo, có thể Lấy lại / Chia lại |
| NV chủ động bàn giao ca | Tôi nhả với lý do "Hết ca / bàn giao ca" kèm ghi chú; lead về hàng chờ cho ca sau, không tính lỗi |
| Sự kiện KPI | Lưu **ca tại thời điểm xảy ra**; sửa ca / giờ riêng sau đó không đổi KPI đã ghi |

@facts
| Múi giờ | Giờ Tokyo (UTC+9) cho giờ ca, giờ riêng, trạng thái và chấm công |
| Ngày làm | 00:00–24:00 giờ Tokyo |
| Hiển thị | Trình duyệt đặt múi giờ khác vẫn thấy giờ Tokyo (AC 35) |
| Đối soát | `presence_log` lưu đăng nhập, online, tạm nghỉ, vắng, hết ca; xuất giờ online thực tế so với ca |

## Nhân viên tự đăng ký ca và chấm công thế nào? {#tu-dang-ky}

Cập nhật 30/10/2026: mỗi bộ phận chọn `shift_mode` là Trưởng nhóm xếp (mặc định), Nhân viên tự đăng ký hoặc Kết hợp; mọi bộ phận đều được dùng tự đăng ký (đã chốt #48).[](source:spec)

@workflow id=luong-dang-ky title="Kỳ đăng ký ca và chấm công (Rule 10)"
| lane dk | Đăng ký |
| lane chot | Chốt kỳ |
| lane cong | Chấm công |
| mo | Mở kỳ tuần sau | frontend | dk |
| chon | NV chọn ô, Gửi | frontend | dk |
| cho | Còn chỗ? | backend | dk |
| ds | Danh sách chờ | database | dk |
| du | Đủ người tối thiểu? | backend | chot |
| bu | Điền bù | frontend | chot |
| ph2 | Phát hành lịch | backend | chot |
| vao2 | Vào ca 1 chạm | frontend | cong |
| ra | Ra ca | frontend | cong |
| mo > chon | |
| chon > cho | |
| cho > ds | hết |
| cho > du | còn |
| du > ph2 | đủ | emphasis |
| du > bu | thiếu |
| bu > ph2 | xác nhận |
| ph2 > vao2 | |
| vao2 > ra | |

@steps id=dang-ky-steps
| dk-mo | Mở kỳ tuần sau | Sao chép cấu hình kỳ trước; báo "Mở đăng ký ca tuần …". Có thể bật `register_auto_open`. | luong-dang-ky | mo |
| dk-chon | NV chọn ô, Gửi | Màn 15d: ô hiện số chỗ còn ("3/5"), chọn nhiều ô rồi Gửi một lần; có Dùng lại tuần trước. Lỗi chồng giờ, vượt tối đa, ngày nghỉ phép hiện ngay trên ô. | luong-dang-ky | chon |
| dk-cho | Còn chỗ? | `register_approval` = Tự duyệt: còn chỗ thì nhận ngay, ai gửi trước được trước. Chế độ Trưởng nhóm duyệt: duyệt hàng loạt 1 chạm. | luong-dang-ky | cho |
| dk-ds | Danh sách chờ | Có người hủy thì người đầu danh sách chờ được nhận và được báo. | luong-dang-ky | ds |
| dk-du | Đủ người tối thiểu? | Đến hạn chốt (mặc định 18:00 thứ Năm tuần trước, giờ Tokyo) thì khoá; NV thiếu ca được nhắc 24 giờ và 2 giờ trước hạn. | luong-dang-ky | du |
| dk-bu | Điền bù | Gợi ý NV chưa đủ ca hoặc ca nền của bộ phận; Trưởng nhóm chỉ xác nhận. | luong-dang-ky | bu |
| dk-ph | Phát hành lịch | Sau phát hành lịch đi theo Rule 2 / 2c; NV đổi ca phải dùng Xin đổi ca. | luong-dang-ky | ph2 |
| dk-vao | Vào ca 1 chạm | Nút nổi trong cửa sổ vào ca (từ `shift_early_minutes` trước đến `checkin_late_window` sau giờ bắt đầu); giờ do máy chủ ghi theo Tokyo. | luong-dang-ky | vao2 |
| dk-ra | Ra ca | Còn lead đang tư vấn thì nhắc bàn giao ca trước; ra ca chuyển ⚪ Hết ca. | luong-dang-ky | ra |

| Tham số | Mặc định | Ý nghĩa |
| --- | --- | --- |
| `register_min_shifts` · `register_max_shifts` | 5 / 6 | Số ca tối thiểu / tối đa mỗi NV trong kỳ |
| `checkin_late_window` | 60 phút | Cửa sổ vào ca sau giờ bắt đầu |
| `late_grace_minutes` | 5 phút | Vào sau giờ bắt đầu + 5 phút là Đi trễ |
| `checkin_remind_minutes` · `checkin_alert_minutes` | 10 / 30 phút | Nhắc NV / báo Trưởng nhóm khi chưa vào ca |
| `auto_checkout_minutes` | 30 phút | Quên ra ca: tự ra ca tại giờ hết ca, nhãn "Tự đóng" |
| `attendance_mode` | Bấm vào/ra | Tắt · Tự ghi · Bấm vào/ra |

| Kết quả ca | Khi nào |
| --- | --- |
| Đúng giờ | Vào trong dung sai |
| Đi trễ n phút | Ví dụ AC 46: ca 08:30, vào 08:48 → trễ 18 phút |
| Về sớm n phút | Ra ca trước giờ hết ca |
| Tự đóng | Quên ra ca quá `auto_checkout_minutes` |
| Không chấm công | Có lịch nhưng không vào; đánh dấu cuối ca {bad:Cần đối soát} |
| Nghỉ phép | Có nghỉ phép đã duyệt; không bị tính vắng |

Quên vào ca nhưng có làm việc thì NV gửi **Xin bổ sung công** (Màn 15f), Trưởng nhóm duyệt 1 chạm ở Màn 14d. Thời gian làm thực tế = giờ ra − giờ vào − tổng tạm nghỉ, chỉ để báo cáo; chấm công **không tính lương** ở bản đầu.[](source:spec)

@callout level=open-question title="Cột số ca tối thiểu–tối đa"
Wireframe bỏ cột "Số ca tối thiểu–tối đa" khỏi bảng cấu hình theo bộ phận ở Màn 14d. Nếu giữ thì chỉ đặt theo kỳ đăng ký (Sửa chỉ tiêu). Cần chốt với BA.

## Màn hình, dữ liệu và sự kiện nào cần làm? {#man-hinh}

| Màn | Tên | Ai dùng | Nội dung chính |
| --- | --- | --- | --- |
| 13 | Danh mục ca | Quản trị / HR | Tạo ca: tên (≤ 50 ký tự, không trùng), giờ, nghỉ giữa ca, bộ phận, màu, Đang dùng |
| 13b | Sửa ca (danh mục) | Quản trị / Trưởng nhóm có quyền | Áp dụng từ ngày, Lý do thay đổi bắt buộc, Xem trước ảnh hưởng |
| 14 | Xếp lịch ca & Duyệt yêu cầu | Trưởng nhóm / Quản trị | Lưới NV × ngày, Sao chép tuần trước, Áp mẫu lặp, Phát hành; tab Yêu cầu, Lịch sử import, Đăng ký ca |
| 14b | Import Excel lịch ca | Trưởng nhóm / Quản trị | 3 bước: Tải mẫu → Tải file lên → Xem trước & Nhập |
| 14c | Sửa ca của nhân viên | Trưởng nhóm / Quản trị | Popup từ ô lịch: 4 thao tác, phạm vi áp dụng, lý do, thông báo NV |
| 14d | Kỳ đăng ký & Bảng chấm công | Trưởng nhóm | Bảng chấm công lọc ngày/tuần/tháng, Sửa công (lý do), Duyệt bổ sung công, Xuất Excel; tab Cấu hình theo bộ phận |
| 15 | Ca của tôi | NV | Lịch tuần/tháng, Xin đổi ca, Xin nghỉ, Yêu cầu của tôi |
| 15d | Đăng ký ca | NV | Lưới ngày × ca có số chỗ còn, thanh tiến độ, Gửi đăng ký |
| 15e | Công của tôi | NV | Lịch tháng với giờ vào/ra, kết quả, tổng kết tháng |
| 15f | Xin bổ sung công | NV | Popup: ngày, giờ vào thực tế, lý do |
| 16 | Thanh trạng thái làm việc | NV (mọi màn) | Ca hiện tại, badge trạng thái, Tạm nghỉ, Vào ca / Ra ca |
| 17 | Tài khoản & Ai đang đi làm hôm nay | Quản trị / Trưởng nhóm | Cột Trạng thái làm việc, Hoạt động gần nhất, bộ lọc; "Hôm nay: n/tổng đang làm", nút ngoại lệ |

| Sự kiện | Khi nào | Người nghe |
| --- | --- | --- |
| `work_status.changed` | Trạng thái đổi (Online / Tạm nghỉ / Vắng / Ngoài ca / Nghỉ phép) | JCN-116.2: danh sách ứng viên, cảnh báo NV vắng khi đang giữ lead |
| `shift.published` | Phát hành / sửa lịch | Thông báo NV (khung JCN-116.2) |
| `leave.approved` | Duyệt nghỉ | Cập nhật lịch, thông báo NV |

Bảng dữ liệu: `shift`, `shift_assignment` (Nháp/Phát hành), `leave_request`, `presence_log`, `work_status`, `shift_registration_period`, `shift_registration`, `attendance` (nguồn: bấm / tự đóng / bổ sung), `shift_exception`, `shift_import_log`.[](source:spec)

## QA cần kiểm những tiêu chí nào? {#kiem-thu}

- [ ] AC 2: chọn nhiều ô T2–T6, gán Hành chính một thao tác, Phát hành → NV nhận "Lịch ca đã cập nhật".
- [ ] AC 4: tối thiểu 3 người mà khung chỉ có 2 Sale → hàng "Đủ người tối thiểu" hiện cảnh báo vàng.
- [ ] AC 5–8: 🟢 khi trong ca và có thao tác; Tạm nghỉ 30 phút → 🟡; 10 phút không thao tác → 🟠; hết ca → ⚪ trừ khi bật Nhận việc ngoài ca.
- [ ] AC 9: duyệt nghỉ ngày mai → ngày mai NV ở 🔴 và không được chia lead.
- [ ] AC 12: NV Vắng quá ngưỡng khi giữ lead → Trưởng nhóm nhận cảnh báo; lead chưa trả lời tự nhả theo SLA 5 phút.
- [ ] AC 14–15: Xem trước hiện hợp lệ / cảnh báo / lỗi; dòng lỗi không được nhập; Tải file lỗi có cột "Lỗi".
- [ ] AC 17: nghỉ phép đã duyệt không bị file import ghi đè, chỉ cảnh báo.
- [ ] AC 19: nhập lại cùng file cho kết quả giống lần đầu; Hoàn tác đưa lịch về trước khi import.
- [ ] AC 22: ghi đè lịch đã phát hành mà thiếu lý do chung → không nhập được.
- [ ] AC 24, 26: sửa ca (danh mục hoặc ô lịch) thiếu lý do → không lưu được; có lý do → áp dụng ngay, không cần duyệt.
- [ ] AC 27: giờ riêng 09:00–12:00 → lưới hiện ⏱, trước 09:00 NV chưa 🟢.
- [ ] AC 31: Nghỉ (bỏ ca) NV đang giữ 4 lead → cảnh báo trước khi lưu; sau lưu NV ⚪, lead giữ nguyên, Trưởng nhóm được báo.
- [ ] AC 33: hai Trưởng nhóm sửa cùng ô → người lưu sau nhận "tải lại", không ghi đè; Hoàn tác trong 10 phút.
- [ ] AC 35, 37: giờ hiển thị luôn là Tokyo; sửa ca không đổi KPI đã ghi.
- [ ] AC 39–41: gửi 5 ô một lần ở chế độ Tự duyệt; ô đầy vào danh sách chờ; chồng giờ / nghỉ phép báo lỗi ngay trên ô.
- [ ] AC 43: chốt kỳ phát hành khung đủ người, khung thiếu → cảnh báo và Điền bù.
- [ ] AC 45: trước khi bấm Vào ca, NV hiện "⚪ Chưa vào ca" và không được chia lead.
- [ ] AC 46: vào 08:48 cho ca 08:30 với dung sai 5 phút → "Đi trễ 18 phút".
- [ ] AC 48: ca hết 17:30, không Ra ca → 18:00 ghi giờ ra 17:30 nhãn "Tự đóng".
- [ ] AC 49–51: bổ sung công bị từ chối thì vẫn "Không chấm công"; sửa công cần lý do; nghỉ phép không thành "Không chấm công".
- [ ] AC 52: Xuất Excel đúng các dòng đã lọc, giờ Tokyo, có cột kết quả và nguồn.

@callout level=open-question title="Điểm còn mở ảnh hưởng triển khai"
#36 🔴 nguồn chấm công / lịch ca / nghỉ phép sẵn có · #37 danh sách ca thật · #42 số người tối thiểu mỗi khung giờ (chờ Nguyệt) · #49 hạn chốt và 5–6 ca/tuần · #50 tranh chấp chỗ · #52 nối chấm công sang tính lương.
