import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/custom_confirm_dialog.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/scaffold_with_back_button.dart';
import '../controller/add_job_provider_controller.dart';

class AddJobsProviderScreen extends StatelessWidget {
  const AddJobsProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobsController>();

    return ScaffoldWithBackButton(
      title: "إضافة وظيفة جديدة",
      body: Obx(() {
        if (controller.isPageLoading.value) {
          return const LoadingWidget();
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w16,
                vertical: ManagerHeight.h16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🏢 الشركة
                  LabeledDropdownField<String>(
                    label: "الشركة",
                    hint: "اختر الشركة",
                    value: controller.selectedCompanyId.value,
                    items: controller.companies
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['label'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (v) => controller.selectedCompanyId.value = v,
                  ),
                  SizedBox(height: ManagerHeight.h12),

                  /// 🏷️ عنوان الوظيفة
                  LabeledTextField(
                    label: "عنوان الوظيفة",
                    hintText: "مثلاً: مطور Flutter",
                    controller: controller.jobTitleController,
                    widthButton: ManagerWidth.w16,
                  ),
                  SizedBox(height: ManagerHeight.h12),

                  /// نوع الوظيفة
                  LabeledDropdownField<String>(
                    label: "نوع الوظيفة",
                    hint: "اختر النوع",
                    value: controller.selectedJobType.value,
                    items: controller.jobTypes
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['label'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (v) => controller.selectedJobType.value = v,
                  ),
                  SizedBox(height: ManagerHeight.h12),

                  /// 💬 وصف مختصر
                  LabeledTextField(
                    label: "الوصف المختصر",
                    hintText: "أدخل وصفًا مختصرًا للوظيفة",
                    maxLines: 3,
                    controller: controller.shortDescController,
                    widthButton: ManagerWidth.w16,
                  ),
                  SizedBox(height: ManagerHeight.h12),

                  /// 🧠 سنوات الخبرة
                  LabeledTextField(
                    widthButton: ManagerWidth.w16,
                    label: "سنوات الخبرة المطلوبة",
                    hintText: "مثلاً: 3",
                    keyboardType: TextInputType.number,
                    controller: controller.experienceController,
                  ),
                  SizedBox(height: ManagerHeight.h12),

                  /// 💰 الراتب
                  LabeledTextField(
                    widthButton: ManagerWidth.w16,
                    label: "الراتب الشهري",
                    hintText: "مثلاً: 5000",
                    keyboardType: TextInputType.number,
                    controller: controller.salaryController,
                  ),
                  SizedBox(height: ManagerHeight.h12),

                  /// 📆 آخر موعد للتقديم
                  LabeledTextField(
                    widthButton: ManagerWidth.w16,
                    label: "آخر موعد للتقديم",
                    hintText: "YYYY-MM-DD",
                    controller: controller.deadlineController,
                  ),
                  SizedBox(height: ManagerHeight.h12),

                  /// 📍 مكان العمل
                  LabeledDropdownField<String>(
                    label: "مكان العمل",
                    hint: "اختر الموقع",
                    value: controller.selectedWorkLocation.value,
                    items: controller.workLocations
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['label'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (v) => controller.selectedWorkLocation.value = v,
                  ),
                  SizedBox(height: ManagerHeight.h12),

                  /// 📊 حالة الوظيفة
                  LabeledDropdownField<String>(
                    label: "حالة الوظيفة",
                    hint: "اختر الحالة",
                    value: controller.selectedJobStatus.value,
                    items: controller.jobStatuses
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['label'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (v) => controller.selectedJobStatus.value = v,
                  ),
                  SizedBox(height: ManagerHeight.h20),

                  /// ⚙️ المهارات / اللغات / المؤهلات
                  _MultiSelectList(
                    title: "المهارات المطلوبة",
                    items: controller.skillsList,
                    selectedItems: controller.selectedSkills,
                  ),
                  SizedBox(height: ManagerHeight.h16),

                  _MultiSelectList(
                    title: "اللغات المطلوبة",
                    items: controller.languagesList,
                    selectedItems: controller.selectedLanguages,
                  ),
                  SizedBox(height: ManagerHeight.h16),

                  _MultiSelectList(
                    title: "المؤهلات العلمية",
                    items: controller.qualificationsList,
                    selectedItems: controller.selectedQualifications,
                  ),
                  SizedBox(height: ManagerHeight.h20),

                  /// زر الإضافة
                  ButtonApp(
                    title: "إضافة الوظيفة",
                    onPressed: () {
                      Get.dialog(
                        CustomConfirmDialog(
                          title: "تأكيد الإضافة",
                          subtitle: "هل أنت متأكد من إضافة هذه الوظيفة؟",
                          confirmText: "نعم",
                          cancelText: "إلغاء",
                          onConfirm: () {
                            Get.back();
                            controller.addJob();
                          },
                          onCancel: () => Get.back(),
                        ),
                      );
                    },
                    paddingWidth: 0,
                  ),
                  SizedBox(height: ManagerHeight.h40),
                ],
              ),
            ),
            if (controller.isActionLoading.value) const LoadingWidget(),
          ],
        );
      }),
    );
  }
}

/// 🧱 مكوّن لاختيار عناصر متعددة
class _MultiSelectList extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;
  final RxList<String> selectedItems;

  const _MultiSelectList({
    required this.title,
    required this.items,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s14,
              color: ManagerColors.black,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              final isSelected = selectedItems.contains(item['id']);
              return ChoiceChip(
                label: Text(item['label'] ?? ''),
                selected: isSelected,
                selectedColor: ManagerColors.primaryColor,
                backgroundColor: ManagerColors.primaryColor.withOpacity(0.08),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : ManagerColors.primaryColor,
                ),
                onSelected: (selected) {
                  if (selected) {
                    selectedItems.add(item['id']!);
                  } else {
                    selectedItems.remove(item['id']);
                  }
                },
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
