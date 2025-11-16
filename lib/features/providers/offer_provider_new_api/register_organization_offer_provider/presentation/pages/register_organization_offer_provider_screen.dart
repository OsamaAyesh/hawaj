import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_strings.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/scaffold_with_back_button.dart';
import '../../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
import '../../../../../common/map_ticker/domain/di/di.dart';
import '../../../../../common/map_ticker/domain/entities/location_ticker_entity.dart';
import '../../../../../common/map_ticker/presenation/pages/map_ticker_screen.dart';
import '../controllers/register_organization_offer_provider_controller.dart';

class RegisterOrganizationOfferProviderScreen extends StatelessWidget {
  const RegisterOrganizationOfferProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterOrganizationOfferProviderController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.registerCompany,
      body: Stack(
        children: [
          // Main Content
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

                  // Title & Subtitle
                  TitleFormScreenWidget(
                    title: ManagerStrings.registerCompanyTitle,
                  ),
                  SubTitleFormScreenWidget(
                    subTitle: ManagerStrings.registerCompanySubtitle,
                  ),

                  SizedBox(height: ManagerHeight.h20),

                  // Organization Name
                  LabeledTextField(
                    label: ManagerStrings.companyName,
                    hintText: ManagerStrings.companyNameHint,
                    controller: controller.organizationNameController,
                    textInputAction: TextInputAction.next,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // Organization Services
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

                  // Organization Type Dropdown
                  Obx(() {
                    if (controller.isLoadingTypes.value) {
                      return Container(
                        padding: EdgeInsets.all(ManagerHeight.h16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (controller.typesErrorMessage.isNotEmpty) {
                      return Container(
                        padding: EdgeInsets.all(ManagerHeight.h16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              controller.typesErrorMessage.value,
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: ManagerHeight.h8),
                            ElevatedButton.icon(
                              onPressed: controller.retryFetchTypes,
                              icon: Icon(Icons.refresh),
                              label: Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }

                    return LabeledDropdownField(
                      label: 'نوع المؤسسة',
                      hint: 'اختر نوع المؤسسة',
                      value: controller.selectedOrganizationType.value,
                      items: controller.organizationTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.organizationType),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedOrganizationType.value = value;
                      },
                    );
                  }),
                  const SizedBoxBetweenFieldWidgets(),

                  // Location
                  LabeledTextField(
                    label: ManagerStrings.setLocation,
                    hintText: 'اضغط لتحديد الموقع',
                    controller: controller.organizationLocationController,
                    enabled: true,
                    onButtonTap: () async {
                      final result = await Get.to(
                        () => const MapTickerScreen(),
                        binding: MapTickerBindings(),
                      );

                      if (result != null && result is LocationTickerEntity) {
                        controller.organizationLocationController.text =
                            '${result.latitude},${result.longitude}';
                      }
                    },
                    buttonWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'حدد الموقع',
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // Detailed Address
                  LabeledTextField(
                    label: ManagerStrings.detailedAddress,
                    hintText: ManagerStrings.detailedAddressHint,
                    controller:
                        controller.organizationDetailedAddressController,
                    textInputAction: TextInputAction.next,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // Manager Name
                  LabeledTextField(
                    label: ManagerStrings.responsiblePerson,
                    hintText: ManagerStrings.responsiblePersonHint,
                    controller: controller.managerNameController,
                    textInputAction: TextInputAction.next,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // Phone Number
                  LabeledTextField(
                    label: ManagerStrings.phoneNumber,
                    hintText: ManagerStrings.phoneNumberHint,
                    controller: controller.phoneNumberController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // Working Hours
                  LabeledTextField(
                    label: ManagerStrings.workingHours,
                    hintText: ManagerStrings.workingHoursHint,
                    controller: controller.workingHoursController,
                    textInputAction: TextInputAction.next,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // Organization Logo
                  UploadMediaField(
                    label: ManagerStrings.companyLogo,
                    hint: ManagerStrings.companyLogoHint,
                    note: ManagerStrings.companyLogoHint2,
                    file: controller.organizationLogo,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // Organization Banner (Optional)
                  UploadMediaField(
                    label: 'صورة الغلاف (اختياري)',
                    hint: 'اختر صورة الغلاف',
                    note: 'الصور المدعومة: PNG, JPG, JPEG',
                    file: controller.organizationBanner,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // Commercial Registration Number
                  LabeledTextField(
                    label: ManagerStrings.commercialNumber,
                    hintText: ManagerStrings.commercialNumberHint,
                    controller:
                        controller.commercialRegistrationNumberController,
                    textInputAction: TextInputAction.done,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // Commercial Registration File
                  UploadMediaField(
                    label: ManagerStrings.commercialRecord,
                    hint: ManagerStrings.commercialRecordHint,
                    note: ManagerStrings.companyLogoHint2,
                    file: controller.commercialRegistrationFile,
                  ),

                  SizedBox(height: ManagerHeight.h24),

                  // Submit Button
                  ButtonApp(
                    title: ManagerStrings.submitButton,
                    onPressed: () {
                      showDialogConfirmRegisterCompanyOffer(
                        title: ManagerStrings.confirmAddOrgTitle,
                        subTitle: ManagerStrings.confirmAddOrgSubtitle,
                        actionConfirmText: ManagerStrings.confirmAddOrgConfirm,
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
          Obx(() {
            if (!controller.isLoading.value) {
              return const SizedBox.shrink();
            }
            return LoadingWidget();
          }),
        ],
      ),
    ).withHawaj(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.createCompanyDailyOffer,
    );
  }
}
