import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/lable_drop_down_button.dart';
import '../../../../../../core/widgets/show_dialog_confirm_register_company_offer_widget.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
import '../../../subscription_offer_provider/presentation/controller/get_plans_controller.dart';
import '../controller/add_offer_controller.dart';

class AddOfferProviderScreen extends StatelessWidget {
  const AddOfferProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addOfferController = Get.find<CreateOfferProviderController>();
    final plansController = Get.find<PlansController>();

    /// تحميل بيانات المؤسسات عند الدخول
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (plansController.organizations.isEmpty) {
        plansController.fetchOrganizations();
      }
    });

    return ScaffoldWithBackButton(
      title: ManagerStrings.offerRegisterTitle,
      body: Obx(() {
        // حالة التحميل الأولية لبيانات المؤسسة
        if (plansController.isLoading.value &&
            plansController.organizations.isEmpty) {
          return LoadingWidget();
        }

        if (plansController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              plansController.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        // نأخذ أول مؤسسة كافتراضي
        final orgId = plansController.selectedOrganization.value?.id ??
            (plansController.organizations.isNotEmpty
                ? plansController.organizations.first.id
                : 1);

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ManagerHeight.h24),

                    /// ===== Title & Subtitle =====
                    TitleFormScreenWidget(title: ManagerStrings.offerAddNew),
                    SubTitleFormScreenWidget(
                        subTitle: ManagerStrings.offerSubtitle),
                    SizedBox(height: ManagerHeight.h16),

                    /// ===== Product Name =====
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.offerProductName,
                      hintText: ManagerStrings.offerProductDesc1,
                      controller: addOfferController.productNameController,
                      textInputAction: TextInputAction.next,
                      minLines: 1,
                      maxLines: 1,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// ===== Product Description =====
                    LabeledTextField(
                      widthButton: ManagerWidth.w130,
                      label: ManagerStrings.offerProductDesc,
                      hintText: ManagerStrings.offerProductDescHint,
                      controller:
                          addOfferController.productDescriptionController,
                      textInputAction: TextInputAction.next,
                      minLines: 1,
                      maxLines: 1,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// ===== Upload Image =====
                    UploadMediaField(
                      label: ManagerStrings.offerProductImages,
                      hint: ManagerStrings.offerProductImagesHint,
                      note: ManagerStrings.offerProductImagesHint2,
                      file: addOfferController.pickedImage,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// ===== Product Price =====
                    LabeledTextField(
                      widthButton: ManagerWidth.w40,
                      label: ManagerStrings.offerProductPrice,
                      hintText: ManagerStrings.offerProductPriceHint,
                      controller: addOfferController.productPriceController,
                      buttonWidget: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: ManagerHeight.h2),
                        child: Image.asset(ManagerIcons.ryalSudia),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBoxBetweenFieldWidgets(),

                    /// ===== Offer Type Dropdown =====
                    Obx(() => LabeledDropdownField<String>(
                          label: ManagerStrings.offerType,
                          hint: ManagerStrings.offerTypeHint,
                          value: addOfferController.offerType.value.isEmpty
                              ? null
                              : addOfferController.offerType.value,
                          items: const [
                            DropdownMenuItem(value: "2", child: Text("عادي")),
                            DropdownMenuItem(
                                value: "1", child: Text("خصم بالمئة")),
                          ],
                          onChanged: (value) {
                            addOfferController.offerType.value = value ?? "";
                          },
                        )),

                    /// ===== Extra Fields if Discount =====
                    Obx(() {
                      if (addOfferController.offerType.value == "1") {
                        return Column(
                          children: [
                            const SizedBoxBetweenFieldWidgets(),
                            LabeledTextField(
                              widthButton: ManagerWidth.w40,
                              label: "نسبة الخصم %",
                              hintText: "أدخل نسبة الخصم",
                              controller:
                                  addOfferController.offerPriceController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBoxBetweenFieldWidgets(),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        addOfferController
                                                .offerStartDateController.text =
                                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: LabeledTextField(
                                        widthButton: ManagerWidth.w130,
                                        label: ManagerStrings.offerFromDate,
                                        hintText: "اختر تاريخ البداية",
                                        controller: addOfferController
                                            .offerStartDateController,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ManagerWidth.w16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        addOfferController
                                                .offerEndDateController.text =
                                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: LabeledTextField(
                                        widthButton: ManagerWidth.w130,
                                        label: ManagerStrings.offerToDate,
                                        hintText: "اختر تاريخ النهاية",
                                        controller: addOfferController
                                            .offerEndDateController,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBoxBetweenFieldWidgets(),
                            LabeledTextField(
                              widthButton: ManagerWidth.w130,
                              label: ManagerStrings.offerDesc,
                              hintText: ManagerStrings.offerDescHint,
                              controller:
                                  addOfferController.offerDescriptionController,
                              textInputAction: TextInputAction.next,
                              minLines: 4,
                              maxLines: 5,
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    const SizedBoxBetweenFieldWidgets(),

                    /// ===== Offer Status Dropdown =====
                    Obx(() => LabeledDropdownField<String>(
                          label: "حالة العرض",
                          hint: "اختر حالة العرض",
                          value: addOfferController.offerStatus.value.isEmpty
                              ? null
                              : addOfferController.offerStatus.value,
                          items: const [
                            DropdownMenuItem(value: "1", child: Text("نشر")),
                            DropdownMenuItem(
                                value: "2", child: Text("غير منشور")),
                            DropdownMenuItem(value: "3", child: Text("منتهي")),
                            DropdownMenuItem(value: "4", child: Text("ملغي")),
                            DropdownMenuItem(
                                value: "5", child: Text("قيد المعاينة")),
                          ],
                          onChanged: (value) {
                            addOfferController.offerStatus.value = value ?? "";
                          },
                        )),

                    SizedBox(height: ManagerHeight.h16),

                    /// ===== Submit Button =====
                    ButtonApp(
                      title: ManagerStrings.offerSubmit,
                      onPressed: () {
                        if (orgId == null) {
                          Get.snackbar("خطأ", "لا توجد مؤسسة متاحة حالياً");
                          return;
                        }
                        showDialogConfirmRegisterCompanyOffer(
                          title: ManagerStrings.confirmAddProductTitle,
                          subTitle: ManagerStrings.confirmAddProductSubtitle,
                          actionConfirmText:
                              ManagerStrings.confirmAddProductConfirm,
                          actionCancel: ManagerStrings.confirmAddProductCancel,
                          context,
                          onConfirm: () {
                            // نمرر الـ id الحقيقي للمؤسسة
                            addOfferController.submitOffer(
                                organizationId: orgId);
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
            if (addOfferController.isLoading.value) LoadingWidget(),
          ],
        );
      }),
    );
  }
}
