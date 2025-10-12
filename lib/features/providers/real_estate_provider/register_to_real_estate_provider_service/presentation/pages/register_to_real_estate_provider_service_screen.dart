import 'dart:io';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/upload_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/widgets/custom_confirm_dialog.dart';
import '../widgets/account_type_selector_widget.dart';

class RegisterToRealEstateProviderServiceScreen extends StatefulWidget {
  const RegisterToRealEstateProviderServiceScreen({super.key});

  @override
  State<RegisterToRealEstateProviderServiceScreen> createState() =>
      _RegisterToRealEstateProviderServiceScreenState();
}

class _RegisterToRealEstateProviderServiceScreenState
    extends State<RegisterToRealEstateProviderServiceScreen> {
  String selectedAccountType = "office";
  final Rx<File?> logoFile = Rx<File?>(null);
  final Rx<File?> brokerageFile = Rx<File?>(null);
  final Rx<File?> commercialRecordFile = Rx<File?>(null);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.joinAsRealEstateProvider,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom + ManagerHeight.h16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ManagerHeight.h24),

              /// ===== العنوان =====
              TitleTextScreenWidget(
                title: ManagerStrings.startListingProperties,
              ),
              SizedBox(height: ManagerHeight.h4),
              SubTitleTextScreenWidget(
                subTitle: ManagerStrings.completeInfoToPublish,
              ),
              SizedBox(height: ManagerHeight.h24),

              /// ===== اسم الشخص =====
              LabeledTextField(
                label: ManagerStrings.fullName,
                hintText: ManagerStrings.enterFullName,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ===== رقم الجوال =====
              LabeledTextField(
                label: ManagerStrings.phoneNumber,
                hintText: ManagerStrings.enterPhoneNumber,
                keyboardType: TextInputType.phone,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ===== رقم الواتساب =====
              LabeledTextField(
                label: ManagerStrings.whatsappNumber,
                hintText: ManagerStrings.enterWhatsappNumber,
                keyboardType: TextInputType.phone,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ===== الموقع الجغرافي =====
              LabeledTextField(
                label: ManagerStrings.locationLabel,
                hintText: ManagerStrings.setYourLocation,
                widthButton: 140,
                onButtonTap: () {},
                buttonWidget: Container(
                  width: 140,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      ManagerStrings.setYourLocation,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ===== العنوان التفصيلي =====
              LabeledTextField(
                label: ManagerStrings.detailedAddress,
                hintText: ManagerStrings.enterLocationDetails,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ===== وصف مختصر =====
              LabeledTextField(
                label: ManagerStrings.activityDescription,
                hintText: ManagerStrings.enterActivityDescription,
                minLines: 3,
                maxLines: 5,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ===== رفع شعار مقدم العقارات =====
              UploadMediaField(
                label: ManagerStrings.uploadLogoLabel,
                hint: ManagerStrings.uploadLogoHint,
                note: ManagerStrings.uploadLogoNote,
                file: logoFile,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ===== نوع الحساب =====
              AccountTypeSelector(
                onChanged: (value) {
                  setState(() => selectedAccountType = value);
                },
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ===== إذا كان مكتب عقاري أظهر حقول إضافية =====
              if (selectedAccountType == "office") ...[
                UploadMediaField(
                  label: ManagerStrings.brokerageCertificate,
                  hint: ManagerStrings.uploadBrokerageHint,
                  note: ManagerStrings.uploadBrokerageNote,
                  file: brokerageFile,
                ),
                const SizedBoxBetweenFieldWidgets(),
                UploadMediaField(
                  label: ManagerStrings.commercialRecord,
                  hint: ManagerStrings.uploadCommercialHint,
                  note: ManagerStrings.uploadCommercialNote,
                  file: commercialRecordFile,
                ),
                const SizedBoxBetweenFieldWidgets(),
              ],

              SizedBox(height: ManagerHeight.h24),

              ButtonApp(
                title: ManagerStrings.addButton,
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return CustomConfirmDialog(
                        title: "تأكيد الإضافة",
                        subtitle:
                            "هل أنت متأكد من رغبتك في إضافة هذه البيانات؟",
                        confirmText: "تأكيد",
                        cancelText: "إلغاء",
                        onConfirm: () {
                          Navigator.pop(context);
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      );
                    },
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
