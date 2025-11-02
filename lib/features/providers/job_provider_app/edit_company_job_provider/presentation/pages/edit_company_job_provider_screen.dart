import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
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
import 'package:app_mobile/features/common/map_ticker/domain/di/di.dart';
import 'package:app_mobile/features/common/map_ticker/presenation/pages/map_ticker_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/job_company_item_model.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../controller/edit_company_job_provider_controller.dart';

class EditCompanyJobsProviderScreen extends StatefulWidget {
  final JobCompanyItemModel company;

  const EditCompanyJobsProviderScreen({
    super.key,
    required this.company,
  });

  @override
  State<EditCompanyJobsProviderScreen> createState() =>
      _EditCompanyJobsProviderScreenState();
}

class _EditCompanyJobsProviderScreenState
    extends State<EditCompanyJobsProviderScreen> {
  late final EditCompanyJobProviderController controller;

  @override
  void initState() {
    super.initState();

    // ✅ استخدم الكنترولر المحقون من الـ DI
    controller = Get.find<EditCompanyJobProviderController>();

    _fillFieldsFromModel(widget.company);
  }

  /// ✅ دالة تعبئة البيانات القادمة من الموديل
  void _fillFieldsFromModel(JobCompanyItemModel company) {
    controller.companyId = company.id; // ✅ تخزين الـ id داخل الكنترولر

    controller.companyNameController.text = company.companyName;
    controller.industryController.text = company.industry;
    controller.mobileController.text = company.mobileNumber;
    controller.detailedAddressController.text = company.detailedAddress;
    controller.companyDescriptionController.text = company.companyDescription;
    controller.shortDescriptionController.text =
        company.companyShortDescription;
    controller.contactPersonNameController.text = company.contactPersonName;
    controller.contactPersonEmailController.text = company.contactPersonEmail;
    controller.locationController.text =
        "${company.locationLat}, ${company.locationLng}";
    controller.locationLat.value = company.locationLat;
    controller.locationLng.value = company.locationLng;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "تعديل بيانات الشركة",
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
                  .copyWith(bottom: ManagerHeight.h16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ManagerHeight.h24),
                  const TitleTextScreenWidget(
                    title: "قم بتحديث بيانات شركتك بسهولة",
                  ),
                  SizedBox(height: ManagerHeight.h4),
                  const SubTitleTextScreenWidget(
                    subTitle:
                        "يمكنك تعديل بيانات الشركة أدناه لتحديث معلوماتها في النظام.",
                  ),
                  SizedBox(height: ManagerHeight.h24),

                  // === الحقول ===
                  LabeledTextField(
                    controller: controller.companyNameController,
                    label: "اسم الشركة",
                    hintText: "أدخل اسم الشركة",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  LabeledTextField(
                    controller: controller.industryController,
                    label: "النشاط التجاري",
                    hintText: "أدخل النشاط التجاري",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  LabeledTextField(
                    controller: controller.mobileController,
                    label: "رقم الجوال",
                    hintText: "05xxxxxxxx",
                    keyboardType: TextInputType.phone,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // ===== موقع الشركة =====
                  LabeledTextField(
                    label: "تحديد موقع الشركة",
                    hintText: "اضغط لتحديد موقع جديد (اختياري)",
                    controller: controller.locationController,
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
                    onButtonTap: () async {
                      final result = await Get.to(
                        () => const MapTickerScreen(),
                        binding: MapTickerBindings(),
                      );

                      if (result != null &&
                          result.latitude != null &&
                          result.longitude != null) {
                        controller.updateCompanyLocation(
                          result.latitude!,
                          result.longitude!,
                        );
                      }
                    },
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // ===== باقي الحقول =====
                  LabeledTextField(
                    controller: controller.detailedAddressController,
                    label: "عنوان الشركة",
                    hintText: "أدخل عنوان الشركة بالتفصيل",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  LabeledTextField(
                    controller: controller.companyDescriptionController,
                    label: "وصف النشاط",
                    hintText: "أدخل وصف الشركة",
                    minLines: 3,
                    maxLines: 5,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  LabeledTextField(
                    controller: controller.shortDescriptionController,
                    label: "وصف قصير إضافي",
                    hintText: "نبذة تعريفية قصيرة",
                    minLines: 2,
                    maxLines: 4,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  UploadMediaField(
                    label: "شعار الشركة (اختياري)",
                    hint: "ارفع شعارًا جديدًا إن أردت التغيير",
                    note: "PNG أو JPG",
                    file: controller.companyLogo,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  LabeledTextField(
                    controller: controller.contactPersonNameController,
                    label: "الاسم الكامل",
                    hintText: "أدخل الاسم الكامل للمسؤول",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  LabeledTextField(
                    controller: controller.contactPersonEmailController,
                    label: "البريد الإلكتروني",
                    hintText: "example@domain.com",
                    keyboardType: TextInputType.emailAddress,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  UploadMediaField(
                    label: "السجل التجاري (اختياري)",
                    hint: "ارفع نسخة محدثة إذا لزم الأمر",
                    note: "PDF أو صورة",
                    file: controller.commercialRegister,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  UploadMediaField(
                    label: "رخصة مزاولة النشاط (اختياري)",
                    hint: "ارفع نسخة محدثة إذا لزم الأمر",
                    note: "PDF أو صورة",
                    file: controller.activityLicense,
                  ),
                  SizedBox(height: ManagerHeight.h24),

                  ButtonApp(
                    title: "تحديث بيانات الشركة",
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CustomConfirmDialog(
                          title: "تأكيد التعديل",
                          subtitle:
                              "هل أنت متأكد من رغبتك في تعديل بيانات هذه الشركة؟",
                          confirmText: "تأكيد",
                          cancelText: "إلغاء",
                          onConfirm: () {
                            Get.back();
                            controller.updateCompany();
                          },
                          onCancel: () => Get.back(),
                        ),
                      );
                    },
                    paddingWidth: 0,
                  ),
                  SizedBox(height: ManagerHeight.h16),
                ],
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) return const LoadingWidget();
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
