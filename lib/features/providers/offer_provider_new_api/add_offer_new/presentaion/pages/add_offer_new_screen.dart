import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/lable_drop_down_button.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/upload_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
import '../controller/add_offer_new_controller.dart';

class AddOfferNewScreen extends StatelessWidget {
  const AddOfferNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddOfferNewController>();

    return ScaffoldWithBackButton(
      title: "إضافة عرض جديد",
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        return Stack(
          children: [
            _buildForm(context, controller),
            if (controller.isSubmitting.value)
              Container(
                color: Colors.black26,
                child: const Center(child: LoadingWidget()),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildForm(BuildContext context, AddOfferNewController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + ManagerHeight.h20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ManagerHeight.h20),
            TitleFormScreenWidget(title: "تفاصيل العرض الجديد"),
            SubTitleFormScreenWidget(
              subTitle:
                  "قم بإضافة تفاصيل العرض الذي ترغب بنشره ضمن مؤسستك المسجلة.",
            ),
            SizedBox(height: ManagerHeight.h20),

            /// ===== Dropdown لاختيار المؤسسة =====
            Obx(() {
              return LabeledDropdownField(
                label: "اختر المؤسسة",
                hint: controller.companies.isEmpty
                    ? "لا توجد مؤسسات متاحة"
                    : "حدد المؤسسة المرتبطة بالعرض",
                value: controller.selectedCompany.value,
                items: controller.companies.map((company) {
                  return DropdownMenuItem(
                    value: company,
                    child: Text(
                      company.organizationName,
                      style: getMediumTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedCompany.value = value;
                },
              );
            }),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== Product Name =====
            LabeledTextField(
              widthButton: ManagerWidth.w130,
              label: "اسم المنتج",
              hintText: "أدخل اسم المنتج...",
              controller: controller.productNameController,
              textInputAction: TextInputAction.next,
            ),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== Product Description =====
            LabeledTextField(
              widthButton: ManagerWidth.w130,
              label: "وصف المنتج",
              hintText: "اكتب وصفاً مفصلاً للمنتج...",
              controller: controller.productDescriptionController,
              minLines: 3,
              maxLines: 5,
            ),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== Upload Image =====
            UploadMediaField(
              label: "صورة المنتج",
              hint: "قم برفع صورة واضحة للمنتج",
              note: "الصيغ المسموحة: JPG, PNG",
              file: controller.pickedImage,
            ),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== Product Price =====
            LabeledTextField(
              widthButton: ManagerWidth.w80,
              label: "السعر",
              hintText: "أدخل سعر المنتج",
              controller: controller.productPriceController,
              keyboardType: TextInputType.number,
            ),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== Offer Type =====
            Obx(() => LabeledDropdownField<String>(
                  label: "نوع العرض",
                  hint: "اختر نوع العرض",
                  value: controller.offerType.value.isEmpty
                      ? null
                      : controller.offerType.value,
                  items: const [
                    DropdownMenuItem(value: "2", child: Text("عرض عادي")),
                    DropdownMenuItem(value: "1", child: Text("خصم بنسبة")),
                  ],
                  onChanged: (v) => controller.offerType.value = v ?? "",
                )),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== Discount Fields =====
            Obx(() {
              if (controller.offerType.value == "1") {
                return Column(
                  children: [
                    LabeledTextField(
                      widthButton: ManagerWidth.w80,
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
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                controller.offerStartDateController.text =
                                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                              }
                            },
                            child: AbsorbPointer(
                              child: LabeledTextField(
                                label: "تاريخ البداية",
                                hintText: "اختر تاريخ البداية",
                                controller: controller.offerStartDateController,
                                widthButton: 130,
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
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                controller.offerEndDateController.text =
                                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                              }
                            },
                            child: AbsorbPointer(
                              child: LabeledTextField(
                                label: "تاريخ النهاية",
                                hintText: "اختر تاريخ النهاية",
                                controller: controller.offerEndDateController,
                                widthButton: 130,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBoxBetweenFieldWidgets(),
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: "وصف العرض",
                      hintText: "اكتب تفاصيل العرض الخاصة بالخصم...",
                      controller: controller.offerDescriptionController,
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== Offer Status =====
            Obx(() => LabeledDropdownField<String>(
                  label: "حالة العرض",
                  hint: "اختر حالة العرض",
                  value: controller.offerStatus.value.isEmpty
                      ? null
                      : controller.offerStatus.value,
                  items: const [
                    DropdownMenuItem(value: "5", child: Text("قيد المراجعة")),
                    DropdownMenuItem(value: "1", child: Text("منشور")),
                    DropdownMenuItem(value: "2", child: Text("غير منشور")),
                    DropdownMenuItem(value: "3", child: Text("منتهي")),
                    DropdownMenuItem(value: "4", child: Text("ملغي")),
                  ],
                  onChanged: (v) => controller.offerStatus.value = v ?? "5",
                )),
            SizedBox(height: ManagerHeight.h32),

            /// ===== Submit Button =====
            ButtonApp(
              title: "إضافة العرض",
              onPressed: controller.submitOffer,
              paddingWidth: 0,
            ),
            SizedBox(height: ManagerHeight.h20),
          ],
        ),
      ),
    );
  }
}
