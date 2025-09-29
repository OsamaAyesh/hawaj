import 'package:app_mobile/features/common/map/presenation/widgets/verfied_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';
import 'drawer_widget.dart';
import 'manager_drawer_items.dart';

class AppDrawer extends StatelessWidget {
  final GlobalKey<SliderDrawerState> sliderKey;
  final String userName;
  final String role;
  final String phone;
  final bool isLoading;
  final String avatar;

  const AppDrawer({
    super.key,
    required this.sliderKey,
    required this.userName,
    required this.role,
    required this.phone,
    required this.avatar,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ManagerColors.white,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildDrawerContent(),
            ),
          ],
        ),
      ),
    );
  }

  /// محتوى الـ Drawer
  Widget _buildDrawerContent() {
    // إنشاء الـ manager هنا
    final visibilityManager = DrawerVisibilityManager(enabled: {
      DrawerFeatures.userProfile,
      DrawerFeatures.userDailyOffers,
      DrawerFeatures.userDelivery,
      DrawerFeatures.userContracts,
      DrawerFeatures.userRealEstate,
      DrawerFeatures.providerManageOffers,
      DrawerFeatures.providerManageContracts,
    });

    final userItems = visibilityManager.buildUserItems();
    final providerItems = visibilityManager.buildProviderItems();

    // Debug: طباعة عدد العناصر
    print('👤 User items count: ${userItems.length}');
    print('🏢 Provider items count: ${providerItems.length}');

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
        vertical: ManagerHeight.h12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // قسم المستخدم
          if (userItems.isNotEmpty) ...[
            _sectionHeader('طالب الخدمة'),
            SizedBox(height: ManagerHeight.h8),
            ...userItems.map((item) => _buildItem(item)),
          ],

          // فاصل
          if (userItems.isNotEmpty && providerItems.isNotEmpty) ...[
            SizedBox(height: ManagerHeight.h12),
            _buildDivider(),
            SizedBox(height: ManagerHeight.h12),
          ],

          // قسم مزود الخدمة
          if (providerItems.isNotEmpty) ...[
            _sectionHeader('مزود الخدمة'),
            SizedBox(height: ManagerHeight.h8),
            ...providerItems.map((item) => _buildItem(item)),
          ],

          // إذا لم توجد عناصر نهائياً
          if (userItems.isEmpty && providerItems.isEmpty) ...[
            SizedBox(height: ManagerHeight.h50),
            Center(
              child: Text(
                'لا توجد أقسام متاحة',
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],

          SizedBox(height: ManagerHeight.h24),
          _buildLogoutButton(),
          SizedBox(height: ManagerHeight.h16),
        ],
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
            imageUrl: 'https://your-server.com/profile.jpg',
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
            child: Text(
              role,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: ManagerHeight.h8),
          if (phone.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.white70),
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

  Widget _sectionHeader(String title) {
    return Row(
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
          title,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s14,
            color: ManagerColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(DrawerItemModel item) {
    return InkWell(
      onTap: () {
        sliderKey.currentState?.closeSlider();
        Future.delayed(const Duration(milliseconds: 300), item.onTap);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.only(
          left: ManagerWidth.w12,
          right: ManagerWidth.w12,
          bottom: ManagerHeight.h8,
        ),
        margin: EdgeInsets.only(bottom: ManagerHeight.h4),
        child: Row(
          children: [
            Image.asset(
              item.iconPath,
              width: ManagerWidth.w24,
              height: ManagerHeight.h24,
            ),
            SizedBox(width: ManagerWidth.w12),
            Expanded(
              child: Text(
                item.title,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: ManagerColors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: 1,
      height: 1,
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () {
        Get.defaultDialog(
          title: 'تسجيل الخروج',
          middleText: 'هل تريد تسجيل الخروج من التطبيق؟',
          textConfirm: 'تسجيل الخروج',
          textCancel: 'إلغاء',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          },
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w16,
          vertical: ManagerHeight.h14,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red.shade700, size: 20),
            SizedBox(width: ManagerWidth.w8),
            Text(
              'تسجيل الخروج',
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s13,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
