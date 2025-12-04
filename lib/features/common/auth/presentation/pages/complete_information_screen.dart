import 'dart:io';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../core/widgets/lable_drop_down_button.dart';
import '../controller/completed_profile_controller.dart';

class CompleteInformationScreen extends StatefulWidget {
  const CompleteInformationScreen({super.key});

  @override
  State<CompleteInformationScreen> createState() =>
      _CompleteInformationScreenState();
}

class _CompleteInformationScreenState extends State<CompleteInformationScreen> {
  // ✅ إنشاء Controllers محلية في الـ State بدلاً من استخدام controllers من GetX
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController dateOfBirthController;

  late final CompletedProfileController controller;

  @override
  void initState() {
    super.initState();

    // ✅ تهيئة Controllers المحلية
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    dateOfBirthController = TextEditingController();

    // ✅ جلب GetX Controller
    controller = Get.find<CompletedProfileController>();
  }

  @override
  void dispose() {
    // ✅ التخلص من Controllers المحلية فقط عند dispose
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
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

                    /// First Name - استخدام Controller المحلي
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.firstName,
                      hintText: ManagerStrings.firstName,
                      controller: firstNameController,
                      // ✅ Controller محلي
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

                    /// Last Name - استخدام Controller المحلي
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.lastName,
                      hintText: ManagerStrings.lastName,
                      controller: lastNameController,
                      // ✅ Controller محلي
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

                    /// Date of Birth - استخدام Controller المحلي
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.dob,
                      hintText: ManagerStrings.dob,
                      controller: dateOfBirthController,
                      // ✅ Controller محلي
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
                          dateOfBirthController.text =
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

                    /// Continue Button - تمرير القيم من Controllers المحلية
                    ButtonApp(
                      title: ManagerStrings.continueButton,
                      onPressed: () => _submitProfile(),
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

  /// ✅ دالة لإرسال البيانات - تنسخ القيم من Controllers المحلية
  Future<void> _submitProfile() async {
    // نسخ القيم من Controllers المحلية إلى GetX Controller
    controller.firstNameController.text = firstNameController.text;
    controller.lastNameController.text = lastNameController.text;
    controller.dateOfBirthController.text = dateOfBirthController.text;

    // استدعاء دالة الإرسال
    await controller.submitProfile();
  }

  /// Bottom Sheet لاختيار الصورة باستخدام FilePicker
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
            /// العنوان
            Text(
              'اختر صورة الملف الشخصي',
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s16,
                color: ManagerColors.black,
              ),
            ),
            SizedBox(height: ManagerHeight.h24),

            /// خيار المعرض
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.photo_library,
                  color: ManagerColors.primaryColor,
                  size: 28,
                ),
              ),
              title: Text(
                'اختيار من المعرض',
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: ManagerColors.black,
                ),
              ),
              subtitle: Text(
                'اختر صورة من معرض الصور',
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.greyWithColor,
                ),
              ),
              onTap: () async {
                Get.back();
                await _pickImageFromGallery();
              },
            ),

            Divider(height: ManagerHeight.h24),

            /// خيار الملفات
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.insert_drive_file,
                  color: ManagerColors.primaryColor,
                  size: 28,
                ),
              ),
              title: Text(
                'اختيار من الملفات',
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: ManagerColors.black,
                ),
              ),
              subtitle: Text(
                'تصفح جميع الملفات',
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.greyWithColor,
                ),
              ),
              onTap: () async {
                Get.back();
                await _pickImageFromFiles();
              },
            ),

            SizedBox(height: ManagerHeight.h16),

            /// زر الإلغاء
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w32,
                  vertical: ManagerHeight.h12,
                ),
              ),
              child: Text(
                'إلغاء',
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: ManagerColors.greyWithColor,
                ),
              ),
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// دالة لاختيار الصورة من المعرض
  Future<void> _pickImageFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        final fileSize = await file.length();
        if (fileSize > 5 * 1024 * 1024) {
          Get.snackbar(
            'خطأ',
            'حجم الصورة كبير جداً. الحد الأقصى 5 ميجابايت',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            margin: EdgeInsets.all(ManagerWidth.w16),
            borderRadius: 8,
          );
          return;
        }

        controller.avatarImage.value = file;

        Get.snackbar(
          'نجح',
          'تم اختيار الصورة بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          margin: EdgeInsets.all(ManagerWidth.w16),
          borderRadius: 8,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      debugPrint('خطأ في اختيار الصورة: $e');
      Get.snackbar(
        'خطأ',
        'فشل اختيار الصورة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: EdgeInsets.all(ManagerWidth.w16),
        borderRadius: 8,
      );
    }
  }

  /// دالة لاختيار الصورة من جميع الملفات
  Future<void> _pickImageFromFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        final fileSize = await file.length();
        if (fileSize > 5 * 1024 * 1024) {
          Get.snackbar(
            'خطأ',
            'حجم الصورة كبير جداً. الحد الأقصى 5 ميجابايت',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            margin: EdgeInsets.all(ManagerWidth.w16),
            borderRadius: 8,
          );
          return;
        }

        controller.avatarImage.value = file;

        Get.snackbar(
          'نجح',
          'تم اختيار الصورة بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          margin: EdgeInsets.all(ManagerWidth.w16),
          borderRadius: 8,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      debugPrint('خطأ في اختيار الصورة: $e');
      Get.snackbar(
        'خطأ',
        'فشل اختيار الصورة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: EdgeInsets.all(ManagerWidth.w16),
        borderRadius: 8,
      );
    }
  }
}
