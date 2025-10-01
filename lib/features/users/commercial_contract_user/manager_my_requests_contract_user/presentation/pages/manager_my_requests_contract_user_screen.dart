import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/widgets/custom_tab_bar_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';

class ManagerMyRequestsContractUserScreen extends StatelessWidget {
  const ManagerMyRequestsContractUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.manageRequestsTitle, // إدارة الطلبات
      body: Column(
        children: [
          SizedBox(height: ManagerHeight.h16),
          Expanded(
            child: CustomTabBarWidget(
              tabs: [
                ManagerStrings.pendingRequestsTab, // طلبات بالإنتظار
                ManagerStrings.activeRequestsTab, // الطلبات النشطة
              ],
              views: [
                // ListView.builder(
                //   padding: const EdgeInsets.all(16),
                //   itemCount: 3,
                //   itemBuilder: (context, index) {
                //     return Card(
                //       margin: const EdgeInsets.only(bottom: 12),
                //       child: ListTile(
                //         title: Text("طلب بالإنتظار ${index + 1}"),
                //         subtitle: const Text("تفاصيل مختصرة عن الطلب..."),
                //       ),
                //     );
                //   },
                // ),
                //
                // /// محتوى الطلبات النشطة
                // ListView.builder(
                //   padding: const EdgeInsets.all(16),
                //   itemCount: 2,
                //   itemBuilder: (context, index) {
                //     return Card(
                //       margin: const EdgeInsets.only(bottom: 12),
                //       child: ListTile(
                //         title: Text("طلب نشط ${index + 1}"),
                //         subtitle: const Text("تفاصيل مختصرة عن الطلب..."),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
