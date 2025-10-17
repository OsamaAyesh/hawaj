import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_strings.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/scaffold_with_back_button.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/sub_title_text_screen_widget.dart';
import '../../../../../../core/widgets/title_text_screen_widget.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../controller/add_real_estate_controller.dart';

class AddRealEstateScreen extends StatefulWidget {
  const AddRealEstateScreen({super.key});

  @override
  State<AddRealEstateScreen> createState() => _AddRealEstateScreenState();
}

class _AddRealEstateScreenState extends State<AddRealEstateScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddRealEstateController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.addRealEstateTitle,
      body: Obx(() {
        return Stack(
          children: [
            if (!controller.isListsLoaded.value)
              const Center(child: CircularProgressIndicator())
            else
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

                    /// 🔹 نوع العقار
                    LabeledDropdownField<String>(
                      label: "نوع العقار",
                      hint: "اختر نوع العقار (فيلا، شقة، أرض...)",
                      value: controller.selectedPropertyType,
                      items: controller.propertyTypes
                          .map((e) => DropdownMenuItem(
                                value: e['id'],
                                child: Text(e['label'] ?? ''),
                              ))
                          .toList(),
                      onChanged: (v) => controller.selectedPropertyType = v,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// 🔹 نوع العملية
                    LabeledDropdownField<String>(
                      label: "نوع العملية",
                      hint: "اختر هل العقار للبيع أم للإيجار",
                      value: controller.selectedOperationType,
                      items: controller.operationTypes
                          .map((e) => DropdownMenuItem(
                                value: e['id'],
                                child: Text(e['label'] ?? ''),
                              ))
                          .toList(),
                      onChanged: (v) => controller.selectedOperationType = v,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// 🔹 صفة المعلن
                    LabeledDropdownField<String>(
                      label: "صفة المعلن",
                      hint: "اختر صفتك (مالك، وكيل، مفوض)",
                      value: controller.selectedAdvertiserRole,
                      items: controller.advertiserRoles
                          .map((e) => DropdownMenuItem(
                                value: e['id'],
                                child: Text(e['label'] ?? ''),
                              ))
                          .toList(),
                      onChanged: (v) => controller.selectedAdvertiserRole = v,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// 🔹 نوع البيع
                    LabeledDropdownField<String>(
                      label: "نوع البيع",
                      hint: "اختر نوع البيع (عاجل / عادي)",
                      value: controller.selectedSaleType,
                      items: controller.saleTypes
                          .map((e) => DropdownMenuItem(
                                value: e['id'],
                                child: Text(e['label'] ?? ''),
                              ))
                          .toList(),
                      onChanged: (v) => controller.selectedSaleType = v,
                    ),
                    SizedBox(height: ManagerHeight.h24),

                    /// ==============================
                    /// 📍 تحديد الموقع الجغرافي
                    Text(
                      "تعيين الموقع الجغرافي",
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.black,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h8),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.addRealEstate();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManagerColors.primaryColor,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "حدد موقع العقار",
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h24),

                    /// ==============================
                    /// 🏡 الحقول التفصيلية
                    LabeledTextField(
                      label: "عنوان الإعلان",
                      hintText: "اكتب عنوان الإعلان هنا",
                      widthButton: 0,
                      onChanged: (val) => controller.propertySubject = val,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    LabeledTextField(
                      label: "العنوان التفصيلي",
                      hintText: "ادخل العنوان التفصيلي للعقار",
                      widthButton: 0,
                      onChanged: (val) => controller.detailedAddress = val,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    LabeledTextField(
                      label: "السعر المطلوب",
                      hintText: "ادخل السعر (بيع أو إيجار شهري)",
                      widthButton: 0,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => controller.price = val,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            label: "المساحة (م²)",
                            hintText: "ادخل مساحة العقار بالمتر",
                            widthButton: 0,
                            keyboardType: TextInputType.number,
                            onChanged: (val) => controller.area = val,
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w8),
                        Expanded(
                          child: LabeledTextField(
                            label: "نسبة العمولة",
                            hintText: "عمولة البيع بالنسبة %",
                            widthButton: 0,
                            keyboardType: TextInputType.number,
                            onChanged: (val) => controller.commission = val,
                          ),
                        ),
                      ],
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    LabeledTextField(
                      label: "الوصف",
                      hintText: "أدخل وصفًا واضحًا للعقار",
                      minLines: 3,
                      maxLines: 5,
                      widthButton: 0,
                      onChanged: (val) => controller.propertyDescription = val,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// ==============================
                    /// ✨ المميزات
                    Text(
                      "المميزات",
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.black,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h8),
                    Obx(() => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.features.map((feature) {
                            final label = feature['label'] ?? '';
                            final isSelected = feature['selected'] == 'true';
                            return ChoiceChip(
                              label: Text(
                                label,
                                style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s12,
                                  color: isSelected
                                      ? Colors.white
                                      : ManagerColors.primaryColor,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: ManagerColors.primaryColor,
                              backgroundColor:
                                  ManagerColors.primaryColor.withOpacity(0.06),
                              onSelected: (selected) {
                                feature['selected'] =
                                    selected ? 'true' : 'false';
                              },
                            );
                          }).toList(),
                        )),
                    SizedBox(height: ManagerHeight.h24),

                    /// 🗓️ الأيام المتاحة للزيارة
                    LabeledDropdownField<String>(
                      label: "الأيام المتاحة للزيارة",
                      hint: "اختر الأيام من أيام الأسبوع",
                      value: controller.selectedVisitDays,
                      items: controller.weekDays
                          .map((e) => DropdownMenuItem(
                                value: e['id'],
                                child: Text(e['label'] ?? ''),
                              ))
                          .toList(),
                      onChanged: (v) => controller.selectedVisitDays = v,
                    ),
                    SizedBox(height: ManagerHeight.h24),

                    /// 🖼️ صور العقار
                    UploadMediaField(
                      label: "صور العقار",
                      hint: "رفع الصور أو الفيديوهات",
                      note: "أضف صورًا واضحة للعقار لجذب العملاء.",
                      file: controller.propertyImages.isNotEmpty
                          ? Rx<File?>(controller.propertyImages.last)
                          : Rx<File?>(null),
                    ),

                    const SizedBoxBetweenFieldWidgets(),

                    /// 📄 صك العقار
                    UploadMediaField(
                      label: "صك العقار",
                      hint: "رفع الملف",
                      note: "قم برفع صك الملكية لإثبات صحة المعلومات.",
                      file: Rx<File?>(controller.deedDocument),
                    ),

                    SizedBox(height: ManagerHeight.h36),

                    /// 🔘 الزر السفلي
                    ButtonApp(
                      title: "استمرار بالإضافة",
                      onPressed: () => controller.addRealEstate(),
                      paddingWidth: 0,
                    ),
                    SizedBox(height: ManagerHeight.h32),
                  ],
                ),
              ),

            /// 🔹 Loading فوق المحتوى
            if (controller.isLoading.value) const LoadingWidget(),
          ],
        );
      }),
    );
  }
}
