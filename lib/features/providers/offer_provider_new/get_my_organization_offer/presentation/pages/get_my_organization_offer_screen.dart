import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/util/empty_state_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/get_organization_item_with_offer_model.dart';
import '../../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../offers_provider/add_offer/domain/di/di.dart';
import '../../../../offers_provider/manage_list_offer/presentation/pages/manage_list_offer_provider_screen.dart';
import '../../../../offers_provider/register_company_offer_provider/domain/di/di.dart';
import '../../../../offers_provider/register_company_offer_provider/presentation/pages/register_company_offer_provider_screen.dart';
import '../controller/get_my_organization_offer_controller.dart';

class GetMyOrganizationOfferScreen extends StatelessWidget {
  const GetMyOrganizationOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetMyCompanyController>();

    return ScaffoldWithBackButton(
      title: "إدارة مؤسساتي",
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          initRegisterMyCompanyOfferProvider();
          Get.to(RegisterCompanyOfferProviderScreen());
        },
        backgroundColor: ManagerColors.primaryColor,
        child: const Icon(Icons.add, color: ManagerColors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        if (controller.companies.isEmpty) {
          return const Center(
            child: EmptyStateWidget(
              messageAr: "لا توجد مؤسسات حالياً",
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.getMyCompany,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(ManagerWidth.w16),
            itemCount: controller.companies.length,
            itemBuilder: (context, index) {
              final company = controller.companies[index];
              return _buildCompanyCard(company);
            },
          ),
        );
      }),
    ).withHawaj(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.myCompaniesDailyOffer,
    );
  }

  Widget _buildCompanyCard(GetOrganizationItemWithOfferModel company) {
    return Container(
      margin: EdgeInsets.only(bottom: ManagerHeight.h16),
      padding: EdgeInsets.all(ManagerWidth.w16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerWidth.w12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                company.organizationName,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w10,
                  vertical: ManagerHeight.h6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(ManagerWidth.w8),
                ),
                child: Text(
                  company.organizationStatusLabel,
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: Colors.orange[800]!,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h8),
          Text(
            company.organizationServices,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s13,
              color: Colors.grey[700]!,
            ),
          ),
          SizedBox(height: ManagerHeight.h16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallStat(
                  "معلق", _countOffers(company, "معلق"), Colors.orange),
              _buildSmallStat(
                  "مسودة", _countOffers(company, "مسودة"), Colors.grey),
              _buildSmallStat(
                  "منشور", _countOffers(company, "منشور"), Colors.green),
              _buildSmallStat("إجمالي", company.offers.length.toString(),
                  ManagerColors.primaryColor),
            ],
          ),
          SizedBox(height: ManagerHeight.h16),
          GestureDetector(
            onTap: () {
              initGetMyCompany();
              Get.to(ManageListOfferProviderScreen(
                companyId: company.id,
              ));
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor,
                borderRadius: BorderRadius.circular(ManagerWidth.w8),
              ),
              padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
              alignment: Alignment.center,
              child: Text(
                "إدارة العروض (${company.offers.length})",
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (company.offers.any((offer) => offer.offerStatusLabel == "منتهي"))
            Padding(
              padding: EdgeInsets.only(top: ManagerHeight.h12),
              child: Container(
                padding: EdgeInsets.all(ManagerWidth.w12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(ManagerWidth.w8),
                ),
                child: Text(
                  "هناك عروض منتهية تحتاج إلى تحديث",
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s13,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s16,
            color: color,
          ),
        ),
        Text(
          title,
          style: getMediumTextStyle(
            fontSize: ManagerFontSize.s13,
            color: color,
          ),
        ),
      ],
    );
  }

  String _countOffers(
      GetOrganizationItemWithOfferModel company, String status) {
    return company.offers
        .where((offer) => offer.offerStatusLabel == status)
        .length
        .toString();
  }
}
