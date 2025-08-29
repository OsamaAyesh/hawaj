import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/resources/manager_styles.dart';

/// ========== Model for a single drawer item
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

/// Model for a service provider (Provider)
class ProviderSection {
  final String name;
  final List<DrawerItemModel> items;

  ProviderSection({
    required this.name,
    required this.items,
  });
}

/// AppDrawer (Animated side menu)
class AppDrawer extends StatelessWidget {
  final GlobalKey<SliderDrawerState> sliderKey;
  final String userName;
  final String role;
  final String phone;
  final List<DrawerItemModel> userItems;
  final List<ProviderSection> providers;

  const AppDrawer({
    super.key,
    required this.sliderKey,
    this.userName = "Guest",
    this.role = "User",
    this.phone = "",
    this.userItems = const [],
    this.providers = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: Container(
        color: ManagerColors.white,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: ManagerHeight.h16),

              /// Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close,
                      color: ManagerColors.primaryColor),
                  onPressed: () => sliderKey.currentState?.closeSlider(),
                ),
              ),

              ///User Information
              const SizedBox(height: 12),
              Text(userName,
                  style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: ManagerColors.black)),
              const SizedBox(height: 4),
              Text(role,
                  style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s11,
                      color: ManagerColors.greyWithColor)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, size: 16),
                  SizedBox(width: ManagerWidth.w4),
                  Text(phone,
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.black)),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: ManagerColors.greyWithColor.withOpacity(0.4)),

              /// User Role Features.
              ...userItems.map((item) => _drawerItem(item)).toList(),

              // if (providers.isNotEmpty) ...[
              //   const SizedBox(height: 16),
              //   Divider(color: ManagerColors.greyWithColor.withOpacity(0.4)),
              //   ...providers.map((provider) => _buildProvider(provider)),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  /// عنصر Drawer عادي
  Widget _drawerItem(DrawerItemModel item) {
    return ListTile(
      leading: Image.asset(
        item.iconPath,
        width: ManagerWidth.w24,
        height: ManagerHeight.h24,
      ),
      title: Text(
        item.title,
        style: getRegularTextStyle(
          fontSize: ManagerFontSize.s12,
          color: ManagerColors.black,
        ),
      ),
      onTap: item.onTap,
    );
  }

  ///Build Provider Part.
  Widget _buildProvider(ProviderSection provider) {
    return ExpansionTile(
      leading: const Icon(Icons.business, color: ManagerColors.primaryColor),
      title: Text(
        provider.name,
        style: getBoldTextStyle(
          fontSize: ManagerFontSize.s13,
          color: ManagerColors.black,
        ),
      ),
      children: provider.items.map((item) => _drawerItem(item)).toList(),
    );
  }
}
