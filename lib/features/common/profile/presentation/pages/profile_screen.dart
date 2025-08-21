// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../../constants/di/dependency_injection.dart';
// import '../../../../../core/resources/manager_colors.dart';
// import '../../../../../core/resources/manager_font_size.dart';
// import '../../../../../core/resources/manager_height.dart';
// import '../../../../../core/resources/manager_icons.dart';
// import '../../../../../core/resources/manager_images.dart';
// import '../../../../../core/resources/manager_opacity.dart';
// import '../../../../../core/resources/manager_radius.dart';
// import '../../../../../core/resources/manager_strings.dart';
// import '../../../../../core/resources/manager_styles.dart';
// import '../../../../../core/resources/manager_width.dart';
// import '../../../../../core/routes/custom_transitions.dart';
// import '../../../../../core/storage/local/app_settings_prefs.dart';
// import '../../../../../core/util/role_utils.dart';
// import '../../../../../core/widgets/custom_confirm_dialog.dart';
// import '../../../../../core/widgets/loading_widget.dart';
// import '../../../../../core/widgets/scaffold_with_back_button.dart';
// import '../../../../add_bank_information/domain/di/di.dart';
// import '../../../../farmer/home/presentation/pages/home_screen_farmer.dart';
// import '../../../../trader/home/presentation/pages/home_screen_trader.dart';
// import '../../data/repository/change_password_repository.dart';
// import '../../data/repository/edit_profile_repository.dart';
// import '../../domain/di/di.dart';
// import '../../domain/use_case/change_password_use_case.dart';
// import '../../domain/use_case/edit_profile_use_case.dart';
// import '../../domain/use_case/logout_use_case.dart';
// import '../controller/changer_password_controller.dart';
// import '../controller/edit_profile_controller.dart';
// import '../controller/get_profile_controller.dart';
// import '../controller/logout_controller.dart';
// import 'contact_us_screen.dart';
// import 'edit_information_profile_screen.dart';
// import 'edit_password_screen.dart';
// import 'information_bank_account.dart';
// import 'privacy_policy.dart';
// import 'package:dotted_border/dotted_border.dart';
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
//   @override
//   void initState() {
//
//     super.initState();
//
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     _slideAnimation = Tween<Offset>(
//         begin: const Offset(0, 0.1), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//     _fadeAnimation = Tween<double>(begin: 0, end: 1)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//
//     _controller.forward();
//   }
//
//
//
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  ScaffoldWithBackButton(
//       title: ManagerStrings.profileTitle,
//       onBack: (){},
//       body:  SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: ManagerWidth.w16),
//               child: Column(
//                 children: [
//                   SizedBox(height: ManagerHeight.h24),
//                   Stack(
//                     alignment: Alignment.bottomRight,
//                     children: [
//                       // CircleAvatar(
//                       //   radius: ManagerHeight.h45,
//                       //   backgroundImage: const AssetImage(
//                       //       ManagerImages.profileInHomeImage),
//                       // ),
//                       Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white,
//                         ),
//                         child: const Icon(Icons.verified,
//                             color: ManagerColors.primaryColor,
//                             size: 20),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: ManagerHeight.h12),
//                   Text("محمد علي إسماعيل",
//                       style: getBoldTextStyle(
//                           fontSize: ManagerFontSize.s14,
//                           color: ManagerColors.black)),
//                   SizedBox(height: ManagerHeight.h4),
//                   Text(
//                     ManagerStrings.newUser,
//                     style: getRegularTextStyle(
//                       fontSize: ManagerFontSize.s10,
//                       color: ManagerColors.greyWithColor,
//                     ),
//                   ),
//                   SizedBox(height: ManagerHeight.h4),
//
//                   SizedBox(height: ManagerHeight.h16),
//                   Row(
//                     children: [
//                       _infoCard(
//                           "${profile?.ratesAverage ?? ""} ★",
//                           ManagerStrings.profileScreenHint3,
//                           subText:
//                           "(حسب ${profile?.ratesCount})"),
//                       _infoCard(profile?.createdAt ?? "",
//                           ManagerStrings.profileScreenHint4),
//                       _infoCard(
//                           profile?.completedOrders.toString() ??
//                               "",
//                           ManagerStrings.profileScreenHint5),
//                     ],
//                   ),
//                   SizedBox(height: ManagerHeight.h24),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       ManagerStrings.profileScreenHint6,
//                       style: getBoldTextStyle(
//                           fontSize: ManagerFontSize.s12,
//                           color: ManagerColors.black),
//                     ),
//                   ),
//                   SizedBox(height: ManagerHeight.h16),
//                   _settingTile(
//                       ManagerStrings.profileScreenHint7,
//                       ManagerIcons.profileIcon1, onTap: () {
//                     initChangerPasswordPassword();
//                     Get.put(ChangePasswordUseCase(
//                         GetIt.I<ChangePasswordRepository>()));
//                     Get.put(
//                         ChangePasswordController(Get.find()));
//                     Navigator.of(context).push(
//                       fadeSlideFromBottom(
//                           const EditPasswordScreen()),
//                     );
//                   }),
//                   _settingTile(
//                       ManagerStrings.profileScreenHint8,
//                       ManagerIcons.profileIcon2, onTap: () {
//                     initEditProfileRequest();
//
//                     Get.put(EditProfileUseCase(
//                         GetIt.I<EditProfileRepository>()));
//                     Get.put(EditProfileController(Get.find()));
//                     Navigator.of(context).push(
//                       fadeSlideFromBottom(
//                           const EditInformationProfileScreen()),
//                     );
//                   }),
//                   _settingTile(
//                       ManagerStrings.profileScreenHint9,
//                       ManagerIcons.profileIcon3, onTap: () {
//                     initEditAccountBank();
//                     initGetInformationBank();
//                     Navigator.of(context).push(
//                       fadeSlideFromBottom(
//                           const InformationBankAccount()),
//                     );
//                   }),
//                   _settingTile(
//                       ManagerStrings.profileScreenHint10,
//                       ManagerIcons.profileIcon4, onTap: () {
//                     initAddReport();
//                     Navigator.of(context).push(
//                       fadeSlideFromBottom(
//                           const ContactUsScreen()),
//                     );
//                   }),
//                   _settingTile(
//                       ManagerStrings.profileScreenHint11,
//                       ManagerIcons.profileIcon5, onTap: () {
//                     Navigator.of(context).push(
//                       fadeSlideFromBottom(
//                           const PrivacyPolicy()),
//                     );
//                   }),
//                   _logoutWidget(
//                     ManagerStrings.profileScreenHint13,
//                     ManagerIcons.deleteAccountIcon,
//                     onTap: () {},
//                   ),
//                   _logoutWidget(
//                     ManagerStrings.profileScreenHint12,
//                     ManagerIcons.profileIcon6,
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (_) => CustomConfirmDialog(
//                           title: ManagerStrings
//                               .profileScreenDialogTitle,
//                           subtitle: ManagerStrings
//                               .profileScreenDialogSubTitle,
//                           confirmText: ManagerStrings
//                               .profileScreenDialogHint1,
//                           cancelText: ManagerStrings
//                               .profileScreenDialogHint2,
//                           onConfirm: () {
//                             Navigator.of(context).pop();
//                             Get.find<LogoutController>()
//                                 .logout();
//                           },
//                           onCancel: () =>
//                               Navigator.of(context).pop(),
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: ManagerHeight.h24),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _infoCard(String value, String label, {String? subText}) {
//     return Expanded(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w4),
//         child: DottedBorder(
//           color: ManagerColors.strokColor,
//           borderType: BorderType.RRect,
//           radius: Radius.circular(ManagerRadius.r6),
//           dashPattern: const [6, 3],
//           strokeWidth: 1.2,
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
//             child: Center(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w2),
//                     child: Text(value,
//                         maxLines: 1,
//                         style: getBoldTextStyle(
//                           fontSize: ManagerFontSize.s12,
//                           color: ManagerColors.black,
//                         )),
//                   ),
//                   SizedBox(height: ManagerHeight.h4),
//                   Text(label,
//                       style: getRegularTextStyle(
//                         fontSize: ManagerFontSize.s11,
//                         color: Colors.grey,
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _settingTile(String title, String icon, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(ManagerRadius.r6),
//           border: Border.all(
//               color:
//               ManagerColors.strokColor.withOpacity(ManagerOpacity.op0_34)),
//         ),
//         child: Row(
//           children: [
//             Image.asset(icon,
//                 height: ManagerHeight.h24, width: ManagerWidth.w24),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(title,
//                   style: getBoldTextStyle(
//                       fontSize: ManagerFontSize.s12,
//                       color: ManagerColors.black),
//                   overflow: TextOverflow.ellipsis),
//             ),
//             const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _logoutWidget(
//       String title,
//       String icon, {
//         VoidCallback? onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(ManagerRadius.r6),
//           border: Border.all(
//               color:
//               ManagerColors.strokColor.withOpacity(ManagerOpacity.op0_34)),
//         ),
//         child: Row(
//           children: [
//             Image.asset(icon,
//                 height: ManagerHeight.h24, width: ManagerWidth.w24),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(title,
//                   style: getBoldTextStyle(
//                       fontSize: ManagerFontSize.s12, color: ManagerColors.red),
//                   overflow: TextOverflow.ellipsis),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
