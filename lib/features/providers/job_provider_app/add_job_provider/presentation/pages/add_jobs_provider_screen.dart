import 'dart:io';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/custom_confirm_dialog.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/title_text_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddJobsProviderScreen extends StatelessWidget {
  const AddJobsProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyFile = Rx<File?>(null); // Placeholder للحقول المطلوبة فقط

    return ScaffoldWithBackButton(
      title: "إضافة وظيفة جديدة",
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
                .copyWith(bottom: ManagerHeight.h16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ManagerHeight.h24),

                /// ===== Title =====
                const TitleTextScreenWidget(title: "أضف وظيفة الآن"),
                SizedBox(height: ManagerHeight.h4),

                const SubTitleTextScreenWidget(
                  subTitle:
                      "قم بتفاصيل الوظيفة لتسهيل عملية البحث واستقبال الطلبات بسهولة.",
                ),

                SizedBox(height: ManagerHeight.h24),

                /// ===== Job Title =====
                LabeledTextField(
                  label: "اسم الوظيفة",
                  hintText: "مثل: محاسب، مهندس، مصمم...",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Job Type =====
                LabeledTextField(
                  label: "نوع الوظيفة",
                  hintText: "دوام كامل / جزئي / عن بعد...",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Job Description =====
                LabeledTextField(
                  label: "وصف مختصر للوظيفة",
                  hintText: "أدخل تفاصيل بسيطة عن المهام المطلوبة",
                  minLines: 3,
                  maxLines: 5,
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Notes =====
                LabeledTextField(
                  label: "الملاحظات",
                  hintText: "أدخل أي ملاحظات إضافية (اختياري)",
                  minLines: 2,
                  maxLines: 4,
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Working Hours =====
                LabeledTextField(
                  label: "ساعات العمل",
                  hintText: "مثل: من 8 صباحًا حتى 4 مساءً",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Salary Range =====
                LabeledTextField(
                  label: "الراتب والامتيازات",
                  hintText: "أدخل الراتب المتوقع أو المزايا المقدمة",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Location =====
                LabeledTextField(
                  label: "تعيين الموقع الجغرافي",
                  hintText: "حدد موقع مقر الوظيفة",
                  widthButton: ManagerWidth.w130,
                  buttonWidget: Container(
                    width: ManagerWidth.w140,
                    height: ManagerHeight.h44,
                    decoration: BoxDecoration(
                      color: ManagerColors.primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        "حدد موقع الوظيفة",
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Address =====
                LabeledTextField(
                  label: "عنوان الوظيفة",
                  hintText: "أدخل العنوان بالتفصيل",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Contact Number =====
                LabeledTextField(
                  label: "رقم التواصل للتقديم",
                  hintText: "05xxxxxxxx",
                  keyboardType: TextInputType.phone,
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Email =====
                LabeledTextField(
                  label: "البريد الإلكتروني",
                  hintText: "example@company.com",
                  keyboardType: TextInputType.emailAddress,
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Application Deadline =====
                LabeledTextField(
                  label: "تاريخ انتهاء التقديم",
                  hintText: "أدخل تاريخ انتهاء استقبال الطلبات",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Work Type =====
                LabeledTextField(
                  label: "نوع مكان العمل",
                  hintText: "ميداني / مكتبي / عمل عن بعد",
                  widthButton: ManagerWidth.w130,
                ),

                SizedBox(height: ManagerHeight.h24),

                /// ===== Submit Button =====
                ButtonApp(
                  title: "إضافة الوظيفة",
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => CustomConfirmDialog(
                        title: "تأكيد إضافة الوظيفة",
                        subtitle:
                            "هل أنت متأكد من رغبتك في إضافة هذه الوظيفة؟ سيتم مراجعة التفاصيل قبل النشر.",
                        confirmText: "تأكيد",
                        cancelText: "إلغاء",
                        onConfirm: () {},
                        onCancel: () {},
                      ),
                    );
                  },
                  paddingWidth: 0,
                ),
                SizedBox(height: ManagerHeight.h16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
