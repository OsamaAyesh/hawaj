import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:flutter/material.dart';

class AddCvUserScreen extends StatelessWidget {
  const AddCvUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "إضافة السيرة الذاتية",
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
            .copyWith(bottom: ManagerHeight.h20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ManagerHeight.h16),

            /// ===== العنوان الفرعي =====
            Text(
              "أضف سيرتك الذاتية بسهولة",
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.black,
              ),
            ),
            SizedBox(height: ManagerHeight.h6),
            Text(
              "املأ البيانات التالية بدقة لتسهيل وصول الشركات إلى مؤهلاتك وخبراتك.",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.titleTextFieldPassword,
              ),
            ),
            SizedBox(height: ManagerHeight.h20),

            /// ===== رفع السيرة الذاتية =====
            Container(
              padding: EdgeInsets.all(ManagerWidth.w12),
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(ManagerRadius.r8),
              ),
              child: Row(
                children: [
                  Icon(Icons.upload_file_rounded,
                      color: ManagerColors.primaryColor),
                  SizedBox(width: ManagerWidth.w8),
                  Expanded(
                    child: Text(
                      "قم بتحميل سيرتك الذاتية بصيغة PDF",
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ManagerWidth.w12,
                        vertical: ManagerHeight.h8),
                    decoration: BoxDecoration(
                      color: ManagerColors.primaryColor,
                      borderRadius: BorderRadius.circular(ManagerRadius.r8),
                    ),
                    child: Text(
                      "اختيار ملف",
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: ManagerHeight.h20),

            /// ===== المعلومات الشخصية =====
            _SectionTitle(title: "المعلومات الشخصية"),

            const LabeledTextField(
              label: "الاسم الكامل",
              hintText: "أدخل اسمك الكامل",
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),
            const LabeledTextField(
              label: "البريد الإلكتروني",
              hintText: "example@email.com",
              keyboardType: TextInputType.emailAddress,
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),
            const LabeledTextField(
              label: "رقم الهاتف",
              hintText: "05xxxxxxxx",
              keyboardType: TextInputType.phone,
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),
            const LabeledTextField(
              label: "العنوان",
              hintText: "أدخل عنوان السكن الحالي",
              widthButton: 130,
            ),

            SizedBox(height: ManagerHeight.h20),

            /// ===== المؤهل العلمي =====
            _SectionTitle(title: "المؤهل العلمي"),

            const LabeledTextField(
              label: "الدرجة العلمية",
              hintText: "بكالوريوس / ماجستير / دبلوم",
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),
            const LabeledTextField(
              label: "التخصص",
              hintText: "أدخل التخصص الدراسي",
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),
            const LabeledTextField(
              label: "اسم الجامعة أو المعهد",
              hintText: "اكتب اسم الجامعة أو المعهد",
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),
            const LabeledTextField(
              label: "سنة التخرج",
              hintText: "أدخل سنة التخرج",
              keyboardType: TextInputType.number,
              widthButton: 130,
            ),

            SizedBox(height: ManagerHeight.h20),

            /// ===== الخبرات العملية =====
            _SectionTitle(title: "الخبرات العملية"),

            const LabeledTextField(
              label: "المسمى الوظيفي",
              hintText: "اكتب آخر مسمى وظيفي عملت به",
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),
            const LabeledTextField(
              label: "اسم الشركة",
              hintText: "اكتب اسم الشركة أو المؤسسة",
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),
            const LabeledTextField(
              label: "مدة العمل",
              hintText: "مثلاً: من 2020 حتى 2023",
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),
            const LabeledTextField(
              label: "وصف المهام",
              hintText: "صف مهامك ومسؤولياتك السابقة",
              minLines: 2,
              maxLines: 4,
              widthButton: 130,
            ),

            SizedBox(height: ManagerHeight.h20),

            /// ===== المهارات =====
            _SectionTitle(title: "المهارات"),

            const LabeledTextField(
              label: "أضف مهاراتك",
              hintText: "مثل: Flutter, Photoshop, إدارة مشاريع ...",
              widthButton: 130,
            ),

            SizedBox(height: ManagerHeight.h20),

            /// ===== اللغات =====
            _SectionTitle(title: "اللغات"),

            const LabeledTextField(
              label: "اسم اللغة",
              hintText: "مثل: العربية / الإنجليزية / الفرنسية",
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),
            const LabeledTextField(
              label: "مستوى الإتقان",
              hintText: "ممتاز / جيد جدًا / متوسط",
              widthButton: 130,
            ),

            SizedBox(height: ManagerHeight.h20),

            /// ===== الحالة الوظيفية =====
            _SectionTitle(title: "الحالة الوظيفية"),

            Row(
              children: [
                Checkbox(
                  value: true,
                  activeColor: ManagerColors.primaryColor,
                  onChanged: (_) {},
                ),
                Text(
                  "أبحث عن عمل",
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.black,
                  ),
                ),
              ],
            ),

            SizedBox(height: ManagerHeight.h24),

            /// ===== زر الإرسال =====
            Container(
              width: double.infinity,
              height: ManagerHeight.h48,
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor,
                borderRadius: BorderRadius.circular(ManagerRadius.r8),
              ),
              child: Center(
                child: Text(
                  "إضافة السيرة الذاتية",
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: ManagerHeight.h32),
          ],
        ),
      ),
    );
  }
}

/// ===== Widget لعنوان كل قسم =====
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w12,
        vertical: ManagerHeight.h8,
      ),
      margin: EdgeInsets.only(bottom: ManagerHeight.h12),
      decoration: BoxDecoration(
        color: ManagerColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(ManagerRadius.r8),
      ),
      child: Text(
        title,
        style: getBoldTextStyle(
          fontSize: ManagerFontSize.s13,
          color: ManagerColors.primaryColor,
        ),
      ),
    );
  }
}
