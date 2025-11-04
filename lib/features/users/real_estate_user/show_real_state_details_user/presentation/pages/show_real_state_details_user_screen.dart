import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/show_real_estate_details_user_controller.dart';
import '../widgets/real_estate_action_buttons_row.dart';
import '../widgets/real_estate_ad_info_widget.dart';
import '../widgets/real_estate_advertiser_info_widget.dart';
import '../widgets/real_estate_features_widget.dart';
import '../widgets/real_estate_info_card_widget.dart';
import '../widgets/real_state_status_location_row.dart';
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

  @override
  void initState() {
    super.initState();
    controller = Get.find<GetRealEstateUserController>();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
                child: Column(
                  children: [
                    RealStateStatusLocationRow(
                      status: realEstate.operationTypeLabel,
                      address: realEstate.propertyDetailedAddress,
                    ),
                    const RealEstateActionButtonsRow(),
                  ],
                ),
              ),

              SizedBox(height: ManagerHeight.h8),

              ///==== Property Basic Info
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
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
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
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
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                child: RealEstateFeaturesWidget(
                  features: realEstate.featureIds.isNotEmpty
                      ? realEstate.featureIds.split(',')
                      : [],
                ),
              ),

              SizedBox(height: ManagerHeight.h12),

              ///==== Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                child: Text(
                  "وصف العقار",
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
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
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
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
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                child: Text(
                  "معلومات الإعلان",
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
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
        );
      }),
    );
  }
}
