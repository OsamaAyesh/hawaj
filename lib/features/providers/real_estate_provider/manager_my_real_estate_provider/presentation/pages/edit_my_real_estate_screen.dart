import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/custom_confirm_dialog.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/lable_drop_down_button.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/upload_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/real_estate_item_model.dart';
import '../../../../../common/map_ticker/domain/di/di.dart';
import '../../../../../common/map_ticker/presenation/pages/map_ticker_screen.dart';
import '../controller/edit_my_real_estate_controller.dart';

class EditMyRealEstateScreen extends StatefulWidget {
  final RealEstateItemModel realEstate;

  const EditMyRealEstateScreen({super.key, required this.realEstate});

  @override
  State<EditMyRealEstateScreen> createState() => _EditMyRealEstateScreenState();
}

class _EditMyRealEstateScreenState extends State<EditMyRealEstateScreen> {
  late EditMyRealEstateController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<EditMyRealEstateController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeWithRealEstate(widget.realEstate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "تعديل العقار",
      body: Obx(() {
        if (controller.isPageLoading.value) {
          return const LoadingWidget();
        }

        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
                    .copyWith(bottom: ManagerHeight.h20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    TitleTextScreenWidget(title: "تعديل العقار"),
                    SubTitleTextScreenWidget(
                      subTitle:
                          "يمكنك تعديل تفاصيل العقار وتحديث بياناته الحالية",
                    ),
                    SizedBox(height: ManagerHeight.h20),

                    if (controller.propertyOwners.isNotEmpty)
                      LabeledDropdownField<String>(
                        label: "اختر المالك",
                        hint: "حدد المالك المرتبط بهذا العقار",
                        value: controller.propertyOwnerId,
                        items: controller.propertyOwners
                            .map((owner) => DropdownMenuItem(
                                  value: owner.id,
                                  child: Text(owner.ownerName),
                                ))
                            .toList(),
                        onChanged: (value) {
                          controller.propertyOwnerId = value;
                        },
                      ),
                    if (controller.propertyOwners.isNotEmpty)
                      const SizedBoxBetweenFieldWidgets(),

                    /// نوع العقار
                    LabeledDropdownField<String>(
                      label: "نوع العقار",
                      hint: "اختر نوع العقار",
                      value: controller.selectedPropertyType.value,
                      items: controller.propertyTypes
                          .map((e) => DropdownMenuItem(
                              value: e.name, child: Text(e.label ?? '')))
                          .toList(),
                      onChanged: (v) =>
                          controller.selectedPropertyType.value = v,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// نوع العملية
                    LabeledDropdownField<String>(
                      label: "نوع العملية",
                      hint: "اختر نوع العملية",
                      value: controller.selectedOperationType.value,
                      items: controller.operationTypes
                          .map((e) => DropdownMenuItem(
                              value: e.name, child: Text(e.label ?? '')))
                          .toList(),
                      onChanged: (v) =>
                          controller.selectedOperationType.value = v,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// صفة المعلن
                    LabeledDropdownField<String>(
                      label: "صفة المعلن",
                      hint: "اختر صفتك (مالك، وكيل...)",
                      value: controller.selectedAdvertiserRole.value,
                      items: controller.advertiserRoles
                          .map((e) => DropdownMenuItem(
                              value: e.name, child: Text(e.label ?? '')))
                          .toList(),
                      onChanged: (v) =>
                          controller.selectedAdvertiserRole.value = v,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// نوع البيع
                    LabeledDropdownField<String>(
                      label: "نوع البيع",
                      hint: "اختر نوع البيع (عاجل / عادي)",
                      value: controller.selectedSaleType.value,
                      items: controller.saleTypes
                          .map((e) => DropdownMenuItem(
                              value: e.name, child: Text(e.label ?? '')))
                          .toList(),
                      onChanged: (v) => controller.selectedSaleType.value = v,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// نوع الاستخدام
                    LabeledDropdownField<String>(
                      label: "نوع الاستخدام",
                      hint: "اختر نوع الاستخدام (سكني، تجاري...)",
                      value: controller.selectedUsageType.value,
                      items: controller.usageTypes
                          .map((e) => DropdownMenuItem(
                              value: e.name, child: Text(e.label ?? '')))
                          .toList(),
                      onChanged: (v) => controller.selectedUsageType.value = v,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// 📍 الموقع الجغرافي
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: "الموقع الجغرافي",
                      controller: controller.latController,
                      hintText: "حدد موقع العقار على الخريطة",
                      onButtonTap: () async {
                        MapTickerBindings().dependencies();
                        final result =
                            await Get.to(() => const MapTickerScreen());
                        if (result != null) {
                          controller.latController.text =
                              result.latitude.toString();
                          controller.lngController.text =
                              result.longitude.toString();
                        }
                      },
                      buttonWidget: Container(
                        width: ManagerWidth.w120,
                        height: ManagerHeight.h40,
                        decoration: BoxDecoration(
                          color: ManagerColors.primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            "تحديد الموقع",
                            style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s12,
                                color: ManagerColors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// 🏷️ العنوان
                    LabeledTextField(
                      widthButton: ManagerWidth.w140,
                      label: "عنوان الإعلان",
                      hintText: "اكتب عنوان الإعلان هنا",
                      controller: controller.subjectController,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// العنوان التفصيلي
                    LabeledTextField(
                      widthButton: ManagerWidth.w140,
                      label: "العنوان التفصيلي",
                      hintText: "ادخل العنوان التفصيلي للعقار",
                      controller: controller.addressController,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// السعر والمساحة
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            widthButton: ManagerWidth.w140,
                            label: "السعر المطلوب",
                            hintText: "أدخل السعر",
                            keyboardType: TextInputType.number,
                            controller: controller.priceController,
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w8),
                        Expanded(
                          child: LabeledTextField(
                            widthButton: ManagerWidth.w140,
                            label: "المساحة (م²)",
                            hintText: "ادخل المساحة",
                            keyboardType: TextInputType.number,
                            controller: controller.areaController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// العمولة والكلمات المفتاحية
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            widthButton: ManagerWidth.w140,
                            label: "نسبة العمولة %",
                            hintText: "ادخل النسبة",
                            keyboardType: TextInputType.number,
                            controller: controller.commissionController,
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w8),
                        Expanded(
                          child: LabeledTextField(
                            widthButton: ManagerWidth.w140,
                            label: "الكلمات المفتاحية",
                            hintText: "مثلاً: فيلا، شقة، جدة",
                            controller: controller.keywordsController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// ✳️ الحقول متعددة الاختيار (المميزات، المرافق، الأيام)
                    _MultiSelectPicker(
                      title: "المميزات",
                      placeholder: "اختر المميزات الخاصة بالعقار",
                      allItems: controller.features,
                      selectedIds: controller.selectedFeatureIds,
                      onToggleId: controller.toggleFeature,
                      idExtractor: (item) => item.id ?? '',
                      labelExtractor: (item) => item.featureName ?? '',
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    _MultiSelectPicker(
                      title: "المرافق",
                      placeholder: "اختر المرافق المتاحة (موقف، صالة...)",
                      allItems: controller.facilities,
                      selectedIds: controller.selectedFacilityIds,
                      onToggleId: controller.toggleFacility,
                      idExtractor: (item) => item.id ?? '',
                      labelExtractor: (item) => item.facilityName ?? '',
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    _MultiSelectPicker(
                      title: "الأيام المتاحة للزيارة",
                      placeholder: "اختر الأيام المناسبة للزيارة",
                      allItems: controller.weekDays,
                      selectedIds: controller.selectedVisitDayIds,
                      onToggleId: controller.toggleVisitDay,
                      idExtractor: (item) => item.name ?? '',
                      labelExtractor: (item) => item.label ?? '',
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// وصف العقار
                    LabeledTextField(
                      widthButton: ManagerWidth.w140,
                      label: "وصف العقار",
                      hintText: "أدخل وصفًا واضحًا للعقار",
                      minLines: 3,
                      maxLines: 5,
                      controller: controller.descriptionController,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// 📸 رفع الملفات
                    UploadMediaField(
                      label: "صور العقار",
                      hint: "رفع الصور",
                      note: "أضف صورًا واضحة للعقار لجذب العملاء.",
                      onFilePicked: (file) =>
                          controller.propertyImages.add(file),
                      file: controller.propertyImages.isNotEmpty
                          ? Rx(controller.propertyImages.last)
                          : Rx(null),
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    UploadMediaField(
                      label: "فيديوهات العقار",
                      hint: "رفع الفيديوهات",
                      note: "أضف فيديوهات توضيحية للعقار (اختياري).",
                      onFilePicked: (file) =>
                          controller.propertyVideos.add(file),
                      file: controller.propertyVideos.isNotEmpty
                          ? Rx(controller.propertyVideos.last)
                          : Rx(null),
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    UploadMediaField(
                      label: "صك العقار",
                      hint: "رفع الملف",
                      note: "قم برفع صك الملكية لإثبات صحة المعلومات.",
                      onFilePicked: (file) =>
                          controller.deedDocument.value = file,
                      file: controller.deedDocument,
                    ),
                    SizedBox(height: ManagerHeight.h36),

                    /// 🔘 زر التحديث
                    ButtonApp(
                      title: "تحديث العقار",
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return CustomConfirmDialog(
                              title: "تأكيد التعديل",
                              subtitle:
                                  "هل أنت متأكد من حفظ التغييرات؟\nتحقق من صحة جميع التفاصيل قبل المتابعة.",
                              confirmText: "تأكيد",
                              cancelText: "إلغاء",
                              onConfirm: () {
                                Navigator.of(context).pop();
                                controller.editRealEstate();
                              },
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
                      paddingWidth: 0,
                    ),
                    SizedBox(height: ManagerHeight.h32),
                  ],
                ),
              ),
            ),
            if (controller.isActionLoading.value) const LoadingWidget(),
          ],
        );
      }),
    );
  }
}

/// 🔹 Widget للمميزات / المرافق / الأيام - Generic Version
class _MultiSelectPicker<T> extends StatelessWidget {
  final String title;
  final String placeholder;
  final List<T> allItems;
  final RxList<String> selectedIds;
  final void Function(String id) onToggleId;
  final String Function(T item) idExtractor;
  final String Function(T item) labelExtractor;

  const _MultiSelectPicker({
    required this.title,
    required this.placeholder,
    required this.allItems,
    required this.selectedIds,
    required this.onToggleId,
    required this.idExtractor,
    required this.labelExtractor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
            label: title,
            hintText: selectedIds.isEmpty
                ? placeholder
                : "تم اختيار ${selectedIds.length} عنصر",
            widthButton: ManagerWidth.w44,
            onButtonTap: () => _openBottomSheet(context),
            buttonWidget: Container(
              width: ManagerWidth.w44,
              height: ManagerHeight.h44,
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.check, color: Colors.white),
            ),
          ),
          if (selectedIds.isNotEmpty) ...[
            SizedBox(height: ManagerHeight.h12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedIds.map((id) {
                final item = allItems.firstWhereOrNull(
                  (e) => idExtractor(e) == id,
                );
                final label = item != null ? labelExtractor(item) : id;
                return _TagPill(label: label, onRemove: () => onToggleId(id));
              }).toList(),
            ),
          ],
        ],
      );
    });
  }

  void _openBottomSheet(BuildContext context) {
    final tempSelected = selectedIds.toSet();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allItems.map((item) {
                        final id = idExtractor(item);
                        final lbl = labelExtractor(item);
                        final isSel = tempSelected.contains(id);
                        return ChoiceChip(
                          label: Text(
                            lbl,
                            style: getRegularTextStyle(
                              fontSize: ManagerFontSize.s12,
                              color: isSel
                                  ? Colors.white
                                  : ManagerColors.primaryColor,
                            ),
                          ),
                          selected: isSel,
                          selectedColor: ManagerColors.primaryColor,
                          backgroundColor:
                              ManagerColors.primaryColor.withOpacity(0.06),
                          onSelected: (_) {
                            setState(() {
                              isSel
                                  ? tempSelected.remove(id)
                                  : tempSelected.add(id);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              selectedIds.assignAll(tempSelected);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ManagerColors.primaryColor),
                            child: Text(
                              'تم',
                              style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s12,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: ManagerColors.primaryColor)),
                            child: Text(
                              'إلغاء',
                              style: getRegularTextStyle(
                                fontSize: ManagerFontSize.s12,
                                color: ManagerColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// 🔹 شكل العناصر المختارة
class _TagPill extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _TagPill({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
      height: 34,
      decoration: BoxDecoration(
        color: ManagerColors.primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s12, color: ManagerColors.black)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.close,
                  size: 16, color: ManagerColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
// import 'dart:io';
//
// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/widgets/button_app.dart';
// import 'package:app_mobile/core/widgets/custom_confirm_dialog.dart';
// import 'package:app_mobile/core/widgets/labeled_text_field.dart';
// import 'package:app_mobile/core/widgets/lable_drop_down_button.dart';
// import 'package:app_mobile/core/widgets/loading_widget.dart';
// import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
// import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
// import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
// import 'package:app_mobile/core/widgets/title_text_screen_widget.dart';
// import 'package:app_mobile/core/widgets/upload_media_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../../../core/model/real_estate_item_model.dart';
// import '../../data/request/edit_my_real_estate_request.dart';
// import '../controller/edit_my_real_estate_controller.dart';
//
// class EditMyRealEstateScreen extends StatefulWidget {
//   final RealEstateItemModel realEstate;
//
//   const EditMyRealEstateScreen({super.key, required this.realEstate});
//
//   @override
//   State<EditMyRealEstateScreen> createState() => _EditMyRealEstateScreenState();
// }
//
// class _EditMyRealEstateScreenState extends State<EditMyRealEstateScreen> {
//   late EditMyRealEstateController controller;
//
//   // Controllers for editable fields
//   final subjectController = TextEditingController();
//   final addressController = TextEditingController();
//   final priceController = TextEditingController();
//   final areaController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final latController = TextEditingController();
//   final lngController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.find<EditMyRealEstateController>();
//
//     final m = widget.realEstate;
//     subjectController.text = m.propertySubject;
//     addressController.text = m.propertyDetailedAddress;
//     priceController.text = m.price;
//     areaController.text = m.areaSqm;
//     descriptionController.text = m.propertyDescription;
//     latController.text = m.lat;
//     lngController.text = m.lng;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final estate = widget.realEstate;
//
//     return ScaffoldWithBackButton(
//       title: "تعديل العقار",
//       body: Obx(() {
//         return Stack(
//           children: [
//             SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TitleTextScreenWidget(title: "تعديل العقار"),
//                   const SubTitleTextScreenWidget(
//                     subTitle:
//                         "يمكنك تعديل تفاصيل العقار وتحديث بياناته الحالية",
//                   ),
//                   SizedBox(height: ManagerHeight.h20),
//
//                   /// نوع العقار
//                   LabeledDropdownField<String>(
//                     label: "نوع العقار",
//                     hint: "اختر نوع العقار",
//                     value: estate.propertyType,
//                     items: [
//                       DropdownMenuItem(
//                           value: estate.propertyType,
//                           child: Text(estate.propertyTypeLabel)),
//                     ],
//                     onChanged: (_) {},
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//
//                   /// نوع العملية
//                   LabeledDropdownField<String>(
//                     label: "نوع العملية",
//                     hint: "اختر نوع العملية",
//                     value: estate.operationType,
//                     items: [
//                       DropdownMenuItem(
//                           value: estate.operationType,
//                           child: Text(estate.operationTypeLabel)),
//                     ],
//                     onChanged: (_) {},
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//
//                   /// صفة المعلن
//                   LabeledDropdownField<String>(
//                     label: "صفة المعلن",
//                     hint: "اختر صفتك",
//                     value: estate.advertiserRole,
//                     items: [
//                       DropdownMenuItem(
//                           value: estate.advertiserRole,
//                           child: Text(estate.advertiserRoleLabel)),
//                     ],
//                     onChanged: (_) {},
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//
//                   /// نوع البيع
//                   LabeledDropdownField<String>(
//                     label: "نوع البيع",
//                     hint: "اختر نوع البيع",
//                     value: estate.saleType,
//                     items: [
//                       DropdownMenuItem(
//                           value: estate.saleType,
//                           child: Text(estate.saleTypeLabel)),
//                     ],
//                     onChanged: (_) {},
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//
//                   /// نوع الاستخدام
//                   LabeledDropdownField<String>(
//                     label: "نوع الاستخدام",
//                     hint: "اختر نوع الاستخدام",
//                     value: estate.usageType,
//                     items: [
//                       DropdownMenuItem(
//                           value: estate.usageType,
//                           child: Text(estate.usageTypeLabel)),
//                     ],
//                     onChanged: (_) {},
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//
//                   /// العنوان والموقع
//                   LabeledTextField(
//                     widthButton: ManagerWidth.w12,
//                     label: "عنوان الإعلان",
//                     hintText: "أدخل عنوان الإعلان",
//                     controller: subjectController,
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//                   LabeledTextField(
//                     widthButton: ManagerWidth.w12,
//                     label: "العنوان التفصيلي",
//                     hintText: "أدخل العنوان التفصيلي",
//                     controller: addressController,
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//                   LabeledTextField(
//                     widthButton: ManagerWidth.w12,
//                     label: "الموقع الجغرافي",
//                     hintText: "إحداثيات الموقع",
//                     controller: latController,
//                     buttonWidget: Container(
//                       width: ManagerWidth.w100,
//                       height: ManagerHeight.h40,
//                       decoration: BoxDecoration(
//                         color: ManagerColors.primaryColor,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "تحديد الموقع",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//
//                   /// السعر والمساحة
//                   Row(
//                     children: [
//                       Expanded(
//                         child: LabeledTextField(
//                           widthButton: ManagerWidth.w12,
//                           label: "السعر",
//                           hintText: "أدخل السعر",
//                           controller: priceController,
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                       SizedBox(width: ManagerWidth.w8),
//                       Expanded(
//                         child: LabeledTextField(
//                           widthButton: ManagerWidth.w12,
//                           label: "المساحة (م²)",
//                           hintText: "أدخل المساحة",
//                           controller: areaController,
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//
//                   /// الوصف
//                   LabeledTextField(
//                     widthButton: ManagerWidth.w12,
//                     label: "الوصف",
//                     hintText: "أدخل وصفًا واضحًا للعقار",
//                     controller: descriptionController,
//                     minLines: 3,
//                     maxLines: 5,
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//
//                   /// رفع الوسائط
//                   UploadMediaField(
//                     label: "صور العقار",
//                     hint: "قم برفع صور العقار",
//                     note: "يمكنك استبدال الصور القديمة أو إضافة جديدة",
//                     onFilePicked: (File file) {},
//                     file: Rx<File?>(null),
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//
//                   UploadMediaField(
//                     label: "فيديوهات العقار",
//                     hint: "قم برفع فيديوهات العقار",
//                     note: "اختياري: يمكن رفع فيديو توضيحي",
//                     onFilePicked: (File file) {},
//                     file: Rx<File?>(null),
//                   ),
//                   const SizedBoxBetweenFieldWidgets(),
//
//                   UploadMediaField(
//                     label: "صك العقار",
//                     hint: "قم برفع وثيقة الملكية",
//                     note: "ملف PDF أو صورة",
//                     onFilePicked: (File file) {},
//                     file: Rx<File?>(null),
//                   ),
//                   SizedBox(height: ManagerHeight.h36),
//
//                   /// زر التحديث
//                   ButtonApp(
//                     title: "تحديث العقار",
//                     onPressed: () =>
//                         _confirmUpdateDialog(widget.realEstate.id.toString()),
//                     paddingWidth: 0,
//                   ),
//                   SizedBox(height: ManagerHeight.h36),
//                 ],
//               ),
//             ),
//             if (controller.isLoading.value) const LoadingWidget(),
//           ],
//         );
//       }),
//     );
//   }
//
//   Future<void> _confirmUpdateDialog(String id) async {
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => CustomConfirmDialog(
//         title: "تأكيد التعديل",
//         subtitle: "هل أنت متأكد أنك تريد حفظ التغييرات؟",
//         confirmText: "تأكيد",
//         cancelText: "إلغاء",
//         onConfirm: () async {
//           Get.back();
//           await _submitEdit(id);
//         },
//         onCancel: () => Get.back(),
//       ),
//     );
//   }
//
//   Future<void> _submitEdit(String id) async {
//     final m = widget.realEstate;
//     final request = EditMyRealEstateRequest(
//       id: id,
//       propertySubject: subjectController.text,
//       propertyType: m.propertyType,
//       operationType: m.operationType,
//       advertiserRole: m.advertiserRole,
//       saleType: m.saleType,
//       keywords: m.keywords,
//       lat: m.lat,
//       lng: m.lng,
//       propertyDetailedAddress: addressController.text,
//       price: priceController.text,
//       areaSqm: areaController.text,
//       commissionPercentage: m.commissionPercentage,
//       usageType: m.usageType,
//       propertyDescription: descriptionController.text,
//       featureIds: m.featureIds,
//       facilityIds: m.facilityIds,
//       visitDays: m.visitDays,
//       visitTimeFrom: m.visitTimeFrom,
//       visitTimeTo: m.visitTimeTo,
//       propertyOwnerId: m.propertyOwnerId,
//       propertyImages: [],
//       propertyVideos: [],
//       deedDocument: null,
//     );
//
//     await controller.editRealEstate(request);
//   }
// }
