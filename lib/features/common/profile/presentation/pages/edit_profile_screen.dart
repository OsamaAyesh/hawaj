// lib/features/.../presentation/pages/edit_profile_screen.dart
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_icons.dart';
import '../../../../../core/resources/manager_images.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import '../../../../../core/widgets/button_app.dart';
import '../controller/update_profile_controller.dart';
import '../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;

  late final EditProfileController editController;

  @override
  void initState() {
    super.initState();

    editController = Get.find<EditProfileController>();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve:
              Interval(0.1 * index, 0.5 + 0.1 * index, curve: Curves.easeOut),
        ),
      );
    });

    _fadeAnimations = List.generate(4, (index) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.1 * index, 0.5 + 0.1 * index, curve: Curves.easeIn),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    // لا نعمل dispose للـ controllers هنا لأن GetX بيتكفّل فيهم داخل EditProfileController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.personalAccountInfo,
      body: Obx(() {
        final isLoading = editController.isLoading.value;

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: ManagerHeight.h20),

                  /// ===== Avatar =====
                  FadeTransition(
                    opacity: _fadeAnimations[0],
                    child: SlideTransition(
                      position: _slideAnimations[0],
                      child: Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: ManagerHeight.h45,
                              backgroundImage: editController
                                          .avatarFile.value !=
                                      null
                                  ? FileImage(editController.avatarFile.value!)
                                  : _buildAvatarFallback(),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: InkWell(
                                onTap: () async {
                                  await editController.pickAvatar();
                                  if (!mounted) return;
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  width: ManagerWidth.w22,
                                  height: ManagerHeight.h22,
                                  decoration: const BoxDecoration(
                                    color: ManagerColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Image.asset(
                                    ManagerIcons.profileIcon3,
                                    width: ManagerWidth.w16,
                                    height: ManagerHeight.h16,
                                    color: ManagerColors.white,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: ManagerHeight.h32),

                  /// ===== First & Last Name =====
                  FadeTransition(
                    opacity: _fadeAnimations[1],
                    child: SlideTransition(
                      position: _slideAnimations[1],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomPasswordField(
                            label: ManagerStrings.firstName,
                            isRequired: true,
                            iconPath: ManagerIcons.nameIcon,
                            isPasswordField: false,
                            controller: editController.firstNameController,
                          ),
                          SizedBox(height: ManagerHeight.h16),
                          CustomPasswordField(
                            label: ManagerStrings.lastName,
                            isRequired: true,
                            iconPath: ManagerIcons.nameIcon,
                            isPasswordField: false,
                            controller: editController.lastNameController,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: ManagerHeight.h16),

                  /// ===== Gender & DOB =====
                  FadeTransition(
                    opacity: _fadeAnimations[2],
                    child: SlideTransition(
                      position: _slideAnimations[2],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomPasswordField(
                            label: ManagerStrings.gender,
                            isRequired: false,
                            iconPath: ManagerIcons.profileIcon3,
                            isPasswordField: false,
                            controller: editController.genderController,
                          ),
                          SizedBox(height: ManagerHeight.h16),
                          // GestureDetector(
                          //   onTap: () async {
                          //     await editController.pickDob(context);
                          //     if (!mounted) return;
                          //   },
                          //   child: AbsorbPointer(
                          //     child: CustomPasswordField(
                          //       label: ManagerStrings.gender,
                          //       isRequired: false,
                          //       iconPath: ManagerIcons.profileIcon3,
                          //       isPasswordField: false,
                          //       controller: editController.dobController,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// ===== Save button =====
                  FadeTransition(
                    opacity: _fadeAnimations[3],
                    child: SlideTransition(
                      position: _slideAnimations[3],
                      child: ButtonApp(
                        title: ManagerStrings.edit,
                        onPressed: () async {
                          await editController.saveProfile(context);
                          if (!mounted) return;
                        },
                        paddingWidth: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: ManagerHeight.h20),
                ],
              ),
            ),

            /// ===== Full-screen Loading =====
            if (isLoading)
              Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true,
                  child: Container(
                    color: Colors.black.withOpacity(0.08),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        );
      }),
    ).withHawaj(
      section: HawajSections.settingsSection,
      screen: HawajScreens.editProfileScreen,
    );
  }

  ImageProvider _buildAvatarFallback() {
    if (editController.networkAvatarUrl.isNotEmpty) {
      return NetworkImage(editController.networkAvatarUrl);
    }
    return const AssetImage(ManagerImages.imageFoodOneRemove);
  }
}
