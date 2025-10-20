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
import 'package:app_mobile/core/widgets/upload_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCompanyJobsProviderScreen extends StatelessWidget {
  const AddCompanyJobsProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // قيم Rx فارغة مؤقتة لاستخدامها فقط كـ placeholder للـ UI
    final dummyFile = Rx<File?>(null);

    return ScaffoldWithBackButton(
      title: "تسجيل شركتك",
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
                const TitleTextScreenWidget(
                    title: "انضم كشركة وابدأ بنشر الوظائف"),
                SizedBox(height: ManagerHeight.h4),

                const SubTitleTextScreenWidget(
                  subTitle:
                      "قم بإدخال بيانات شركتك ليتم التحقق منها واعتمادها في النظام، حيث يمكنك بعد التسجيل إدارة الوظائف ونشر الإعلانات بسهولة.",
                ),

                SizedBox(height: ManagerHeight.h24),

                /// ===== Company Name =====
                LabeledTextField(
                  label: "اسم الشركة",
                  hintText: "أدخل اسم الشركة",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Business Activity =====
                LabeledTextField(
                  label: "النشاط التجاري",
                  hintText: "أدخل النشاط التجاري للشركة",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Phone Number =====
                LabeledTextField(
                  label: "رقم الجوال",
                  hintText: "05xxxxxxxx",
                  keyboardType: TextInputType.phone,
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Location =====
                LabeledTextField(
                  label: "تعيين موقع الشركة",
                  hintText: "حدد موقع الشركة",
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
                        "حدد موقع الشركة",
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
                  label: "عنوان الشركة",
                  hintText: "أدخل عنوان الشركة بالتفصيل",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Description =====
                LabeledTextField(
                  label: "وصف النشاط",
                  hintText: "أدخل وصفًا مختصرًا عن نشاط الشركة",
                  minLines: 3,
                  maxLines: 5,
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Extra Description =====
                LabeledTextField(
                  label: "وصف قصير إضافي",
                  hintText: "اكتب نبذة تعريفية قصيرة عن الشركة",
                  minLines: 2,
                  maxLines: 4,
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Company Logo =====
                UploadMediaField(
                  label: "شعار الشركة",
                  hint: "ارفع شعار شركتك",
                  note: "PNG أو JPG",
                  file: dummyFile,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Full Name =====
                LabeledTextField(
                  label: "الاسم الكامل",
                  hintText: "أدخل الاسم الكامل للمسؤول",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Email =====
                LabeledTextField(
                  label: "البريد الإلكتروني",
                  hintText: "example@domain.com",
                  keyboardType: TextInputType.emailAddress,
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== Commercial Register =====
                LabeledTextField(
                  label: "السجل التجاري",
                  hintText: "أدخل رقم السجل التجاري",
                  widthButton: ManagerWidth.w130,
                ),
                const SizedBoxBetweenFieldWidgets(),

                /// ===== License Upload =====
                UploadMediaField(
                  label: "رخصة مزاولة النشاط",
                  hint: "ارفع رخصة مزاولة النشاط",
                  note: "PDF أو صورة",
                  file: dummyFile,
                ),

                SizedBox(height: ManagerHeight.h24),

                /// ===== Submit Button =====
                ButtonApp(
                  title: "إرسال بيانات الشركة",
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => CustomConfirmDialog(
                        title: "تأكيد تسجيل الشركة",
                        subtitle:
                            "هل أنت متأكد من رغبتك في تسجيل هذه الشركة؟ سيتم مراجعة الطلب واعتماده من قبل الإدارة.",
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
