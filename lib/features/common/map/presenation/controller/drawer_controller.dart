import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// استيراد الـ Profile UseCase والـ Model
import '../../../profile/domain/use_case/get_profile_use_case.dart';

/// Model لبيانات المستخدم في الـ Drawer
class DrawerUserData {
  final String name;
  final String role;
  final String phone;
  final String? avatar;

  DrawerUserData({
    required this.name,
    required this.role,
    required this.phone,
    this.avatar,
  });
}

/// Controller لإدارة بيانات المستخدم في الـ Drawer
class MapDrawerController extends GetxController {
  final GetProfileUseCase _getProfileUseCase;

  MapDrawerController(this._getProfileUseCase);

  // بيانات المستخدم
  final userData = Rxn<DrawerUserData>();

  // حالة التحميل
  final isLoading = false.obs;

  // رسالة الخطأ
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  /// جلب بيانات المستخدم من Profile
  Future<void> fetchUserData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (kDebugMode) print('[Drawer] 🔄 جاري جلب بيانات المستخدم...');

      // استدعاء الـ UseCase
      final result = await _getProfileUseCase.execute();

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          if (kDebugMode) print('[Drawer] ❌ خطأ: ${failure.message}');

          // Fallback data
          userData.value = DrawerUserData(
            name: 'مستخدم',
            role: 'جديد',
            phone: '',
            avatar: null,
          );
        },
        (profile) {
          userData.value = DrawerUserData(
            name: profile.data.name ?? 'مستخدم',
            role: 'مستخدم جديد',
            phone: profile.data.phone ?? '',
            avatar: profile.data.avatar,
          );
          if (kDebugMode) {
            print('[Drawer] ✅ تم جلب البيانات بنجاح');
            print('[Drawer] الاسم: ${profile.data.name}');
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'فشل في جلب بيانات المستخدم';
      if (kDebugMode) print('[Drawer] 💥 Exception: $e');

      // Fallback data
      userData.value = DrawerUserData(
        name: 'مستخدم',
        role: 'جديد',
        phone: '',
        avatar: null,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// إعادة جلب البيانات
  Future<void> refresh() => fetchUserData();
}
