import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/subscription_information_widget.dart';

class SubscriptionInformationScreen extends StatelessWidget {
  const SubscriptionInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "معلومات الإشتراك",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SubscriptionInformationWidget(
            packageName: "Super",
            startDate: "2024-10-01",
            endDate: "2024-10-30",
            status: "الاشتراك نشط",
            statusColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
