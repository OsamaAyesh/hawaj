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
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../common/map_ticker/domain/di/di.dart';
import '../../../../../common/map_ticker/presenation/pages/map_ticker_screen.dart';
import '../../domain/di/di.dart';
import '../controller/add_company_jobs_provider_controller.dart';

class AddCompanyJobsProviderScreen extends StatefulWidget {
  const AddCompanyJobsProviderScreen({super.key});

  @override
  State<AddCompanyJobsProviderScreen> createState() =>
      _AddCompanyJobsProviderScreenState();
}

class _AddCompanyJobsProviderScreenState
    extends State<AddCompanyJobsProviderScreen> {
  late AddCompanyJobsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AddCompanyJobsController>();
  }

  @override
  void dispose() {
    disposeAddCompanyJobs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "تسجيل شركتك",
      body: Stack(
        children: [
          /// ===== Main Content =====
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

                  /// ===== Title =====
                  const TitleTextScreenWidget(
                    title: "انضم كشركة وابدأ بنشر الوظائف",
                  ),
                  SizedBox(height: ManagerHeight.h4),

                  const SubTitleTextScreenWidget(
                    subTitle:
                        "قم بإدخال بيانات شركتك ليتم التحقق منها واعتمادها في النظام، حيث يمكنك بعد التسجيل إدارة الوظائف ونشر الإعلانات بسهولة.",
                  ),
                  SizedBox(height: ManagerHeight.h24),

                  /// ===== Company Name =====
                  LabeledTextField(
                    controller: controller.companyNameController,
                    label: "اسم الشركة",
                    hintText: "أدخل اسم الشركة",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== Business Activity =====
                  LabeledTextField(
                    controller: controller.industryController,
                    label: "النشاط التجاري",
                    hintText: "أدخل النشاط التجاري للشركة",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== Phone Number =====
                  LabeledTextField(
                    controller: controller.mobileController,
                    label: "رقم الجوال",
                    hintText: "05xxxxxxxx",
                    keyboardType: TextInputType.phone,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== Set Location (Map Picker) =====
                  LabeledTextField(
                    label: "تحديد موقع الشركة",
                    hintText: "اضغط لتحديد الموقع على الخريطة",
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

                  /// ===== Address =====
                  LabeledTextField(
                    controller: controller.detailedAddressController,
                    label: "عنوان الشركة",
                    hintText: "أدخل عنوان الشركة بالتفصيل",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== Description =====
                  LabeledTextField(
                    controller: controller.companyDescriptionController,
                    label: "وصف النشاط",
                    hintText: "أدخل وصفًا مختصرًا عن نشاط الشركة",
                    minLines: 3,
                    maxLines: 5,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== Extra Description =====
                  LabeledTextField(
                    controller: controller.shortDescriptionController,
                    label: "وصف قصير إضافي",
                    hintText: "اكتب نبذة تعريفية قصيرة عن الشركة",
                    minLines: 2,
                    maxLines: 4,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== Company Logo =====
                  UploadMediaField(
                    label: "شعار الشركة",
                    hint: "ارفع شعار شركتك",
                    note: "PNG أو JPG",
                    file: controller.companyLogo,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== Full Name =====
                  LabeledTextField(
                    controller: controller.contactPersonNameController,
                    label: "الاسم الكامل",
                    hintText: "أدخل الاسم الكامل للمسؤول",
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== Email =====
                  LabeledTextField(
                    controller: controller.contactPersonEmailController,
                    label: "البريد الإلكتروني",
                    hintText: "example@domain.com",
                    keyboardType: TextInputType.emailAddress,
                    widthButton: ManagerWidth.w130,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== Commercial Register =====
                  UploadMediaField(
                    label: "السجل التجاري",
                    hint: "ارفع السجل التجاري",
                    note: "PDF أو صورة",
                    file: controller.commercialRegister,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== Activity License =====
                  UploadMediaField(
                    label: "رخصة مزاولة النشاط",
                    hint: "ارفع رخصة مزاولة النشاط",
                    note: "PDF أو صورة",
                    file: controller.activityLicense,
                  ),
                  SizedBox(height: ManagerHeight.h24),

                  /// ===== Submit Button =====
                  ButtonApp(
                    title: "إرسال بيانات الشركة",
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CustomConfirmDialog(
                          title: "تأكيد تسجيل الشركة",
                          subtitle:
                              "هل أنت متأكد من رغبتك في تسجيل هذه الشركة؟ سيتم مراجعة الطلب واعتماده من قبل الإدارة.",
                          confirmText: "تأكيد",
                          cancelText: "إلغاء",
                          onConfirm: () {
                            Get.back();
                            controller.submitCompany();
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

          /// ===== Loading Overlay =====
          Obx(() {
            if (controller.isLoading.value) {
              return const LoadingWidget();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
