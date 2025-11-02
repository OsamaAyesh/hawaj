import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/lable_drop_down_button.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/di/di.dart';
import '../controller/add_job_provider_controller.dart';

class AddJobsProviderScreen extends StatefulWidget {
  const AddJobsProviderScreen({super.key});

  @override
  State<AddJobsProviderScreen> createState() => _AddJobsProviderScreenState();
}

class _AddJobsProviderScreenState extends State<AddJobsProviderScreen> {
  late AddJobsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AddJobsController>();
  }

  @override
  void dispose() {
    controller.jobTitleController.dispose();
    controller.shortDescController.dispose();
    controller.experienceController.dispose();
    controller.salaryController.dispose();
    controller.deadlineController.dispose();
    disposeAddJobsModule();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "إضافة وظيفة جديدة",
      body: Obx(() {
        if (controller.isPageLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingWidget(),
                SizedBox(height: 20),
                Text(
                  "جاري تحميل بيانات الشركات والإعدادات...",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
                  .copyWith(bottom: ManagerHeight.h24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdowns(),
                  SizedBox(height: ManagerHeight.h16),
                  ButtonApp(
                    title: "إضافة الوظيفة",
                    onPressed: () => controller.addJob(),
                    paddingWidth: ManagerWidth.w16,
                  ),
                ],
              ),
            ),
            if (controller.isActionLoading.value)
              const Center(child: LoadingWidget()),
          ],
        );
      }),
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        LabeledTextField(
          label: "عنوان الوظيفة",
          hintText: "مثل: مصمم جرافيك، مهندس...",
          onChanged: (v) => controller.jobTitleController.text = v,
          widthButton: ManagerWidth.w130,
        ),
        const SizedBox(height: 16),
        _dropdown("الشركة", controller.companies, controller.selectedCompanyId),
        const SizedBox(height: 16),
        _dropdown(
            "نوع الوظيفة", controller.jobTypes, controller.selectedJobType),
        const SizedBox(height: 16),
        _dropdown("مكان العمل", controller.workLocations,
            controller.selectedWorkLocation),
        const SizedBox(height: 16),
        _dropdown("حالة الوظيفة", controller.jobStatuses,
            controller.selectedJobStatus),
        const SizedBox(height: 16),
        _dropdown("المؤهل العلمي", controller.educationDegrees,
            controller.selectedEducation),
        const SizedBox(height: 16),
        _dropdown("اللغة", controller.languages, controller.selectedLanguage),
        const SizedBox(height: 16),
        _dropdown("المهارة", controller.skills, controller.selectedSkill),
        const SizedBox(height: 16),
        _dropdown("المؤهلات المهنية", controller.qualifications,
            controller.selectedQualification),
      ],
    );
  }

  Widget _dropdown(
      String label, List<Map<String, String>> items, RxnString selected) {
    return LabeledDropdownField<String>(
      label: label,
      hint: "اختر $label",
      value: selected.value,
      items: items
          .map((e) => DropdownMenuItem(
                value: e['id'],
                child: Text(e['label'] ?? ''),
              ))
          .toList(),
      onChanged: (v) => selected.value = v,
    );
  }
}
