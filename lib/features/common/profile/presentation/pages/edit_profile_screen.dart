import 'dart:io';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_icons.dart';
import '../../../../../core/resources/manager_images.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/widgets/button_app.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenScreenState();
}

class _EditProfileScreenScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;


  @override
  void initState() {
    super.initState();


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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ScaffoldWithBackButton(

      title: ManagerStrings.personalAccountInfo,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ManagerHeight.h20),
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
                        backgroundImage: AssetImage(ManagerImages.imageFoodOneRemove)
                        as ImageProvider,
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () {},
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
            FadeTransition(
              opacity: _fadeAnimations[1],
              child: SlideTransition(
                position: _slideAnimations[1],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ManagerHeight.h8),
                    CustomPasswordField(
                      label: ManagerStrings.fullName,
                      isRequired: false,
                      iconPath: ManagerIcons.nameIcon,
                      isPasswordField: false,
                      controller: TextEditingController(),
                    ),
                    SizedBox(height: ManagerHeight.h16),
                    CustomPasswordField(
                      label: ManagerStrings.phoneNumber,
                      isRequired: false,
                      iconPath: ManagerIcons.phoneIcon,
                      isPasswordField: false,
                      controller:TextEditingController(),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FadeTransition(
              opacity: _fadeAnimations[2],
              child: SlideTransition(
                position: _slideAnimations[2],
                child: ButtonApp(
                  title: ManagerStrings.edit,
                  onPressed: () {},
                  paddingWidth: 0,
                ),
              ),
            ),
            SizedBox(height: ManagerHeight.h20),
          ],
        ),
      ),
    );
  }
}
