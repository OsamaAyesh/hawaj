import 'dart:io';

import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/lable_drop_down_button.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/upload_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterServiceProviderContractScreen extends StatelessWidget {
  const RegisterServiceProviderContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "الاشتراك كمقدم خدمة",
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom + ManagerHeight.h16,
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ManagerHeight.h24),

              TitleTextScreenWidget(title: "الاشتراك كمقدم خدمة"),
              SubTitleTextScreenWidget(
                subTitle:
                    "انضم إلى المنصة كمقدم خدمة وابدا بتقديم خدماتك للعملاء بكل احترافية وسهولة.",
              ),

              SizedBox(height: ManagerHeight.h20),

              // الاسم التجاري
              LabeledTextField(
                label: "الاسم التجاري",
                hintText: "ادخل الاسم التجاري لمقدم الخدمة",
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // نوع النشاط
              LabeledDropdownField<String>(
                label: "نوع النشاط",
                hint: "اختر نوع النشاط الخاص بمقدم الخدمة",
                value: null,
                items: const [
                  DropdownMenuItem(value: "تجاري", child: Text("تجاري")),
                  DropdownMenuItem(value: "خدمي", child: Text("خدمي")),
                ],
                onChanged: (_) {},
              ),
              const SizedBoxBetweenFieldWidgets(),

              // رقم الترخيص أو السجل التجاري
              LabeledTextField(
                label: "رقم الترخيص أو السجل التجاري",
                hintText: "ادخل رقم الترخيص أو السجل التجاري",
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // وصف قصير
              LabeledTextField(
                label: "وصف قصير",
                hintText: "ادخل وصف قصير لخدماتك",
                minLines: 3,
                maxLines: 4,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // نبذة عن مقدم الخدمة
              LabeledTextField(
                label: "نبذة عن مقدم الخدمة",
                hintText: "اكتب نبذة عن مقدم الخدمة",
                minLines: 4,
                maxLines: 6,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // تاريخ التأسيس
              LabeledTextField(
                label: "تاريخ التأسيس",
                hintText: "ادخل تاريخ تأسيس الشركة",
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // رقم الجوال
              LabeledTextField(
                label: "رقم الجوال",
                hintText: "ادخل رقم الجوال",
                keyboardType: TextInputType.phone,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // تحديد الموقع الجغرافي
              LabeledTextField(
                label: "تحديد الموقع الجغرافي",
                hintText: "اضغط لتحديد الموقع",
                onButtonTap: () {
                  // TODO: فتح شاشة الخريطة لاحقاً
                },
                buttonWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "حدد الموقع",
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // العنوان التفصيلي
              LabeledTextField(
                label: "العنوان التفصيلي",
                hintText: "ادخل العنوان التفصيلي",
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // رفع الرخصة
              UploadMediaField(
                label: "رخصة المكتب أو الشركة",
                hint: "قم برفع نسخة من الرخصة",
                note: "بصيغة PDF أو صورة واضحة",
                file: Rx<File?>(null), // مبدئياً فارغ
              ),
              const SizedBoxBetweenFieldWidgets(),

              // رفع الشعار
              UploadMediaField(
                label: "شعار المكتب أو الشركة",
                hint: "قم برفع شعار المكتب أو الشركة",
                note: "يفضل PNG بخلفية شفافة",
                file: Rx<File?>(null), // مبدئياً فارغ
              ),

              SizedBox(height: ManagerHeight.h24),

              // زر الإرسال
              ButtonApp(
                title: "الاشتراك كمقدم خدمة",
                onPressed: () {
                  // TODO: تنفيذ الإرسال لاحقاً
                },
                paddingWidth: 0,
              ),
              SizedBox(height: ManagerHeight.h16),
            ],
          ),
        ),
      ),
    );
  }
}
