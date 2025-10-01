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
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';

class AddNewServiceCommercialContractsScreen extends StatelessWidget {
  const AddNewServiceCommercialContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.addNewServiceTitle,
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

              /// ===== العنوان الرئيسي =====
              TitleTextScreenWidget(title: ManagerStrings.addNewServiceTitle),
              SubTitleTextScreenWidget(
                subTitle: ManagerStrings.addNewServiceSubTitle,
              ),
              SizedBox(height: ManagerHeight.h20),

              /// ===== اسم الخدمة =====
              LabeledTextField(
                label: ManagerStrings.serviceNameLabel,
                hintText: ManagerStrings.serviceNameHint,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ===== وصف الخدمة =====
              LabeledTextField(
                label: ManagerStrings.serviceDescriptionLabel,
                hintText: ManagerStrings.serviceDescriptionHint,
                minLines: 4,
                maxLines: 6,
                widthButton: ManagerWidth.w130,
              ),
              const SizedBoxBetweenFieldWidgets(),

              /// ===== السعر الابتدائي =====
              LabeledTextField(
                label: ManagerStrings.serviceInitialPriceLabel,
                hintText: ManagerStrings.serviceInitialPriceHint,
                keyboardType: TextInputType.number,
                widthButton: 50,
                onButtonTap: () {},
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

              /// ===== الصورة التوضيحية للخدمة =====
              UploadMediaField(
                label: ManagerStrings.serviceUploadImageLabel,
                hint: ManagerStrings.serviceUploadImageHint,
                note: ManagerStrings.serviceUploadImageNote,
                file: Rx<File?>(null), // فارغ حالياً
              ),

              SizedBox(height: ManagerHeight.h32),

              /// ===== زر الإضافة =====
              ButtonApp(
                title: ManagerStrings.addServiceButton,
                onPressed: () {
                  showDialogConfirmRegisterCompanyOffer(
                    title: ManagerStrings.confirmAddServiceTitle,
                    subTitle: ManagerStrings.confirmAddServiceSubTitle,
                    actionConfirmText: ManagerStrings.confirm,
                    actionCancel: ManagerStrings.cancel,
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
