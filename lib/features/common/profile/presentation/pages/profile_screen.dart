import 'package:app_mobile/core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:app_mobile/features/common/profile/presentation/pages/edit_profile_screen.dart';
import 'package:app_mobile/features/common/profile/presentation/pages/terms_and_condition_screen.dart';
import 'package:app_mobile/features/splash_and_boarding/presentation/pages/splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_icons.dart';
import '../../../../../core/resources/manager_images.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_strings.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/storage/local/app_settings_prefs.dart';
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
    with TickerProviderStateMixin {
  late AnimationController _avatarController;
  late AnimationController _contentController;
  late Animation<double> _avatarScaleAnimation;
  late Animation<double> _avatarRotationAnimation;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  /// GetX controller
  late final ProfileController profileController;

  @override
  void initState() {
    super.initState();
    profileController = Get.find<ProfileController>();

    // Avatar animations - with bounce effect
    _avatarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _avatarScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
    ]).animate(_avatarController);

    _avatarRotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _avatarController,
        curve: Curves.elasticOut,
      ),
    );

    // Content animations - staggered
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _slideAnimations = List.generate(6, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _contentController,
          curve: Interval(
            0.1 * index,
            0.4 + (0.1 * index),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _fadeAnimations = List.generate(6, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _contentController,
          curve: Interval(
            0.1 * index,
            0.4 + (0.1 * index),
            curve: Curves.easeIn,
          ),
        ),
      );
    });

    // Start animations
    _avatarController.forward();
    _contentController.forward();
  }

  @override
  void dispose() {
    _avatarController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.profileTitle,
      onBack: () => Get.back(),
      body: Obx(() {
        // Loading state
        if (profileController.isLoading.value &&
            profileController.profileData.value == null) {
          return const LoadingWidget();
        }

        // Error state
        if (profileController.hasError.value &&
            profileController.profileData.value == null) {
          return _buildErrorView();
        }

        // Success state
        final data = profileController.profileData.value!;
        final name = data.data.name;
        final phone = data.data.phone;
        final avatarUrl = data.data.avatar;

        const subscribedCount = '4';

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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                    child: Column(
                      children: [
                        SizedBox(height: ManagerHeight.h32),

                        /// ======= Avatar with Verified Badge (Animated) =======
                        _buildAnimatedAvatar(avatarUrl),

                        SizedBox(height: ManagerHeight.h16),

                        /// ======= Name (Animated) =======
                        _buildAnimatedText(
                          0,
                          name,
                          getBoldTextStyle(
                            fontSize: ManagerFontSize.s15,
                            color: ManagerColors.black,
                          ),
                        ),

                        SizedBox(height: ManagerHeight.h6),

                        /// ======= New User Badge (Animated) =======
                        _buildAnimatedText(
                          1,
                          ManagerStrings.newUser,
                          getRegularTextStyle(
                            fontSize: ManagerFontSize.s10,
                            color: ManagerColors.greyWithColor,
                          ),
                        ),

                        SizedBox(height: ManagerHeight.h20),

                        /// ======= Info Cards (Animated) =======
                        _buildAnimatedWidget(
                          2,
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
                        ),

                        SizedBox(height: ManagerHeight.h24),

                        /// ======= Settings Title (Animated) =======
                        _buildAnimatedWidget(
                          3,
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              ManagerStrings.listSettings,
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s13,
                                color: ManagerColors.black,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: ManagerHeight.h12),

                        /// ======= Settings List (Animated) =======
                        _buildAnimatedWidget(
                          4,
                          Column(
                            children: [
                              SettingsTileWidget(
                                title: ManagerStrings.manageServices,
                                icon: ManagerIcons.profileIcon1,
                                onTap: () {
                                  // TODO: Navigate to manage services
                                },
                              ),
                              SettingsTileWidget(
                                title: ManagerStrings.editProfile,
                                icon: ManagerIcons.profileIcon3,
                                onTap: () {
                                  initUpdateAvatar(data.data.name, avatarUrl);
                                  Get.to(const EditProfileScreen());
                                },
                              ),
                              SettingsTileWidget(
                                title: ManagerStrings.contactSupport,
                                icon: ManagerIcons.profileIcon4,
                                onTap: () {
                                  // TODO: Navigate to contact support
                                },
                              ),
                              SettingsTileWidget(
                                title: ManagerStrings.termsConditions,
                                icon: ManagerIcons.profileIcon5,
                                onTap: () {
                                  Get.to(() => const TermsConditionsScreen());
                                },
                              ),
                            ],
                          ),
                        ),

                        /// ======= Logout Button (Animated) =======
                        _buildAnimatedWidget(
                          5,
                          LogoutWidget(
                            title: ManagerStrings.logout,
                            icon: ManagerIcons.profileIcon6,
                            onTap: () => _handleLogout(context),
                          ),
                        ),

                        /// Optional: Refresh loader
                        if (profileController.isRefreshing.value) ...[
                          SizedBox(height: ManagerHeight.h16),
                          const LoadingWidget()
                        ],

                        SizedBox(height: ManagerHeight.h32),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    ).withHawaj(
      section: HawajSections.settingsSection,
      screen: HawajScreens.profileScreen,
    );
  }

  /// ======= Animated Avatar with Real Image or Default =======
  Widget _buildAnimatedAvatar(String avatarUrl) {
    return ScaleTransition(
      scale: _avatarScaleAnimation,
      child: RotationTransition(
        turns: _avatarRotationAnimation,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ManagerColors.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 52,
                backgroundColor: ManagerColors.greyWithColor.withOpacity(0.1),
                child: _buildAvatarImage(avatarUrl),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.verified,
                color: ManagerColors.primaryColor,
                size: 24,
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 2000.ms,
                    color: Colors.white.withOpacity(0.5),
                  )
                  .scale(
                    duration: 1500.ms,
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    duration: 1500.ms,
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(1, 1),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// ======= Build Avatar Image (Network or Default) =======
  Widget _buildAvatarImage(String avatarUrl) {
    if (avatarUrl.isNotEmpty &&
        (avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://'))) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          width: 104,
          height: 104,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: ManagerColors.greyWithColor.withOpacity(0.1),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ManagerColors.primaryColor,
              ),
            ),
          ),
          errorWidget: (context, url, error) => _buildDefaultAvatar(),
        ),
      );
    } else {
      return _buildDefaultAvatar();
    }
  }

  /// ======= Default Avatar Widget =======
  Widget _buildDefaultAvatar() {
    return ClipOval(
      child: Image.asset(
        ManagerImages.imageFoodOneRemove,
        width: 104,
        height: 104,
        fit: BoxFit.cover,
      ),
    );
  }

  /// ======= Animated Text Widget =======
  Widget _buildAnimatedText(int index, String text, TextStyle style) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: Text(text, style: style),
      ),
    );
  }

  /// ======= Animated Generic Widget =======
  Widget _buildAnimatedWidget(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: child,
      ),
    );
  }

  /// ======= Error View =======
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ManagerWidth.w24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: ManagerColors.redNew.withOpacity(0.7),
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .then()
                .shake(duration: 500.ms),
            SizedBox(height: ManagerHeight.h16),
            Text(
              profileController.errorMessage.value.isEmpty
                  ? 'حدث خطأ ما'
                  : profileController.errorMessage.value,
              style: getBoldTextStyle(
                color: ManagerColors.redNew,
                fontSize: ManagerFontSize.s13,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h20),
            ElevatedButton.icon(
              onPressed: profileController.retryLoading,
              icon: const Icon(Icons.refresh),
              label: Text(
                'إعادة المحاولة',
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ManagerColors.primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w24,
                  vertical: ManagerHeight.h12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ManagerRadius.r8),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          ],
        ),
      ),
    );
  }

  /// ======= Handle Logout =======
  void _handleLogout(BuildContext context) {
    showDialogConfirmRegisterCompanyOffer(
      title: ManagerStrings.titleConfirmation,
      subTitle: ManagerStrings.messageSignout,
      actionConfirmText: ManagerStrings.buttonContinue,
      actionCancel: ManagerStrings.buttonCancel,
      context,
      onConfirm: () async {
        Navigator.pop(context);

        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: LoadingWidget()),
        );

        try {
          final prefs = await SharedPreferences.getInstance();
          final appPrefs = AppSettingsPrefs(prefs);
          await appPrefs.clear();

          await Future.delayed(const Duration(milliseconds: 800));

          AppSnackbar.success("تم تسجيل الخروج بنجاح");

          if (context.mounted) {
            Get.offAll(() => const SplashScreen());
          }
        } catch (e) {
          if (context.mounted) Navigator.pop(context);
          AppSnackbar.error("حدث خطأ أثناء تسجيل الخروج");
        }
      },
      onCancel: () => Navigator.pop(context),
    );
  }
}
// import 'package:app_mobile/core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
// import 'package:app_mobile/core/util/snack_bar.dart';
// import 'package:app_mobile/core/widgets/loading_widget.dart';
// import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
// import 'package:app_mobile/features/common/profile/presentation/pages/edit_profile_screen.dart';
// import 'package:app_mobile/features/splash_and_boarding/presentation/pages/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../../core/resources/manager_colors.dart';
// import '../../../../../core/resources/manager_font_size.dart';
// import '../../../../../core/resources/manager_height.dart';
// import '../../../../../core/resources/manager_icons.dart';
// import '../../../../../core/resources/manager_images.dart';
// import '../../../../../core/resources/manager_strings.dart';
// import '../../../../../core/resources/manager_styles.dart';
// import '../../../../../core/resources/manager_width.dart';
// import '../../../../../core/storage/local/app_settings_prefs.dart';
// import '../../../../../core/widgets/scaffold_with_back_button.dart';
// import '../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
// import '../../domain/di/di.dart';
// import '../controller/get_profile_controller.dart';
// import '../widgets/info_card.dart';
// import '../widgets/logout_widget.dart';
// import '../widgets/settings_tile_widget.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;
//
//   late final ProfileController profileController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     profileController = Get.find<ProfileController>();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldWithBackButton(
//       title: ManagerStrings.profileTitle,
//       onBack: () => Get.back(),
//       // Logic: use Obx to react to controller states; keep original UI structure
//       body: Obx(() {
//         // Loading (initial)
//         if (profileController.isLoading.value &&
//             profileController.profileData.value == null) {
//           return const LoadingWidget();
//         }
//
//         // Error (no data yet)
//         if (profileController.hasError.value &&
//             profileController.profileData.value == null) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     profileController.errorMessage.value.isEmpty
//                         ? 'Something went wrong'
//                         : profileController.errorMessage.value,
//                     style: getBoldTextStyle(
//                       color: Colors.red,
//                       fontSize: ManagerFontSize.s12,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 12),
//                   ElevatedButton.icon(
//                     onPressed: profileController.retryLoading,
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         // Success (or cached data)
//         final data = profileController.profileData.value!;
//         final name = data.data.name;
//         final phone = data.data.phone;
//         // final urlImage = data.data.;
//
//         const subscribedCount =
//             '4'; // TODO: replace with API field if available
//
//         return RefreshIndicator(
//           onRefresh: profileController.refreshProfileData,
//           displacement: 60,
//           color: ManagerColors.primaryColor,
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(
//                   parent: BouncingScrollPhysics(),
//                 ),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: SlideTransition(
//                       position: _slideAnimation,
//                       child: Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
//                         child: SizedBox(
//                           width: double.infinity,
//                           child: Column(
//                             children: [
//                               SizedBox(height: ManagerHeight.h24),
//
//                               /// ======= Profile Image With Verified (kept as-is)
//                               Stack(
//                                 alignment: Alignment.bottomRight,
//                                 children: [
//                                   const CircleAvatar(
//                                     radius: 45,
//                                     backgroundImage: AssetImage(
//                                         ManagerImages.imageFoodOneRemove),
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.all(4),
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.white,
//                                     ),
//                                     child: const Icon(
//                                       Icons.verified,
//                                       color: ManagerColors.primaryColor,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: ManagerHeight.h12),
//
//                               /// ======= Name Profile (bound to controller data)
//                               Text(
//                                 name,
//                                 style: getBoldTextStyle(
//                                   fontSize: ManagerFontSize.s14,
//                                   color: ManagerColors.black,
//                                 ),
//                               ),
//                               SizedBox(height: ManagerHeight.h4),
//
//                               /// ====== New User label (kept)
//                               Text(
//                                 ManagerStrings.newUser,
//                                 style: getRegularTextStyle(
//                                   fontSize: ManagerFontSize.s10,
//                                   color: ManagerColors.greyWithColor,
//                                 ),
//                               ),
//
//                               SizedBox(height: ManagerHeight.h16),
//
//                               /// ====== Phone & Subscribed services
//                               Row(
//                                 children: [
//                                   InfoCard(
//                                     value: phone,
//                                     label: ManagerStrings.phoneNumber,
//                                   ),
//                                   InfoCard(
//                                     value: subscribedCount,
//                                     label: ManagerStrings.subscribedServices,
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: ManagerHeight.h16),
//
//                               /// ====== Settings list title
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: Text(
//                                   ManagerStrings.listSettings,
//                                   style: getBoldTextStyle(
//                                     fontSize: ManagerFontSize.s12,
//                                     color: ManagerColors.black,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: ManagerHeight.h8),
//
//                               /// ====== Settings tiles
//                               SettingsTileWidget(
//                                 title: ManagerStrings.manageServices,
//                                 icon: ManagerIcons.profileIcon1,
//                                 onTap: () {
//                                   // TODO
//                                 },
//                               ),
//                               SettingsTileWidget(
//                                 title: ManagerStrings.editProfile,
//                                 icon: ManagerIcons.profileIcon3,
//                                 onTap: () {
//                                   // TODO
//                                   initUpdateAvatar(data.data.name, "");
//                                   Get.to(EditProfileScreen());
//                                 },
//                               ),
//                               SettingsTileWidget(
//                                 title: ManagerStrings.contactSupport,
//                                 icon: ManagerIcons.profileIcon4,
//                                 onTap: () {
//                                   // TODO
//                                 },
//                               ),
//                               SettingsTileWidget(
//                                 title: ManagerStrings.termsConditions,
//                                 icon: ManagerIcons.profileIcon5,
//                                 onTap: () {
//                                   // TODO
//                                 },
//                               ),
//
//                               /// ====== Logout
//                               LogoutWidget(
//                                 title: ManagerStrings.logout,
//                                 icon: ManagerIcons.profileIcon6,
//                                 onTap: () {
//                                   showDialogConfirmRegisterCompanyOffer(
//                                     title: ManagerStrings.titleConfirmation,
//                                     subTitle: ManagerStrings.messageSignout,
//                                     actionConfirmText:
//                                         ManagerStrings.buttonContinue,
//                                     actionCancel: ManagerStrings.buttonCancel,
//                                     context,
//                                     onConfirm: () async {
//                                       Navigator.pop(
//                                           context); // إغلاق نافذة التأكيد
//
//                                       // ✅ عرض Loading أثناء تسجيل الخروج
//                                       showDialog(
//                                         context: context,
//                                         barrierDismissible: false,
//                                         builder: (_) => const Center(
//                                             child: LoadingWidget()),
//                                       );
//
//                                       try {
//                                         final prefs = await SharedPreferences
//                                             .getInstance();
//                                         final appPrefs =
//                                             AppSettingsPrefs(prefs);
//
//                                         await appPrefs.clear();
//
//                                         await Future.delayed(
//                                             const Duration(milliseconds: 800));
//
//                                         // if (context.mounted)
//                                         //   Navigator.pop(context);
//                                         AppSnackbar.success("تم تسجيل الخروج");
//
//                                         if (context.mounted) {
//                                           Get.offAll(const SplashScreen());
//                                         }
//                                       } catch (e) {
//                                         if (context.mounted)
//                                           Navigator.pop(context);
//                                         AppSnackbar.error(
//                                             "حدث خطأ أثناء تسجيل الخروج: $e");
//                                       }
//                                     },
//                                     onCancel: () => Navigator.pop(context),
//                                   );
//                                 },
//                               ),
//
//                               /// Optional: tiny loader while refreshing
//                               if (profileController.isRefreshing.value) ...[
//                                 SizedBox(height: ManagerHeight.h12),
//                                 const LoadingWidget()
//                               ],
//
//                               SizedBox(height: ManagerHeight.h24),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     ).withHawaj(
//       section: HawajSections.settingsSection,
//       screen: HawajScreens.profileScreen,
//     );
//   }
// }
