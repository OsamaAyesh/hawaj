import 'dart:io';

import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_colors.dart';
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
import '../controller/update_organization_offer_provider_controller.dart';

class UpdateOrganizationOfferProviderScreen extends StatefulWidget {
  const UpdateOrganizationOfferProviderScreen({super.key});

  @override
  State<UpdateOrganizationOfferProviderScreen> createState() =>
      _UpdateOrganizationOfferProviderScreenState();
}

class _UpdateOrganizationOfferProviderScreenState
    extends State<UpdateOrganizationOfferProviderScreen> {
  late final UpdateOrganizationOfferProviderController controller;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<UpdateOrganizationOfferProviderController>();

    // انتظر frame واحد للتأكد من تهيئة الـ Controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // عرض loading حتى يتم التهيئة
    if (!isInitialized) {
      return Scaffold(
        backgroundColor: ManagerColors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: ManagerColors.primaryColor,
          ),
        ),
      );
    }

    return ScaffoldWithBackButton(
      title: 'تعديل المؤسسة',
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
                    title: 'تعديل بيانات المؤسسة',
                  ),
                  SubTitleFormScreenWidget(
                    subTitle: 'قم بتحديث بيانات مؤسستك',
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
                    hintText: 'خط الطول',
                    controller: controller.organizationLocationLatController,
                    enabled: true,
                    onButtonTap: () async {
                      final result = await Get.to(
                        () => const MapTickerScreen(),
                        binding: MapTickerBindings(),
                      );

                      if (result != null && result is LocationTickerEntity) {
                        controller.organizationLocationLatController.text =
                            result.latitude.toString();
                        controller.organizationLocationLngController.text =
                            result.longitude.toString();
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

                  // Longitude (Hidden field but needed)
                  LabeledTextField(
                    label: 'عرض المؤسسة',
                    hintText: 'خط العرض',
                    controller: controller.organizationLocationLngController,
                    textInputAction: TextInputAction.next,
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
                  _buildImageField(
                    controller: controller,
                    label: ManagerStrings.companyLogo,
                    hint: ManagerStrings.companyLogoHint,
                    note: ManagerStrings.companyLogoHint2,
                    file: controller.organizationLogo,
                    currentImageUrl: controller.currentOrganizationLogo.value,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // Organization Banner (Optional)
                  _buildImageField(
                    controller: controller,
                    label: 'صورة الغلاف (اختياري)',
                    hint: 'اختر صورة الغلاف',
                    note: 'الصور المدعومة: PNG, JPG, JPEG',
                    file: controller.organizationBanner,
                    currentImageUrl: controller.currentOrganizationBanner.value,
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
                  _buildFileField(
                    controller: controller,
                    label: ManagerStrings.commercialRecord,
                    hint: ManagerStrings.commercialRecordHint,
                    note: ManagerStrings.companyLogoHint2,
                    file: controller.commercialRegistrationFile,
                    currentFileUrl:
                        controller.currentCommercialRegistration.value,
                  ),

                  SizedBox(height: ManagerHeight.h24),

                  // Submit Button
                  ButtonApp(
                    title: 'تحديث البيانات',
                    onPressed: () {
                      showDialogConfirmRegisterCompanyOffer(
                        title: 'تأكيد التحديث',
                        subTitle: 'هل أنت متأكد من تحديث بيانات المؤسسة؟',
                        actionConfirmText: 'نعم، تحديث',
                        actionCancel: 'إلغاء',
                        context,
                        onConfirm: controller.updateOrganization,
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
      screen: HawajScreens.addNewOffer,

      ///Error
    );
  }

  // ==================== Build Image Field with Current Image ====================
  Widget _buildImageField({
    required UpdateOrganizationOfferProviderController controller,
    required String label,
    required String hint,
    required String note,
    required Rx<File?> file,
    required String currentImageUrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الصورة الحالية
        Obx(() {
          // إخفاء الصورة الحالية إذا تم اختيار صورة جديدة
          if (currentImageUrl.isEmpty || file.value != null) {
            return SizedBox.shrink();
          }

          return Container(
            margin: EdgeInsets.only(bottom: ManagerHeight.h8),
            padding: EdgeInsets.all(ManagerHeight.h12),
            decoration: BoxDecoration(
              color: ManagerColors.greyWithColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ManagerColors.greyWithColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الصورة الحالية:',
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.greyWithColor,
                  ),
                ),
                SizedBox(height: ManagerHeight.h8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: currentImageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 120,
                      color: ManagerColors.greyWithColor.withOpacity(0.2),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 120,
                      color: ManagerColors.greyWithColor.withOpacity(0.2),
                      child: Icon(Icons.broken_image,
                          color: ManagerColors.greyWithColor),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        // رفع صورة جديدة
        UploadMediaField(
          label: label,
          hint: hint,
          note: note,
          file: file,
        ),
      ],
    );
  }

  // ==================== Build File Field with Current File ====================
  Widget _buildFileField({
    required UpdateOrganizationOfferProviderController controller,
    required String label,
    required String hint,
    required String note,
    required Rx<File?> file,
    required String currentFileUrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الملف الحالي
        Obx(() {
          // إخفاء الملف الحالي إذا تم اختيار ملف جديد
          if (currentFileUrl.isEmpty || file.value != null) {
            return SizedBox.shrink();
          }

          return Container(
            margin: EdgeInsets.only(bottom: ManagerHeight.h8),
            padding: EdgeInsets.all(ManagerHeight.h12),
            decoration: BoxDecoration(
              color: ManagerColors.greyWithColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ManagerColors.greyWithColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf,
                    color: ManagerColors.primaryColor, size: 32),
                SizedBox(width: ManagerWidth.w12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الملف الحالي:',
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.greyWithColor,
                        ),
                      ),
                      Text(
                        'السجل التجاري',
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: ManagerColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // فتح الملف
                  },
                  icon: Icon(Icons.open_in_new,
                      color: ManagerColors.primaryColor),
                ),
              ],
            ),
          );
        }),

        // رفع ملف جديد
        UploadMediaField(
          label: label,
          hint: hint,
          note: note,
          file: file,
        ),
      ],
    );
  }
}
