import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/custom_confirm_dialog.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/scaffold_with_back_button.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';

class EditProfileRealStateOwnerScreen extends StatelessWidget {
  const EditProfileRealStateOwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "تعديل بياناتي",
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
            .copyWith(bottom: ManagerHeight.h16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ManagerHeight.h24),

            /// ===== الاسم =====
            LabeledTextField(
              label: "الاسم التجاري أو اسم الشخص",
              hintText: "أدخل اسم المكتب أو اسمك الكامل",
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== رقم الجوال =====
            LabeledTextField(
              label: "رقم الجوال",
              hintText: "أدخل رقم الهاتف",
              keyboardType: TextInputType.phone,
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== رقم الواتساب =====
            LabeledTextField(
              label: "رقم الواتس آب",
              hintText: "أدخل رقم الهاتف مع مفتاح الدولة (مثال: +970599XXXXXX)",
              keyboardType: TextInputType.phone,
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== العنوان التفصيلي =====
            LabeledTextField(
              label: "العنوان التفصيلي",
              hintText: "أدخل العنوان التفصيلي للمكتب",
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== وصف مختصر للنشاط =====
            LabeledTextField(
              label: "وصف مختصر للنشاط",
              hintText: "أدخل نبذة موجزة عن خدماتك العقارية",
              minLines: 3,
              maxLines: 5,
              widthButton: 130,
            ),
            const SizedBoxBetweenFieldWidgets(),

            /// ===== رفع شعار مقدم العقارات =====
            UploadMediaField(
              label: "شعار مقدم العقارات",
              hint: "ارفع شعار مقدم العقارات",
              note: "اختياري (PNG أو JPG)",
              file: Rx<File?>(null),
            ),
            SizedBox(height: ManagerHeight.h24),

            /// ===== زر التعديل =====
            ButtonApp(
              title: "تعديل",
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => CustomConfirmDialog(
                    title: "تعديل بيانات الحساب العقاري",
                    subtitle:
                        "تم تحديث بياناتك الظاهرة للمستخدمين، مثل الاسم، رقم التواصل والوصف.",
                    confirmText: "متابعة",
                    cancelText: "إلغاء",
                    onConfirm: () => Navigator.pop(context),
                    onCancel: () => Navigator.pop(context),
                  ),
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
