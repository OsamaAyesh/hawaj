import 'dart:io';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/title_text_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../../../core/resources/manager_strings.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';

class AddRealEstateScreen extends StatefulWidget {
  const AddRealEstateScreen({super.key});

  @override
  State<AddRealEstateScreen> createState() => _AddRealEstateScreenState();
}

class _AddRealEstateScreenState extends State<AddRealEstateScreen> {
  String? propertyType;
  String? processType;
  String? advertiserType;
  String? saleType;
  String? visitDays;

  final features = [
    "مدخل خاص",
    "غرفة سائق",
    "تكييف مركزي",
    "ملحق خارجي",
    "مطبخ راكب"
  ];
  final selectedFeatures = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.addRealEstateTitle,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: ManagerHeight.h20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TitleTextScreenWidget(title: ManagerStrings.addRealEstateTitle),
              SubTitleTextScreenWidget(
                subTitle: ManagerStrings.addRealEstateSubtitle,
              ),
              SizedBox(height: ManagerHeight.h20),

              /// ==============================
              /// 🔹 نوع العقار
              LabeledDropdownField<String>(
                label: "نوع العقار",
                hint: "اختر نوع العقار (فيلا، شقة، أرض...)",
                value: propertyType,
                items: ["فيلا", "شقة", "أرض", "مكتب", "عمارة"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => propertyType = v),
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// 🔹 نوع العملية
              LabeledDropdownField<String>(
                label: "نوع العملية",
                hint: "اختر هل العقار للبيع أم للإيجار",
                value: processType,
                items: ["للبيع", "للإيجار"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => processType = v),
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// 🔹 صفة المعلن
              LabeledDropdownField<String>(
                label: "صفة المعلن",
                hint: "اختر صفتك (مالك، وكيل، مفوض)",
                value: advertiserType,
                items: ["مالك", "وكيل", "مفوض"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => advertiserType = v),
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// 🔹 نوع البيع
              LabeledDropdownField<String>(
                label: "نوع البيع",
                hint: "اختر نوع البيع (عاجل / عادي)",
                value: saleType,
                items: ["عاجل", "عادي"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => saleType = v),
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
                onPressed: () {},
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
                label: "العنوان التفصيلي",
                hintText: "ادخل العنوان التفصيلي للعقار",
                widthButton: 0,
              ),
              const SizedBoxBetweenFieldWidgets(),

              LabeledTextField(
                label: "السعر المطلوب",
                hintText: "ادخل السعر (بيع أو إيجار شهري)",
                widthButton: 0,
              ),
              const SizedBoxBetweenFieldWidgets(),

              Row(
                children: [
                  Expanded(
                    child: LabeledTextField(
                      label: "المساحة (م²)",
                      hintText: "ادخل مساحة العقار بالمتر",
                      widthButton: 0,
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w8),
                  Expanded(
                    child: LabeledTextField(
                      label: "نسبة العمولة",
                      hintText: "عمولة البيع بالنسبة %",
                      widthButton: 0,
                    ),
                  ),
                ],
              ),
              const SizedBoxBetweenFieldWidgets(),

              Row(
                children: [
                  Expanded(
                    child: LabeledTextField(
                      label: "عدد الغرف",
                      hintText: "ادخل عدد غرف النوم",
                      widthButton: 0,
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w8),
                  Expanded(
                    child: LabeledTextField(
                      label: "عدد دورات المياه",
                      hintText: "ادخل عدد الحمامات",
                      widthButton: 0,
                    ),
                  ),
                ],
              ),
              const SizedBoxBetweenFieldWidgets(),

              Row(
                children: [
                  Expanded(
                    child: LabeledTextField(
                      label: "عمر العقار",
                      hintText: "ادخل عمر العقار بالسنوات",
                      widthButton: 0,
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w8),
                  Expanded(
                    child: LabeledTextField(
                      label: "عدد الأدوار",
                      hintText: "ادخل عدد الأدوار",
                      widthButton: 0,
                    ),
                  ),
                ],
              ),
              const SizedBoxBetweenFieldWidgets(),

              Row(
                children: [
                  Expanded(
                    child: LabeledTextField(
                      label: "عرض الشارع",
                      hintText: "عرض الشارع بالمتر",
                      widthButton: 0,
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w8),
                  Expanded(
                    child: LabeledTextField(
                      label: "نوع الواجهة",
                      hintText: "شمالية / شرقية / غربية / جنوبية",
                      widthButton: 0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ManagerHeight.h24),

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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: features.map((feature) {
                  final isSelected = selectedFeatures.contains(feature);
                  return ChoiceChip(
                    label: Text(
                      feature,
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
                      setState(() {
                        selected
                            ? selectedFeatures.add(feature)
                            : selectedFeatures.remove(feature);
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: ManagerHeight.h24),

              /// ==============================
              /// 🗓️ الأيام المتاحة للزيارة
              LabeledDropdownField<String>(
                label: "الأيام المتاحة للزيارة",
                hint: "اختر الأيام من أيام الأسبوع",
                value: visitDays,
                items: [
                  "الأحد",
                  "الاثنين",
                  "الثلاثاء",
                  "الأربعاء",
                  "الخميس",
                  "الجمعة",
                  "السبت"
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => visitDays = v),
              ),
              SizedBox(height: ManagerHeight.h24),

              /// ==============================
              /// 🖼️ صور العقار
              UploadMediaField(
                label: "صور العقار",
                hint: "رفع الصور أو الفيديوهات",
                note: "أضف صورًا واضحة للعقار لجذب العملاء.",
                file: Rx<File?>(null),
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// 📄 صك العقار
              UploadMediaField(
                label: "صك العقار",
                hint: "رفع الملف",
                note: "قم برفع صك الملكية لإثبات صحة المعلومات.",
                file: Rx<File?>(null),
              ),
              SizedBox(height: ManagerHeight.h36),

              /// ==============================
              /// 🔘 الزر السفلي
              ButtonApp(
                title: "استمرار بالإضافة",
                onPressed: () {},
                paddingWidth: 0,
              ),
              SizedBox(height: ManagerHeight.h32),
            ],
          ),
        ),
      ),
    );
  }
}
