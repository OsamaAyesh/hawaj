import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import '../../../../../../core/widgets/custom_confirm_dialog.dart'; // ✅ استيراد الـ Dialog
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
import '../../domain/di/di.dart';
import '../controller/add_offer_controller.dart';

class AddOfferProviderScreen extends StatefulWidget {
  const AddOfferProviderScreen({super.key});

  @override
  State<AddOfferProviderScreen> createState() => _AddOfferProviderScreenState();
}

class _AddOfferProviderScreenState extends State<AddOfferProviderScreen> {
  late AddOfferController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AddOfferController>();

    // تحميل الشركات عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCompanies();
    });
  }

  @override
  void dispose() {
    disposeCreateOfferProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "إضافة عرض جديد",
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        if (controller.companiesList.isEmpty) {
          return _buildNoCompaniesState();
        }

        return Stack(
          children: [
            _buildForm(context),
            if (controller.isSubmitting.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: LoadingWidget()),
              ),
          ],
        );
      }),
    ).withHawaj(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.addNewOffer,
    );
  }

  Widget _buildNoCompaniesState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ManagerWidth.w24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.business_outlined, size: 90, color: Colors.grey),
            SizedBox(height: ManagerHeight.h16),
            Text(
              "لا توجد شركات متاحة حاليًا",
              style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s18, color: ManagerColors.black),
            ),
            SizedBox(height: ManagerHeight.h8),
            Text(
              "قم بإضافة شركتك أولاً لتتمكن من إنشاء العروض.",
              textAlign: TextAlign.center,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.greyWithColor,
              ),
            ),
            SizedBox(height: ManagerHeight.h24),
            ButtonApp(
              title: "تحديث الشركات",
              onPressed: controller.fetchCompanies,
              paddingWidth: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + ManagerHeight.h16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ManagerHeight.h24),
            TitleFormScreenWidget(title: "تسجيل عرض جديد"),
            SubTitleFormScreenWidget(
              subTitle: "اختر الشركة واملأ التفاصيل أدناه",
            ),
            SizedBox(height: ManagerHeight.h16),

            // قائمة اختيار الشركة
            Obx(() => LabeledDropdownField<String>(
                  label: "اختر الشركة",
                  hint: "اختر الشركة التي تريد إضافة العرض لها",
                  value: controller.selectedCompany.value?.id,
                  items: controller.companiesList
                      .map(
                        (company) => DropdownMenuItem<String>(
                          value: company.id,
                          child: Text(company.organizationName),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    controller.selectedCompany.value = controller.companiesList
                        .firstWhereOrNull((c) => c.id == v);
                  },
                )),
            SizedBox(height: ManagerHeight.h20),

            // اسم المنتج
            LabeledTextField(
              label: "اسم المنتج",
              hintText: "أدخل اسم المنتج",
              controller: controller.productNameController,
              widthButton: ManagerWidth.w130,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // وصف المنتج
            LabeledTextField(
              label: "وصف المنتج",
              hintText: "أدخل وصف المنتج",
              controller: controller.productDescriptionController,
              minLines: 3,
              maxLines: 5,
              widthButton: ManagerWidth.w130,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // صورة المنتج
            UploadMediaField(
              label: "صورة المنتج",
              hint: "قم برفع صورة المنتج",
              file: controller.pickedImage,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // السعر
            LabeledTextField(
              label: "السعر",
              hintText: "أدخل السعر",
              controller: controller.productPriceController,
              keyboardType: TextInputType.number,
              buttonWidget: Padding(
                padding: EdgeInsets.symmetric(vertical: ManagerHeight.h2),
                child: Image.asset(ManagerIcons.ryalSudia),
              ),
              widthButton: ManagerWidth.w130,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // نوع العرض
            Obx(() => LabeledDropdownField<String>(
                  label: "نوع العرض",
                  hint: "اختر نوع العرض",
                  value: controller.offerType.value.isEmpty
                      ? null
                      : controller.offerType.value,
                  items: const [
                    DropdownMenuItem(value: "2", child: Text("عادي")),
                    DropdownMenuItem(value: "1", child: Text("خصم")),
                  ],
                  onChanged: (v) => controller.offerType.value = v ?? "",
                )),

            // قسم الخصم
            Obx(() {
              if (controller.offerType.value == "1") {
                return Column(
                  children: [
                    const SizedBoxBetweenFieldWidgets(),
                    LabeledTextField(
                      label: "نسبة الخصم %",
                      hintText: "أدخل نسبة الخصم",
                      controller: controller.offerPriceController,
                      keyboardType: TextInputType.number,
                      widthButton: ManagerWidth.w130,
                    ),
                    const SizedBoxBetweenFieldWidgets(),
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            label: "تاريخ البداية",
                            hintText: "اختر تاريخ البداية",
                            controller: controller.offerStartDateController,
                            widthButton: ManagerWidth.w130,
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w16),
                        Expanded(
                          child: LabeledTextField(
                            label: "تاريخ النهاية",
                            hintText: "اختر تاريخ النهاية",
                            controller: controller.offerEndDateController,
                            widthButton: ManagerWidth.w130,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBoxBetweenFieldWidgets(),

            // زر الإرسال مع الـ Dialog
            ButtonApp(
              title: "إضافة العرض",
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => CustomConfirmDialog(
                    title: "تأكيد الإضافة",
                    subtitle: "هل أنت متأكد من أنك تريد إضافة هذا العرض؟",
                    confirmText: "تأكيد",
                    cancelText: "إلغاء",
                    onConfirm: () {
                      Navigator.of(ctx).pop();
                      controller.submitOffer();
                    },
                    onCancel: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                );
              },
              paddingWidth: 0,
            ),
            SizedBox(height: ManagerHeight.h24),
          ],
        ),
      ),
    );
  }
}
