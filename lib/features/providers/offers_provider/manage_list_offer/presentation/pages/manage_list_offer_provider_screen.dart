import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
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

class ManageListOfferProviderScreen extends StatelessWidget {
  const ManageListOfferProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ الحصول على الـController المسجل مسبقاً عبر الـBindings
    final controller = Get.find<ManageListOfferProviderController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.productList,
      body: Obx(() {
        // ===== حالة التحميل =====
        if (controller.isLoading.value && !controller.hasCompany) {
          return const LoadingWidget();
        }

        // ===== حالة الخطأ =====
        if (controller.errorMessage.isNotEmpty && !controller.hasCompany) {
          // يمكنك لاحقاً إضافة Widget مخصص لعرض رسالة الخطأ
          // return ErrorOffersWidget(
          //   message: controller.errorMessage.value,
          //   onRetry: () => controller.fetchOffers(),
          // );
        }

        // ===== حالة عدم وجود بيانات =====
        if (!controller.hasOffers) {
          return const EmptyStateWidget();
        }

        // ===== حالة النجاح =====
        return Column(
          children: [
            // شريط توضيح حالة العروض
            const StatusLegendWidget(),
            SizedBox(height: ManagerHeight.h8),

            // قائمة العروض
            Expanded(
              child: RefreshIndicator(
                color: ManagerColors.primaryColor,
                backgroundColor: Colors.white,
                onRefresh: () => controller.fetchOffers(isRefresh: true),
                child: Stack(
                  children: [
                    // GridView لعرض العروض
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
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

                    // شريط علوي يظهر عند التحديث بالسحب
                    if (controller.isRefreshing.value)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(ManagerWidth.w8),
                          decoration: BoxDecoration(
                            color: ManagerColors.primaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(ManagerRadius.r12),
                              bottomRight: Radius.circular(ManagerRadius.r12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: ManagerWidth.w8),
                              Text(
                                'جاري التحديث...',
                                style: getMediumTextStyle(
                                  fontSize: ManagerFontSize.s12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ManagerColors.primaryColor,
        onPressed: () {
          initCreateOfferProvider();
          Get.to(AddOfferProviderScreen());
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'إضافة عرض',
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
