import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants/di/dependency_injection.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_icons.dart';
import '../../../../../core/resources/manager_images.dart';
import '../../../../../core/resources/manager_opacity.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_strings.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/routes/custom_transitions.dart';
import '../../../../../core/storage/local/app_settings_prefs.dart';
import '../../../../../core/widgets/custom_confirm_dialog.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../../core/widgets/scaffold_with_back_button.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
import '../widgets/info_card.dart';
import '../widgets/logout_widget.dart';
import '../widgets/settings_tile_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.profileTitle,
      onBack: () {},
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: ManagerHeight.h24),

                    ///======= Profile Image With Verfied
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: ManagerHeight.h45,
                          backgroundImage: const AssetImage(
                              ManagerImages.imageFoodOneRemove),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(Icons.verified,
                              color: ManagerColors.primaryColor, size: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: ManagerHeight.h12),

                    ///======= Name Profile Widget
                    Text("محمد علي إسماعيل",
                        style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.black)),
                    SizedBox(height: ManagerHeight.h4),

                    ///======New User Widget
                    Text(
                      ManagerStrings.newUser,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s10,
                        color: ManagerColors.greyWithColor,
                      ),
                    ),

                    SizedBox(height: ManagerHeight.h16),

                    ///====== Row Widget Phone Number And Number Of Subscription Services
                    Row(
                      children: [
                        InfoCard(
                          value: "9665665236253234",
                          label: ManagerStrings.phoneNumber,
                        ),
                        InfoCard(
                          value: "4",
                          label: ManagerStrings.subscribedServices,
                        ),
                      ],
                    ),
                    SizedBox(height: ManagerHeight.h16),

                    ///========= Text Title List Settings =====
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ManagerStrings.listSettings,
                        style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.black),
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h8),

                    ///======Manager Services Settings
                    SettingsTileWidget(
                      title: ManagerStrings.manageServices,
                      icon: ManagerIcons.profileIcon1,
                      onTap: () {},
                    ),

                    ///====== Change Password Comment Code When Use Remove Comment
                    // SettingsTileWidget(
                    //   title:  ManagerStrings.changePassword,
                    //   icon:   ManagerIcons.profileIcon2, onTap: () {
                    //
                    // }),

                    ///=========Edit Profile Settings
                    SettingsTileWidget(
                        title: ManagerStrings.editProfile,
                        icon: ManagerIcons.profileIcon3,
                        onTap: () {}),

                    ///==== Contact Us Settings
                    SettingsTileWidget(
                        title: ManagerStrings.contactSupport,
                        icon: ManagerIcons.profileIcon4,
                        onTap: () {}),

                    ///====== Privacy Policy Settings
                    SettingsTileWidget(
                        title: ManagerStrings.termsConditions,
                        icon: ManagerIcons.profileIcon5,
                        onTap: () {}),

                    ///-======== Logout Settings Widget
                    LogoutWidget(
                      title: ManagerStrings.logout,
                      icon: ManagerIcons.profileIcon6,
                      onTap: () {
                        showDialogConfirmRegisterCompanyOffer(
                          title: ManagerStrings.titleConfirmation,
                          subTitle: ManagerStrings.messageSignout,
                          actionConfirmText: ManagerStrings.buttonContinue,
                          actionCancel: ManagerStrings.buttonCancel,
                          context,
                          onConfirm: () {

                          },
                          onCancel: () {

                          },
                        );
                      },
                    ),
                    SizedBox(height: ManagerHeight.h24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
