import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/delete_my_real_estate_controller.dart';
import '../controller/get_my_real_estates_controller.dart';
import '../widgets/real_estate_list_widget.dart';

/// =====================
/// 🔹 شاشة إدارة العقارات
/// =====================
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
          /// 🔹 المحتوى الرئيسي
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
                onEdit: (id) {
                  // Get.toNamed('/editRealEstate', arguments: id);
                },
                onDelete: (id) async {
                  await _showDeleteDialog(context, id);
                },
              ),
            );
          }),

          /// 🔹 Loading يغطي الشاشة بالكامل
          Obx(() {
            if (getController.isLoading.value ||
                deleteController.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(child: LoadingWidget()),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  /// 🔹 دالة عرض الديالوج لتأكيد الحذف
  Future<void> _showDeleteDialog(BuildContext context, String id) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد أنك تريد حذف هذا العقار؟"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await deleteController.deleteRealEstate(double.tryParse(id) ?? 1);
              await getController.refreshEstates();
            },
            child: const Text("تأكيد", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// =====================
/// 🔹 قائمة العقارات
/// =====================

/// =====================
/// 🔹 كارد العقار
/// =====================
