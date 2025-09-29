import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_strings.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/scaffold_with_back_button.dart';
import '../../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
import '../../../../../common/map/domain/entities/location_entity.dart';
import '../../../../../common/map_ticker/domain/di/di.dart';
import '../../../../../common/map_ticker/presenation/pages/map_ticker_screen.dart';
import '../controller/register_my_company_offer_provider_controller.dart';

class RegisterCompanyOfferProviderScreen extends StatelessWidget {
  const RegisterCompanyOfferProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterMyCompanyOfferProviderController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.registerCompany,
      body: Obx(() {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom +
                      ManagerHeight.h16,
                ),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ManagerHeight.h24),

                    TitleFormScreenWidget(
                      title: ManagerStrings.registerCompanyTitle,
                    ),
                    SubTitleFormScreenWidget(
                      subTitle: ManagerStrings.registerCompanySubtitle,
                    ),

                    SizedBox(height: ManagerHeight.h20),

                    // اسم الشركة
                    LabeledTextField(
                      label: ManagerStrings.companyName,
                      hintText: ManagerStrings.companyNameHint,
                      controller: controller.organizationNameController,
                      textInputAction: TextInputAction.next,
                      widthButton: ManagerWidth.w130,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // خدمات الشركة
                    LabeledTextField(
                      label: ManagerStrings.companyServices,
                      hintText: ManagerStrings.companyServicesHint,
                      controller: controller.organizationServicesController,
                      textInputAction: TextInputAction.next,
                      minLines: 4,
                      maxLines: 5,
                      widthButton: ManagerWidth.w130,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // الموقع
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.dob,
                      hintText: ManagerStrings.dob,
                      controller: controller.organizationLocationController,
                      enabled: true,
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: ManagerColors.iconsColorInAuth,
                      ),
                      onButtonTap: () async {
                        print("kjsdffffff");
                        final result = await Get.to(
                          () => const MapTickerScreen(),
                          binding: MapTickerBindings(),
                        );
                        if (result != null && result is LocationEntity) {
                          controller.organizationLocationController.text =
                              '${result.latitude},${result.longitude}';
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
                    // LabeledTextField(
                    //   label: ManagerStrings.setLocation,
                    //   hintText: 'اضغط لتحديد الموقع',
                    //   controller: controller.organizationLocationController,
                    //   enabled: false,
                    //   onButtonTap: () async {
                    //     print("kjsdffffff");
                    //     final result = await Get.to(
                    //       () => const MapTickerScreen(),
                    //       binding: MapTickerBindings(),
                    //     );
                    //
                    //     if (result != null && result is LocationEntity) {
                    //       controller.organizationLocationController.text =
                    //           '${result.latitude},${result.longitude}';
                    //     }
                    //   },
                    //   buttonWidget: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(Icons.location_on,
                    //           color: Colors.white, size: 16),
                    //       SizedBox(width: 4),
                    //       Text(
                    //         'حدد الموقع',
                    //         style: getBoldTextStyle(
                    //           fontSize: ManagerFontSize.s12,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   widthButton: ManagerWidth.w130,
                    // ),
                    // LabeledTextField(
                    //   label: ManagerStrings.setLocation,
                    //   hintText: ManagerStrings.setLocation,
                    //   controller: controller.organizationLocationController,
                    //   onButtonTap: () {
                    //     // TODO: فتح خريطة لاختيار الموقع
                    //   },
                    //   buttonWidget: Text(
                    //     ManagerStrings.setLocationButton,
                    //     style: getBoldTextStyle(
                    //       fontSize: ManagerFontSize.s12,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    //   widthButton: ManagerWidth.w130,
                    // ),
                    ,
                    const SizedBoxBetweenFieldWidgets(),

                    // العنوان التفصيلي
                    LabeledTextField(
                      label: ManagerStrings.detailedAddress,
                      hintText: ManagerStrings.detailedAddressHint,
                      controller:
                          controller.organizationDetailedAddressController,
                      textInputAction: TextInputAction.next,
                      widthButton: ManagerWidth.w130,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // المسؤول
                    LabeledTextField(
                      label: ManagerStrings.responsiblePerson,
                      hintText: ManagerStrings.responsiblePersonHint,
                      controller: controller.managerNameController,
                      textInputAction: TextInputAction.next,
                      widthButton: ManagerWidth.w130,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // رقم الهاتف
                    LabeledTextField(
                      label: ManagerStrings.phoneNumber,
                      hintText: ManagerStrings.phoneNumberHint,
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      widthButton: ManagerWidth.w130,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // ساعات العمل
                    LabeledTextField(
                      label: ManagerStrings.workingHours,
                      hintText: ManagerStrings.workingHoursHint,
                      controller: controller.workingHoursController,
                      textInputAction: TextInputAction.next,
                      widthButton: ManagerWidth.w130,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // شعار الشركة
                    UploadMediaField(
                      label: ManagerStrings.companyLogo,
                      hint: ManagerStrings.companyLogoHint,
                      note: ManagerStrings.companyLogoHint2,
                      file: controller.organizationLogo,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // السجل التجاري
                    LabeledTextField(
                      label: ManagerStrings.commercialNumber,
                      hintText: ManagerStrings.commercialNumberHint,
                      controller:
                          controller.commercialRegistrationNumberController,
                      textInputAction: TextInputAction.done,
                      widthButton: ManagerWidth.w130,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // رفع السجل التجاري
                    UploadMediaField(
                      label: ManagerStrings.commercialRecord,
                      hint: ManagerStrings.commercialRecordHint,
                      note: ManagerStrings.commercialRecordHint2,
                      file: controller.commercialRegistrationFile,
                    ),

                    SizedBox(height: ManagerHeight.h24),

                    // زر التسجيل
                    ButtonApp(
                      title: ManagerStrings.submitButton,
                      onPressed: () {
                        showDialogConfirmRegisterCompanyOffer(
                          title: ManagerStrings.confirmAddOrgTitle,
                          subTitle: ManagerStrings.confirmAddOrgSubtitle,
                          actionConfirmText:
                              ManagerStrings.confirmAddOrgConfirm,
                          actionCancel: ManagerStrings.confirmAddOrgCancel,
                          context,
                          onConfirm: controller.registerOrganization,
                          onCancel: controller.resetState,
                        );
                      },
                      paddingWidth: 0,
                    ),
                    SizedBox(height: ManagerHeight.h16),
                  ],
                ),
              ),
            ),

            // Loading Overlay
            if (controller.isLoading.value)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
