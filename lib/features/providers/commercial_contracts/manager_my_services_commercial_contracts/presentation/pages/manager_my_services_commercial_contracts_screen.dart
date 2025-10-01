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
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return const MyServiceCardWidget(
                imageUrl:
                    "https://images.unsplash.com/photo-1518770660439-4636190af475",
                title: "تحليل البيانات",
                description:
                    "استخدام الذكاء الاصطناعي وتحليل البيانات باستخدام أحدث الأدوات لتحسين الأداء واتخاذ القرار.",
                price: "1499",
                isActive: true,
              );
            },
          ),

          /// ===== Tab 2: Disabled Services =====
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return const MyServiceCardWidget(
                imageUrl:
                    "https://images.unsplash.com/photo-1518770660439-4636190af475",
                title: "تحليل البيانات",
                description:
                    "استخدام الذكاء الاصطناعي وتحليل البيانات باستخدام أحدث الأدوات لتحسين الأداء واتخاذ القرار.",
                price: "1499",
                isActive: false,
              );
            },
          ),
        ],
      ),
    );
  }
}
