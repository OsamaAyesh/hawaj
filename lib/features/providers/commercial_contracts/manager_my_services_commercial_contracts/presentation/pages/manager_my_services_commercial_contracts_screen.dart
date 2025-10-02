import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/custom_tab_bar_widget.dart';
import '../widgets/my_service_card_widget.dart';

class ManagerMyServicesCommercialContractsScreen extends StatelessWidget {
  const ManagerMyServicesCommercialContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.manageServicesTitle,
      body: CustomTabBarWidget(
        tabs: [
          ManagerStrings.activeServices,
          ManagerStrings.disabledServices,
        ],
        views: [
          // ===== Tab 1: Active Services =====
          GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w16,
              vertical: 12,
            ),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200, // العرض الأقصى لكل كارد
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: ManagerHeight.h205),
            itemBuilder: (context, index) {
              return MyServiceGridCardWidget(
                imageUrl:
                    "https://images.unsplash.com/photo-1518770660439-4636190af475",
                title: "تحليل البيانات",
                description:
                    "استخراج رؤى ذكية من بياناتك باستخدام تقنيات التحليل والتعلم الآلي لتحسين اتخاذ القرار.",
                price: "699",
                isActive: true,
                onToggle: () {
                  // TODO: فتح دايلوج تأكيد تعطيل الخدمة
                },
              );
            },
          ),

          // ===== Tab 2: Disabled Services =====
          GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w16,
              vertical: 12,
            ),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200, // العرض الأقصى لكل كارد
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: ManagerHeight.h205),
            itemBuilder: (context, index) {
              return MyServiceGridCardWidget(
                imageUrl:
                    "https://images.unsplash.com/photo-1518770660439-4636190af475",
                title: "تحليل البيانات",
                description:
                    "استخراج رؤى ذكية من بياناتك باستخدام تقنيات التحليل والتعلم الآلي لتحسين اتخاذ القرار.",
                price: "699",
                isActive: false,
                onToggle: () {
                  // TODO: فتح دايلوج تأكيد تفعيل الخدمة
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
