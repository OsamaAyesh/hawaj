// add_offer_new_screen.dart
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
import '../../domain/di/di.dart';
import '../controller/add_offer_new_controller.dart';

class AddOfferNewScreen extends StatefulWidget {
  const AddOfferNewScreen({super.key});

  @override
  State<AddOfferNewScreen> createState() => _AddOfferNewScreenState();
}

class _AddOfferNewScreenState extends State<AddOfferNewScreen>
    with SingleTickerProviderStateMixin {
  late final AddOfferNewController controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Get controller
    controller = Get.find<AddOfferNewController>();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animation after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    disposeAddOfferNew();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "إضافة عرض جديد",
      body: Obx(() {
        // Loading state for fetching companies
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        // Empty state - no companies
        if (controller.companies.isEmpty) {
          return _buildEmptyState();
        }

        // Main form with animation
        return Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildForm(context),
              ),
            ),

            // Submitting overlay
            if (controller.isSubmitting.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ManagerWidth.w32,
                      vertical: ManagerHeight.h24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LoadingWidget(),
                        SizedBox(height: ManagerHeight.h16),
                        Text(
                          'جاري إضافة العرض...',
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s15,
                            color: ManagerColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  // ==================== Empty State ====================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ManagerWidth.w24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 600),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.elasticOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.business_outlined,
                  size: 80,
                  color: ManagerColors.primaryColor,
                ),
              ),
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
  Widget _buildForm(BuildContext context) {
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
            _buildHeader(),
            SizedBox(height: ManagerHeight.h20),

            // Form Fields
            _buildOrganizationDropdown(),
            const SizedBoxBetweenFieldWidgets(),

            _buildProductNameField(),
            const SizedBoxBetweenFieldWidgets(),

            _buildProductDescriptionField(),
            const SizedBoxBetweenFieldWidgets(),

            _buildProductImageField(),
            const SizedBoxBetweenFieldWidgets(),

            _buildProductPriceField(),
            const SizedBoxBetweenFieldWidgets(),

            _buildOfferTypeDropdown(),
            const SizedBoxBetweenFieldWidgets(),

            _buildConditionalDiscountFields(),

            _buildOfferStatusDropdown(),

            SizedBox(height: ManagerHeight.h32),

            // Submit Button
            _buildSubmitButton(),

            SizedBox(height: ManagerHeight.h20),
          ],
        ),
      ),
    );
  }

  // ==================== Header Section ====================
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleFormScreenWidget(title: "تفاصيل العرض الجديد"),
        SubTitleFormScreenWidget(
          subTitle:
              "قم بإضافة تفاصيل العرض الذي ترغب بنشره ضمن مؤسستك المسجلة.",
        ),
      ],
    );
  }

  // ==================== Organization Dropdown ====================
  Widget _buildOrganizationDropdown() {
    return Obx(() {
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
    });
  }

  // ==================== Product Name Field ====================
  Widget _buildProductNameField() {
    return LabeledTextField(
      widthButton: ManagerWidth.w130,
      label: "اسم المنتج",
      hintText: "أدخل اسم المنتج...",
      controller: controller.productNameController,
      textInputAction: TextInputAction.next,
    );
  }

  // ==================== Product Description Field ====================
  Widget _buildProductDescriptionField() {
    return LabeledTextField(
      widthButton: ManagerWidth.w130,
      label: "وصف المنتج",
      hintText: "اكتب وصفاً مفصلاً للمنتج...",
      controller: controller.productDescriptionController,
      textInputAction: TextInputAction.next,
      minLines: 3,
      maxLines: 5,
    );
  }

  // ==================== Product Image Field ====================
  Widget _buildProductImageField() {
    return UploadMediaField(
      label: "صورة المنتج",
      hint: "قم برفع صورة واضحة للمنتج",
      note: "الصيغ المسموحة: JPG, PNG",
      file: controller.pickedImage,
    );
  }

  // ==================== Product Price Field ====================
  Widget _buildProductPriceField() {
    return LabeledTextField(
      widthButton: ManagerWidth.w80,
      label: "السعر",
      hintText: "أدخل سعر المنتج",
      controller: controller.productPriceController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
    );
  }

  // ==================== Offer Type Dropdown ====================
  Widget _buildOfferTypeDropdown() {
    return Obx(() => LabeledDropdownField<String>(
          label: "نوع العرض",
          hint: "اختر نوع العرض",
          value: controller.offerType.value,
          items: const [
            DropdownMenuItem(value: "2", child: Text("عرض عادي")),
            DropdownMenuItem(value: "1", child: Text("خصم بنسبة")),
          ],
          onChanged: (v) => controller.offerType.value = v ?? "2",
        ));
  }

  // ==================== Conditional Discount Fields ====================
  Widget _buildConditionalDiscountFields() {
    return Obx(() {
      if (controller.offerType.value == "1") {
        return TweenAnimationBuilder(
          duration: const Duration(milliseconds: 400),
          tween: Tween<double>(begin: 0, end: 1),
          curve: Curves.easeInOut,
          builder: (context, double value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Column(
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
                    child: _buildDateField(
                      label: "تاريخ البداية",
                      hint: "اختر تاريخ البداية",
                      controller: controller.offerStartDateController,
                      title: 'تاريخ بداية العرض',
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w16),

                  // End Date
                  Expanded(
                    child: _buildDateField(
                      label: "تاريخ النهاية",
                      hint: "اختر تاريخ النهاية",
                      controller: controller.offerEndDateController,
                      title: 'تاريخ نهاية العرض',
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
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  // ==================== Date Field Helper ====================
  Widget _buildDateField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String title,
  }) {
    return GestureDetector(
      onTap: () => _selectDate(context, controller, title),
      child: AbsorbPointer(
        child: LabeledTextField(
          label: label,
          hintText: hint,
          controller: controller,
          widthButton: 130,
          prefixIcon: Icon(
            Icons.calendar_today,
            color: ManagerColors.primaryColor,
            size: 18,
          ),
        ),
      ),
    );
  }

  // ==================== Offer Status Dropdown ====================
  Widget _buildOfferStatusDropdown() {
    return Obx(() => LabeledDropdownField<String>(
          label: "حالة العرض",
          hint: "اختر حالة العرض",
          value: controller.offerStatus.value,
          items: const [
            DropdownMenuItem(value: "5", child: Text("قيد المراجعة")),
            DropdownMenuItem(value: "1", child: Text("منشور")),
            DropdownMenuItem(value: "2", child: Text("غير منشور")),
            DropdownMenuItem(value: "3", child: Text("منتهي")),
            DropdownMenuItem(value: "4", child: Text("ملغي")),
          ],
          onChanged: (v) => controller.offerStatus.value = v ?? "5",
        ));
  }

  // ==================== Submit Button ====================
  Widget _buildSubmitButton() {
    return ButtonApp(
      title: "إضافة العرض",
      onPressed: controller.submitOffer,
      paddingWidth: 0,
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
// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_font_size.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_styles.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/widgets/button_app.dart';
// import 'package:app_mobile/core/widgets/labeled_text_field.dart';
// import 'package:app_mobile/core/widgets/lable_drop_down_button.dart';
// import 'package:app_mobile/core/widgets/loading_widget.dart';
// import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
// import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
// import 'package:app_mobile/core/widgets/upload_media_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
// import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
// import '../controller/add_offer_new_controller.dart';
//
// class AddOfferNewNewNewScreen extends StatelessWidget {
//   const AddOfferNewNewNewScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AddOfferNewController>();
//
//     return ScaffoldWithBackButton(
//       title: "إضافة عرض جديد",
//       body: Obx(() {
//         // Loading state for fetching companies
//         if (controller.isLoading.value) {
//           return const Center(child: LoadingWidget());
//         }
//
//         // Empty state - no companies
//         if (controller.companies.isEmpty) {
//           return _buildEmptyState(controller);
//         }
//
//         // Main form
//         return Stack(
//           children: [
//             _buildForm(context, controller),
//
//             // Submitting overlay
//             if (controller.isSubmitting.value)
//               Container(
//                 color: Colors.black26,
//                 child: const Center(child: LoadingWidget()),
//               ),
//           ],
//         );
//       }),
//     );
//   }
//
//   // ==================== Empty State ====================
//   Widget _buildEmptyState(AddOfferNewController controller) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(ManagerWidth.w24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.business_outlined,
//               size: 80,
//               color: ManagerColors.greyWithColor,
//             ),
//             SizedBox(height: ManagerHeight.h24),
//             Text(
//               'لا توجد مؤسسات متاحة',
//               style: getBoldTextStyle(
//                 fontSize: ManagerFontSize.s18,
//                 color: ManagerColors.black,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: ManagerHeight.h12),
//             Text(
//               'يرجى تسجيل مؤسسة أولاً لتتمكن من إضافة عروض',
//               style: getRegularTextStyle(
//                 fontSize: ManagerFontSize.s14,
//                 color: ManagerColors.greyWithColor,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: ManagerHeight.h32),
//             ButtonApp(
//               title: 'إعادة المحاولة',
//               onPressed: controller.retryFetchCompanies,
//               paddingWidth: ManagerWidth.w48,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ==================== Main Form ====================
//   Widget _buildForm(BuildContext context, AddOfferNewController controller) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom + ManagerHeight.h20,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: ManagerHeight.h20),
//
//             // Title & Subtitle
//             TitleFormScreenWidget(title: "تفاصيل العرض الجديد"),
//             SubTitleFormScreenWidget(
//               subTitle:
//                   "قم بإضافة تفاصيل العرض الذي ترغب بنشره ضمن مؤسستك المسجلة.",
//             ),
//             SizedBox(height: ManagerHeight.h20),
//
//             // ===== Organization Dropdown =====
//             Obx(() {
//               return LabeledDropdownField(
//                 label: "اختر المؤسسة",
//                 hint: "حدد المؤسسة المرتبطة بالعرض",
//                 value: controller.selectedCompany.value,
//                 items: controller.companies.map((company) {
//                   return DropdownMenuItem(
//                     value: company,
//                     child: Text(
//                       company.organizationName,
//                       style: getMediumTextStyle(
//                         fontSize: ManagerFontSize.s14,
//                         color: ManagerColors.black,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   controller.selectedCompany.value = value;
//                 },
//               );
//             }),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== Product Name =====
//             LabeledTextField(
//               widthButton: ManagerWidth.w130,
//               label: "اسم المنتج",
//               hintText: "أدخل اسم المنتج...",
//               controller: controller.productNameController,
//               textInputAction: TextInputAction.next,
//             ),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== Product Description =====
//             LabeledTextField(
//               widthButton: ManagerWidth.w130,
//               label: "وصف المنتج",
//               hintText: "اكتب وصفاً مفصلاً للمنتج...",
//               controller: controller.productDescriptionController,
//               textInputAction: TextInputAction.next,
//               minLines: 3,
//               maxLines: 5,
//             ),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== Product Image =====
//             UploadMediaField(
//               label: "صورة المنتج",
//               hint: "قم برفع صورة واضحة للمنتج",
//               note: "الصيغ المسموحة: JPG, PNG",
//               file: controller.pickedImage,
//             ),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== Product Price =====
//             LabeledTextField(
//               widthButton: ManagerWidth.w80,
//               label: "السعر",
//               hintText: "أدخل سعر المنتج",
//               controller: controller.productPriceController,
//               keyboardType: TextInputType.number,
//               textInputAction: TextInputAction.next,
//             ),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== Offer Type =====
//             Obx(() => LabeledDropdownField<String>(
//                   label: "نوع العرض",
//                   hint: "اختر نوع العرض",
//                   value: controller.offerType.value,
//                   // ✅ إزالة الشرط
//                   items: const [
//                     DropdownMenuItem(value: "2", child: Text("عرض عادي")),
//                     DropdownMenuItem(value: "1", child: Text("خصم بنسبة")),
//                   ],
//                   onChanged: (v) => controller.offerType.value = v ?? "2",
//                 )),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== Discount Fields (Conditional) =====
//             Obx(() {
//               if (controller.offerType.value == "1") {
//                 return Column(
//                   children: [
//                     // Discount Percentage
//                     LabeledTextField(
//                       widthButton: ManagerWidth.w80,
//                       label: "نسبة الخصم %",
//                       hintText: "أدخل نسبة الخصم (1-100)",
//                       controller: controller.offerPriceController,
//                       keyboardType: TextInputType.number,
//                       textInputAction: TextInputAction.next,
//                     ),
//                     const SizedBoxBetweenFieldWidgets(),
//
//                     // Start & End Dates
//                     Row(
//                       children: [
//                         // Start Date
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () => _selectDate(
//                               context,
//                               controller.offerStartDateController,
//                               'تاريخ بداية العرض',
//                             ),
//                             child: AbsorbPointer(
//                               child: LabeledTextField(
//                                 label: "تاريخ البداية",
//                                 hintText: "اختر تاريخ البداية",
//                                 controller: controller.offerStartDateController,
//                                 widthButton: 130,
//                                 prefixIcon: Icon(
//                                   Icons.calendar_today,
//                                   color: ManagerColors.primaryColor,
//                                   size: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: ManagerWidth.w16),
//
//                         // End Date
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () => _selectDate(
//                               context,
//                               controller.offerEndDateController,
//                               'تاريخ نهاية العرض',
//                             ),
//                             child: AbsorbPointer(
//                               child: LabeledTextField(
//                                 label: "تاريخ النهاية",
//                                 hintText: "اختر تاريخ النهاية",
//                                 controller: controller.offerEndDateController,
//                                 widthButton: 130,
//                                 prefixIcon: Icon(
//                                   Icons.calendar_today,
//                                   color: ManagerColors.primaryColor,
//                                   size: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBoxBetweenFieldWidgets(),
//
//                     // Offer Description
//                     LabeledTextField(
//                       widthButton: ManagerWidth.w130,
//                       label: "وصف العرض",
//                       hintText: "اكتب تفاصيل العرض الخاصة بالخصم...",
//                       controller: controller.offerDescriptionController,
//                       textInputAction: TextInputAction.done,
//                       minLines: 3,
//                       maxLines: 5,
//                     ),
//                     const SizedBoxBetweenFieldWidgets(),
//                   ],
//                 );
//               }
//               return const SizedBox.shrink();
//             }),
//
//             // ===== Offer Status =====
//             Obx(() => LabeledDropdownField<String>(
//                   label: "حالة العرض",
//                   hint: "اختر حالة العرض",
//                   value: controller.offerStatus.value,
//                   // ✅ إزالة الشرط
//                   items: const [
//                     DropdownMenuItem(value: "5", child: Text("قيد المراجعة")),
//                     DropdownMenuItem(value: "1", child: Text("منشور")),
//                     DropdownMenuItem(value: "2", child: Text("غير منشور")),
//                     DropdownMenuItem(value: "3", child: Text("منتهي")),
//                     DropdownMenuItem(value: "4", child: Text("ملغي")),
//                   ],
//                   onChanged: (v) => controller.offerStatus.value = v ?? "5",
//                 )),
//
//             SizedBox(height: ManagerHeight.h32),
//
//             // ===== Submit Button =====
//             ButtonApp(
//               title: "إضافة العرض",
//               onPressed: controller.submitOffer,
//               paddingWidth: 0,
//             ),
//
//             SizedBox(height: ManagerHeight.h20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ==================== Date Picker Helper ====================
//   Future<void> _selectDate(
//     BuildContext context,
//     TextEditingController controller,
//     String title,
//   ) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//       helpText: title,
//       cancelText: 'إلغاء',
//       confirmText: 'تأكيد',
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: ManagerColors.primaryColor,
//               onPrimary: Colors.white,
//               onSurface: ManagerColors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       controller.text =
//           "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//     }
//   }
// }
