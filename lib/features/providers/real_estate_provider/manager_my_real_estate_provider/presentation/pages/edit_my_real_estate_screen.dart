import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/custom_confirm_dialog.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/sub_title_text_screen_widget.dart';
import 'package:app_mobile/core/widgets/title_text_screen_widget.dart';
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

  final subjectController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final areaController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<EditMyRealEstateController>();

    final model = widget.realEstate;
    subjectController.text = model.propertySubject;
    addressController.text = model.propertyDetailedAddress;
    priceController.text = model.price;
    areaController.text = model.areaSqm;
    descriptionController.text = model.propertyDescription;
  }

  @override
  Widget build(BuildContext context) {
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
                        "يمكنك تعديل تفاصيل العقار وتحديث البيانات الحالية",
                  ),
                  SizedBox(height: ManagerHeight.h20),
                  LabeledTextField(
                    widthButton: ManagerWidth.w12,
                    label: "عنوان الإعلان",
                    hintText: "اكتب عنوان العقار",
                    controller: subjectController,
                  ),
                  const SizedBoxBetweenFieldWidgets(),
                  LabeledTextField(
                    widthButton: ManagerWidth.w12,
                    label: "العنوان التفصيلي",
                    hintText: "اكتب العنوان بالتفصيل",
                    controller: addressController,
                  ),
                  const SizedBoxBetweenFieldWidgets(),
                  LabeledTextField(
                    label: "السعر",
                    hintText: "أدخل السعر",
                    widthButton: ManagerWidth.w12,
                    controller: priceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBoxBetweenFieldWidgets(),
                  LabeledTextField(
                    widthButton: ManagerWidth.w12,
                    label: "المساحة (م²)",
                    hintText: "أدخل مساحة العقار",
                    controller: areaController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBoxBetweenFieldWidgets(),
                  LabeledTextField(
                    label: "الوصف",
                    widthButton: ManagerWidth.w12,
                    hintText: "أدخل وصفًا واضحًا للعقار",
                    controller: descriptionController,
                    minLines: 3,
                    maxLines: 5,
                  ),
                  SizedBox(height: ManagerHeight.h24),
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
        id: id);

    await controller.editRealEstate(request);
  }
}
