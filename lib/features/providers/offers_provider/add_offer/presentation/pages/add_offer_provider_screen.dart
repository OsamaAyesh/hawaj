import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_radius.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
import '../../../register_company_offer_provider/domain/di/di.dart';
import '../controller/add_offer_controller.dart';

class AddOfferProviderScreen extends StatefulWidget {
  const AddOfferProviderScreen({super.key});

  @override
  State<AddOfferProviderScreen> createState() => _AddOfferProviderScreenState();
}

class _AddOfferProviderScreenState extends State<AddOfferProviderScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch company details when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<AddOfferController>();
      controller.onScreenEnter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddOfferController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.offerRegisterTitle,
      body: Obx(() {
        // 1️⃣ Initial Loading State
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        // 2️⃣ No Company Registered State
        if (!controller.hasCompany.value) {
          return _buildNoCompanyState(context, controller);
        }

        // 3️⃣ Add Offer Form
        return Stack(
          children: [
            _buildOfferForm(context, controller),
            if (controller.isSubmitting.value) LoadingWidget()
          ],
        );
      }),
    );
  }

  /// UI when no company is registered
  Widget _buildNoCompanyState(
      BuildContext context, AddOfferController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ManagerWidth.w24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_outlined,
                size: 80, color: Colors.grey.shade400),
            SizedBox(height: ManagerHeight.h24),

            // Title
            Text(
              ManagerStrings.noCompanyTitle,
              style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s22, color: ManagerColors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h12),

            // Subtitle
            Text(
              ManagerStrings.noCompanySubtitle,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.greyWithColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h32),

            // Go to Register Company Button
            ButtonApp(
              title: ManagerStrings.goToRegisterCompany,
              onPressed: () {
                initRegisterMyCompanyOfferProvider();
                Get.toNamed(Routes.registerCompanyOfferProviderScreen);
              },
              paddingWidth: 0,
            ),
            SizedBox(height: ManagerHeight.h16),

            // Retry Button
            OutlinedButton(
              onPressed: controller.fetchCompany,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w32,
                  vertical: ManagerHeight.h14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, size: 20),
                  SizedBox(width: ManagerWidth.w8),
                  Text(ManagerStrings.retry),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Main form for adding an offer
  Widget _buildOfferForm(BuildContext context, AddOfferController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + ManagerHeight.h16,
        ),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ManagerHeight.h24),

            // Screen Title & Subtitle
            TitleFormScreenWidget(title: ManagerStrings.offerAddNew),
            SubTitleFormScreenWidget(subTitle: ManagerStrings.offerSubtitle),
            SizedBox(height: ManagerHeight.h16),

            // Company Info Display
            Container(
              padding: EdgeInsets.all(ManagerWidth.w12),
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor.withOpacity(0.08),
                // خلفية لطيفة من الـprimary
                borderRadius: BorderRadius.circular(ManagerRadius.r12),
                border: Border.all(
                  color: ManagerColors.primaryColor.withOpacity(0.4),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ManagerColors.primaryColor.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // أيقونة المؤسسة
                  Container(
                    width: ManagerHeight.h36,
                    height: ManagerHeight.h36,
                    decoration: BoxDecoration(
                      color: ManagerColors.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ManagerColors.primaryColor.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.business,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w12),

                  // النص
                  Expanded(
                    child: Text(
                      '${ManagerStrings.businessName}: '
                      '${controller.company.value?.organization ?? ManagerStrings.noData}',
                      style: getMediumTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ManagerHeight.h16),

            // Product Name
            LabeledTextField(
              widthButton: ManagerWidth.w130,
              label: ManagerStrings.offerProductName,
              hintText: ManagerStrings.offerProductDesc1,
              controller: controller.productNameController,
              textInputAction: TextInputAction.next,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // Product Description
            LabeledTextField(
              widthButton: ManagerWidth.w130,
              label: ManagerStrings.offerProductDesc,
              hintText: ManagerStrings.offerProductDescHint,
              controller: controller.productDescriptionController,
              textInputAction: TextInputAction.next,
              minLines: 3,
              maxLines: 5,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // Product Images
            UploadMediaField(
              label: ManagerStrings.offerProductImages,
              hint: ManagerStrings.offerProductImagesHint,
              note: ManagerStrings.offerProductImagesHint2,
              file: controller.pickedImage,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // Product Price
            LabeledTextField(
              widthButton: ManagerWidth.w40,
              label: ManagerStrings.offerProductPrice,
              hintText: ManagerStrings.offerProductPriceHint,
              controller: controller.productPriceController,
              keyboardType: TextInputType.number,
              buttonWidget: Padding(
                padding: EdgeInsets.symmetric(vertical: ManagerHeight.h2),
                child: Image.asset(ManagerIcons.ryalSudia),
              ),
            ),
            const SizedBoxBetweenFieldWidgets(),

            // Offer Type
            Obx(() => LabeledDropdownField<String>(
                  label: ManagerStrings.offerType,
                  hint: ManagerStrings.offerTypeHint,
                  value: controller.offerType.value.isEmpty
                      ? null
                      : controller.offerType.value,
                  items: [
                    DropdownMenuItem(
                        value: "2",
                        child: Text(ManagerStrings.offerTypeNormal)),
                    DropdownMenuItem(
                        value: "1",
                        child: Text(ManagerStrings.offerTypeDiscount)),
                  ],
                  onChanged: (v) => controller.offerType.value = v ?? "",
                )),

            // Discount Fields (appear only if discount selected)
            Obx(() {
              if (controller.offerType.value == "1") {
                return Column(
                  children: [
                    const SizedBoxBetweenFieldWidgets(),

                    // Discount Percentage
                    LabeledTextField(
                      widthButton: ManagerWidth.w40,
                      label: ManagerStrings.offerDiscountPercent,
                      hintText: ManagerStrings.offerDiscountPercentHint,
                      controller: controller.offerPriceController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    // Start & End Dates
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
                                widthButton: ManagerWidth.w130,
                                label: ManagerStrings.offerFromDate,
                                hintText: ManagerStrings.offerFromDateHint,
                                controller: controller.offerStartDateController,
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
                                widthButton: ManagerWidth.w130,
                                label: ManagerStrings.offerToDate,
                                hintText: ManagerStrings.offerToDateHint,
                                controller: controller.offerEndDateController,
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

            // Offer Status
            Obx(() => LabeledDropdownField<String>(
                  label: ManagerStrings.offerStatus,
                  hint: ManagerStrings.offerStatusHint,
                  value: controller.offerStatus.value.isEmpty
                      ? null
                      : controller.offerStatus.value,
                  items: [
                    DropdownMenuItem(
                      value: "5",
                      child: Text(ManagerStrings.offerStatusPending),
                    ),
                    DropdownMenuItem(
                      value: "1",
                      child: Text(ManagerStrings.offerStatusPublished),
                    ),
                    DropdownMenuItem(
                      value: "2",
                      child: Text(ManagerStrings.offerStatusUnpublished),
                    ),
                    DropdownMenuItem(
                      value: "3",
                      child: Text(ManagerStrings.offerStatusFinished),
                    ),
                    DropdownMenuItem(
                      value: "4",
                      child: Text(ManagerStrings.offerStatusCanceled),
                    ),
                  ],
                  onChanged: (v) => controller.offerStatus.value = v ?? "5",
                )),

            SizedBox(height: ManagerHeight.h24),

            // Submit Button
            ButtonApp(
              title: ManagerStrings.offerSubmit,
              onPressed: () {
                showDialogConfirmRegisterCompanyOffer(
                  title: ManagerStrings.confirmAddProductTitle,
                  subTitle: ManagerStrings.confirmAddProductSubtitle,
                  actionConfirmText: ManagerStrings.confirmAddProductConfirm,
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
    );
  }
}

// import 'package:app_mobile/core/resources/manager_icons.dart';
// import 'package:app_mobile/core/resources/manager_strings.dart';
// import 'package:app_mobile/core/widgets/button_app.dart';
// import 'package:app_mobile/core/widgets/loading_widget.dart';
// import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../../../core/resources/manager_height.dart';
// import '../../../../../../core/resources/manager_width.dart';
// import '../../../../../../core/widgets/labeled_text_field.dart';
// import '../../../../../../core/widgets/lable_drop_down_button.dart';
// import '../../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
// import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
// import '../../../../../../core/widgets/upload_media_widget.dart';
// import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
// import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
// import '../controller/add_offer_controller.dart';
//
// class AddOfferProviderScreen extends StatefulWidget {
//   const AddOfferProviderScreen({super.key});
//
//   @override
//   State<AddOfferProviderScreen> createState() => _AddOfferProviderScreenState();
// }
//
// class _AddOfferProviderScreenState extends State<AddOfferProviderScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // استدعاء جلب الشركة في كل مرة تفتح فيها الشاشة
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final controller = Get.find<AddOfferController>();
//       controller.onScreenEnter();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AddOfferController>();
//
//     return ScaffoldWithBackButton(
//       title: ManagerStrings.offerRegisterTitle,
//       body: Obx(() {
//         // ===== 1️⃣ حالة التحميل الأولي =====
//         if (controller.isLoading.value) {
//           return const Center(
//             child: LoadingWidget(),
//           );
//         }
//
//         // ===== 2️⃣ حالة عدم وجود شركة =====
//         if (!controller.hasCompany.value) {
//           return _buildNoCompanyState(context, controller);
//         }
//
//         // ===== 3️⃣ نموذج إضافة العرض =====
//         return Stack(
//           children: [
//             _buildOfferForm(context, controller),
//
//             // Overlay أثناء عملية الإرسال
//             if (controller.isSubmitting.value)
//               Container(
//                 color: Colors.black.withOpacity(0.5),
//                 child: const Center(
//                   child: LoadingWidget(),
//                 ),
//               ),
//           ],
//         );
//       }),
//     );
//   }
//
//   // ===== شاشة عدم وجود شركة =====
//   Widget _buildNoCompanyState(
//       BuildContext context, AddOfferController controller) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(ManagerWidth.w24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // أيقونة
//             Icon(
//               Icons.business_outlined,
//               size: 80,
//               color: Colors.grey.shade400,
//             ),
//             SizedBox(height: ManagerHeight.h24),
//
//             // العنوان
//             Text(
//               'يجب تسجيل شركة أولاً',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey.shade800,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: ManagerHeight.h12),
//
//             // الوصف
//             Text(
//               'لإضافة عروض، يجب عليك تسجيل شركتك أولاً في قسم العروض اليومية',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey.shade600,
//                 height: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: ManagerHeight.h32),
//
//             // زر الانتقال لتسجيل الشركة
//             ButtonApp(
//               title: 'انتقل إلى تسجيل الشركة',
//               onPressed: () {
//                 Get.back(); // العودة للصفحة السابقة
//                 // يمكنك هنا توجيه المستخدم لصفحة تسجيل الشركة
//                 // Get.toNamed(Routes.registerCompany);
//               },
//               paddingWidth: 0,
//             ),
//             SizedBox(height: ManagerHeight.h16),
//
//             // زر إعادة المحاولة
//             OutlinedButton(
//               onPressed: () {
//                 controller.fetchCompany();
//               },
//               style: OutlinedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: ManagerWidth.w32,
//                   vertical: ManagerHeight.h14,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.refresh, size: 20),
//                   SizedBox(width: ManagerWidth.w8),
//                   const Text('إعادة المحاولة'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ===== نموذج إضافة العرض =====
//   Widget _buildOfferForm(BuildContext context, AddOfferController controller) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
//       child: SingleChildScrollView(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom + ManagerHeight.h16,
//         ),
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: ManagerHeight.h24),
//
//             // ===== العنوان والوصف =====
//             TitleFormScreenWidget(title: ManagerStrings.offerAddNew),
//             SubTitleFormScreenWidget(subTitle: ManagerStrings.offerSubtitle),
//             SizedBox(height: ManagerHeight.h16),
//
//             // ===== معلومات الشركة =====
//             Container(
//               padding: EdgeInsets.all(ManagerWidth.w12),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.blue.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.business, color: Colors.blue.shade700, size: 20),
//                   SizedBox(width: ManagerWidth.w8),
//                   Expanded(
//                     child: Text(
//                       'الشركة: ${controller.company.value?.organization ?? "غير محدد"}',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.blue.shade900,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: ManagerHeight.h16),
//
//             // ===== اسم المنتج =====
//             LabeledTextField(
//               widthButton: ManagerWidth.w130,
//               label: ManagerStrings.offerProductName,
//               hintText: ManagerStrings.offerProductDesc1,
//               controller: controller.productNameController,
//               textInputAction: TextInputAction.next,
//             ),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== وصف المنتج =====
//             LabeledTextField(
//               widthButton: ManagerWidth.w130,
//               label: ManagerStrings.offerProductDesc,
//               hintText: ManagerStrings.offerProductDescHint,
//               controller: controller.productDescriptionController,
//               textInputAction: TextInputAction.next,
//               minLines: 3,
//               maxLines: 5,
//             ),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== صورة المنتج =====
//             UploadMediaField(
//               label: ManagerStrings.offerProductImages,
//               hint: ManagerStrings.offerProductImagesHint,
//               note: ManagerStrings.offerProductImagesHint2,
//               file: controller.pickedImage,
//             ),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== سعر المنتج =====
//             LabeledTextField(
//               widthButton: ManagerWidth.w40,
//               label: ManagerStrings.offerProductPrice,
//               hintText: ManagerStrings.offerProductPriceHint,
//               controller: controller.productPriceController,
//               keyboardType: TextInputType.number,
//               buttonWidget: Padding(
//                 padding: EdgeInsets.symmetric(vertical: ManagerHeight.h2),
//                 child: Image.asset(ManagerIcons.ryalSudia),
//               ),
//             ),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== نوع العرض =====
//             Obx(() => LabeledDropdownField<String>(
//                   label: ManagerStrings.offerType,
//                   hint: ManagerStrings.offerTypeHint,
//                   value: controller.offerType.value.isEmpty
//                       ? null
//                       : controller.offerType.value,
//                   items: const [
//                     DropdownMenuItem(value: "2", child: Text("عادي")),
//                     DropdownMenuItem(value: "1", child: Text("خصم بالمئة")),
//                   ],
//                   onChanged: (v) => controller.offerType.value = v ?? "",
//                 )),
//
//             // ===== حقول الخصم (تظهر فقط عند اختيار خصم) =====
//             Obx(() {
//               if (controller.offerType.value == "1") {
//                 return Column(
//                   children: [
//                     const SizedBoxBetweenFieldWidgets(),
//
//                     // نسبة الخصم
//                     LabeledTextField(
//                       widthButton: ManagerWidth.w40,
//                       label: "نسبة الخصم %",
//                       hintText: "أدخل نسبة الخصم",
//                       controller: controller.offerPriceController,
//                       keyboardType: TextInputType.number,
//                     ),
//                     const SizedBoxBetweenFieldWidgets(),
//
//                     // تاريخ البداية والنهاية
//                     Row(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () async {
//                               final picked = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime.now(),
//                                 lastDate: DateTime(2100),
//                               );
//                               if (picked != null) {
//                                 controller.offerStartDateController.text =
//                                     "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//                               }
//                             },
//                             child: AbsorbPointer(
//                               child: LabeledTextField(
//                                 widthButton: ManagerWidth.w130,
//                                 label: ManagerStrings.offerFromDate,
//                                 hintText: "اختر تاريخ البداية",
//                                 controller: controller.offerStartDateController,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: ManagerWidth.w16),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () async {
//                               final picked = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime.now(),
//                                 lastDate: DateTime(2100),
//                               );
//                               if (picked != null) {
//                                 controller.offerEndDateController.text =
//                                     "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//                               }
//                             },
//                             child: AbsorbPointer(
//                               child: LabeledTextField(
//                                 widthButton: ManagerWidth.w130,
//                                 label: ManagerStrings.offerToDate,
//                                 hintText: "اختر تاريخ النهاية",
//                                 controller: controller.offerEndDateController,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBoxBetweenFieldWidgets(),
//
//                     // وصف العرض
//                     LabeledTextField(
//                       widthButton: ManagerWidth.w130,
//                       label: ManagerStrings.offerDesc,
//                       hintText: ManagerStrings.offerDescHint,
//                       controller: controller.offerDescriptionController,
//                       minLines: 4,
//                       maxLines: 5,
//                     ),
//                   ],
//                 );
//               }
//               return const SizedBox.shrink();
//             }),
//             const SizedBoxBetweenFieldWidgets(),
//
//             // ===== حالة العرض =====
//             Obx(() => LabeledDropdownField<String>(
//                   label: "حالة العرض",
//                   hint: "اختر حالة العرض",
//                   value: controller.offerStatus.value.isEmpty
//                       ? null
//                       : controller.offerStatus.value,
//                   items: const [
//                     DropdownMenuItem(value: "5", child: Text("قيد المعاينة")),
//                     DropdownMenuItem(value: "1", child: Text("نشر")),
//                     DropdownMenuItem(value: "2", child: Text("غير منشور")),
//                     DropdownMenuItem(value: "3", child: Text("منتهي")),
//                     DropdownMenuItem(value: "4", child: Text("ملغي")),
//                   ],
//                   onChanged: (v) => controller.offerStatus.value = v ?? "5",
//                 )),
//
//             SizedBox(height: ManagerHeight.h24),
//
//             // ===== زر الإرسال =====
//             ButtonApp(
//               title: ManagerStrings.offerSubmit,
//               onPressed: () {
//                 showDialogConfirmRegisterCompanyOffer(
//                   title: ManagerStrings.confirmAddProductTitle,
//                   subTitle: ManagerStrings.confirmAddProductSubtitle,
//                   actionConfirmText: ManagerStrings.confirmAddProductConfirm,
//                   actionCancel: ManagerStrings.confirmAddProductCancel,
//                   context,
//                   onConfirm: controller.submitOffer,
//                   onCancel: () {},
//                 );
//               },
//               paddingWidth: 0,
//             ),
//             SizedBox(height: ManagerHeight.h16),
//           ],
//         ),
//       ),
//     );
//   }
// }
