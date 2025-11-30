import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../core/widgets/upload_media_widget.dart';
import '../controller/completed_profile_controller.dart';

class CompleteInformationScreen extends StatefulWidget {
  const CompleteInformationScreen({super.key});

  @override
  State<CompleteInformationScreen> createState() =>
      _CompleteInformationScreenState();
}

class _CompleteInformationScreenState extends State<CompleteInformationScreen> {
  // احتفظ بـ reference للـ controller
  late final CompletedProfileController controller;

  @override
  void initState() {
    super.initState();
    // استخدم Get.find() مرة واحدة فقط في initState
    controller = Get.find<CompletedProfileController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: Obx(() {
        return Stack(
          children: [
            /// --- Main Content ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ManagerHeight.h96),

                    /// Title
                    Align(
                      alignment: Get.locale?.languageCode == 'ar'
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Text(
                        ManagerStrings.profileSetupTitle,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.primaryColor,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: -0.2, end: 0, duration: 500.ms),
                    ),
                    SizedBox(height: ManagerHeight.h8),

                    /// Subtitle
                    Align(
                      alignment: Get.locale?.languageCode == 'ar'
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Text(
                        ManagerStrings.profileSetupSubtitle,
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.subtitleLoginTextColor,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 150.ms)
                          .slideY(begin: -0.1, end: 0, duration: 600.ms),
                    ),
                    SizedBox(height: ManagerHeight.h32),

                    /// صورة الملف الشخصي
                    Center(
                      child: Stack(
                        children: [
                          Obx(() {
                            return CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  ManagerColors.greyWithColor.withOpacity(0.2),
                              backgroundImage:
                                  controller.avatarImage.value != null
                                      ? FileImage(controller.avatarImage.value!)
                                      : null,
                              child: controller.avatarImage.value == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: ManagerColors.greyWithColor,
                                    )
                                  : null,
                            );
                          }),

                          /// مؤشر الرفع
                          Obx(() {
                            if (controller.isUploadingAvatar.value) {
                              return Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          }),

                          /// زر اختيار الصورة
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                _showImagePickerBottomSheet(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ManagerColors.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 100.ms)
                        .scale(begin: Offset(0.8, 0.8), end: Offset(1, 1)),
                    SizedBox(height: ManagerHeight.h32),

                    /// First Name
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.firstName,
                      hintText: ManagerStrings.firstName,
                      controller: controller.firstNameController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: ManagerColors.iconsColorInAuth,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 200.ms)
                        .slideX(begin: -0.3, end: 0, duration: 400.ms),
                    SizedBox(height: ManagerHeight.h14),

                    /// Last Name
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.lastName,
                      hintText: ManagerStrings.lastName,
                      controller: controller.lastNameController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: ManagerColors.iconsColorInAuth,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 350.ms)
                        .slideX(begin: 0.3, end: 0, duration: 400.ms),
                    SizedBox(height: ManagerHeight.h14),

                    /// Gender (Dropdown)
                    LabeledDropdownField(
                      label: ManagerStrings.gender,
                      hint: ManagerStrings.gender,
                      value: controller.gender.value == 0
                          ? null
                          : controller.gender.value,
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text(ManagerStrings.genderMale),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text(ManagerStrings.genderFemale),
                        ),
                      ],
                      onChanged: (val) {
                        controller.gender.value = val ?? 0;
                      },
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 500.ms)
                        .slideX(begin: -0.2, end: 0, duration: 400.ms),
                    SizedBox(height: ManagerHeight.h14),

                    /// Date of Birth
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.dob,
                      hintText: ManagerStrings.dob,
                      controller: controller.dateOfBirthController,
                      enabled: true,
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: ManagerColors.iconsColorInAuth,
                      ),
                      onButtonTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          controller.dateOfBirthController.text =
                              pickedDate.toIso8601String().split("T").first;
                        }
                      },
                      buttonWidget: Text(
                        ManagerStrings.dob,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: Colors.white,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 650.ms)
                        .slideX(begin: 0.3, end: 0, duration: 400.ms),
                    SizedBox(height: ManagerHeight.h32),

                    /// Continue Button
                    ButtonApp(
                      title: ManagerStrings.continueButton,
                      onPressed: () => controller.submitProfile(),
                      paddingWidth: 0,
                    ).animate().fadeIn(duration: 400.ms, delay: 800.ms).slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        ),

                    /// Error or Success Messages
                    if (controller.errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    SizedBox(height: ManagerHeight.h20),
                  ],
                ),
              ),
            ),

            /// --- Loading Overlay ---
            if (controller.isLoading.value) const LoadingWidget()
          ],
        );
      }),
    );
  }

  /// Bottom Sheet لاختيار الصورة
  void _showImagePickerBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(ManagerWidth.w20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ManagerHeight.h20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اختر صورة الملف الشخصي',
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.black,
              ),
            ),
            SizedBox(height: ManagerHeight.h20),
            UploadMediaField(
              label: 'صورة الملف الشخصي',
              hint: 'اختر صورة',
              note: 'الصور المدعومة: PNG, JPG, JPEG',
              file: controller.avatarImage,
              onFilePicked: (file) {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
