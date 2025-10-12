import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

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
          showActions: !isAvailable,
          // 🔹 لو العقار غير متاح نعرض الأيقونات
          imageUrl: "https://i.imgur.com/O8QqY9G.jpeg",
          title: "فيلا للبيع",
          location: "حي العزيزية، مدينة الرياض، منطقة الرياض",
          area: "651 م²",
          rooms: "7",
          halls: "2",
          // 🔹 عدد الصالات
          age: "10 سنوات",
          baths: "2",
          direction: "شمالي غربي",
          purpose: "سكني",
          // 🔹 الغرض
          commission: "2.5%",
          price: "450000 دولار أمريكي",
          features: const [
            "الفيلا مؤثثة",
            "الفيلا يوجد بها حوش",
            "مطابخ مجهزة بالكامل",
            "مدخل سيارات خاص",
          ],

          /// 🔹 البيانات الإضافية في القسم المنقط
          extraInfo: const {
            "تاريخ الإضافة": "14-07-2027",
            "رقم الترخيص": "3928492389482933",
            "تاريخ انتهاء الرخصة": "14-07-2028",
            "المساحة على حسب الصك": "635 م²",
          },
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: ManagerHeight.h16),
      itemCount: 2,
    );
  }
}
