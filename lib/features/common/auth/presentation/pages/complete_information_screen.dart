import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/labeled_text_field.dart';
import '../controller/completed_profile_controller.dart';

class CompleteInformationScreen extends StatelessWidget {
  const CompleteInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompletedProfileController>();

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
                          fontSize: ManagerFontSize.s14,
                          color: ManagerColors.primaryColor,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: -0.2, end: 0, duration: 500.ms),
                    ),

                    SizedBox(height: ManagerHeight.h4),

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

                    /// Full Name
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.fullNameLabel,
                      hintText: ManagerStrings.fullNameHint,
                      controller: controller.firstNameController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: ManagerHeight.h12),
                        child: Image.asset(
                          ManagerIcons.nameIcon,
                          height: ManagerHeight.h12,
                          width: ManagerWidth.w14,
                          color: ManagerColors.iconsColorInAuth,
                        ),
                      ),
                      minLines: 1,
                      maxLines: 1,
                    ),

                    SizedBox(height: ManagerHeight.h14),

                    /// Email
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.emailLabel,
                      hintText: ManagerStrings.emailHint,
                      controller: controller.emailController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: ManagerHeight.h12),
                        child: Image.asset(
                          ManagerIcons.mailIcon,
                          height: ManagerHeight.h12,
                          width: ManagerWidth.w14,
                          color: ManagerColors.iconsColorInAuth,
                        ),
                      ),
                      minLines: 1,
                      maxLines: 1,
                    ),

                    SizedBox(height: ManagerHeight.h14),

                    /// Location
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.locationLabel,
                      hintText: ManagerStrings.locationHint,
                      controller: controller.locationController,
                      minLines: 1,
                      maxLines: 1,
                      onButtonTap: () {},
                      enabled: true,
                      buttonWidget: Text(
                        ManagerStrings.locationButton,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: ManagerHeight.h48),

                    /// Continue Button
                    ButtonApp(
                      title: ManagerStrings.continueButton,
                      onPressed: () => controller.submitProfile(),
                      paddingWidth: 0,
                    ),

                    if (controller.errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    if (controller.isSuccess.value)
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Profile updated successfully!",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            /// --- Loading Overlay ---
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }
}


// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_font_size.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_icons.dart';
// import 'package:app_mobile/core/resources/manager_strings.dart';
// import 'package:app_mobile/core/resources/manager_styles.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/widgets/button_app.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';
//
// import '../../../../../core/widgets/labeled_text_field.dart';
// import '../../../../../core/widgets/upload_media_widget.dart';
//
// class CompleteInformationScreen extends StatelessWidget {
//   const CompleteInformationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ManagerColors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: ManagerHeight.h96),
//
//               /// Welcome Title
//               Align(
//                 alignment: Get.locale?.languageCode == 'ar'
//                     ? Alignment.topRight
//                     : Alignment.topLeft,
//                 child: Text(
//                   ManagerStrings.profileSetupTitle,
//                   style: getBoldTextStyle(
//                     fontSize: ManagerFontSize.s14,
//                     color: ManagerColors.primaryColor,
//                   ),
//                 )
//                     .animate()
//                     .fadeIn(duration: 500.ms)
//                     .slideY(begin: -0.2, end: 0, duration: 500.ms),
//               ),
//
//               SizedBox(height: ManagerHeight.h4),
//
//               /// Welcome Subtitle
//               Align(
//                 alignment: Get.locale?.languageCode == 'ar'
//                     ? Alignment.topRight
//                     : Alignment.topLeft,
//                 child: Text(
//                   ManagerStrings.profileSetupSubtitle,
//                   style: getRegularTextStyle(
//                     fontSize: ManagerFontSize.s12,
//                     color: ManagerColors.subtitleLoginTextColor,
//                   ),
//                 )
//                     .animate()
//                     .fadeIn(duration: 600.ms, delay: 150.ms)
//                     .slideY(begin: -0.1, end: 0, duration: 600.ms),
//               ),
//
//               SizedBox(height: ManagerHeight.h32),
//
//               /// Name Field Widget
//               LabeledTextField(
//                 widthButton: ManagerWidth.w130,
//                 label: ManagerStrings.fullNameLabel,
//                 hintText: ManagerStrings.fullNameHint,
//                 controller: TextEditingController(),
//                 isPhoneField: true,
//                 textInputAction: TextInputAction.next,
//                 prefixIcon: Padding(
//                   padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
//                   child: Image.asset(
//                     ManagerIcons.nameIcon,
//                     height: ManagerHeight.h12,
//                     width: ManagerWidth.w14,
//                     color: ManagerColors.iconsColorInAuth,
//                   ),
//                 ),
//                 minLines: 1,
//                 maxLines: 1,
//               )
//                   .animate()
//                   .fadeIn(duration: 500.ms, delay: 300.ms)
//                   .slideX(
//                   begin: Get.locale?.languageCode == 'ar' ? -0.2 : 0.2,
//                   end: 0,
//                   duration: 500.ms),
//
//               SizedBox(height: ManagerHeight.h14),
//
//               /// Email Text Field Widget
//               LabeledTextField(
//                 widthButton: ManagerWidth.w130,
//                 label: ManagerStrings.emailLabel,
//                 hintText: ManagerStrings.emailHint,
//                 controller: TextEditingController(),
//                 isEmailField: true,
//                 textInputAction: TextInputAction.next,
//                 prefixIcon: Padding(
//                   padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
//                   child: Image.asset(
//                     ManagerIcons.mailIcon,
//                     height: ManagerHeight.h12,
//                     width: ManagerWidth.w14,
//                     color: ManagerColors.iconsColorInAuth,
//                   ),
//                 ),
//                 minLines: 1,
//                 maxLines: 1,
//               )
//                   .animate()
//                   .fadeIn(duration: 500.ms, delay: 450.ms)
//                   .slideX(
//                   begin: Get.locale?.languageCode == 'ar' ? -0.2 : 0.2,
//                   end: 0,
//                   duration: 500.ms),
//
//               SizedBox(height: ManagerHeight.h14),
//
//               /// Location Field
//               LabeledTextField(
//                 widthButton: ManagerWidth.w130,
//                 label: ManagerStrings.locationLabel,
//                 hintText: ManagerStrings.locationHint,
//                 controller: TextEditingController(text: ""),
//                 minLines: 1,
//                 maxLines: 1,
//                 onButtonTap: () {},
//                 enabled: true,
//                 buttonWidget: Text(
//                   ManagerStrings.locationButton,
//                   style: getBoldTextStyle(
//                     fontSize: ManagerFontSize.s12,
//                     color: Colors.white,
//                   ),
//                 ),
//               )
//                   .animate()
//                   .fadeIn(duration: 500.ms, delay: 600.ms)
//                   .slideX(
//                   begin: Get.locale?.languageCode == 'ar' ? -0.2 : 0.2,
//                   end: 0,
//                   duration: 500.ms),
//
//               SizedBox(height: ManagerHeight.h14),
//
//               /// Upload Image Profile Widget
//               // UploadProfileImageField(
//               //   label: ManagerStrings.profileImageLabel,
//               //   hint: ManagerStrings.profileImageHint,
//               //   note: ManagerStrings.profileImageNote,
//               //   onTap: () {
//               //     // Action Upload Image
//               //   },
//               // )
//               //     .animate()
//               //     .fadeIn(duration: 600.ms, delay: 750.ms)
//               //     .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
//
//               SizedBox(height: ManagerHeight.h48),
//
//               /// Continue Button Widget
//               ButtonApp(
//                 title: ManagerStrings.continueButton,
//                 onPressed: () {},
//                 paddingWidth: 0,
//               )
//                   .animate()
//                   .fadeIn(duration: 500.ms, delay: 900.ms)
//                   .slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOutBack),
//             ],
//           ).animate()
//               .fadeIn(duration: 400.ms)
//               .slideY(begin: 0.1, end: 0, duration: 400.ms),
//         ),
//       ),
//     );
//   }
// }
