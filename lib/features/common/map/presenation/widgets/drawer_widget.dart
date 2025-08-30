import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/resources/manager_styles.dart';

/// Model for a single drawer item
class DrawerItemModel {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  DrawerItemModel({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });
}

/// AppDrawer with two sections (User / Providers)
/// If a section has no items, it will be hidden entirely.
class AppDrawer extends StatelessWidget {
  final GlobalKey<SliderDrawerState> sliderKey;
  final String userName;
  final String role;
  final String phone;

  /// Flat items for the "User" section
  final List<DrawerItemModel> userItems;

  /// Flat items for the "Providers" section
  final List<DrawerItemModel> providerItems;

  const AppDrawer({
    super.key,
    required this.sliderKey,
    this.userName = "Guest",
    this.role = "User",
    this.phone = "",
    this.userItems = const [],
    this.providerItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    final hasUser = userItems.isNotEmpty;
    final hasProvider = providerItems.isNotEmpty;

    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: SafeArea(
        child: Container(
          color: ManagerColors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Close button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: ManagerColors.primaryColor),
                    onPressed: () => sliderKey.currentState?.closeSlider(),
                  ),
                ),

                /// User header (name/role/phone)
                _buildUserHeader(),

                const SizedBox(height: 12),

                /// ===== User section (hidden if empty)
                if (hasUser) ...[
                  _sectionHeader(title: "أقسام طالب الخدمة"),
                  const SizedBox(height: 6),
                  ...userItems.map(_drawerItem).toList(),
                ],

                /// Dotted divider only if both sections are visible
                if (hasUser && hasProvider) ...[
                  const SizedBox(height: 12),
                  _dottedDivider(),
                  const SizedBox(height: 12),
                ],

                /// ===== Provider section (hidden if empty)
                if (hasProvider) ...[
                  _sectionHeader(title: "أقسام مزودي الخدمة"),
                  const SizedBox(height: 6),
                  ...providerItems.map(_drawerItem).toList(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// User header (avatar + name + role + phone)
  Widget _buildUserHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: ManagerColors.primaryColor.withOpacity(0.1),
          child: const Icon(Icons.person, color: ManagerColors.primaryColor, size: 34),
        ),
        const SizedBox(height: 10),
        Text(
          userName,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s14,
            color: ManagerColors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          role,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s11,
            color: ManagerColors.greyWithColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        if (phone.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone, size: 16, color: ManagerColors.primaryColor),
              SizedBox(width: ManagerWidth.w4),
              Text(
                phone,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.black,
                ),
              ),
            ],
          ),
      ],
    );
  }

  /// Unified section header for both sections
  Widget _sectionHeader({required String title}) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: ManagerColors.primaryColor,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s12,
            color: ManagerColors.primaryColor,
          ),
        ),
      ],
    );
  }

  /// Single drawer item (flat look)
  Widget _drawerItem(DrawerItemModel item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: ManagerHeight.h12,top: ManagerHeight.h2),
        child: Row(
          children: [
             Image.asset(
              item.iconPath,
              width: ManagerWidth.w22,
              height: ManagerHeight.h22,
            ),
          SizedBox(width:ManagerWidth.w4),
          Expanded(
            child: Text(
                item.title,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.black,
                ),
              maxLines: 1,
              ),
          ),
            Icon(
              Icons.chevron_right,
              color: ManagerColors.greyWithColor.withOpacity(0.8),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  /// Dotted divider between sections (lightweight, no custom painter)
  Widget _dottedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Number of dots based on available width
        final count = (constraints.maxWidth / 6).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
                (_) => Container(
              width: 3,
              height: 1.2,
              color: ManagerColors.greyWithColor.withOpacity(0.35),
            ),
          ),
        );
      },
    );
  }
}
