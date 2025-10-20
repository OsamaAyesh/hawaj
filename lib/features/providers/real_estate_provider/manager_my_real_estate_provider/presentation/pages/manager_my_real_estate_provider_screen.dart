import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/get_my_real_estates_controller.dart';
import '../widgets/real_estate_list_widget.dart';

class ManagerMyRealEstateProviderScreen extends StatefulWidget {
  const ManagerMyRealEstateProviderScreen({super.key});

  @override
  State<ManagerMyRealEstateProviderScreen> createState() =>
      _ManagerMyRealEstateProviderScreenState();
}

class _ManagerMyRealEstateProviderScreenState
    extends State<ManagerMyRealEstateProviderScreen> {
  late GetMyRealEstatesController controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller and fetch data
    controller = Get.find<GetMyRealEstatesController>();
    controller.fetchMyRealEstates();
  }

  @override
  void dispose() {
    // Delete controller instance when leaving screen
    Get.delete<GetMyRealEstatesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "عقاراتي",
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (controller.realEstates.isEmpty) {
          return const Center(child: Text("لا يوجد عقارات حالياً"));
        }

        return RefreshIndicator(
          color: Colors.blue,
          onRefresh: () async {
            await controller.refreshEstates();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RealEstateListWidget(
                  isAvailable: true,
                  realEstates: controller.realEstates,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
