import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/features/common/profile/presentation/pages/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_icons.dart';
import '../../../../../core/resources/manager_images.dart';
import '../../../../../core/resources/manager_strings.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/widgets/scaffold_with_back_button.dart';
import '../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';

import '../../domain/di/di.dart';
import '../controller/get_profile_controller.dart';
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

  /// GetX controller (must be provided via Get.put/Get.lazyPut/Binding)
  late final ProfileController profileController;

  @override
  void initState() {
    super.initState();

    // Get the controller instance (logic wiring)
    profileController = Get.find<ProfileController>();

    // Animations (keep original look & feel)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

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
      onBack: () => Get.back(),
      // Logic: use Obx to react to controller states; keep original UI structure
      body: Obx(() {
        // Loading (initial)
        if (profileController.isLoading.value &&
            profileController.profileData.value == null) {
          return const LoadingWidget();
        }

        // Error (no data yet)
        if (profileController.hasError.value &&
            profileController.profileData.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profileController.errorMessage.value.isEmpty
                        ? 'Something went wrong'
                        : profileController.errorMessage.value,
                    style: getBoldTextStyle(
                      color: Colors.red,
                      fontSize: ManagerFontSize.s12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: profileController.retryLoading,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Success (or cached data)
        final data = profileController.profileData.value!;
        final name = data.data.name;
        final phone = data.data.phone;

        const subscribedCount = '4'; // TODO: replace with API field if available

        return RefreshIndicator(
          onRefresh: profileController.refreshProfileData,
          displacement: 60,
          color: ManagerColors.primaryColor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
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

                              /// ======= Profile Image With Verified (kept as-is)
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  const CircleAvatar(
                                    radius: 45,
                                    backgroundImage:
                                    AssetImage(ManagerImages.imageFoodOneRemove),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.verified,
                                      color: ManagerColors.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ManagerHeight.h12),

                              /// ======= Name Profile (bound to controller data)
                              Text(
                                name,
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s14,
                                  color: ManagerColors.black,
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h4),

                              /// ====== New User label (kept)
                              Text(
                                ManagerStrings.newUser,
                                style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s10,
                                  color: ManagerColors.greyWithColor,
                                ),
                              ),

                              SizedBox(height: ManagerHeight.h16),

                              /// ====== Phone & Subscribed services
                              Row(
                                children: [
                                  InfoCard(
                                    value: phone,
                                    label: ManagerStrings.phoneNumber,
                                  ),
                                  InfoCard(
                                    value: subscribedCount,
                                    label: ManagerStrings.subscribedServices,
                                  ),
                                ],
                              ),
                              SizedBox(height: ManagerHeight.h16),

                              /// ====== Settings list title
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  ManagerStrings.listSettings,
                                  style: getBoldTextStyle(
                                    fontSize: ManagerFontSize.s12,
                                    color: ManagerColors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h8),

                              /// ====== Settings tiles
                              SettingsTileWidget(
                                title: ManagerStrings.manageServices,
                                icon: ManagerIcons.profileIcon1,
                                onTap: () {
                                  // TODO
                                },
                              ),
                              SettingsTileWidget(
                                title: ManagerStrings.editProfile,
                                icon: ManagerIcons.profileIcon3,
                                onTap: () {
                                  // TODO
                                  initUpdateAvatar();
                                  Get.to(EditProfileScreen());
                                },
                              ),
                              SettingsTileWidget(
                                title: ManagerStrings.contactSupport,
                                icon: ManagerIcons.profileIcon4,
                                onTap: () {
                                  // TODO
                                },
                              ),
                              SettingsTileWidget(
                                title: ManagerStrings.termsConditions,
                                icon: ManagerIcons.profileIcon5,
                                onTap: () {
                                  // TODO
                                },
                              ),

                              /// ====== Logout
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
                                      // TODO: perform logout
                                    },
                                    onCancel: () {},
                                  );
                                },
                              ),

                              /// Optional: tiny loader while refreshing
                              if (profileController.isRefreshing.value) ...[
                                SizedBox(height: ManagerHeight.h12),
                                const LoadingWidget()
                              ],

                              SizedBox(height: ManagerHeight.h24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),

    );
  }
}
