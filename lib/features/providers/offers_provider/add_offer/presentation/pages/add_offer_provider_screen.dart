import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
import '../controller/add_offer_controller.dart';

class AddOfferProviderScreen extends StatelessWidget {
  const AddOfferProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddOfferController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.offerRegisterTitle,
      body: Obx(() {
        // ===== 1️⃣ تحميل أولي لبيانات الشركة =====
        if (controller.isLoading.value && controller.company.value == null) {
          return const LoadingWidget();
        }

        // ===== 2️⃣ حالة الخطأ =====
        if (controller.companyError.isNotEmpty) {
          return Center(
            child: Text(
              controller.companyError.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        // ===== 3️⃣ لا توجد شركة =====
        if (controller.company.value == null) {
          return const Center(child: Text("لا توجد بيانات مؤسسة حالياً"));
        }

        // ===== 4️⃣ نموذج إضافة العرض =====
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ManagerHeight.h24),

                    /// العنوان والوصف
                    TitleFormScreenWidget(title: ManagerStrings.offerAddNew),
                    SubTitleFormScreenWidget(
                        subTitle: ManagerStrings.offerSubtitle),
                    SizedBox(height: ManagerHeight.h16),

                    /// اسم المنتج
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.offerProductName,
                      hintText: ManagerStrings.offerProductDesc1,
                      controller: controller.productNameController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// وصف المنتج
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.offerProductDesc,
                      hintText: ManagerStrings.offerProductDescHint,
                      controller: controller.productDescriptionController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// صورة المنتج
                    UploadMediaField(
                      label: ManagerStrings.offerProductImages,
                      hint: ManagerStrings.offerProductImagesHint,
                      note: ManagerStrings.offerProductImagesHint2,
                      file: controller.pickedImage,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// سعر المنتج
                    LabeledTextField(
                      widthButton: ManagerWidth.w40,
                      label: ManagerStrings.offerProductPrice,
                      hintText: ManagerStrings.offerProductPriceHint,
                      controller: controller.productPriceController,
                      keyboardType: TextInputType.number,
                      buttonWidget: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: ManagerHeight.h2),
                        child: Image.asset(ManagerIcons.ryalSudia),
                      ),
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// نوع العرض
                    Obx(() => LabeledDropdownField<String>(
                          label: ManagerStrings.offerType,
                          hint: ManagerStrings.offerTypeHint,
                          value: controller.offerType.value.isEmpty
                              ? null
                              : controller.offerType.value,
                          items: const [
                            DropdownMenuItem(value: "2", child: Text("عادي")),
                            DropdownMenuItem(
                                value: "1", child: Text("خصم بالمئة")),
                          ],
                          onChanged: (v) =>
                              controller.offerType.value = v ?? "",
                        )),

                    /// الحقول الإضافية عند اختيار خصم
                    Obx(() {
                      if (controller.offerType.value == "1") {
                        return Column(
                          children: [
                            const SizedBoxBetweenFieldWidgets(),
                            LabeledTextField(
                              widthButton: ManagerWidth.w40,
                              label: "نسبة الخصم %",
                              hintText: "أدخل نسبة الخصم",
                              controller: controller.offerPriceController,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBoxBetweenFieldWidgets(),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        controller
                                                .offerStartDateController.text =
                                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: LabeledTextField(
                                        widthButton: ManagerWidth.w130,
                                        label: ManagerStrings.offerFromDate,
                                        hintText: "اختر تاريخ البداية",
                                        controller:
                                            controller.offerStartDateController,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ManagerWidth.w16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        controller.offerEndDateController.text =
                                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: LabeledTextField(
                                        widthButton: ManagerWidth.w130,
                                        label: ManagerStrings.offerToDate,
                                        hintText: "اختر تاريخ النهاية",
                                        controller:
                                            controller.offerEndDateController,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBoxBetweenFieldWidgets(),
                            LabeledTextField(
                              widthButton: ManagerWidth.w130,
                              label: ManagerStrings.offerDesc,
                              hintText: ManagerStrings.offerDescHint,
                              controller: controller.offerDescriptionController,
                              minLines: 4,
                              maxLines: 5,
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    const SizedBoxBetweenFieldWidgets(),

                    /// حالة العرض
                    Obx(() => LabeledDropdownField<String>(
                          label: "حالة العرض",
                          hint: "اختر حالة العرض",
                          value: controller.offerStatus.value.isEmpty
                              ? null
                              : controller.offerStatus.value,
                          items: const [
                            DropdownMenuItem(value: "1", child: Text("نشر")),
                            DropdownMenuItem(
                                value: "2", child: Text("غير منشور")),
                            DropdownMenuItem(value: "3", child: Text("منتهي")),
                            DropdownMenuItem(value: "4", child: Text("ملغي")),
                            DropdownMenuItem(
                                value: "5", child: Text("قيد المعاينة")),
                          ],
                          onChanged: (v) =>
                              controller.offerStatus.value = v ?? "",
                        )),

                    SizedBox(height: ManagerHeight.h16),

                    /// زر الإرسال
                    ButtonApp(
                      title: ManagerStrings.offerSubmit,
                      onPressed: () {
                        showDialogConfirmRegisterCompanyOffer(
                          title: ManagerStrings.confirmAddProductTitle,
                          subTitle: ManagerStrings.confirmAddProductSubtitle,
                          actionConfirmText:
                              ManagerStrings.confirmAddProductConfirm,
                          actionCancel: ManagerStrings.confirmAddProductCancel,
                          context,
                          onConfirm: controller.submitOffer,
                          onCancel: () {},
                        );
                      },
                      paddingWidth: 0,
                    ),
                    SizedBox(height: ManagerHeight.h16),
                  ],
                ),
              ),
            ),

            /// ✅ Overlay يظهر أثناء الإضافة (submitOffer)
            if (controller.isSubmitting.value) const LoadingWidget(),

            /// Overlay إضافي أثناء أي عملية تحميل (اختياري)
            if (controller.isLoading.value && controller.company.value != null)
              const LoadingWidget(),
          ],
        );
      }),
    );
  }
}
