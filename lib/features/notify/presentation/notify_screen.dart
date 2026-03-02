import 'package:btl_music_app/features/notify/presentation/widgets/notify_item.dart';
import 'package:flutter/material.dart';

class NotifyScreen extends StatelessWidget {
  const NotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        "image": "https://picsum.photos/200",
        "title": "V-Pop Hôm Nay · 1 năm",
        "desc":
            "Đếm không xuể các hot hit V-Pop tung hoành các bảng xếp hạng hiện nay",
      },
      {
        "image": "https://picsum.photos/201",
        "title": "Đường đua #zingchart 🔥 · 1 năm",
        "desc":
            "Hồ Quang Hiếu tiếp tục đỉnh nóc, kịch trần, bay phấp phới vị trí No 1",
      },
      {
        "image": "https://picsum.photos/202",
        "title": "Pop Ballad Việt Nổi Bật · 1 năm",
        "desc":
            "Đa sầu đa cảm với những sự lựa chọn hàng đầu của Pop Ballad Việt",
      },
      {
        "image": "https://picsum.photos/203",
        "title": "Cà Phê Sáng · 1 năm",
        "desc":
            "Tận hưởng sáng chủ nhật cùng những giai điệu quen thuộc nơi quán xưa",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Thông báo"),
      ),
      body: SafeArea(
        child: Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return PlaylistItem(
                image: data[index]["image"]!,
                title: data[index]["title"]!,
                description: data[index]["desc"]!,
                onTap: () {
                  // xử lý khi bấm vào
                },
              );
            },
          ),
        ),
      ),
    );
  }
}