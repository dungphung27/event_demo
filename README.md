# event-demo

Demo Flutter web minh họa **sự kiện và tương tác người dùng trong giao diện**, thuộc môn **Lập trình Đa nền tảng** (Báo cáo Tuần, Chủ đề 7: Sự kiện và tương tác người dùng trong giao diện).

- Trường Đại học Bách Khoa, Khoa Điện tử và Trí tuệ nhân tạo
- Nhóm thực hiện: Phùng Đức Dũng, Phan Văn Đức Hiếu

## 1. Mô tả dự án

Ứng dụng **Danh sách công việc** nhỏ. Người dùng nhập việc, bấm Thêm, bấm vào dòng để đánh dấu xong, vuốt để xóa, bấm đúp để dọn các việc đã xong. Bên dưới có khung **Sự kiện vừa nhận**: mỗi lần người dùng thao tác, khung này ghi lại sự kiện nào vừa được tiếp nhận (`onPressed`, `onTap`, `onDismissed`, `onDoubleTap`) và kết quả đã đổi (state mới). Thanh **State** phía trên cho thấy số việc và số việc đã xong, nên nhìn thấy ngay giao diện phản ánh state.

Mục tiêu theo yêu cầu bài tập:

- Tạo một luồng tương tác phù hợp: nhập việc → thêm → tick xong → xóa.
- Minh họa sự kiện được tiếp nhận: khung Sự kiện vừa nhận ghi tên callback mỗi lần thao tác.
- Minh họa kết quả được phản ánh trên giao diện: danh sách, dòng gạch ngang, thanh State và nút Thêm đổi theo dữ liệu.

### Luồng tương tác

| Thao tác của người dùng | Callback nhận sự kiện | State đổi | Giao diện phản ánh |
|---|---|---|---|
| Gõ chữ vào ô nhập | `onChanged` của `TextField` | `canAdd` thành `true` | Nút Thêm hết bị xám |
| Bấm Thêm (hoặc nhấn Enter) | `onPressed`, `onSubmitted` | Thêm một `Task` vào `tasks` | Dòng mới hiện ra, ô nhập được xóa, số việc tăng |
| Bấm vào một dòng | `onTap` của `InkWell` | `task.done` đảo giá trị | Icon đổi thành dấu tick, chữ gạch ngang, số "đã xong" tăng |
| Vuốt một dòng sang bên | `onDismissed` của `Dismissible` | Xóa `Task` khỏi `tasks` | Dòng biến mất, số việc giảm |
| Bấm đúp thanh State | `onDoubleTap` của `GestureDetector` | Xóa các `Task` có `done` | Các dòng đã xong biến mất |

### Widget sử dụng

| Widget | Vai trò trong demo |
|---|---|
| `FilledButton` + `onPressed` | Nút Thêm. `onPressed` bằng `null` khi ô nhập trống nên nút bị vô hiệu hóa |
| `TextField` + `onChanged`, `onSubmitted` | Nhận chữ người dùng gõ và phím Enter |
| `InkWell` + `onTap` | Mỗi dòng việc bấm được, có hiệu ứng ripple |
| `GestureDetector` + `onDoubleTap` | Thanh State nhận cử chỉ bấm đúp |
| `Dismissible` + `onDismissed` | Vuốt để xóa một dòng |
| `StatefulWidget` + `setState` | `HomeScreen` giữ `tasks` và `log`, `AddBar` giữ `canAdd` |
| `StatelessWidget` | `TaskTile`, `EventLog`: chỉ hiển thị dữ liệu được truyền vào |

### Công nghệ

| Công nghệ | Vai trò |
|---|---|
| Flutter web (chạy trên Chrome) | Xây dựng giao diện |
| Material (`material.dart`) | Scaffold, Card, FilledButton, TextField, InkWell, Dismissible |

Demo không dùng package ngoài.

## 2. Cấu trúc chương trình

```
lib/
├── main.dart
├── task.dart
├── home_screen.dart
├── add_bar.dart
├── task_tile.dart
└── event_log.dart
```

| File | Lớp | Loại | Nhiệm vụ |
|---|---|---|---|
| `main.dart` | `MyApp` | Stateless | Khởi động app, mở `HomeScreen` |
| `task.dart` | `Task` | Dữ liệu | Một việc: `title` và `done` |
| `home_screen.dart` | `HomeScreen` | Stateful | Giữ state (`tasks`, `log`), nhận sự kiện từ các widget con và gọi `setState` |
| `add_bar.dart` | `AddBar` | Stateful | Ô nhập và nút Thêm, giữ `canAdd`, báo việc mới lên cha qua callback `onAdd` |
| `task_tile.dart` | `TaskTile` | Stateless | Một dòng việc, báo sự kiện lên cha qua callback `onTap` |
| `event_log.dart` | `EventLog` | Stateless | Hiện danh sách sự kiện vừa nhận |

Nguyên tắc **dữ liệu đi xuống, sự kiện đi lên**: `HomeScreen` giữ state và truyền xuống `TaskTile`, `EventLog`. Widget con không tự đổi dữ liệu, chỉ gọi callback (`onTap`, `onAdd`) để báo lên.

