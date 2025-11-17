import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
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
import '../../../register_organization_offer_provider/domain/di/di.dart'
    show initRegisterOrganizationOfferProvider;
import '../../../register_organization_offer_provider/presentation/pages/register_organization_offer_provider_screen.dart';
import '../controller/get_my_organization_offer_controller.dart';

class GetMyOrganizationOfferScreen extends StatelessWidget {
  const GetMyOrganizationOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetMyCompanyController>();

    return ScaffoldWithBackButton(
      title: ManagerStrings.myCompaniesTitle,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          initRegisterOrganizationOfferProvider();
          Get.to(const RegisterOrganizationOfferProviderScreen());
        },
        backgroundColor: ManagerColors.primaryColor,
        icon: const Icon(Icons.add, color: ManagerColors.white),
        label: Text(
          'إضافة شركة',
          style: getMediumTextStyle(
            fontSize: ManagerFontSize.s14,
            color: ManagerColors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        if (controller.companies.isEmpty) {
          return Center(
            child: EmptyStateWidget(
              messageAr: ManagerStrings.noCompanies,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.getMyCompany,
          color: ManagerColors.primaryColor,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w16,
              vertical: ManagerHeight.h12,
            ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerWidth.w16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(ManagerWidth.w16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ManagerColors.primaryColor.withOpacity(0.05),
                  ManagerColors.primaryColor.withOpacity(0.02),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ManagerWidth.w16),
                topRight: Radius.circular(ManagerWidth.w16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        company.organizationName,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s18,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: ManagerWidth.w8),
                    _buildStatusBadge(company.organizationStatusLabel),
                  ],
                ),
                SizedBox(height: ManagerHeight.h12),
                Row(
                  children: [
                    Icon(
                      Icons.business_center_rounded,
                      size: ManagerWidth.w16,
                      color: ManagerColors.primaryColor,
                    ),
                    SizedBox(width: ManagerWidth.w6),
                    Expanded(
                      child: Text(
                        company.organizationServices,
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: Colors.grey[600]!,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Statistics Section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w16,
              vertical: ManagerHeight.h16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إحصائيات العروض',
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s15,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: ManagerHeight.h12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: ManagerStrings.statusPending,
                        value:
                            _countOffers(company, ManagerStrings.statusPending),
                        color: Colors.orange,
                        icon: Icons.schedule_rounded,
                      ),
                    ),
                    SizedBox(width: ManagerWidth.w10),
                    Expanded(
                      child: _buildStatCard(
                        title: ManagerStrings.statusDraft,
                        value:
                            _countOffers(company, ManagerStrings.statusDraft),
                        color: Colors.grey,
                        icon: Icons.edit_document,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ManagerHeight.h10),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: ManagerStrings.statusPublished,
                        value: _countOffers(
                            company, ManagerStrings.statusPublished),
                        color: Colors.green,
                        icon: Icons.check_circle_rounded,
                      ),
                    ),
                    SizedBox(width: ManagerWidth.w10),
                    Expanded(
                      child: _buildStatCard(
                        title: ManagerStrings.statusTotal,
                        value: company.offers.length.toString(),
                        color: ManagerColors.primaryColor,
                        icon: Icons.analytics_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expired Warning
          if (company.offers.any((offer) =>
              offer.offerStatusLabel == ManagerStrings.statusExpired))
            Container(
              margin: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              padding: EdgeInsets.all(ManagerWidth.w12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(ManagerWidth.w10),
                border: Border.all(
                  color: Colors.red[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red[700],
                    size: ManagerWidth.w20,
                  ),
                  SizedBox(width: ManagerWidth.w8),
                  Expanded(
                    child: Text(
                      ManagerStrings.expiredOffersWarning,
                      style: getMediumTextStyle(
                        fontSize: ManagerFontSize.s13,
                        color: Colors.red[700]!,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Action Button
          Padding(
            padding: EdgeInsets.all(ManagerWidth.w16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  initGetMyCompany();
                  Get.to(ManageListOfferProviderScreen(
                    companyId: company.id,
                  ));
                },
                borderRadius: BorderRadius.circular(ManagerWidth.w12),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ManagerColors.primaryColor,
                        ManagerColors.primaryColor.withOpacity(0.85),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(ManagerWidth.w12),
                    boxShadow: [
                      BoxShadow(
                        color: ManagerColors.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: ManagerHeight.h14),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings_rounded,
                          color: Colors.white,
                          size: ManagerWidth.w20,
                        ),
                        SizedBox(width: ManagerWidth.w8),
                        Text(
                          "${ManagerStrings.manageOffers} (${company.offers.length})",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w12,
        vertical: ManagerHeight.h6,
      ),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(ManagerWidth.w20),
        border: Border.all(
          color: Colors.orange[300]!,
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: getBoldTextStyle(
          fontSize: ManagerFontSize.s12,
          color: Colors.orange[800]!,
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(ManagerWidth.w12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: ManagerWidth.w24,
          ),
          SizedBox(height: ManagerHeight.h8),
          Text(
            value,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s20,
              color: color,
            ),
          ),
          SizedBox(height: ManagerHeight.h4),
          Text(
            title,
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_font_size.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_strings.dart';
// import 'package:app_mobile/core/resources/manager_styles.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/util/empty_state_widget.dart';
// import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
// import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../../../core/model/get_organization_item_with_offer_model.dart';
// import '../../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
// import '../../../../../../core/widgets/loading_widget.dart';
// import '../../../../offers_provider/add_offer/domain/di/di.dart';
// import '../../../../offers_provider/manage_list_offer/presentation/pages/manage_list_offer_provider_screen.dart';
// import '../../../register_organization_offer_provider/domain/di/di.dart'
//     show initRegisterOrganizationOfferProvider;
// import '../../../register_organization_offer_provider/presentation/pages/register_organization_offer_provider_screen.dart';
// import '../controller/get_my_organization_offer_controller.dart';
//
// class GetMyOrganizationOfferScreen extends StatelessWidget {
//   const GetMyOrganizationOfferScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<GetMyCompanyController>();
//
//     return ScaffoldWithBackButton(
//       title: ManagerStrings.myCompaniesTitle,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           initRegisterOrganizationOfferProvider();
//           Get.to(const RegisterOrganizationOfferProviderScreen());
//         },
//         backgroundColor: ManagerColors.primaryColor,
//         child: const Icon(Icons.add, color: ManagerColors.white),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const LoadingWidget();
//         }
//
//         if (controller.companies.isEmpty) {
//           return Center(
//             child: EmptyStateWidget(
//               messageAr: ManagerStrings.noCompanies,
//             ),
//           );
//         }
//
//         return RefreshIndicator(
//           onRefresh: controller.getMyCompany,
//           child: ListView.builder(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: EdgeInsets.all(ManagerWidth.w16),
//             itemCount: controller.companies.length,
//             itemBuilder: (context, index) {
//               final company = controller.companies[index];
//               return _buildCompanyCard(company);
//             },
//           ),
//         );
//       }),
//     ).withHawaj(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.myCompaniesDailyOffer,
//     );
//   }
//
//   Widget _buildCompanyCard(GetOrganizationItemWithOfferModel company) {
//     return Container(
//       margin: EdgeInsets.only(bottom: ManagerHeight.h16),
//       padding: EdgeInsets.all(ManagerWidth.w16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(ManagerWidth.w12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 company.organizationName,
//                 style: getBoldTextStyle(
//                   fontSize: ManagerFontSize.s16,
//                   color: Colors.black,
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: ManagerWidth.w10,
//                   vertical: ManagerHeight.h6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.orange[100],
//                   borderRadius: BorderRadius.circular(ManagerWidth.w8),
//                 ),
//                 child: Text(
//                   company.organizationStatusLabel,
//                   style: getMediumTextStyle(
//                     fontSize: ManagerFontSize.s12,
//                     color: Colors.orange[800]!,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: ManagerHeight.h8),
//           Text(
//             company.organizationServices,
//             style: getRegularTextStyle(
//               fontSize: ManagerFontSize.s13,
//               color: Colors.grey[700]!,
//             ),
//           ),
//           SizedBox(height: ManagerHeight.h16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildSmallStat(
//                   ManagerStrings.statusPending,
//                   _countOffers(company, ManagerStrings.statusPending),
//                   Colors.orange),
//               _buildSmallStat(
//                   ManagerStrings.statusDraft,
//                   _countOffers(company, ManagerStrings.statusDraft),
//                   Colors.grey),
//               _buildSmallStat(
//                   ManagerStrings.statusPublished,
//                   _countOffers(company, ManagerStrings.statusPublished),
//                   Colors.green),
//               _buildSmallStat(ManagerStrings.statusTotal,
//                   company.offers.length.toString(), ManagerColors.primaryColor),
//             ],
//           ),
//           SizedBox(height: ManagerHeight.h16),
//           GestureDetector(
//             onTap: () {
//               initGetMyCompany();
//               Get.to(ManageListOfferProviderScreen(
//                 companyId: company.id,
//               ));
//             },
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: ManagerColors.primaryColor,
//                 borderRadius: BorderRadius.circular(ManagerWidth.w8),
//               ),
//               padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
//               alignment: Alignment.center,
//               child: Text(
//                 "${ManagerStrings.manageOffers} (${company.offers.length})",
//                 style: getMediumTextStyle(
//                   fontSize: ManagerFontSize.s14,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           if (company.offers.any((offer) =>
//               offer.offerStatusLabel == ManagerStrings.statusExpired))
//             Padding(
//               padding: EdgeInsets.only(top: ManagerHeight.h12),
//               child: Container(
//                 padding: EdgeInsets.all(ManagerWidth.w12),
//                 decoration: BoxDecoration(
//                   color: Colors.red[50],
//                   borderRadius: BorderRadius.circular(ManagerWidth.w8),
//                 ),
//                 child: Text(
//                   ManagerStrings.expiredOffersWarning,
//                   style: getMediumTextStyle(
//                     fontSize: ManagerFontSize.s13,
//                     color: Colors.red,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSmallStat(String title, String value, Color color) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: getBoldTextStyle(
//             fontSize: ManagerFontSize.s16,
//             color: color,
//           ),
//         ),
//         Text(
//           title,
//           style: getMediumTextStyle(
//             fontSize: ManagerFontSize.s13,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _countOffers(
//       GetOrganizationItemWithOfferModel company, String status) {
//     return company.offers
//         .where((offer) => offer.offerStatusLabel == status)
//         .length
//         .toString();
//   }
// }
