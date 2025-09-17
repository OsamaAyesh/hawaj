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
    final controller = Get.find<CreateOfferProviderController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.offerRegisterTitle,
      body: Obx(() {
        // أثناء تحميل بيانات الشركة
        if (controller.isLoading.value && controller.company.value == null) {
          return const LoadingWidget();
        }

        // في حالة خطأ عند جلب بيانات الشركة
        if (controller.companyError.isNotEmpty) {
          return Center(
            child: Text(
              controller.companyError.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        // إذا لم يتم جلب الشركة بعد (بدون خطأ)
        if (controller.company.value == null) {
          return const Center(child: Text("لا توجد بيانات مؤسسة حالياً"));
        }

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ManagerHeight.h24),

                    /// ===== Title & Subtitle =====
                    TitleFormScreenWidget(title: ManagerStrings.offerAddNew),
                    SubTitleFormScreenWidget(
                        subTitle: ManagerStrings.offerSubtitle),
                    SizedBox(height: ManagerHeight.h16),

                    /// ===== Product Name =====
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.offerProductName,
                      hintText: ManagerStrings.offerProductDesc1,
                      controller: controller.productNameController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// ===== Product Description =====
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.offerProductDesc,
                      hintText: ManagerStrings.offerProductDescHint,
                      controller: controller.productDescriptionController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// ===== Upload Image =====
                    UploadMediaField(
                      label: ManagerStrings.offerProductImages,
                      hint: ManagerStrings.offerProductImagesHint,
                      note: ManagerStrings.offerProductImagesHint2,
                      file: controller.pickedImage,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// ===== Product Price =====
                    LabeledTextField(
                      widthButton: ManagerWidth.w40,
                      label: ManagerStrings.offerProductPrice,
                      hintText: ManagerStrings.offerProductPriceHint,
                      controller: controller.productPriceController,
                      buttonWidget: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: ManagerHeight.h2),
                        child: Image.asset(ManagerIcons.ryalSudia),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// ===== Offer Type Dropdown =====
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
                          onChanged: (value) {
                            controller.offerType.value = value ?? "";
                          },
                        )),

                    /// ===== Extra Fields if Discount =====
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

                    /// ===== Offer Status Dropdown =====
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
                          onChanged: (value) {
                            controller.offerStatus.value = value ?? "";
                          },
                        )),

                    SizedBox(height: ManagerHeight.h16),

                    /// ===== Submit Button =====
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
                          onConfirm: () {
                            // سيستخدم الcontroller الـ organizationId المجلوب تلقائياً
                            controller.submitOffer();
                          },
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

            /// Loading Overlay عند أي عملية
            if (controller.isLoading.value) const LoadingWidget(),
          ],
        );
      }),
    );
  }
}
