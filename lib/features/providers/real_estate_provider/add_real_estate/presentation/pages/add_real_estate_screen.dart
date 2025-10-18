import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_strings.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/util/currency_and_icon/currency_icon_widget.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/scaffold_with_back_button.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/sub_title_text_screen_widget.dart';
import '../../../../../../core/widgets/title_text_screen_widget.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../../../../common/map_ticker/domain/di/di.dart';
import '../../../../../common/map_ticker/presenation/pages/map_ticker_screen.dart';
import '../controller/add_real_estate_controller.dart';

class AddRealEstateScreen extends StatelessWidget {
  const AddRealEstateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddRealEstateController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.addRealEstateTitle,
      body: Obx(() {
        if (!c.isListsLoaded.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
                  .copyWith(bottom: ManagerHeight.h20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  TitleTextScreenWidget(
                      title: ManagerStrings.addRealEstateTitle),
                  SubTitleTextScreenWidget(
                    subTitle: ManagerStrings.addRealEstateSubtitle,
                  ),
                  SizedBox(height: ManagerHeight.h20),

                  /// ===== نوع العقار =====
                  LabeledDropdownField<String>(
                    label: "نوع العقار",
                    hint: "اختر نوع العقار (فيلا، شقة، أرض...)",
                    value: c.selectedPropertyType.value,
                    items: c.propertyTypes
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['label'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (v) => c.selectedPropertyType.value = v,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== نوع العملية =====
                  LabeledDropdownField<String>(
                    label: "نوع العملية",
                    hint: "اختر هل العقار للبيع أم للإيجار",
                    value: c.selectedOperationType.value,
                    items: c.operationTypes
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['label'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (v) => c.selectedOperationType.value = v,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== صفة المعلن =====
                  LabeledDropdownField<String>(
                    label: "صفة المعلن",
                    hint: "اختر صفتك (مالك، وكيل، مفوض)",
                    value: c.selectedAdvertiserRole.value,
                    items: c.advertiserRoles
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['label'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (v) => c.selectedAdvertiserRole.value = v,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== نوع البيع =====
                  LabeledDropdownField<String>(
                    label: "نوع البيع",
                    hint: "اختر نوع البيع (عاجل / عادي)",
                    value: c.selectedSaleType.value,
                    items: c.saleTypes
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['label'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (v) => c.selectedSaleType.value = v,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== نوع الاستخدام =====
                  LabeledDropdownField<String>(
                    label: "نوع الاستخدام",
                    hint: "اختر نوع الاستخدام (سكني، تجاري...)",
                    value: c.selectedUsageType.value,
                    items: c.usageTypes
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['label'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (v) => c.selectedUsageType.value = v,
                  ),
                  SizedBox(height: ManagerHeight.h24),

                  /// ===== الموقع الجغرافي =====
                  LabeledTextField(
                    label: "تعيين الموقع الجغرافي",
                    controller: c.locationLatController,
                    hintText: "حدد موقع العقار على الخريطة",
                    widthButton: 140,
                    onButtonTap: () async {
                      MapTickerBindings().dependencies();
                      final result =
                          await Get.to(() => const MapTickerScreen());
                      if (result != null) {
                        c.locationLatController.text =
                            result.latitude.toString();
                        c.locationLngController.text =
                            result.longitude.toString();
                      }
                    },
                    buttonWidget: Container(
                      width: ManagerWidth.w140,
                      height: ManagerHeight.h44,
                      decoration: BoxDecoration(
                        color: ManagerColors.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          "حدد موقع العقار",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== عنوان الإعلان =====
                  LabeledTextField(
                    widthButton: ManagerWidth.w130,
                    label: "عنوان الإعلان",
                    hintText: "اكتب عنوان الإعلان هنا",
                    onChanged: (v) => c.propertySubject = v,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== العنوان التفصيلي =====
                  LabeledTextField(
                    widthButton: ManagerWidth.w130,
                    label: "العنوان التفصيلي",
                    hintText: "ادخل العنوان التفصيلي للعقار",
                    onChanged: (v) => c.detailedAddress = v,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  // / ===== السعر =====
                  LabeledTextField(
                    label: "السعر المطلوب",
                    hintText: "أدخل السعر (بيع أو إيجار شهري)",
                    keyboardType: TextInputType.number,
                    onChanged: (v) => c.price = v,
                    widthButton: ManagerWidth.w44,
                    onButtonTap: () {},
                    buttonWidget: Container(
                      width: ManagerWidth.w44,
                      height: ManagerHeight.h44,
                      decoration: BoxDecoration(
                        color: ManagerColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Directionality.of(context) == TextDirection.rtl
                                  ? const Radius.circular(8)
                                  : Radius.zero,
                          bottomLeft:
                              Directionality.of(context) == TextDirection.rtl
                                  ? const Radius.circular(8)
                                  : Radius.zero,
                          topRight:
                              Directionality.of(context) == TextDirection.ltr
                                  ? const Radius.circular(8)
                                  : Radius.zero,
                          bottomRight:
                              Directionality.of(context) == TextDirection.ltr
                                  ? const Radius.circular(8)
                                  : Radius.zero,
                        ),
                      ),
                      child: Center(
                        child: CurrencyIconWidget(
                          height: ManagerHeight.h18,
                          width: ManagerWidth.w18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== المساحة والعمولة =====
                  Row(
                    children: [
                      Expanded(
                        child: LabeledTextField(
                          widthButton: ManagerWidth.w130,
                          label: "المساحة (م²)",
                          hintText: "ادخل مساحة العقار بالمتر",
                          keyboardType: TextInputType.number,
                          onChanged: (v) => c.area = v,
                        ),
                      ),
                      SizedBox(width: ManagerWidth.w8),
                      Expanded(
                        child: LabeledTextField(
                          widthButton: ManagerWidth.w130,
                          label: "نسبة العمولة",
                          hintText: "عمولة البيع بالنسبة %",
                          keyboardType: TextInputType.number,
                          onChanged: (v) => c.commission = v,
                        ),
                      ),
                    ],
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== وصف العقار =====
                  LabeledTextField(
                    widthButton: ManagerWidth.w130,
                    label: "الوصف",
                    hintText: "أدخل وصفًا واضحًا للعقار",
                    minLines: 3,
                    maxLines: 5,
                    onChanged: (v) => c.propertyDescription = v,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== المميزات =====
                  _MultiSelectPicker(
                    title: "المميزات",
                    placeholder: "أدخل المميزات الخاصة بالعقار الخاص فيك",
                    allItems: c.features,
                    selectedIds: c.selectedFeatureIds,
                    onToggleId: (id) => c.toggleFeature(id),
                  ),
                  SizedBox(height: ManagerHeight.h16),

                  /// ===== المرافق =====
                  _MultiSelectPicker(
                    title: "المرافق",
                    placeholder: "أدخل المرافق المتاحة (موقف، صالة...)",
                    allItems: c.facilities,
                    selectedIds: c.selectedFacilityIds,
                    onToggleId: (id) => c.toggleFacility(id),
                  ),
                  SizedBox(height: ManagerHeight.h16),

                  /// ===== الأيام المتاحة للزيارة =====
                  _MultiSelectPicker(
                    title: "الأيام المتاحة للزيارة",
                    placeholder: "اختر الأيام من أيام الأسبوع",
                    allItems: c.weekDays,
                    selectedIds: c.selectedVisitDayIds,
                    onToggleId: (id) => c.toggleVisitDay(id),
                  ),
                  SizedBox(height: ManagerHeight.h24),

                  /// ===== صور العقار =====
                  UploadMediaField(
                    label: "صور العقار",
                    hint: "رفع الصور أو الفيديوهات",
                    note: "أضف صورًا واضحة للعقار لجذب العملاء.",
                    file: c.propertyImages.isNotEmpty
                        ? Rx<File?>(c.propertyImages.last)
                        : Rx<File?>(null),
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== صك العقار =====
                  UploadMediaField(
                    label: "صك العقار",
                    hint: "رفع الملف",
                    note: "قم برفع صك الملكية لإثبات صحة المعلومات.",
                    file: c.deedDocument != null
                        ? Rx<File?>(c.deedDocument)
                        : Rx<File?>(null),
                  ),
                  SizedBox(height: ManagerHeight.h36),

                  /// ===== زر الإضافة =====
                  ButtonApp(
                    title: "استمرار بالإضافة",
                    onPressed: () => c.addRealEstate(),
                    paddingWidth: 0,
                  ),
                  SizedBox(height: ManagerHeight.h32),
                ],
              ),
            ),
            if (c.isLoading.value) const LoadingWidget(),
          ],
        );
      }),
    );
  }
}

/// ===============================================
///         Multi-select picker reusable widget
/// ===============================================
class _MultiSelectPicker extends StatelessWidget {
  final String title;
  final String placeholder;
  final List<Map<String, String>> allItems;
  final RxList<String> selectedIds;
  final void Function(String id) onToggleId;

  const _MultiSelectPicker({
    required this.title,
    required this.placeholder,
    required this.allItems,
    required this.selectedIds,
    required this.onToggleId,
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
                : "تم اختيار ${selectedIds.length}",
            widthButton: ManagerWidth.w44,
            onButtonTap: () => _openBottomSheet(context),
            buttonWidget: Container(
              width: ManagerWidth.w44,
              height: ManagerHeight.h44,
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Directionality.of(context) == TextDirection.rtl
                      ? const Radius.circular(8)
                      : Radius.zero,
                  bottomLeft: Directionality.of(context) == TextDirection.rtl
                      ? const Radius.circular(8)
                      : Radius.zero,
                  topRight: Directionality.of(context) == TextDirection.ltr
                      ? const Radius.circular(8)
                      : Radius.zero,
                  bottomRight: Directionality.of(context) == TextDirection.ltr
                      ? const Radius.circular(8)
                      : Radius.zero,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
          // /// ===== العنوان =====
          // Padding(
          //   padding: EdgeInsets.only(bottom: ManagerHeight.h8),
          //   child: Text(
          //     title,
          //     style: getBoldTextStyle(
          //       fontSize: ManagerFontSize.s12,
          //       color: ManagerColors.black,
          //     ),
          //   ),
          // ),
          //
          // /// ===== الحقل بنفس فكرة LabeledTextField مع زر داخلي =====
          // Container(
          //   height: ManagerHeight.h48,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(8),
          //     border: Border.all(
          //       color: ManagerColors.greyWithColor.withOpacity(0.3),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       /// 🔹 النص (placeholder أو عدد العناصر المختارة)
          //       Expanded(
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
          //           child: Text(
          //             selectedIds.isEmpty
          //                 ? placeholder
          //                 : "${selectedIds.length} تم اختيارها",
          //             style: getRegularTextStyle(
          //               fontSize: ManagerFontSize.s12,
          //               color: selectedIds.isEmpty
          //                   ? ManagerColors.greyWithColor
          //                   : ManagerColors.black,
          //             ),
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         ),
          //       ),
          //
          //       /// 🔹 الزر الجانبي (بنفس تصميم زر العملة)
          //       // GestureDetector(
          //       //   onTap: () => _openBottomSheet(context),
          //       //   child: Container(
          //       //     width: ManagerWidth.w44,
          //       //     height: double.infinity,
          //       //     decoration: BoxDecoration(
          //       //       color: ManagerColors.primaryColor,
          //       //       borderRadius: BorderRadius.only(
          //       //         topLeft: Directionality.of(context) == TextDirection.rtl
          //       //             ? const Radius.circular(8)
          //       //             : Radius.zero,
          //       //         bottomLeft:
          //       //             Directionality.of(context) == TextDirection.rtl
          //       //                 ? const Radius.circular(8)
          //       //                 : Radius.zero,
          //       //         topRight:
          //       //             Directionality.of(context) == TextDirection.ltr
          //       //                 ? const Radius.circular(8)
          //       //                 : Radius.zero,
          //       //         bottomRight:
          //       //             Directionality.of(context) == TextDirection.ltr
          //       //                 ? const Radius.circular(8)
          //       //                 : Radius.zero,
          //       //       ),
          //       //     ),
          //       //     child: const Center(
          //       //       child: Icon(
          //       //         Icons.check,
          //       //         color: Colors.white,
          //       //         size: 22,
          //       //       ),
          //       //     ),
          //       //   ),
          //       // ),
          //     ],
          //   ),
          // ),

          /// ===== التاجات المختارة =====
          if (selectedIds.isNotEmpty) ...[
            SizedBox(height: ManagerHeight.h12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedIds.map((id) {
                final label =
                    allItems.firstWhereOrNull((e) => e['id'] == id)?['label'] ??
                        id;
                return _TagPill(
                  label: label,
                  onRemove: () => onToggleId(id),
                );
              }).toList(),
            ),
          ],
        ],
      );
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Obx(() {
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(title,
  //             style: getBoldTextStyle(
  //                 fontSize: ManagerFontSize.s12, color: ManagerColors.black)),
  //         SizedBox(height: ManagerHeight.h8),
  //
  //         // Box with check icon
  //         InkWell(
  //           onTap: () => _openBottomSheet(context),
  //           child: Container(
  //             height: ManagerHeight.h48,
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(
  //                   color: ManagerColors.greyWithColor.withOpacity(0.3)),
  //             ),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   height: double.infinity,
  //                   width: 54,
  //                   decoration: BoxDecoration(
  //                     color: ManagerColors.primaryColor,
  //                     borderRadius: const BorderRadius.only(
  //                       topRight: Radius.circular(8),
  //                       bottomRight: Radius.circular(8),
  //                     ),
  //                   ),
  //                   child:
  //                       const Icon(Icons.check, color: Colors.white, size: 28),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: Text(
  //                     placeholder,
  //                     style: getRegularTextStyle(
  //                       fontSize: ManagerFontSize.s12,
  //                       color: ManagerColors.greyWithColor,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //               ],
  //             ),
  //           ),
  //         ),
  //
  //         if (selectedIds.isNotEmpty) ...[
  //           SizedBox(height: ManagerHeight.h12),
  //           Wrap(
  //             spacing: 8,
  //             runSpacing: 8,
  //             children: selectedIds.map((id) {
  //               final label =
  //                   allItems.firstWhereOrNull((e) => e['id'] == id)?['label'] ??
  //                       id;
  //               return _TagPill(
  //                 label: label,
  //                 onRemove: () => onToggleId(id),
  //               );
  //             }).toList(),
  //           ),
  //         ],
  //       ],
  //     );
  //   });
  // }

  void _openBottomSheet(BuildContext context) {
    final search = TextEditingController();
    final tempSelected = selectedIds.toSet();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<Map<String, String>> filtered = allItems
                .where((e) => (e['label'] ?? '')
                    .toLowerCase()
                    .contains(search.text.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ===== عنوان النافذة =====
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: ManagerColors.greyWithColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "اختر من القائمة",
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: ManagerColors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// ===== قائمة الخيارات =====
                  Flexible(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: filtered.map((item) {
                          final id = item['id']!;
                          final lbl = item['label'] ?? '';
                          final isSel = tempSelected.contains(id);

                          return ChoiceChip(
                            checkmarkColor: ManagerColors.white,
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSel
                                    ? ManagerColors.primaryColor
                                    : ManagerColors.primaryColor
                                        .withOpacity(0.3),
                              ),
                            ),
                            onSelected: (_) {
                              setState(() {
                                if (isSel) {
                                  tempSelected.remove(id);
                                } else {
                                  tempSelected.add(id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ===== الأزرار (زر تم على اليسار، إلغاء على اليمين) =====
                  Row(
                    children: [
                      /// زر "تم" على اليسار
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            selectedIds.assignAll(tempSelected);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ManagerColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'تم',
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// زر "إلغاء" على اليمين
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: ManagerColors.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
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
        );
      },
    );
  }
}

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
