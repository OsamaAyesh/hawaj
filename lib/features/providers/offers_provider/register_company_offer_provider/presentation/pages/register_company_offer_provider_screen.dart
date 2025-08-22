import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_icons.dart';
import '../../../../../../core/resources/manager_strings.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';

class RegisterCompanyOfferProviderScreen extends StatelessWidget {
  const RegisterCompanyOfferProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.registerCompany,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ManagerHeight.h24,
              ),

              /// ======== Title Widget =========
              TitleFormScreenWidget(
                title: ManagerStrings.registerCompanyTitle,
              ),

              /// ======== Subtitle Widget =========
              SubTitleFormScreenWidget(
                subTitle: ManagerStrings.registerCompanySubtitle,
              ),

              SizedBox(
                height: ManagerHeight.h16,
              ),

              /// ======== Text Field Company Name =================
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.companyName,
                hintText: ManagerStrings.companyNameHint,
                controller: TextEditingController(),
                isPhoneField: false,
                textInputAction: TextInputAction.next,
                minLines: 1,
                maxLines: 1,
              ),

              const SizedBoxBetweenFieldWidgets(),

              /// ======== Text Field Company Services =================
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.companyServices,
                hintText: ManagerStrings.companyServicesHint,
                controller: TextEditingController(),
                isPhoneField: false,
                textInputAction: TextInputAction.next,
                minLines: 5,
                maxLines: 6,
              ),

              const SizedBoxBetweenFieldWidgets(),

              /// ======== Text Field Set Location On Map =================
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.setLocation,
                hintText: ManagerStrings.setLocation,
                controller: TextEditingController(text: ""),
                minLines: 1,
                maxLines: 1,
                onButtonTap: () {},
                enabled: true,
                buttonWidget: Text(
                  ManagerStrings.setLocationButton,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBoxBetweenFieldWidgets(),

              /// ======== Text Field Details Location=================
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.detailedAddress,
                hintText: ManagerStrings.detailedAddressHint,
                controller: TextEditingController(),
                isPhoneField: false,
                textInputAction: TextInputAction.next,
                minLines: 1,
                maxLines: 1,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ======== Text Field Responsible Person=================
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.responsiblePerson,
                hintText: ManagerStrings.responsiblePersonHint,
                controller: TextEditingController(),
                isPhoneField: false,
                textInputAction: TextInputAction.next,
                minLines: 1,
                maxLines: 1,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ======== Text Field Responsible Person=================
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.phoneNumber,
                hintText: ManagerStrings.phoneNumberHint,
                controller: TextEditingController(),
                isPhoneField: false,
                textInputAction: TextInputAction.next,
                minLines: 1,
                maxLines: 1,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ======== Text Field Responsible Person=================
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.workingHours,
                hintText: ManagerStrings.workingHoursHint,
                controller: TextEditingController(),
                isPhoneField: false,
                textInputAction: TextInputAction.next,
                minLines: 1,
                maxLines: 1,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ======== Upload File Widget=================
              UploadProfileImageField(
                label: ManagerStrings.companyLogo,
                hint: ManagerStrings.companyLogoHint,
                note: ManagerStrings.companyLogoHint2,
                onTap: () {
                  // Action Upload Image
                },
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ========  Text Field Commercial Number=================
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.commercialNumber,
                hintText: ManagerStrings.commercialNumberHint,
                controller: TextEditingController(),
                isPhoneField: false,
                textInputAction: TextInputAction.next,
                minLines: 1,
                maxLines: 1,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ======== Upload File Widget=================
              UploadProfileImageField(
                label: ManagerStrings.commercialRecord,
                hint: ManagerStrings.commercialRecordHint,
                note: ManagerStrings.commercialRecordHint2,
                onTap: () {
                  // Action Upload Image
                },
              ),
              SizedBox(
                height: ManagerHeight.h16,
              ),

              /// ======== Button Widget=================
              ButtonApp(
                  title: ManagerStrings.submitButton,
                  onPressed: () {
                    showDialogConfirmRegisterCompanyOffer(
                      title: ManagerStrings.confirmAddOrgTitle,
                      subTitle: ManagerStrings.confirmAddOrgSubtitle,
                      actionConfirmText: ManagerStrings.confirmAddOrgConfirm,
                      actionCancel: ManagerStrings.confirmAddOrgCancel,
                      context,
                      onConfirm: () {
                        // TODO: تنفيذ عملية التأكيد
                        print("Company offer registered ✅");
                      },
                      onCancel: () {
                        // TODO: إلغاء العملية
                        print("Operation cancelled ❌");
                      },
                    );
                  },
                  paddingWidth: 0),

              SizedBox(
                height: ManagerHeight.h16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
