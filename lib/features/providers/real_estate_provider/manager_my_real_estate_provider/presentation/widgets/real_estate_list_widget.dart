import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'real_estate_card_widget.dart';

class RealEstateListWidget extends StatelessWidget {
  final bool isAvailable;

  const RealEstateListWidget({super.key, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
      itemBuilder: (context, index) {
        return RealEstateCardWidget(
          isAvailable: isAvailable,
          imageUrl: "https://i.imgur.com/O8QqY9G.jpeg",
          title: "فيلا للبيع",
          location: "حي العزيزية، مدينة الرياض، منطقة الرياض",
          area: "651 م²",
          rooms: "7",
          age: "10 سنوات",
          baths: "2",
          direction: "شمال غربي",
          commission: "2.5%",
          price: "450000 ريال سعودي",
          features: const [
            "الفيلا مؤثثة",
            "الفيلا يوجد معها مسبح",
            "مطبخ راكب بالكامل",
            "مدخل سيارات خاص",
          ],
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: ManagerHeight.h16),
      itemCount: 2,
    );
  }
}
