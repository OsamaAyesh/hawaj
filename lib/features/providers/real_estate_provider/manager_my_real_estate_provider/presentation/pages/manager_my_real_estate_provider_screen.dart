import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/widgets/custom_tab_bar_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';

import '../widgets/real_estate_list_widget.dart';

class ManagerMyRealEstateProviderScreen extends StatelessWidget {
  const ManagerMyRealEstateProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "عقاراتي",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- TabBar ---
          Expanded(
            child: CustomTabBarWidget(
              tabs: const ["العقارات المتاحة", "العقارات غير المتاحة"],
              indicatorColor: Colors.white,
              backgroundColor: ManagerColors.backGroundColorTab,
              views: const [
                /// المتاحة
                RealEstateListWidget(isAvailable: true),

                /// غير المتاحة
                RealEstateListWidget(isAvailable: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
