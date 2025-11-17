// get_my_organization_offer_screen.dart
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
import '../../../details_my_organization/domain/di/di.dart';
import '../../../details_my_organization/presentation/pages/details_my_organization_screen.dart';
import '../../../register_organization_offer_provider/domain/di/di.dart'
    show initRegisterOrganizationOfferProvider;
import '../../../register_organization_offer_provider/presentation/pages/register_organization_offer_provider_screen.dart';
import '../controller/get_my_organization_offer_controller.dart';

class GetMyOrganizationOfferScreen extends StatefulWidget {
  const GetMyOrganizationOfferScreen({super.key});

  @override
  State<GetMyOrganizationOfferScreen> createState() =>
      _GetMyOrganizationOfferScreenState();
}

class _GetMyOrganizationOfferScreenState
    extends State<GetMyOrganizationOfferScreen>
    with SingleTickerProviderStateMixin {
  late final GetMyCompanyController controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Get controller
    controller = Get.find<GetMyCompanyController>();

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  /// Fetch companies data
  Future<void> _fetchData() async {
    await controller.getMyCompany();
    if (mounted) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.myCompaniesTitle,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddCompany,
        backgroundColor: ManagerColors.primaryColor,
        elevation: 4,
        icon: const Icon(
          Icons.add_business_rounded,
          color: ManagerColors.white,
        ),
        label: Text(
          ManagerStrings.addNewCompany,
          style: getBoldTextStyle(
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
          return _buildEmptyState();
        }

        return _buildCompaniesList();
      }),
    ).withHawaj(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.myCompaniesDailyOffer,
    );
  }

  // ==================== Empty State ====================
  Widget _buildEmptyState() {
    return Center(
      child: EmptyStateWidget(
        messageAr: ManagerStrings.noCompanies,
      ),
    );
  }

  // ==================== Companies List ====================
  Widget _buildCompaniesList() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: RefreshIndicator(
        onRefresh: _fetchData,
        color: ManagerColors.primaryColor,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: ManagerWidth.w16,
            vertical: ManagerHeight.h16,
          ),
          itemCount: controller.companies.length,
          itemBuilder: (context, index) {
            final company = controller.companies[index];
            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 300 + (index * 100)),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.easeOutCubic,
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: _buildCompanyCard(company, index),
            );
          },
        ),
      ),
    );
  }

  // ==================== Company Card ====================
  Widget _buildCompanyCard(
    GetOrganizationItemWithOfferModel company,
    int index,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: ManagerHeight.h20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerWidth.w20),
        boxShadow: [
          BoxShadow(
            color: ManagerColors.primaryColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(company),
          _buildStatisticsSection(company),
          if (_hasExpiredOffers(company)) _buildWarningSection(),
          _buildActionButton(company),
        ],
      ),
    );
  }

  // ==================== Header Section ====================
  Widget _buildHeaderSection(GetOrganizationItemWithOfferModel company) {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ManagerColors.primaryColor.withOpacity(0.08),
            ManagerColors.primaryColor.withOpacity(0.03),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ManagerWidth.w20),
          topRight: Radius.circular(ManagerWidth.w20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ManagerWidth.w12),
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(ManagerWidth.w12),
                ),
                child: Icon(
                  Icons.store_rounded,
                  color: ManagerColors.primaryColor,
                  size: ManagerWidth.w28,
                ),
              ),
              SizedBox(width: ManagerWidth.w12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.organizationName,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s18,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: ManagerHeight.h4),
                    _buildOrganizationStatus(company.organizationStatusLabel),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h16),
          Container(
            padding: EdgeInsets.all(ManagerWidth.w12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ManagerWidth.w10),
              border: Border.all(
                color: ManagerColors.primaryColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.business_center_rounded,
                  size: ManagerWidth.w18,
                  color: ManagerColors.primaryColor.withOpacity(0.7),
                ),
                SizedBox(width: ManagerWidth.w8),
                Expanded(
                  child: Text(
                    company.organizationServices,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: Colors.grey[700]!,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Statistics Section ====================
  Widget _buildStatisticsSection(GetOrganizationItemWithOfferModel company) {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: ManagerColors.primaryColor,
                size: ManagerWidth.w20,
              ),
              SizedBox(width: ManagerWidth.w8),
              Text(
                ManagerStrings.offersStatistics,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: ManagerStrings.statusPublished,
                  value: _countOffersByStatus(company, '1'),
                  color: const Color(0xFF10B981),
                  icon: Icons.check_circle_rounded,
                ),
              ),
              SizedBox(width: ManagerWidth.w12),
              Expanded(
                child: _buildStatCard(
                  title: ManagerStrings.statusPending,
                  value: _countOffersByStatus(company, '5'),
                  color: const Color(0xFFF59E0B),
                  icon: Icons.pending_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: ManagerStrings.statusDraft,
                  value: _countOffersByStatus(company, '2'),
                  color: const Color(0xFF6B7280),
                  icon: Icons.edit_note_rounded,
                ),
              ),
              SizedBox(width: ManagerWidth.w12),
              Expanded(
                child: _buildStatCard(
                  title: ManagerStrings.statusExpired,
                  value: _countOffersByStatus(company, '3'),
                  color: const Color(0xFFEF4444),
                  icon: Icons.event_busy_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: ManagerStrings.statusCancelled,
                  value: _countOffersByStatus(company, '4'),
                  color: const Color(0xFF8B5CF6),
                  icon: Icons.cancel_rounded,
                ),
              ),
              SizedBox(width: ManagerWidth.w12),
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
    );
  }

  // ==================== Warning Section ====================
  Widget _buildWarningSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ManagerWidth.w20),
      padding: EdgeInsets.all(ManagerWidth.w14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFEF2F2),
            Color(0xFFFEE2E2),
          ],
        ),
        borderRadius: BorderRadius.circular(ManagerWidth.w12),
        border: Border.all(
          color: const Color(0xFFFECACA),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ManagerWidth.w8),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              color: const Color(0xFFDC2626),
              size: ManagerWidth.w22,
            ),
          ),
          SizedBox(width: ManagerWidth.w12),
          Expanded(
            child: Text(
              ManagerStrings.expiredOffersWarning,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s14,
                color: const Color(0xFFDC2626),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Action Button ====================
  Widget _buildActionButton(GetOrganizationItemWithOfferModel company) {
    return Padding(
      padding: EdgeInsets.all(ManagerWidth.w20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetails(company.id),
          borderRadius: BorderRadius.circular(ManagerWidth.w14),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ManagerColors.primaryColor,
                  ManagerColors.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: BorderRadius.circular(ManagerWidth.w14),
              boxShadow: [
                BoxShadow(
                  color: ManagerColors.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: ManagerHeight.h16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: ManagerWidth.w22,
                  ),
                  SizedBox(width: ManagerWidth.w10),
                  Text(
                    "${ManagerStrings.manageOffers} (${company.offers.length})",
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w8),
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: ManagerWidth.w16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== Organization Status ====================
  Widget _buildOrganizationStatus(String status) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w10,
        vertical: ManagerHeight.h4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withOpacity(0.15),
        borderRadius: BorderRadius.circular(ManagerWidth.w6),
        border: Border.all(
          color: const Color(0xFFF59E0B).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ManagerWidth.w6,
            height: ManagerWidth.w6,
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: ManagerWidth.w6),
          Text(
            status,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s11,
              color: const Color(0xFFD97706),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Stat Card ====================
  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w12,
        vertical: ManagerHeight.h14,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(ManagerWidth.w14),
        border: Border.all(
          color: color.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(ManagerWidth.w10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: ManagerWidth.w24,
            ),
          ),
          SizedBox(height: ManagerHeight.h10),
          Text(
            value,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s22,
              color: color,
            ),
          ),
          SizedBox(height: ManagerHeight.h6),
          Text(
            title,
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s12,
              color: color.withOpacity(0.85),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==================== Helper Methods ====================

  /// Check if company has expired offers
  bool _hasExpiredOffers(GetOrganizationItemWithOfferModel company) {
    return company.offers.any((offer) => offer.offerStatus == '3');
  }

  /// Count offers by status ID
  String _countOffersByStatus(
    GetOrganizationItemWithOfferModel company,
    String statusId,
  ) {
    return company.offers
        .where((offer) => offer.offerStatus == statusId)
        .length
        .toString();
  }

  // ==================== Navigation Methods ====================

  /// Navigate to add company screen
  void _onAddCompany() {
    initRegisterOrganizationOfferProvider();
    Get.to(
      const RegisterOrganizationOfferProviderScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    )?.then((_) {
      // Refresh data when returning from add company screen
      _fetchData();
    });
  }

  /// Navigate to company details screen
  void _navigateToDetails(String companyId) {
    initGetMyOrganizationDetails();
    Get.to(
      DetailsMyOrganizationScreen(id: companyId),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    )?.then((_) {
      // Refresh data when returning from details screen
      _fetchData();
    });
  }
}
