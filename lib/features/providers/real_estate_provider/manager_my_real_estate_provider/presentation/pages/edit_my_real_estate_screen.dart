import 'dart:io';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/custom_confirm_dialog.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/lable_drop_down_button.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/upload_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/real_estate_item_model.dart';
import '../../data/request/edit_my_real_estate_request.dart';
import '../controller/edit_my_real_estate_controller.dart';

class EditMyRealEstateScreen extends StatefulWidget {
  final RealEstateItemModel realEstate;

  const EditMyRealEstateScreen({super.key, required this.realEstate});

  @override
  State<EditMyRealEstateScreen> createState() => _EditMyRealEstateScreenState();
}

class _EditMyRealEstateScreenState extends State<EditMyRealEstateScreen> {
  late EditMyRealEstateController controller;

  // Controllers for editable fields
  final subjectController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final areaController = TextEditingController();
  final descriptionController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<EditMyRealEstateController>();

    final m = widget.realEstate;
    subjectController.text = m.propertySubject;
    addressController.text = m.propertyDetailedAddress;
    priceController.text = m.price;
    areaController.text = m.areaSqm;
    descriptionController.text = m.propertyDescription;
    latController.text = m.lat;
    lngController.text = m.lng;
  }

  @override
  Widget build(BuildContext context) {
    final estate = widget.realEstate;

    return ScaffoldWithBackButton(
      title: "تعديل العقار",
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleTextScreenWidget(title: "تعديل العقار"),
                  const SubTitleTextScreenWidget(
                    subTitle:
                        "يمكنك تعديل تفاصيل العقار وتحديث بياناته الحالية",
                  ),
                  SizedBox(height: ManagerHeight.h20),

                  /// نوع العقار
                  LabeledDropdownField<String>(
                    label: "نوع العقار",
                    hint: "اختر نوع العقار",
                    value: estate.propertyType,
                    items: [
                      DropdownMenuItem(
                          value: estate.propertyType,
                          child: Text(estate.propertyTypeLabel)),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// نوع العملية
                  LabeledDropdownField<String>(
                    label: "نوع العملية",
                    hint: "اختر نوع العملية",
                    value: estate.operationType,
                    items: [
                      DropdownMenuItem(
                          value: estate.operationType,
                          child: Text(estate.operationTypeLabel)),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// صفة المعلن
                  LabeledDropdownField<String>(
                    label: "صفة المعلن",
                    hint: "اختر صفتك",
                    value: estate.advertiserRole,
                    items: [
                      DropdownMenuItem(
                          value: estate.advertiserRole,
                          child: Text(estate.advertiserRoleLabel)),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// نوع البيع
                  LabeledDropdownField<String>(
                    label: "نوع البيع",
                    hint: "اختر نوع البيع",
                    value: estate.saleType,
                    items: [
                      DropdownMenuItem(
                          value: estate.saleType,
                          child: Text(estate.saleTypeLabel)),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// نوع الاستخدام
                  LabeledDropdownField<String>(
                    label: "نوع الاستخدام",
                    hint: "اختر نوع الاستخدام",
                    value: estate.usageType,
                    items: [
                      DropdownMenuItem(
                          value: estate.usageType,
                          child: Text(estate.usageTypeLabel)),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// العنوان والموقع
                  LabeledTextField(
                    widthButton: ManagerWidth.w12,
                    label: "عنوان الإعلان",
                    hintText: "أدخل عنوان الإعلان",
                    controller: subjectController,
                  ),
                  const SizedBoxBetweenFieldWidgets(),
                  LabeledTextField(
                    widthButton: ManagerWidth.w12,
                    label: "العنوان التفصيلي",
                    hintText: "أدخل العنوان التفصيلي",
                    controller: addressController,
                  ),
                  const SizedBoxBetweenFieldWidgets(),
                  LabeledTextField(
                    widthButton: ManagerWidth.w12,
                    label: "الموقع الجغرافي",
                    hintText: "إحداثيات الموقع",
                    controller: latController,
                    buttonWidget: Container(
                      width: ManagerWidth.w100,
                      height: ManagerHeight.h40,
                      decoration: BoxDecoration(
                        color: ManagerColors.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text(
                          "تحديد الموقع",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// السعر والمساحة
                  Row(
                    children: [
                      Expanded(
                        child: LabeledTextField(
                          widthButton: ManagerWidth.w12,
                          label: "السعر",
                          hintText: "أدخل السعر",
                          controller: priceController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: ManagerWidth.w8),
                      Expanded(
                        child: LabeledTextField(
                          widthButton: ManagerWidth.w12,
                          label: "المساحة (م²)",
                          hintText: "أدخل المساحة",
                          controller: areaController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// الوصف
                  LabeledTextField(
                    widthButton: ManagerWidth.w12,
                    label: "الوصف",
                    hintText: "أدخل وصفًا واضحًا للعقار",
                    controller: descriptionController,
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  /// رفع الوسائط
                  UploadMediaField(
                    label: "صور العقار",
                    hint: "قم برفع صور العقار",
                    note: "يمكنك استبدال الصور القديمة أو إضافة جديدة",
                    onFilePicked: (File file) {},
                    file: Rx<File?>(null),
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  UploadMediaField(
                    label: "فيديوهات العقار",
                    hint: "قم برفع فيديوهات العقار",
                    note: "اختياري: يمكن رفع فيديو توضيحي",
                    onFilePicked: (File file) {},
                    file: Rx<File?>(null),
                  ),
                  const SizedBoxBetweenFieldWidgets(),

                  UploadMediaField(
                    label: "صك العقار",
                    hint: "قم برفع وثيقة الملكية",
                    note: "ملف PDF أو صورة",
                    onFilePicked: (File file) {},
                    file: Rx<File?>(null),
                  ),
                  SizedBox(height: ManagerHeight.h36),

                  /// زر التحديث
                  ButtonApp(
                    title: "تحديث العقار",
                    onPressed: () =>
                        _confirmUpdateDialog(widget.realEstate.id.toString()),
                    paddingWidth: 0,
                  ),
                  SizedBox(height: ManagerHeight.h36),
                ],
              ),
            ),
            if (controller.isLoading.value) const LoadingWidget(),
          ],
        );
      }),
    );
  }

  Future<void> _confirmUpdateDialog(String id) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomConfirmDialog(
        title: "تأكيد التعديل",
        subtitle: "هل أنت متأكد أنك تريد حفظ التغييرات؟",
        confirmText: "تأكيد",
        cancelText: "إلغاء",
        onConfirm: () async {
          Get.back();
          await _submitEdit(id);
        },
        onCancel: () => Get.back(),
      ),
    );
  }

  Future<void> _submitEdit(String id) async {
    final m = widget.realEstate;
    final request = EditMyRealEstateRequest(
      id: id,
      propertySubject: subjectController.text,
      propertyType: m.propertyType,
      operationType: m.operationType,
      advertiserRole: m.advertiserRole,
      saleType: m.saleType,
      keywords: m.keywords,
      lat: m.lat,
      lng: m.lng,
      propertyDetailedAddress: addressController.text,
      price: priceController.text,
      areaSqm: areaController.text,
      commissionPercentage: m.commissionPercentage,
      usageType: m.usageType,
      propertyDescription: descriptionController.text,
      featureIds: m.featureIds,
      facilityIds: m.facilityIds,
      visitDays: m.visitDays,
      visitTimeFrom: m.visitTimeFrom,
      visitTimeTo: m.visitTimeTo,
      propertyOwnerId: m.propertyOwnerId,
      propertyImages: [],
      propertyVideos: [],
      deedDocument: null,
    );

    await controller.editRealEstate(request);
  }
}
