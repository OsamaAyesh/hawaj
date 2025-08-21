import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/custom_header_subscription_widget.dart';

class SubscriptionOfferProviderScreen extends StatelessWidget {
  const SubscriptionOfferProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ManagerColors.primaryColor,
        appBar: CustomHeader(
          title: "اشترك الآن", // النص في منتصف الشاشة
          onBack: () {
            Navigator.pop(context); // أو أي أكشن آخر
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ===== Title & Description =====
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: const [
              //       // Title
              //       Text(
              //         "اشترك الآن",
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       SizedBox(height: 12),
              //       // Subtitle
              //       Text(
              //         "انشر عروضك اليومية الآن مع حواج!\n"
              //             "اشترك بخطتك المناسبة وابدأ بنشر عروضك بطريقة ذكية واحترافية.\n"
              //             "ووصلها للعملاء القريبين منك بخريطة تفاعلية.",
              //         style: TextStyle(
              //           color: Colors.white70,
              //           fontSize: 14,
              //           height: 1.5,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
        
              const SizedBox(height: 20),
              //
              // // ===== Plan Card =====
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 16),
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       // Plan Title
              //       const Text(
              //         "الخطة الرائجة",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 18,
              //           color: Colors.black,
              //         ),
              //       ),
              //       const SizedBox(height: 10),
              //
              //       // Plan Name
              //       const Text(
              //         "Super",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20,
              //           color: Colors.deepPurple,
              //         ),
              //       ),
              //       const SizedBox(height: 5),
              //
              //       // Price
              //       const Text(
              //         "59.99 ₪",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 24,
              //           color: Colors.black,
              //         ),
              //       ),
              //
              //       const SizedBox(height: 20),
              //
              //       // Dropdown: نوع المؤسسة
              //       DropdownButtonFormField<String>(
              //         value: "مطعم",
              //         items: const [
              //           DropdownMenuItem(value: "مطعم", child: Text("مطعم")),
              //           DropdownMenuItem(value: "سوبرماركت", child: Text("سوبرماركت")),
              //         ],
              //         onChanged: (val) {},
              //         decoration: const InputDecoration(
              //           labelText: "نوع المؤسسة",
              //           border: OutlineInputBorder(),
              //         ),
              //       ),
              //       const SizedBox(height: 15),
              //
              //       // Dropdown: مدة الاشتراك
              //       DropdownButtonFormField<String>(
              //         value: "شهرية",
              //         items: const [
              //           DropdownMenuItem(value: "شهرية", child: Text("شهرية")),
              //           DropdownMenuItem(value: "سنوية", child: Text("سنوية")),
              //         ],
              //         onChanged: (val) {},
              //         decoration: const InputDecoration(
              //           labelText: "مدة الاشتراك",
              //           border: OutlineInputBorder(),
              //         ),
              //       ),
              //
              //       const SizedBox(height: 20),
              //
              //       // Features Title
              //       const Align(
              //         alignment: Alignment.centerRight,
              //         child: Text(
              //           "القطاعات المشمولة",
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 15,
              //           ),
              //         ),
              //       ),
              //       const SizedBox(height: 10),
              //
              //       // Features List
              //       const FeatureItem(text: "نشر عدد محدد من العروض يومياً"),
              //       const FeatureItem(text: "عرض موقع متجرك أو نشاطك على الخريطة"),
              //       const FeatureItem(text: "إحصاءات وتقارير أداء العروض"),
              //       const FeatureItem(text: "عرض منتجاتك في قنواتك بطريقة احترافية"),
              //
              //       const SizedBox(height: 20),
              //
              //       // Subscribe Button
              //       SizedBox(
              //         width: double.infinity,
              //         child: ElevatedButton(
              //           onPressed: () {},
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.deepPurple,
              //             padding: const EdgeInsets.symmetric(vertical: 14),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //           ),
              //           child: const Text(
              //             "الاشتراك في هذه الخطة",
              //             style: TextStyle(fontSize: 16, color: Colors.white),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(height: 12),
              //
              //       // Note Text
              //       const Text(
              //         "من الممكن تغيير الباقة التي قمت باختيارها بعد انتهاء المدة الحالية "
              //             "أو عن طريق التواصل مع الدعم الفني.",
              //         textAlign: TextAlign.center,
              //         style: TextStyle(fontSize: 12, color: Colors.grey),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== Reusable Widget for Feature Item =====
class FeatureItem extends StatelessWidget {
  final String text;
  const FeatureItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
