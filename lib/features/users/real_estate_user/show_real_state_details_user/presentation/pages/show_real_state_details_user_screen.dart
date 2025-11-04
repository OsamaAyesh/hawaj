import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/add_visit_controller.dart';
import '../../controller/show_real_estate_details_user_controller.dart';
import '../widgets/real_estate_action_buttons_row.dart';
import '../widgets/real_estate_ad_info_widget.dart';
import '../widgets/real_estate_advertiser_info_widget.dart';
import '../widgets/real_estate_features_widget.dart';
import '../widgets/real_estate_info_card_widget.dart';
import '../widgets/real_state_status_location_row.dart';
import '../widgets/visit_request_dialog.dart';
import '../widgets/widget_images_and_icons.dart';

class ShowRealStateDetailsUserScreen extends StatefulWidget {
  final String id;

  const ShowRealStateDetailsUserScreen({super.key, required this.id});

  @override
  State<ShowRealStateDetailsUserScreen> createState() =>
      _ShowRealStateDetailsUserScreenState();
}

class _ShowRealStateDetailsUserScreenState
    extends State<ShowRealStateDetailsUserScreen> {
  late GetRealEstateUserController controller;
  late AddVisitController addVisitController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<GetRealEstateUserController>();
    addVisitController = Get.find<AddVisitController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getRealEstateUser(
        id: widget.id,
        language: 'ar',
        lat: '0',
        lng: '0',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: Stack(
          children: [
            /// =======================
            /// 🏠 المحتوى الأساسي للشاشة
            /// =======================
            Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget();
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: Colors.red,
                    ),
                  ),
                );
              }

              final realEstate = controller.realEstate.value;
              if (realEstate == null) {
                return const Center(child: Text("لا توجد بيانات متاحة"));
              }

              return RefreshIndicator(
                color: ManagerColors.primaryColor,
                onRefresh: () async {
                  await controller.refreshRealEstate(
                    id: widget.id,
                    language: 'ar',
                    lat: '0',
                    lng: '0',
                  );
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///==== Images With Back And Share Button Stack
                      WidgetImagesAndIcons(
                        imageUrls: realEstate.propertyImages.isNotEmpty
                            ? realEstate.propertyImages.split(',')
                            : [],
                      ),

                      SizedBox(height: ManagerHeight.h12),

                      ///==== Location + Status + Actions
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
                        child: Column(
                          children: [
                            RealStateStatusLocationRow(
                              status: realEstate.operationTypeLabel,
                              address: realEstate.propertyDetailedAddress,
                            ),
                            RealEstateActionButtonsRow(
                              title: realEstate.propertySubject,
                              price: realEstate.price,
                              infoText: "معلومات عن العقار",
                              onPriceNotify: () {
                                // 🔔 منطق إشعار السعر لاحقًا
                              },
                              onVisitRequest: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => VisitRequestDialog(
                                    dateController: TextEditingController(),
                                    fromTimeController: TextEditingController(),
                                    toTimeController: TextEditingController(),
                                    onConfirm: () async {
                                      Navigator.pop(context);
                                      await addVisitController.addVisit(
                                        visitDate: "2025-10-23",
                                        timeFrom: "03:30",
                                        timeTo: "04:30",
                                        visitorMemberId: "3",
                                        propertyId: realEstate.id,
                                        visitStatus: "1",
                                      );

                                      if (addVisitController
                                          .errorMessage.isNotEmpty) {
                                        AppSnackbar.error(addVisitController
                                            .errorMessage.value);
                                      } else {
                                        AppSnackbar.success(addVisitController
                                                .successMessage.value.isNotEmpty
                                            ? addVisitController
                                                .successMessage.value
                                            : "تم إرسال الطلب بنجاح.");
                                      }
                                    },
                                    onCancel: () => Navigator.pop(context),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: ManagerHeight.h8),

                      ///==== Property Basic Info
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                        child: RealEstateInfoCardWidget(
                          price: realEstate.price,
                          area: realEstate.areaSqm,
                          type: realEstate.propertyTypeLabel,
                          usage: realEstate.usageTypeLabel,
                        ),
                      ),

                      SizedBox(height: ManagerHeight.h12),

                      ///==== Features
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                        child: Text(
                          "مميزات العقار",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: ManagerHeight.h8),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                        child: RealEstateFeaturesWidget(
                          features: realEstate.featureIds.isNotEmpty
                              ? realEstate.featureIds.split(',')
                              : [],
                        ),
                      ),

                      SizedBox(height: ManagerHeight.h12),

                      ///==== Description
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                        child: Text(
                          "وصف العقار",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                        child: Text(
                          realEstate.propertyDescription.isNotEmpty
                              ? realEstate.propertyDescription
                              : "لا يوجد وصف متاح.",
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.locationColorText,
                          ),
                        ),
                      ),

                      SizedBox(height: ManagerHeight.h12),

                      ///==== Advertiser Info
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                        child: Text(
                          "معلومات المعلن",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.black,
                          ),
                        ),
                      ),
                      const RealEstateAdvertiserInfoWidget(),

                      SizedBox(height: ManagerHeight.h12),

                      ///==== Ad Info
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                        child: Text(
                          "معلومات الإعلان",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                        child: RealEstateAdInfoWidget(
                          advertiserRole: realEstate.advertiserRoleLabel,
                          saleType: realEstate.saleTypeLabel,
                          visitDays: realEstate.visitDays,
                          visitTimeFrom: realEstate.visitTimeFrom,
                          visitTimeTo: realEstate.visitTimeTo,
                        ),
                      ),
                      SizedBox(height: ManagerHeight.h12),
                    ],
                  ),
                ),
              );
            }),

            /// =======================
            /// 🔄 Overlay Loading فوق الشاشة
            /// =======================
            Obx(() {
              if (addVisitController.isLoading.value) {
                return Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: LoadingWidget()),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