## 3. Hướng dẫn cài đặt và chạy

### Yêu cầu

- [Flutter SDK](https://docs.flutter.dev/get-started/install) đã cài và chạy được lệnh `flutter doctor`
- Trình duyệt Google Chrome

### Các bước

Nếu đã có repo của nhóm:

```bash
git clone <đường-dẫn-repo-của-nhóm>
cd <tên-thư-mục-repo>
flutter pub get
flutter run -d chrome
```

Nếu chỉ có thư mục `lib`, tạo project mới rồi chép vào:

```bash
flutter create event_demo --platforms=web
cd event_demo
```

Xóa thư mục `lib` cũ, chép thư mục `lib` của demo vào, rồi chạy:

```bash
flutter run -d chrome
```

### Cách demo

1. Mở app: có sẵn 3 việc, thanh State ghi "3 việc, đã xong 0", nút Thêm đang bị xám.
2. Gõ một việc vào ô nhập: nút Thêm hết xám (sự kiện `onChanged`).
3. Bấm Thêm: việc mới hiện cuối danh sách, khung nhật ký ghi `onPressed → thêm ...`.
4. Bấm vào một dòng: icon thành dấu tick xanh, chữ gạch ngang, nhật ký ghi `onTap → ... done = true`, thanh State tăng số đã xong.
5. Vuốt một dòng sang trái hoặc phải: dòng biến mất, nhật ký ghi `onDismissed`.
6. Bấm đúp thanh State: các việc đã xong biến mất, nhật ký ghi `onDoubleTap`.
7. Xóa hết việc để thấy dòng "Danh sách trống".

## 4. Phân công công việc

| Thành viên | Phần việc |
|---|---|
| **Phùng Đức Dũng** | Phần nhập liệu và danh sách: `add_bar.dart`, `task_tile.dart`, `task.dart`. Phần lý thuyết: callback, `onPressed`, `onTap`, `GestureDetector`, `InkWell` |
| **Phan Văn Đức Hiếu** | Phần state và phản hồi: `main.dart`, `home_screen.dart`, `event_log.dart`. Phần lý thuyết: phân biệt sự kiện với state, `setState`, cập nhật giao diện |
| **Cả hai** | Thiết kế luồng tương tác, chạy thử và chụp ảnh kết quả, làm slide thuyết trình, viết README, đẩy code lên GitHub |

> Bảng này là đề xuất phân chia. Có thể chỉnh lại cho đúng với phần mỗi bạn thực tế đã làm.

## 5. Kết quả dự án

Đối chiếu với yêu cầu của bài tập:

| Yêu cầu | Kết quả |
|---|---|
| Tạo một luồng tương tác phù hợp | Luồng nhập việc, thêm, tick xong, xóa, dọn. Có 5 loại sự kiện: `onChanged`, `onPressed`, `onTap`, `onDismissed`, `onDoubleTap` |
| Minh họa sự kiện được tiếp nhận | Khung **Sự kiện vừa nhận** ghi tên callback mỗi lần thao tác |
| Minh họa kết quả phản ánh trên giao diện | Danh sách, dấu tick, chữ gạch ngang, thanh State và trạng thái nút Thêm đổi ngay sau `setState` |
| Phân biệt sự kiện với nơi lưu state | Sự kiện chỉ ghi vào nhật ký rồi biến mất. Dữ liệu còn lại nằm trong `tasks` của `HomeScreen` |

### Ảnh chụp màn hình

Thêm ảnh chụp sau khi chạy app vào thư mục `screenshots/`:

| Trạng thái đầu | Sau khi tick và thêm việc | Sau khi dọn |
|---|---|---|
| ![Đầu](screenshots/dau.png) | ![Tick](screenshots/tick.png) | ![Dọn](screenshots/don.png) |

### Điều rút ra

- Mỗi widget nhận một loại sự kiện qua callback riêng, nên đọc code là biết thao tác nào gây ra việc gì.
- Sự kiện chỉ là khoảnh khắc. Dữ liệu cần giữ (`tasks`) phải nằm trong State, giao diện được vẽ lại từ dữ liệu đó.
- Widget con (`TaskTile`) chỉ báo sự kiện lên, widget cha (`HomeScreen`) quyết định đổi state, nên `TaskTile` dùng lại được ở chỗ khác.

### Hạn chế và hướng phát triển

- Dữ liệu chưa được lưu, tắt app là mất.
- Có thể thêm sửa tên việc bằng `onLongPress`.
- Có thể dùng `Provider` hoặc MVVM (Chủ đề 4) khi nhiều màn hình cùng dùng danh sách.

## 6. Tài liệu tham khảo

- [Flutter - Add interactivity to your Flutter app](https://docs.flutter.dev/ui/interactivity)
- [Flutter - Handling taps](https://docs.flutter.dev/cookbook/gestures/handling-taps)
- [Flutter - Add Material touch ripples](https://docs.flutter.dev/cookbook/gestures/ripples)
- [Flutter - Implement swipe to dismiss](https://docs.flutter.dev/cookbook/gestures/dismissible)
- [Flutter - Ephemeral state versus app state](https://docs.flutter.dev/data-and-backend/state-mgmt/ephemeral-vs-app)
