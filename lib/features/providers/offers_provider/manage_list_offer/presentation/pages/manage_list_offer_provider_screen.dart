import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/util/empty_state_widget.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/widgets/status_legend.dart';
import '../../../add_offer/domain/di/di.dart';
import '../../../add_offer/presentation/pages/add_offer_provider_screen.dart';
import '../controller/manage_list_offer_provider_controller.dart';
import '../widgets/offer_card_widget.dart';

class ManageListOfferProviderScreen extends StatefulWidget {
  final String companyId;

  const ManageListOfferProviderScreen({super.key, required this.companyId});

  @override
  State<ManageListOfferProviderScreen> createState() =>
      _ManageListOfferProviderScreenState();
}

class _ManageListOfferProviderScreenState
    extends State<ManageListOfferProviderScreen> {
  late ManageListOfferProviderController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ManageListOfferProviderController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOffersByCompanyId(widget.companyId);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.productList,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        if (controller.errorMessage.isNotEmpty && !controller.hasOffers) {
          return _buildErrorState();
        }

        if (!controller.hasOffers) {
          return const EmptyStateWidget(
            messageAr: "لا توجد عروض حالياً",
          );
        }

        return _buildOffersList();
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ManagerColors.primaryColor,
        onPressed: () {
          initCreateOfferProvider();
          Get.to(() => const AddOfferProviderScreen());
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          "إضافة عرض",
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          SizedBox(height: ManagerHeight.h12),
          Text(
            controller.errorMessage.value,
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s12,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ManagerHeight.h16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                controller.fetchOffersByCompanyId(widget.companyId),
            label: const Text("إعادة المحاولة"),
            style: ElevatedButton.styleFrom(
              backgroundColor: ManagerColors.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersList() {
    return RefreshIndicator(
      color: ManagerColors.primaryColor,
      onRefresh: () =>
          controller.fetchOffersByCompanyId(widget.companyId, isRefresh: true),
      child: Column(
        children: [
          const StatusLegendWidget(),
          SizedBox(height: ManagerHeight.h8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
              child: GridView.builder(
                padding: EdgeInsets.only(
                  top: ManagerHeight.h8,
                  bottom: ManagerHeight.h80,
                ),
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemCount: controller.offers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: ManagerHeight.h210,
                  crossAxisSpacing: ManagerWidth.w12,
                  mainAxisSpacing: ManagerHeight.h12,
                ),
                itemBuilder: (context, index) {
                  final offer = controller.offers[index];
                  return OfferCardWidget(offer: offer);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
