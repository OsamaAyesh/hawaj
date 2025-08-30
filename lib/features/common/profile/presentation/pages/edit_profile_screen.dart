import 'dart:io';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_icons.dart';
import '../../../../../core/resources/manager_images.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/widgets/button_app.dart';
import '../controller/update_profile_controller.dart'; // EditProfileController
import '../widgets/custom_text_field.dart';

/// Edit profile screen (name + optional avatar)
/// - Uses EditProfileController (GetX)
/// - Keeps original look & feel (animations, layout)
/// - Full-screen loading overlay while any operation is running
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;

  late final EditProfileController editController;

  // Only name is editable for now (phone is paused as requested)
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Observe app lifecycle to avoid drawing after surface loss
    WidgetsBinding.instance.addObserver(this);

    // Get controller instance
    editController = Get.find<EditProfileController>();

    // Seed initial name (if any)
    nameController.text = editController.name.value;

    // Animations (keep original timing/curves)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.1 * index, 0.5 + 0.1 * index, curve: Curves.easeOut),
        ),
      );
    });

    _fadeAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.1 * index, 0.5 + 0.1 * index, curve: Curves.easeIn),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause/resume the entrance animation to avoid render calls with no surface.
    if (state == AppLifecycleState.paused) {
      if (_controller.isAnimating) _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      if (!_controller.isAnimating && _controller.value < 1.0) {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = ManagerHeight.h45;

    return ScaffoldWithBackButton(
      title: ManagerStrings.personalAccountInfo,
      onBack: () => Get.back(),
      body: Obx(() {
        // Single busy flag for a full-screen overlay (pick/save/update)
        final bool isBusy = editController.isBusy;

        return Stack(
          children: [
            // ===================== Main Content =====================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: ManagerHeight.h20),

                  /// ===== Avatar + edit (picks via file_picker) =====
                  FadeTransition(
                    opacity: _fadeAnimations[0],
                    child: SlideTransition(
                      position: _slideAnimations[0],
                      child: Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: radius,
                              backgroundImage: editController.pickedAvatar.value != null
                                  ? FileImage(editController.pickedAvatar.value!)
                                  : const AssetImage(ManagerImages.imageFoodOneRemove)
                              as ImageProvider,
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: InkWell(
                                onTap: () async {
                                  // Pick image using file_picker (gallery/files)
                                  await editController.pickAvatarWithFilePicker();
                                  if (!mounted) return;
                                  final err = editController.avatarError.value;
                                  if (err != null) {
                                    Get.snackbar('Error', err,
                                        backgroundColor: Colors.red.shade100);
                                  }
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

                  /// ===== Name field only (phone is paused) =====
                  FadeTransition(
                    opacity: _fadeAnimations[1],
                    child: SlideTransition(
                      position: _slideAnimations[1],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomPasswordField(
                            label: ManagerStrings.fullName,
                            isRequired: false,
                            iconPath: ManagerIcons.nameIcon,
                            isPasswordField: false,
                            controller: nameController,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// ===== Save button =====
                  FadeTransition(
                    opacity: _fadeAnimations[2],
                    child: SlideTransition(
                      position: _slideAnimations[2],
                      child: ButtonApp(
                        title: ManagerStrings.edit,
                        onPressed: isBusy
                            ? (){}
                            : () async {
                          final ok = await editController.saveAll(
                            newName: nameController.text.trim(),
                            // If no image is selected, controller will skip avatar update
                            newAvatar: editController.pickedAvatar.value,
                          );

                          if (!mounted) return;

                          if (ok) {
                            // Defer pop to the next frame to avoid "no surface" render issues
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (Navigator.of(context).canPop()) {
                                Get.back();
                              }
                            });
                          } else {
                            Get.snackbar(
                              "Error",
                              editController.profileError.value ??
                                  editController.avatarError.value ??
                                  "Something went wrong",
                              backgroundColor: Colors.red.shade100,
                            );
                          }
                        },
                        paddingWidth: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: ManagerHeight.h20),
                ],
              ),
            ),

            // ===================== Full-screen Loading Overlay =====================
            if (isBusy)
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
    );
  }
}
