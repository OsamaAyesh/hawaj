// lib/features/common/drawer_menu/presentation/controller/drawer_menu_controller.dart

import 'package:get/get.dart';

import '../../domain/models/drawer_menu_model.dart';
import '../../domain/usecases/drawer_menu_use_case.dart';
import '../config/drawer_actions_registry.dart';

class DrawerMenuController extends GetxController {
  final DrawerMenuUseCase _useCase;

  DrawerMenuController(this._useCase);

  // ═══════════════════════════════════════════════════════════
  // 📊 Observable States
  // ═══════════════════════════════════════════════════════════
  final menuItems = <DrawerItemModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // ═══════════════════════════════════════════════════════════
  // 🚀 Auto Load عند بداية Controller
  // ═══════════════════════════════════════════════════════════
  @override
  void onInit() {
    super.onInit();
    loadDrawerMenu();
  }

  // ═══════════════════════════════════════════════════════════
  // 📥 Load Menu من API
  // ═══════════════════════════════════════════════════════════
  Future<void> loadDrawerMenu() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _useCase.execute();

      result.fold(
            (failure) {
          errorMessage.value = failure.message;
          isLoading.value = false;
        },
            (menuModel) {
          // ✅ Filter: نعرض بس العناصر الموجودة في Registry
          menuItems.value = menuModel.items.where((item) {
            // H1 و HR نعرضهم دايماً
            if (item.isHeader || item.isDivider) return true;

            // Items: نتحقق من وجود الدالة
            if (item.actionName == null) return false;
            return DrawerActionsRegistry.hasAction(item.actionName!);
          }).toList();

          isLoading.value = false;
        },
      );
    } catch (e) {
      errorMessage.value = 'حدث خطأ غير متوقع';
      isLoading.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // 🔄 Refresh Menu (للـ RefreshIndicator)
  // ═══════════════════════════════════════════════════════════
  Future<void> refreshMenu() async {
    await loadDrawerMenu();
  }

  // ═══════════════════════════════════════════════════════════
  // 🎯 Handle Item Tap
  // ═══════════════════════════════════════════════════════════
  void handleItemTap(DrawerItemModel item) {
    if (!item.isItem || item.actionName == null) return;

    if (item.isInactive) {
      Get.snackbar('تنبيه', 'هذه الميزة غير متاحة حالياً');
      print("in active");
      return;
    }

    final action = DrawerActionsRegistry.getAction(item.actionName!);

    if (action == null) {
      Get.snackbar('تنبيه', 'الميزة قيد التطوير');
      return;
    }

    try {
      action();
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ في تنفيذ العملية');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // 🎨 Get Icon من Registry
  // ═══════════════════════════════════════════════════════════
  String? getIcon(String actionName) {
    return DrawerActionsRegistry.getIcon(actionName);
  }
}
