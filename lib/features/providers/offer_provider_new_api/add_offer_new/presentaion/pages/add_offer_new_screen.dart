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

class AddOfferNewNewNewScreen extends StatelessWidget {
  const AddOfferNewNewNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddOfferNewController>();

    return ScaffoldWithBackButton(
      title: "إضافة عرض جديد",
      body: Obx(() {
        // Loading state for fetching companies
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        // Empty state - no companies
        if (controller.companies.isEmpty) {
          return _buildEmptyState(controller);
        }

        // Main form
        return Stack(
          children: [
            _buildForm(context, controller),

            // Submitting overlay
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

  // ==================== Empty State ====================
  Widget _buildEmptyState(AddOfferNewController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ManagerWidth.w24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: 80,
              color: ManagerColors.greyWithColor,
            ),
            SizedBox(height: ManagerHeight.h24),
            Text(
              'لا توجد مؤسسات متاحة',
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s18,
                color: ManagerColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h12),
            Text(
              'يرجى تسجيل مؤسسة أولاً لتتمكن من إضافة عروض',
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.greyWithColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h32),
            ButtonApp(
              title: 'إعادة المحاولة',
              onPressed: controller.retryFetchCompanies,
              paddingWidth: ManagerWidth.w48,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Main Form ====================
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

            // Title & Subtitle
            TitleFormScreenWidget(title: "تفاصيل العرض الجديد"),
            SubTitleFormScreenWidget(
              subTitle:
                  "قم بإضافة تفاصيل العرض الذي ترغب بنشره ضمن مؤسستك المسجلة.",
            ),
            SizedBox(height: ManagerHeight.h20),

            // ===== Organization Dropdown =====
            Obx(() {
              return LabeledDropdownField(
                label: "اختر المؤسسة",
                hint: "حدد المؤسسة المرتبطة بالعرض",
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

            // ===== Product Name =====
            LabeledTextField(
              widthButton: ManagerWidth.w130,
              label: "اسم المنتج",
              hintText: "أدخل اسم المنتج...",
              controller: controller.productNameController,
              textInputAction: TextInputAction.next,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // ===== Product Description =====
            LabeledTextField(
              widthButton: ManagerWidth.w130,
              label: "وصف المنتج",
              hintText: "اكتب وصفاً مفصلاً للمنتج...",
              controller: controller.productDescriptionController,
              textInputAction: TextInputAction.next,
              minLines: 3,
              maxLines: 5,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // ===== Product Image =====
            UploadMediaField(
              label: "صورة المنتج",
              hint: "قم برفع صورة واضحة للمنتج",
              note: "الصيغ المسموحة: JPG, PNG",
              file: controller.pickedImage,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // ===== Product Price =====
            LabeledTextField(
              widthButton: ManagerWidth.w80,
              label: "السعر",
              hintText: "أدخل سعر المنتج",
              controller: controller.productPriceController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // ===== Offer Type =====
            Obx(() => LabeledDropdownField<String>(
                  label: "نوع العرض",
                  hint: "اختر نوع العرض",
                  value: controller.offerType.value,
                  // ✅ إزالة الشرط
                  items: const [
                    DropdownMenuItem(value: "2", child: Text("عرض عادي")),
                    DropdownMenuItem(value: "1", child: Text("خصم بنسبة")),
                  ],
                  onChanged: (v) => controller.offerType.value = v ?? "2",
                )),
            const SizedBoxBetweenFieldWidgets(),

            // ===== Discount Fields (Conditional) =====
            Obx(() {
              if (controller.offerType.value == "1") {
                return Column(
                  children: [
                    // Discount Percentage
                    LabeledTextField(
                      widthButton: ManagerWidth.w80,
                      label: "نسبة الخصم %",
                      hintText: "أدخل نسبة الخصم (1-100)",
                      controller: controller.offerPriceController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // Start & End Dates
                    Row(
                      children: [
                        // Start Date
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(
                              context,
                              controller.offerStartDateController,
                              'تاريخ بداية العرض',
                            ),
                            child: AbsorbPointer(
                              child: LabeledTextField(
                                label: "تاريخ البداية",
                                hintText: "اختر تاريخ البداية",
                                controller: controller.offerStartDateController,
                                widthButton: 130,
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: ManagerColors.primaryColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w16),

                        // End Date
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(
                              context,
                              controller.offerEndDateController,
                              'تاريخ نهاية العرض',
                            ),
                            child: AbsorbPointer(
                              child: LabeledTextField(
                                label: "تاريخ النهاية",
                                hintText: "اختر تاريخ النهاية",
                                controller: controller.offerEndDateController,
                                widthButton: 130,
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: ManagerColors.primaryColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // Offer Description
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: "وصف العرض",
                      hintText: "اكتب تفاصيل العرض الخاصة بالخصم...",
                      controller: controller.offerDescriptionController,
                      textInputAction: TextInputAction.done,
                      minLines: 3,
                      maxLines: 5,
                    ),
                    const SizedBoxBetweenFieldWidgets(),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // ===== Offer Status =====
            Obx(() => LabeledDropdownField<String>(
                  label: "حالة العرض",
                  hint: "اختر حالة العرض",
                  value: controller.offerStatus.value,
                  // ✅ إزالة الشرط
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

            // ===== Submit Button =====
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

  // ==================== Date Picker Helper ====================
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    String title,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: title,
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ManagerColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: ManagerColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }
}
