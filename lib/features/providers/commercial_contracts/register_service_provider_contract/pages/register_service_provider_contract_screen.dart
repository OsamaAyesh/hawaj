import 'dart:io';

import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
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

import '../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';

class RegisterServiceProviderContractScreen extends StatelessWidget {
  const RegisterServiceProviderContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.serviceProviderSubscription,
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

              TitleTextScreenWidget(
                title: ManagerStrings.serviceProviderSubscription,
              ),
              SubTitleTextScreenWidget(
                subTitle: ManagerStrings.serviceProviderSubscriptionSubtitle,
              ),

              SizedBox(height: ManagerHeight.h20),

              // الاسم التجاري
              LabeledTextField(
                label: ManagerStrings.serviceProviderTradeName,
                hintText: ManagerStrings.serviceProviderTradeNameHint,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // نوع النشاط
              LabeledDropdownField<String>(
                label: ManagerStrings.serviceProviderActivityType,
                hint: ManagerStrings.serviceProviderActivityTypeHint,
                value: null,
                items: [
                  DropdownMenuItem(
                      value: "تجاري",
                      child: Text(ManagerStrings.serviceProviderActivityType)),
                  DropdownMenuItem(
                      value: "خدمي",
                      child: Text(ManagerStrings.serviceProviderActivityType)),
                ],
                onChanged: (_) {},
              ),
              const SizedBoxBetweenFieldWidgets(),

              // رقم الترخيص أو السجل التجاري
              LabeledTextField(
                label:
                    ManagerStrings.serviceProviderCommercialRegistrationNumber,
                hintText: ManagerStrings
                    .serviceProviderCommercialRegistrationNumberHint,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // وصف قصير
              LabeledTextField(
                label: ManagerStrings.serviceProviderShortDescription,
                hintText: ManagerStrings.serviceProviderShortDescriptionHint,
                minLines: 3,
                maxLines: 4,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // نبذة عن مقدم الخدمة
              LabeledTextField(
                label: ManagerStrings.serviceProviderAboutProvider,
                hintText: ManagerStrings.serviceProviderAboutProviderHint,
                minLines: 4,
                maxLines: 6,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // تاريخ التأسيس
              LabeledTextField(
                label: ManagerStrings.serviceProviderFoundationDate,
                hintText: ManagerStrings.serviceProviderFoundationDateHint,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // رقم الجوال
              LabeledTextField(
                label: ManagerStrings.serviceProviderPhoneNumber,
                hintText: ManagerStrings.serviceProviderPhoneNumberHint,
                keyboardType: TextInputType.phone,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // تحديد الموقع الجغرافي
              LabeledTextField(
                label: ManagerStrings.serviceProviderSetLocation,
                hintText: ManagerStrings.serviceProviderSetLocationHint,
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
                      ManagerStrings.serviceProviderChooseLocation,
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
                label: ManagerStrings.serviceProviderDetailedAddress,
                hintText: ManagerStrings.serviceProviderDetailedAddressHint,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              // رفع الرخصة
              UploadMediaField(
                label: ManagerStrings.serviceProviderLicenseFile,
                hint: ManagerStrings.serviceProviderLicenseFileHint,
                note: ManagerStrings.serviceProviderLicenseFileNote,
                file: Rx<File?>(null), // مبدئياً فارغ
              ),
              const SizedBoxBetweenFieldWidgets(),

              // رفع الشعار
              UploadMediaField(
                label: ManagerStrings.serviceProviderLogoFile,
                hint: ManagerStrings.serviceProviderLogoFileHint,
                note: ManagerStrings.serviceProviderLogoFileNote,
                file: Rx<File?>(null), // مبدئياً فارغ
              ),

              SizedBox(height: ManagerHeight.h24),

              // زر الإرسال
              ButtonApp(
                title: ManagerStrings.serviceProviderSubscription,
                onPressed: () {
                  showDialogConfirmRegisterCompanyOffer(
                    title:
                        ManagerStrings.serviceProviderConfirmSubscriptionTitle,
                    subTitle: ManagerStrings
                        .serviceProviderConfirmSubscriptionSubtitle,
                    actionConfirmText: ManagerStrings.serviceProviderConfirm,
                    actionCancel: ManagerStrings.serviceProviderCancel,
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
