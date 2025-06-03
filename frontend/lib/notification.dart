import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  void _showEventDetail(
    BuildContext context, {
    required String title,
    required String imagePath,
    required String detail,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 180, fit: BoxFit.contain),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEventCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String shortDescription,
    required String detailDescription,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            Text(shortDescription, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _showEventDetail(
                  context,
                  title: title,
                  imagePath: imagePath,
                  detail: detailDescription,
                ),
                child: const Text("Thông tin chi tiết"),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text("Thông Tin Sự Kiện", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  buildEventCard(
                    context,
                    imagePath: 'assets/images/fire_festival.png',
                    title: '🔥 Lễ Hội Lửa 2025',
                    shortDescription: 'Cùng tranh tài trong lễ hội lửa đầy kịch tính tại hè 2025!',
                    detailDescription:
                        'Lễ Hội Lửa 2025 sẽ chính thức quay trở lại vào 31/6/2025! Tham gia ngay để nhận phần thưởng hấp dẫn và trải nghiệm những trận đấu kịch tính!',
                  ),
                  buildEventCard(
                    context,
                    imagePath: 'assets/images/newbie.png',
                    title: '👋 Chào mừng tân thủ!',
                    shortDescription: 'Chào mừng các tân thủ đến với IQ Tranh Đấu!',
                    detailDescription:
                        'Chào mừng các tân thủ đến với IQ Tranh Đấu! Đây là nơi bạn có thể rèn luyện kỹ năng, tham gia các trận đấu hấp dẫn và nhận những phần thưởng giá trị. Hãy bắt đầu hành trình của bạn ngay hôm nay!',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
