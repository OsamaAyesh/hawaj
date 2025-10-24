import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/property_item_owner_model.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/widgets/button_app.dart';
import '../../../../../../core/widgets/custom_confirm_dialog.dart';
import '../../../../../../core/widgets/labeled_text_field.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/scaffold_with_back_button.dart';
import '../../../../../../core/widgets/sized_box_between_feilads_widgets.dart';
import '../../../../../../core/widgets/upload_media_widget.dart';
import '../../domain/di/di.dart';
import '../../presentation/controller/edit_profile_my_property_owner_controller.dart';

class EditProfileRealStateOwnerScreen extends StatefulWidget {
  final String ownerId;

  /// The full owner model passed from the previous screen
  final PropertyItemOwnerModel owner;

  const EditProfileRealStateOwnerScreen({
    super.key,
    required this.owner,
    required this.ownerId,
  });

  @override
  State<EditProfileRealStateOwnerScreen> createState() =>
      _EditProfileRealStateOwnerScreenState();
}

class _EditProfileRealStateOwnerScreenState
    extends State<EditProfileRealStateOwnerScreen> {
  late final EditProfileMyPropertyOwnerController controller;

  // Text Controllers
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final whatsappController = TextEditingController();
  final addressController = TextEditingController();
  final briefController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// 🟢 Initialize DI module with the passed ownerId
    initEditProfileMyPropertyOwnerModule(widget.owner.id ?? '');

    /// 🟢 Get the controller instance
    controller = Get.find<EditProfileMyPropertyOwnerController>();

    /// 🟢 Initialize data into the controller and fields
    _initOwnerData(widget.owner);
  }

  /// Initialize owner data from model
  void _initOwnerData(PropertyItemOwnerModel owner) {
    controller.ownerName = owner.ownerName;
    controller.mobileNumber = owner.mobileNumber;
    controller.whatsappNumber = owner.whatsappNumber;
    controller.locationLat = owner.locationLat;
    controller.locationLng = owner.locationLng;
    controller.detailedAddress = owner.detailedAddress;
    controller.accountType = owner.accountType;
    controller.companyName = owner.companyName;
    controller.companyBrief = owner.companyBrief;

    // Set values in text fields
    nameController.text = owner.companyName ?? '';
    mobileController.text = owner.mobileNumber ?? '';
    whatsappController.text = owner.whatsappNumber ?? '';
    addressController.text = owner.detailedAddress ?? '';
    briefController.text = owner.companyBrief ?? '';
  }

  @override
  void dispose() {
    /// 🔴 Dispose DI module and controller when leaving the screen
    disposeEditProfileMyPropertyOwnerModule();

    nameController.dispose();
    mobileController.dispose();
    whatsappController.dispose();
    addressController.dispose();
    briefController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "تعديل بياناتي",
      body: Obx(() {
        return Stack(
          children: [
            /// ===== المحتوى الرئيسي =====
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16)
                  .copyWith(bottom: ManagerHeight.h24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ManagerHeight.h24),

                  /// ===== الاسم التجاري أو الشخصي =====
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
                          title: "تأكيد تعديل البيانات",
                          subtitle:
                              "سيتم تحديث بياناتك الظاهرة للمستخدمين مثل الاسم، رقم التواصل والوصف.",
                          confirmText: "تأكيد",
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

            /// ===== Overlay Loading فوق المحتوى =====
            if (controller.isLoading.value)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.15),
                alignment: Alignment.center,
                child: const LoadingWidget(),
              ),
          ],
        );
      }),
    );
  }
}
