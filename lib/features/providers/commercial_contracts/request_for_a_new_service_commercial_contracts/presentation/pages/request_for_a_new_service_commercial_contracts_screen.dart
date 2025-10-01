import 'dart:io';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../widget/service_request_card_widget.dart';

class RequestForANewServiceCommercialContractsScreen extends StatelessWidget {
  const RequestForANewServiceCommercialContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.requestForServiceTitle,
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

              /// ===== كارد الطلب =====
              ServiceRequestCard(
                name: "محمد علي إسماعيل",
                subtitle: "966597470024",
                imageUrl:
                    "https://media.istockphoto.com/id/1833394225/photo/businessman-smiling-in-a-meeting-at-the-office.jpg?s=612x612&w=0&k=20&c=Hmt5obbmDOMiIVWG6ftnr_0F6KgvBFQRBhXSELu9IyM=",
                title: "تصميم لوجو احترافي",
                description:
                    "أحتاج إلى تصميم شعار (لوجو) احترافي لمتجر إلكتروني متخصص ببيع منتجات العناية بالبشرة. الاسم المطلوب في الشعار: GlowMe. النمط المطلوب: بسيط، أنيق، يوحي بالثقة والجمال. الألوان المفضلة: الأبيض – الذهبي – الوردي الفاتح. اللغة: الإنجليزية فقط. أرغب باستلام الشعار بصيغ متعددة (PNG + SVG + PDF). يُفضّل عرض 2 إلى 3 نماذج للاختيار من بينها. المدة المتوقعة: 3 أيام كحد أقصى. الميزانية: قابلة للتفاوض حسب الجودة.",
                date: "2024-07-14",
                applicantsCount: "22 متقدم",
              ),

              SizedBox(height: ManagerHeight.h12),

              /// ===== سعر الخدمة =====
              LabeledTextField(
                label: ManagerStrings.requestForServicePrice,
                hintText: ManagerStrings.requestForServicePriceHint,
                keyboardType: TextInputType.number,
                widthButton: 50,
                onButtonTap: () {
                  // منطق عند الضغط على الأيقونة
                },
                buttonWidget: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Container(
                      width: ManagerWidth.w24,
                      height: ManagerHeight.h24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.attach_money,
                        color: ManagerColors.primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBoxBetweenFieldWidgets(),

              /// ===== العرض الفني =====
              UploadMediaField(
                label: ManagerStrings.requestForServiceTechnicalOffer,
                hint: ManagerStrings.requestForServiceTechnicalOfferHint,
                note: ManagerStrings.requestForServiceTechnicalOfferNote,
                file: Rx<File?>(null), // مبدئياً فارغ
              ),

              const SizedBoxBetweenFieldWidgets(),

              /// ===== رقم التواصل =====
              LabeledTextField(
                label: ManagerStrings.requestForServiceContactNumber,
                hintText: ManagerStrings.requestForServiceContactNumberHint,
                keyboardType: TextInputType.phone,
                widthButton: 0,
              ),

              SizedBox(height: ManagerHeight.h32),

              /// ===== زر تقديم الطلب =====
              ButtonApp(
                title: ManagerStrings.requestForServiceSubmit,
                onPressed: () {
                  showDialogConfirmRegisterCompanyOffer(
                    title: ManagerStrings.requestForServiceConfirmTitle,
                    subTitle: ManagerStrings.requestForServiceConfirmSubtitle,
                    actionConfirmText: ManagerStrings.requestForServiceConfirm,
                    actionCancel: ManagerStrings.requestForServiceCancel,
                    context,
                    onConfirm: () {
                      // منطق التأكيد لاحقاً
                    },
                    onCancel: () {},
                  );
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
