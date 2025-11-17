// update_offer_screen.dart
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/lable_drop_down_button.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/upload_media_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
import '../controller/update_offer_controller.dart';

class UpdateOfferScreen extends StatelessWidget {
  const UpdateOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UpdateOfferController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.updateOfferTitle, // "تعديل العرض"
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
  Widget _buildEmptyState(UpdateOfferController controller) {
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
              ManagerStrings.noOrganizationsAvailable, // 'لا توجد مؤسسات متاحة'
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s18,
                color: ManagerColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h12),
            Text(
              ManagerStrings
                  .registerOrganizationFirst, // 'يرجى تسجيل مؤسسة أولاً'
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.greyWithColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h32),
            ButtonApp(
              title: ManagerStrings.retry, // 'إعادة المحاولة'
              onPressed: controller.retryFetchCompanies,
              paddingWidth: ManagerWidth.w48,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Main Form ====================
  Widget _buildForm(BuildContext context, UpdateOfferController controller) {
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
            TitleFormScreenWidget(title: ManagerStrings.updateOfferDetails),
            // "تعديل تفاصيل العرض"
            SubTitleFormScreenWidget(
              subTitle: ManagerStrings
                  .updateOfferSubtitle, // "قم بتحديث تفاصيل العرض المنشور"
            ),
            SizedBox(height: ManagerHeight.h20),

            // Existing Image Preview
            Obx(() {
              if (controller.existingImageUrl.value.isNotEmpty &&
                  controller.pickedImage.value == null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ManagerStrings.currentImage, // 'الصورة الحالية'
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.black,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h8),
                    Container(
                      height: ManagerHeight.h200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ManagerRadius.r12),
                        border: Border.all(
                          color: ManagerColors.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(ManagerRadius.r12),
                        child: CachedNetworkImage(
                          imageUrl: controller.existingImageUrl.value,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h8),
                    Text(
                      ManagerStrings.uploadNewImageOptional,
                      // 'اختياري: قم برفع صورة جديدة للتحديث'
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: Colors.grey[600]!,
                      ),
                    ),
                    const SizedBoxBetweenFieldWidgets(),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // ===== Organization Dropdown =====
            Obx(() {
              return LabeledDropdownField(
                label: ManagerStrings.selectOrganization,
                // "اختر المؤسسة"
                hint: ManagerStrings.selectOrganizationHint,
                // "حدد المؤسسة المرتبطة بالعرض"
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
              label: ManagerStrings.productName,
              // "اسم المنتج"
              hintText: ManagerStrings.enterProductName,
              // "أدخل اسم المنتج..."
              controller: controller.productNameController,
              textInputAction: TextInputAction.next,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // ===== Product Description =====
            LabeledTextField(
              widthButton: ManagerWidth.w130,
              label: ManagerStrings.productDescription,
              // "وصف المنتج"
              hintText: ManagerStrings.enterProductDescription,
              // "اكتب وصفاً مفصلاً للمنتج..."
              controller: controller.productDescriptionController,
              textInputAction: TextInputAction.next,
              minLines: 3,
              maxLines: 5,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // ===== Product Image Upload (Optional for update) =====
            UploadMediaField(
              label: ManagerStrings
                  .productImageOptional, // "صورة المنتج (اختياري)"
              hint: ManagerStrings
                  .uploadNewImageHint, // "قم برفع صورة جديدة للتحديث"
              note: ManagerStrings.allowedFormats, // "الصيغ المسموحة: JPG, PNG"
              file: controller.pickedImage,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // ===== Product Price =====
            LabeledTextField(
              widthButton: ManagerWidth.w80,
              label: ManagerStrings.price,
              // "السعر"
              hintText: ManagerStrings.enterPrice,
              // "أدخل سعر المنتج"
              controller: controller.productPriceController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // ===== Offer Type =====
            Obx(() => LabeledDropdownField<String>(
                  label: ManagerStrings.offerType,
                  // "نوع العرض"
                  hint: ManagerStrings.selectOfferType,
                  // "اختر نوع العرض"
                  value: controller.offerType.value,
                  items: [
                    DropdownMenuItem(
                        value: "2",
                        child: Text(ManagerStrings.regularOffer)), // "عرض عادي"
                    DropdownMenuItem(
                        value: "1",
                        child: Text(
                            ManagerStrings.discountPercentage)), // "خصم بنسبة"
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
                      label: ManagerStrings.discountPercentage,
                      // "نسبة الخصم %"
                      hintText: ManagerStrings.enterDiscountPercentage,
                      // "أدخل نسبة الخصم (1-100)"
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
                              ManagerStrings
                                  .offerStartDate, // 'تاريخ بداية العرض'
                            ),
                            child: AbsorbPointer(
                              child: LabeledTextField(
                                label: ManagerStrings.startDate,
                                // "تاريخ البداية"
                                hintText: ManagerStrings.selectStartDate,
                                // "اختر تاريخ البداية"
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
                              ManagerStrings
                                  .offerEndDate, // 'تاريخ نهاية العرض'
                            ),
                            child: AbsorbPointer(
                              child: LabeledTextField(
                                label: ManagerStrings.endDate,
                                // "تاريخ النهاية"
                                hintText: ManagerStrings.selectEndDate,
                                // "اختر تاريخ النهاية"
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
                      label: ManagerStrings.offerDescription,
                      // "وصف العرض"
                      hintText: ManagerStrings.enterOfferDescription,
                      // "اكتب تفاصيل العرض..."
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
                  label: ManagerStrings.offerStatus,
                  // "حالة العرض"
                  hint: ManagerStrings.selectOfferStatus,
                  // "اختر حالة العرض"
                  value: controller.offerStatus.value,
                  items: [
                    DropdownMenuItem(
                        value: "5",
                        child: Text(
                            ManagerStrings.statusPending)), // "قيد المراجعة"
                    DropdownMenuItem(
                        value: "1",
                        child: Text(ManagerStrings.statusPublished)), // "منشور"
                    DropdownMenuItem(
                        value: "2",
                        child: Text(ManagerStrings.statusDraft)), // "غير منشور"
                    DropdownMenuItem(
                        value: "3",
                        child: Text(ManagerStrings.statusExpired)), // "منتهي"
                    DropdownMenuItem(
                        value: "4",
                        child: Text(ManagerStrings.statusCancelled)), // "ملغي"
                  ],
                  onChanged: (v) => controller.offerStatus.value = v ?? "5",
                )),

            SizedBox(height: ManagerHeight.h32),

            // ===== Submit Button =====
            ButtonApp(
              title: ManagerStrings.updateOffer, // "تحديث العرض"
              onPressed: controller.updateOffer,
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
      cancelText: ManagerStrings.cancel,
      confirmText: ManagerStrings.confirm,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
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
