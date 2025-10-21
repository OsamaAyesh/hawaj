import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/widgets/custom_confirm_dialog.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/real_estate_item_model.dart';
import '../../domain/di/di.dart';
import '../controller/delete_my_real_estate_controller.dart';
import '../controller/get_my_real_estates_controller.dart';
import '../widgets/real_estate_list_widget.dart';
import 'edit_my_real_estate_screen.dart';

class ManagerMyRealEstateProviderScreen extends StatefulWidget {
  const ManagerMyRealEstateProviderScreen({super.key});

  @override
  State<ManagerMyRealEstateProviderScreen> createState() =>
      _ManagerMyRealEstateProviderScreenState();
}

class _ManagerMyRealEstateProviderScreenState
    extends State<ManagerMyRealEstateProviderScreen> {
  late GetMyRealEstatesController getController;
  late DeleteMyRealEstateController deleteController;

  @override
  void initState() {
    super.initState();
    getController = Get.find<GetMyRealEstatesController>();
    deleteController = Get.find<DeleteMyRealEstateController>();
    getController.fetchMyRealEstates();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "عقاراتي",
      body: Stack(
        children: [
          Obx(() {
            if (getController.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  getController.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (getController.realEstates.isEmpty &&
                !getController.isLoading.value) {
              return const Center(child: Text("لا يوجد عقارات حالياً"));
            }

            return RefreshIndicator(
              color: ManagerColors.primaryColor,
              onRefresh: () async => await getController.refreshEstates(),
              child: RealEstateListWidget(
                realEstates: getController.realEstates,

                /// ✅ onEdit الآن يأخذ Model مباشرة
                onEdit: (RealEstateItemModel estate) {
                  initEditMyRealEstate();
                  Get.to(() => EditMyRealEstateScreen(realEstate: estate));
                },

                onDelete: (id) async {
                  await _showDeleteDialog(context, id);
                },
              ),
            );
          }),

          /// ✅ Loading Overlay
          Obx(() {
            if (getController.isLoading.value ||
                deleteController.isLoading.value) {
              return const LoadingWidget();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, String id) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomConfirmDialog(
        title: "تأكيد الحذف",
        subtitle: "هل أنت متأكد أنك تريد حذف هذا العقار؟",
        confirmText: "تأكيد",
        cancelText: "إلغاء",
        onConfirm: () async {
          Get.back();
          await deleteController.deleteRealEstate(double.tryParse(id) ?? 0);
          await getController.refreshEstates();
        },
        onCancel: () => Get.back(),
      ),
    );
  }
}
