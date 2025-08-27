import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';

class AddOfferProviderScreen extends StatefulWidget {
  const AddOfferProviderScreen({super.key});

  @override
  State<AddOfferProviderScreen> createState() => _AddOfferProviderScreenState();
}

class _AddOfferProviderScreenState extends State<AddOfferProviderScreen> {
  String? offerType; // القيمة المختارة من الـ Dropdown

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.offerRegisterTitle,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ManagerHeight.h24),

              /// ======== Title Widget =========
              TitleFormScreenWidget(title: ManagerStrings.offerAddNew),

              /// ======== Subtitle Widget =========
              SubTitleFormScreenWidget(subTitle: ManagerStrings.offerSubtitle),

              SizedBox(height: ManagerHeight.h16),

              /// ======== Text Field Offer Product Name =================
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.offerProductName,
                hintText: ManagerStrings.offerProductDesc1,
                controller: TextEditingController(),
                isPhoneField: false,
                textInputAction: TextInputAction.next,
                minLines: 1,
                maxLines: 1,
              ),

              const SizedBoxBetweenFieldWidgets(),

              /// ======== Text Field Offer Product Description =================
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.offerProductDesc,
                hintText: ManagerStrings.offerProductDescHint,
                controller: TextEditingController(),
                isPhoneField: false,
                textInputAction: TextInputAction.next,
                minLines: 1,
                maxLines: 1,
              ),

              const SizedBoxBetweenFieldWidgets(),

              /// ======== Upload File Widget=================
              // UploadProfileImageField(
              //   label: ManagerStrings.offerProductImages,
              //   hint: ManagerStrings.offerProductImagesHint,
              //   note: ManagerStrings.offerProductImagesHint2,
              //   onTap: () {
              //     // Action Upload Image
              //   },
              // ),

              const SizedBoxBetweenFieldWidgets(),

              /// ======== Text Field Offer Price=================
              LabeledTextField(
                widthButton: ManagerWidth.w40,
                label: ManagerStrings.offerProductPrice,
                hintText: ManagerStrings.offerProductPriceHint,
                controller: TextEditingController(),
                buttonWidget: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0, vertical: ManagerHeight.h2),
                  child: Image.asset(ManagerIcons.ryalSudia),
                ),
                onButtonTap: () {},
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),

              const SizedBoxBetweenFieldWidgets(),

              /// ========= Drop Down Widget (Offer Type)
              LabeledDropdownField<String>(
                label: ManagerStrings.offerType,
                hint: ManagerStrings.offerTypeHint,
                value: offerType,
                items: [
                  DropdownMenuItem(
                    value: "normal",
                    child: Text(
                      ManagerStrings.offerTypeNormal,
                    ),
                  ),
                  DropdownMenuItem(
                    value: "offer",
                    child: Text(
                      ManagerStrings.offerTypeDiscount,
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    offerType = value;
                  });
                },
              ),

              ///====== Show Fields When Type Buy == Offer
              if (offerType == "offer") ...[
                const SizedBoxBetweenFieldWidgets(),

                /// ======== Text Field Offer Discount Price =================
                LabeledTextField(
                  widthButton: ManagerWidth.w40,
                  label: ManagerStrings.offerPrice,
                  hintText: ManagerStrings.offerPriceHint,
                  controller: TextEditingController(),
                  buttonWidget: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0, vertical: ManagerHeight.h2),
                    child: Image.asset(ManagerIcons.ryalSudia),
                  ),
                  onButtonTap: () {},
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBoxBetweenFieldWidgets(),

                /// ======== Date Fields =================
                Row(
                  children: [
                    Expanded(
                      child: LabeledTextField(
                        widthButton: ManagerWidth.w130,
                        label: ManagerStrings.offerFromDate,
                        hintText: ManagerStrings.offerFromDateHint,
                        controller: TextEditingController(),
                        isPhoneField: false,
                        textInputAction: TextInputAction.next,
                        minLines: 1,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: ManagerWidth.w16),
                    Expanded(
                      child: LabeledTextField(
                        widthButton: ManagerWidth.w130,
                        label: ManagerStrings.offerToDate,
                        hintText: ManagerStrings.offerType,
                        controller: TextEditingController(),
                        isPhoneField: false,
                        textInputAction: TextInputAction.next,
                        minLines: 1,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBoxBetweenFieldWidgets(),

                /// ======== Offer Description =================
                LabeledTextField(
                  widthButton: ManagerWidth.w130,
                  label: ManagerStrings.offerDesc,
                  hintText: ManagerStrings.offerDescHint,
                  controller: TextEditingController(),
                  isPhoneField: false,
                  textInputAction: TextInputAction.next,
                  minLines: 4,
                  maxLines: 5,
                ),
              ],
              SizedBox(height: ManagerHeight.h16,),

              ///======Button Add Offer
              ButtonApp(
                title: ManagerStrings.offerSubmit,
                onPressed: () {
                  showDialogConfirmRegisterCompanyOffer(
                    title: ManagerStrings.confirmAddProductTitle,
                    subTitle: ManagerStrings.confirmAddProductSubtitle,
                    actionConfirmText: ManagerStrings.confirmAddProductConfirm,
                    actionCancel: ManagerStrings.confirmAddProductCancel,
                    context,
                    onConfirm: () {

                    },
                    onCancel: () {

                    },
                  );
                },
                paddingWidth: 0,
              ),
              SizedBox(height: ManagerHeight.h16,),
            ],
          ),
        ),
      ),
    );
  }
}
