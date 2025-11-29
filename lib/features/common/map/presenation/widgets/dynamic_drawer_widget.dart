// lib/features/common/drawer_menu/presentation/widgets/dynamic_drawer_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../map/presenation/widgets/verfied_widget.dart';
import '../../domain/models/drawer_menu_model.dart';
import '../controller/drawer_menu_controller.dart';

class DynamicDrawerWidget extends StatelessWidget {
  final GlobalKey<SliderDrawerState> sliderKey;
  final String userName;
  final String role;
  final String phone;
  final String avatar;

  const DynamicDrawerWidget({
    Key? key,
    required this.sliderKey,
    required this.userName,
    required this.role,
    required this.phone,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DrawerMenuController>();

    return Container(
      color: ManagerColors.white,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return _buildErrorState(controller);
                }

                if (controller.menuItems.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshMenu,
                  color: ManagerColors.primaryColor,
                  child: _buildMenuList(controller),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ManagerColors.primaryColor,
            ManagerColors.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => sliderKey.currentState?.closeSlider(),
            ),
          ),
          VerifiedAvatar(
            imageUrl:
                avatar.isNotEmpty ? avatar : 'https://via.placeholder.com/150',
            size: 80,
            isVerified: true,
          ),
          SizedBox(height: ManagerHeight.h12),
          Text(
            userName,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ManagerHeight.h4),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w12,
              vertical: ManagerHeight.h4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user, size: 14, color: Colors.white),
                SizedBox(width: ManagerWidth.w4),
                Text(
                  role,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ManagerHeight.h8),
          if (phone.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, size: 16, color: Colors.white70),
                SizedBox(width: ManagerWidth.w4),
                Text(
                  phone,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMenuList(DrawerMenuController controller) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
        vertical: ManagerHeight.h12,
      ),
      itemCount: controller.menuItems.length,
      itemBuilder: (context, index) {
        final item = controller.menuItems[index];
        return _buildMenuItem(item, controller);
      },
    );
  }

  Widget _buildMenuItem(DrawerItemModel item, DrawerMenuController controller) {
    // H1 - Header
    if (item.isHeader) {
      return Padding(
        padding:
            EdgeInsets.fromLTRB(0, ManagerHeight.h20, 0, ManagerHeight.h12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: ManagerWidth.w8),
            Text(
              item.title,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.black,
              ),
            ),
          ],
        ),
      );
    }

    // HR - Divider
    if (item.isDivider) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
        child: Divider(
          color: Colors.grey.shade300,
          thickness: 1,
          height: 1,
        ),
      );
    }

    // Item - Regular
    if (item.actionName == null) return const SizedBox.shrink();

    final iconPath = controller.getIcon(item.actionName!);
    if (iconPath == null) return const SizedBox.shrink();

    final isActive = item.isActive;

    return InkWell(
      onTap: isActive
          ? () {
              sliderKey.currentState?.closeSlider();
              Future.delayed(const Duration(milliseconds: 300), () {
                controller.handleItemTap(item);
              });
            }
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w12,
          vertical: ManagerHeight.h8,
        ),
        margin: EdgeInsets.only(bottom: ManagerHeight.h4),
        decoration: BoxDecoration(
          color: isActive ? Colors.transparent : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: ManagerWidth.w24,
              height: ManagerHeight.h24,
              color: isActive ? null : Colors.grey,
            ),
            SizedBox(width: ManagerWidth.w12),
            Expanded(
              child: Text(
                item.title,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: isActive ? ManagerColors.black : Colors.grey,
                ),
              ),
            ),
            if (isActive)
              Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400)
            else
              Icon(Icons.lock_outline, size: 17, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(ManagerColors.primaryColor),
          ),
          SizedBox(height: ManagerHeight.h16),
          Text(
            'جارٍ تحميل القائمة...',
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s14,
              color: Colors.grey[600]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(DrawerMenuController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ManagerWidth.w20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.red[400]),
            SizedBox(height: ManagerHeight.h20),
            Text(
              'حدث خطأ في تحميل القائمة',
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s15,
                color: Colors.grey[800]!,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h20),
            ElevatedButton.icon(
              onPressed: controller.refreshMenu,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ManagerColors.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_open, size: 60, color: Colors.grey[400]),
          SizedBox(height: ManagerHeight.h16),
          Text(
            'لا توجد عناصر في القائمة',
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s14,
              color: Colors.grey[600]!,
            ),
          ),
        ],
      ),
    );
  }
}
