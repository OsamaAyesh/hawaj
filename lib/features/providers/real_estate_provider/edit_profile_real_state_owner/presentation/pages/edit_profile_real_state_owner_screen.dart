import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/custom_confirm_dialog.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/scaffold_with_back_button.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../presentation/controller/edit_profile_my_property_owner_controller.dart';

class EditProfileRealStateOwnerScreen extends StatelessWidget {
  const EditProfileRealStateOwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileMyPropertyOwnerController>();

    // TextControllers
    final nameController = TextEditingController();
    final mobileController = TextEditingController();
    final whatsappController = TextEditingController();
    final addressController = TextEditingController();
    final briefController = TextEditingController();

    // تحديث القيم عند تحميل البيانات
    ever(controller.ownerDataAvailable, (available) {
      if (available == true) {
        nameController.text = controller.companyName ?? '';
        mobileController.text = controller.mobileNumber ?? '';
        whatsappController.text = controller.whatsappNumber ?? '';
        addressController.text = controller.detailedAddress ?? '';
        briefController.text = controller.companyBrief ?? '';
      }
    });

    return ScaffoldWithBackButton(
      title: "تعديل بياناتي",
      body: Obx(() {
        return Stack(
          children: [
            /// ===== المحتوى الأساسي =====
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
                  .copyWith(bottom: ManagerHeight.h16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ManagerHeight.h24),

                  /// ===== الاسم =====
                  LabeledTextField(
                    controller: nameController,
                    label: "الاسم التجاري أو اسم الشخص",
                    hintText: "أدخل اسم المكتب أو اسمك الكامل",
                    widthButton: 130,
                    onChanged: (val) => controller.companyName = val,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== رقم الجوال =====
                  LabeledTextField(
                    controller: mobileController,
                    label: "رقم الجوال",
                    hintText: "أدخل رقم الهاتف",
                    keyboardType: TextInputType.phone,
                    widthButton: 130,
                    onChanged: (val) => controller.mobileNumber = val,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== رقم الواتساب =====
                  LabeledTextField(
                    controller: whatsappController,
                    label: "رقم الواتس آب",
                    hintText:
                        "أدخل رقم الهاتف مع مفتاح الدولة (مثال: +970599XXXXXX)",
                    keyboardType: TextInputType.phone,
                    widthButton: 130,
                    onChanged: (val) => controller.whatsappNumber = val,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== العنوان التفصيلي =====
                  LabeledTextField(
                    controller: addressController,
                    label: "العنوان التفصيلي",
                    hintText: "أدخل العنوان التفصيلي للمكتب",
                    widthButton: 130,
                    onChanged: (val) => controller.detailedAddress = val,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== وصف مختصر للنشاط =====
                  LabeledTextField(
                    controller: briefController,
                    label: "وصف مختصر للنشاط",
                    hintText: "أدخل نبذة موجزة عن خدماتك العقارية",
                    minLines: 3,
                    maxLines: 5,
                    widthButton: 130,
                    onChanged: (val) => controller.companyBrief = val,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// ===== رفع شعار مقدم العقارات =====
                  UploadMediaField(
                    label: "شعار مقدم العقارات",
                    hint: "ارفع شعار مقدم العقارات",
                    note: "اختياري (PNG أو JPG)",
                    file: controller.companyLogo == null
                        ? Rx<File?>(null)
                        : Rx<File?>(controller.companyLogo),
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
                          onConfirm: () {
                            Navigator.pop(context);
                            controller.editProfile();
                          },
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

            /// ===== الـ Loading فوق المحتوى =====
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(child: LoadingWidget()),
              ),
          ],
        );
      }),
    );
  }
}
