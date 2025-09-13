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

import '../../../../../constants/di/dependency_injection.dart';
import '../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../core/widgets/lable_drop_down_button.dart';
import '../../domain/use_case/completed_profile_use_case.dart';
import '../controller/completed_profile_controller.dart';

class CompleteInformationScreen extends StatefulWidget {
  const CompleteInformationScreen({super.key});

  @override
  State<CompleteInformationScreen> createState() =>
      _CompleteInformationScreenState();
}

class _CompleteInformationScreenState
    extends State<CompleteInformationScreen> {

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<CompletedProfileController>()) {
      final useCase = instance<CompletedProfileUseCase>();
      Get.put(CompletedProfileController(useCase));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: GetBuilder<CompletedProfileController>(
        builder: (controller) {
          return Obx(() {
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
                        LabeledDropdownField<int>(
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
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 800.ms)
                            .slideY(
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
                if (controller.isLoading.value)
                  const LoadingWidget()
              ],
            );
          });
        },
      ),
    );
  }
}