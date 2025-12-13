// lib/features/providers/real_estate_provider/edit_profile_real_state_owner/presentation/pages/edit_profile_real_state_owner_screen.dart

import 'package:app_mobile/core/model/property_item_owner_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/custom_confirm_dialog.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/upload_media_widget.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:app_mobile/features/common/map_ticker/domain/di/di.dart';
import 'package:app_mobile/features/common/map_ticker/presenation/pages/map_ticker_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import '../../domain/di/di.dart';
import '../controller/edit_profile_my_property_owner_controller.dart';

class EditProfileRealStateOwnerScreen extends StatefulWidget {
  final String ownerId;
  final PropertyItemOwnerModel owner;

  const EditProfileRealStateOwnerScreen({
    super.key,
    required this.owner,
    required this.ownerId,
  });

  @override
  State<EditProfileRealStateOwnerScreen> createState() =>
      _EditProfileRealStateOwnerScreenState();
}

class _EditProfileRealStateOwnerScreenState
    extends State<EditProfileRealStateOwnerScreen> {
  late final EditProfileMyPropertyOwnerController controller;

  @override
  void initState() {
    super.initState();

    // Initialize DI
    initEditProfileMyPropertyOwnerModule(widget.ownerId);

    // Get controller
    controller = Get.find<EditProfileMyPropertyOwnerController>();

    // Populate data
    _initOwnerData();
  }

  void _initOwnerData() {
    final owner = widget.owner;

    // Set text fields
    controller.ownerNameController.text = owner.ownerName ?? '';
    controller.mobileNumberController.text = owner.mobileNumber ?? '';
    controller.whatsappNumberController.text = owner.whatsappNumber ?? '';
    controller.locationLatController.text = owner.locationLat ?? '';
    controller.locationLngController.text = owner.locationLng ?? '';
    controller.detailedAddressController.text = owner.detailedAddress ?? '';
    controller.companyNameController.text = owner.companyName ?? '';
    controller.companyBriefController.text = owner.companyBrief ?? '';

    // Set account type
    controller.selectedAccountType.value = owner.accountType ?? '1';

    // Store existing URLs
    controller.existingCompanyLogoUrl = owner.companyLogo ?? '';
    // Add other URLs if available in model
  }

  @override
  void dispose() {
    disposeEditProfileMyPropertyOwnerModule();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "تعديل بيانات الملكية",
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
                  .copyWith(bottom: ManagerHeight.h24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ManagerHeight.h24),

                  /// ===== العنوان =====
                  const TitleTextScreenWidget(
                    title: "تحديث بيانات الملكية",
                  ),
                  SizedBox(height: ManagerHeight.h4),
                  const SubTitleTextScreenWidget(
                    subTitle:
                        "قم بتعديل وتحديث جميع بيانات ملكيتك العقارية بشكل احترافي.",
                  ),
                  SizedBox(height: ManagerHeight.h24),

                  /// ===== اسم الشخص =====
                  LabeledTextField(
                    controller: controller.ownerNameController,
                    label: "اسم الشخص",
                    hintText: "أدخل الاسم الكامل",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== رقم الجوال =====
                  LabeledTextField(
                    controller: controller.mobileNumberController,
                    label: "رقم الجوال",
                    hintText: "أدخل رقم الجوال",
                    keyboardType: TextInputType.phone,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== رقم الواتساب =====
                  LabeledTextField(
                    controller: controller.whatsappNumberController,
                    label: "رقم الواتساب",
                    hintText: "أدخل رقم الواتساب",
                    keyboardType: TextInputType.phone,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== الموقع الجغرافي =====
                  LabeledTextField(
                    label: "تعيين الموقع الجغرافي",
                    controller: controller.locationLatController,
                    hintText: "حدد موقع مكتبك",
                    widthButton: 140,
                    onButtonTap: () async {
                      MapTickerBindings().dependencies();
                      final result = await Get.to(
                        () => const MapTickerScreen(),
                      );

                      if (result != null) {
                        controller.locationLatController.text =
                            result.latitude.toString();
                        controller.locationLngController.text =
                            result.longitude.toString();
                      }
                    },
                    buttonWidget: Container(
                      width: ManagerWidth.w140,
                      height: ManagerHeight.h44,
                      decoration: BoxDecoration(
                        color: ManagerColors.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          "حدد موقع مكتبك",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== العنوان التفصيلي =====
                  LabeledTextField(
                    controller: controller.detailedAddressController,
                    label: "العنوان التفصيلي",
                    hintText: "أدخل العنوان التفصيلي لمكتبك",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== اسم الشركة =====
                  LabeledTextField(
                    controller: controller.companyNameController,
                    label: "اسم الشركة",
                    hintText: "أدخل اسم شركتك العقارية",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== وصف مختصر للنشاط =====
                  LabeledTextField(
                    controller: controller.companyBriefController,
                    label: "وصف مختصر للنشاط",
                    hintText: "أدخل وصفًا مختصرًا عن نشاطك العقاري",
                    minLines: 3,
                    maxLines: 5,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== رفع شعار مقدم العقارات =====
                  UploadMediaField(
                    label: "شعار مقدم العقارات",
                    hint: "ارفع شعار مقدم العقارات",
                    note: "PNG أو JPG (اختياري)",
                    file: controller.companyLogo,
                    existingUrl: controller.existingCompanyLogoUrl,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== نوع الحساب =====
                  Obx(() => _AccountTypeSelector(
                        selectedType: controller.selectedAccountType.value,
                        onChanged: (value) => controller.setAccountType(value),
                      )),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== الحقول الإضافية في حال مكتب عقاري =====
                  Obx(() {
                    if (controller.selectedAccountType.value == '1') {
                      return Column(
                        children: [
                          UploadMediaField(
                            label: "شهادة الوساطة العقارية",
                            hint: "ارفع شهادة الوساطة العقارية",
                            note: "PDF أو صورة",
                            file: controller.brokerageCertificate,
                            existingUrl:
                                controller.existingBrokerageCertificateUrl,
                          ),
                          const SizedBoxBetweenFieldWidgets(),
                          UploadMediaField(
                            label: "السجل التجاري",
                            hint: "ارفع السجل التجاري",
                            note: "PDF أو صورة",
                            file: controller.commercialRegister,
                            existingUrl:
                                controller.existingCommercialRegisterUrl,
                          ),
                          const SizedBoxBetweenFieldWidgets(),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  SizedBox(height: ManagerHeight.h24),

                  /// ===== زر التحديث =====
                  ButtonApp(
                    title: "تحديث البيانات",
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CustomConfirmDialog(
                          title: "تأكيد تعديل البيانات",
                          subtitle:
                              "سيتم تحديث بياناتك الظاهرة للمستخدمين مثل الاسم، رقم التواصل والوصف.",
                          confirmText: "تأكيد",
                          cancelText: "إلغاء",
                          onConfirm: () {
                            Navigator.pop(context);
                            controller.editProfile();
                          },
                          onCancel: () => Navigator.pop(context),
                        ),
                      );
                    },
                    paddingWidth: 0,
                  ),
                  SizedBox(height: ManagerHeight.h16),
                ],
              ),
            ),

            /// ===== Loading Overlay =====
            if (controller.isLoading.value) const LoadingWidget(),
          ],
        );
      }),
    ).withHawaj(
      section: HawajSections.realEstates,
      screen: HawajScreens.myOwnerPropertys,
    );
  }
}

class _AccountTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;

  const _AccountTypeSelector({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ManagerStrings.accountType,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        _buildRadioOption("1", ManagerStrings.officeAccount),
        const SizedBox(height: 8),
        _buildRadioOption("2", ManagerStrings.personalAccount),
      ],
    );
  }

  Widget _buildRadioOption(String value, String label) {
    final isSelected = selectedType == value;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? ManagerColors.primaryColor
                    : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: ManagerColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: ManagerWidth.w6),
          Text(
            label,
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s14,
              color: isSelected
                  ? ManagerColors.primaryColor
                  : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
