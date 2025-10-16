import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/upload_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/widgets/custom_confirm_dialog.dart';
import '../../../../../common/map_ticker/domain/di/di.dart';
import '../../../../../common/map_ticker/presenation/pages/map_ticker_screen.dart';
import '../controller/add_my_property_owners_controller.dart'
    show AddMyPropertyOwnersController;
import '../widgets/account_type_selector_widget.dart';

class RegisterToRealEstateProviderServiceScreen extends StatelessWidget {
  const RegisterToRealEstateProviderServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddMyPropertyOwnersController>();

    return ScaffoldWithBackButton(
      title: 'الانضمام كمقدم عقارات',
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
                  .copyWith(bottom: ManagerHeight.h16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ManagerHeight.h24),

                  /// ===== العنوان =====
                  const TitleTextScreenWidget(
                    title: "ابدأ بعرض عقاراتك الآن",
                  ),
                  SizedBox(height: ManagerHeight.h4),
                  const SubTitleTextScreenWidget(
                    subTitle:
                        "أكمل بياناتك الأساسية للانضمام إلى منصة جواي كمقدم عقارات، حتى يتم عرض عقاراتك بشكل احترافي.",
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
                  /// ===== الموقع الجغرافي =====
                  LabeledTextField(
                    label: "تعيين الموقع الجغرافي",
                    controller: controller.locationLatController,
                    hintText: "حدد موقع مكتبك",
                    widthButton: 140,
                    onButtonTap: () async {
                      // تنفيذ البايندينغ وربط الكنترولر الخاص بالخريطة
                      MapTickerBindings().dependencies();

                      // الانتقال إلى شاشة اختيار الموقع
                      final result = await Get.to(
                        () => const MapTickerScreen(),
                      );

                      // عند العودة من الخريطة، تعبئة الإحداثيات
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
                        child: Text("حدد موقع مكتبك",
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s12,
                              color: ManagerColors.white,
                            )),
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
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== نوع الحساب =====
                  AccountTypeSelector(
                    onChanged: (value) => controller.setAccountType(value),
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== الحقول الإضافية في حال مكتب عقاري =====
                  if (controller.selectedAccountType.value == '1') ...[
                    UploadMediaField(
                      label: "شهادة الوساطة العقارية",
                      hint: "ارفع شهادة الوساطة العقارية",
                      note: "PDF أو صورة",
                      file: controller.commercialRegistration,
                    ),
                    const SizedBoxBetweenFieldWidgets(),
                    UploadMediaField(
                      label: "السجل التجاري",
                      hint: "ارفع السجل التجاري",
                      note: "PDF أو صورة",
                      file: controller.commercialRegister,
                    ),
                    const SizedBoxBetweenFieldWidgets(),
                  ],

                  SizedBox(height: ManagerHeight.h24),

                  /// ===== زر الإضافة =====
                  ButtonApp(
                    title: "إضافة",
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CustomConfirmDialog(
                          title: "تأكيد الإضافة",
                          subtitle:
                              "هل أنت متأكد من رغبتك في إضافة هذه البيانات؟",
                          confirmText: "تأكيد",
                          cancelText: "إلغاء",
                          onConfirm: () {
                            Navigator.pop(context);
                            controller.submitPropertyOwner();
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
            if (controller.isLoading.value)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: LoadingWidget(),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
