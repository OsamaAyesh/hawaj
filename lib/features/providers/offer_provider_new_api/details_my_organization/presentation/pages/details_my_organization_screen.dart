import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../update_offer/domain/di/di.dart' show initUpdateOffer;
import '../../../update_offer/presentation/pages/update_offer_screen.dart';
import '../controller/details_my_organization_controller.dart';

class DetailsMyOrganizationScreen extends StatefulWidget {
  final String id;

  const DetailsMyOrganizationScreen({super.key, required this.id});

  @override
  State<DetailsMyOrganizationScreen> createState() =>
      _DetailsMyOrganizationScreenState();
}

class _DetailsMyOrganizationScreenState
    extends State<DetailsMyOrganizationScreen> with TickerProviderStateMixin {
  late final DetailsMyOrganizationController controller;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<DetailsMyOrganizationController>();

    // Header animation
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyCompanyDetails(widget.id);
      _headerAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.companyDetailsTitle,
      body: GetBuilder<DetailsMyOrganizationController>(
        builder: (ctrl) {
          if (ctrl.isLoading) {
            return const LoadingWidget();
          }

          if (ctrl.hasError || ctrl.companyDetailsData?.data == null) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ctrl.onRefresh();
              _headerAnimationController.reset();
              _headerAnimationController.forward();
            },
            color: ManagerColors.primaryColor,
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _headerAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.2),
                        end: Offset.zero,
                      ).animate(_headerAnimation),
                      child: _buildModernHeader(),
                    ),
                  ),
                ),

                // Company Info Section
                SliverToBoxAdapter(
                  child: _buildCompanyInfoSection(),
                ),

                // Tab bar
                SliverToBoxAdapter(
                  child: _buildCustomTabBar(),
                ),

                // Tab content based on selected index
                SliverFillRemaining(
                  child: _buildTabContent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Empty state when no data or error
  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      color: ManagerColors.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 200,
          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(begin: 0, end: 1),
                  curve: Curves.elasticOut,
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: ManagerColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.business_outlined,
                      size: 80,
                      color: ManagerColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: ManagerHeight.h24),
                Text(
                  controller.errorMessage ??
                      ManagerStrings.noRegisteredCompanyTitle,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ManagerHeight.h12),
                Text(
                  ManagerStrings.noRegisteredCompanySubtitle,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ManagerHeight.h32),
                ElevatedButton.icon(
                  onPressed: controller.onRefresh,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: Text(
                    ManagerStrings.retryButton,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManagerColors.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: ManagerWidth.w32,
                      vertical: ManagerHeight.h14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ManagerRadius.r8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Modern header with cover and profile
  Widget _buildModernHeader() {
    final data = controller.companyDetailsData?.data;
    if (data == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.all(ManagerWidth.w16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cover section with gradient
          Container(
            height: ManagerHeight.h120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ManagerColors.primaryColor,
                  ManagerColors.primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ManagerRadius.r20),
                topRight: Radius.circular(ManagerRadius.r20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: ManagerHeight.h16,
                  right: ManagerWidth.w16,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ManagerWidth.w12,
                      vertical: ManagerHeight.h6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(ManagerRadius.r20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: ManagerColors.primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: ManagerWidth.w6),
                        Text(
                          ManagerStrings.verifiedCompany,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Profile section
          Transform.translate(
            offset: Offset(0, -ManagerHeight.h40),
            child: Column(
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: data.organizationLogo ?? "",
                      width: ManagerHeight.h80,
                      height: ManagerHeight.h80,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: ManagerHeight.h80,
                        height: ManagerHeight.h80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ManagerColors.primaryColor.withOpacity(0.1),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: ManagerColors.primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: ManagerHeight.h80,
                        height: ManagerHeight.h80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ManagerColors.primaryColor.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.business_rounded,
                          size: 40,
                          color: ManagerColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ManagerHeight.h12),

                // Company name and info
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w20),
                  child: Column(
                    children: [
                      Text(
                        data.organizationName ?? "",
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s20,
                          color: ManagerColors.black,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ManagerHeight.h8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.business_center_rounded,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: ManagerWidth.w6),
                          Flexible(
                            child: Text(
                              data.organizationServices ?? "",
                              style: getRegularTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: Colors.grey[600]!,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ManagerHeight.h12),

                      // Contact info
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ManagerWidth.w16,
                          vertical: ManagerHeight.h10,
                        ),
                        decoration: BoxDecoration(
                          color: ManagerColors.primaryColor.withOpacity(0.08),
                          borderRadius:
                              BorderRadius.circular(ManagerRadius.r10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: 18,
                              color: ManagerColors.primaryColor,
                            ),
                            SizedBox(width: ManagerWidth.w8),
                            Text(
                              data.phoneNumber ?? "",
                              style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: ManagerColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ManagerHeight.h20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Company info section with proper display
  Widget _buildCompanyInfoSection() {
    final data = controller.companyDetailsData?.data;
    if (data == null) return const SizedBox.shrink();

    final offersCount = data.offers?.length ?? 0;
    final address =
        data.organizationDetailedAddress ?? ManagerStrings.notAvailable;
    final workingHours = data.workingHours ?? ManagerStrings.notAvailable;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
      child: Column(
        children: [
          // Offers count card
          _buildInfoCard(
            icon: Icons.local_offer_rounded,
            title: ManagerStrings.totalOffers,
            value: '$offersCount ${ManagerStrings.offers}', // 'عرض'
            color: const Color(0xFF10B981),
          ),
          SizedBox(height: ManagerHeight.h12),

          // Working hours card
          _buildInfoCard(
            icon: Icons.access_time_rounded,
            title: ManagerStrings.workingHours,
            value: workingHours,
            color: const Color(0xFFF59E0B),
          ),
          SizedBox(height: ManagerHeight.h12),

          // Location card
          _buildInfoCard(
            icon: Icons.location_on_rounded,
            title: ManagerStrings.location,
            value: address,
            color: ManagerColors.primaryColor,
          ),
          SizedBox(height: ManagerHeight.h16),
        ],
      ),
    );
  }

  /// Info card widget with full text display
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: ManagerWidth.w16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s13,
                    color: Colors.grey[600]!,
                  ),
                ),
                SizedBox(height: ManagerHeight.h6),
                Text(
                  value,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s15,
                    color: color,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Custom tab bar
  int _selectedTabIndex = 0;

  Widget _buildCustomTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
      padding: EdgeInsets.all(ManagerWidth.w4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(ManagerRadius.r12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              label: ManagerStrings.offers,
              icon: Icons.local_offer_rounded,
              isSelected: _selectedTabIndex == 0,
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
            ),
          ),
          Expanded(
            child: _buildTabButton(
              label: ManagerStrings.settings,
              icon: Icons.settings_rounded,
              isSelected: _selectedTabIndex == 1,
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(ManagerRadius.r10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? ManagerColors.primaryColor : Colors.grey[600],
            ),
            SizedBox(width: ManagerWidth.w8),
            Text(
              label,
              style: isSelected
                  ? getBoldTextStyle(
                      fontSize: ManagerFontSize.s15,
                      color: ManagerColors.primaryColor,
                    )
                  : getMediumTextStyle(
                      fontSize: ManagerFontSize.s15,
                      color: Colors.grey[600]!,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build tab content based on selection
  Widget _buildTabContent() {
    return Padding(
      padding: EdgeInsets.only(top: ManagerHeight.h16),
      child: _selectedTabIndex == 0 ? _buildOffersTab() : _buildSettingsTab(),
    );
  }

  /// Offers tab content
  Widget _buildOffersTab() {
    final data = controller.companyDetailsData?.data;
    final offers = data?.offers ?? [];

    if (offers.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 600),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.elasticOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 80,
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(height: ManagerHeight.h16),
              Text(
                ManagerStrings.noOffersAvailable,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: Colors.grey[600]!,
                ),
              ),
              SizedBox(height: ManagerHeight.h8),
              Text(
                ManagerStrings.addFirstOffer,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: Colors.grey[500]!,
                ),
              ),
              SizedBox(height: ManagerHeight.h24),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to add offer
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  ManagerStrings.addOffer,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ManagerColors.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: ManagerWidth.w24,
                    vertical: ManagerHeight.h14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ManagerRadius.r10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(ManagerWidth.w16),
      itemCount: offers.length,
      itemBuilder: (context, index) {
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
          child: _buildOfferCard(offers[index], index),
        );
      },
    );
  }

  /// Offer card with actions
  Widget _buildOfferCard(dynamic offer, int index) {
    final status = _getOfferStatus(offer.offerStatus ?? '');

    return Container(
      margin: EdgeInsets.only(bottom: ManagerHeight.h16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Offer header
          Container(
            padding: EdgeInsets.all(ManagerWidth.w16),
            decoration: BoxDecoration(
              color: status['color'].withOpacity(0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ManagerRadius.r16),
                topRight: Radius.circular(ManagerRadius.r16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: status['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(ManagerRadius.r8),
                  ),
                  child: Icon(
                    status['icon'],
                    color: status['color'],
                    size: 20,
                  ),
                ),
                SizedBox(width: ManagerWidth.w12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.offerName ?? '',
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ManagerHeight.h4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ManagerWidth.w8,
                          vertical: ManagerHeight.h4,
                        ),
                        decoration: BoxDecoration(
                          color: status['color'].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(ManagerRadius.r6),
                        ),
                        child: Text(
                          status['label'],
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s11,
                            color: status['color'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.grey[600],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ManagerRadius.r10),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined,
                              size: 20, color: ManagerColors.primaryColor),
                          SizedBox(width: ManagerWidth.w12),
                          Text(
                            ManagerStrings.editOffer,
                            style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: ManagerColors.black),
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: Navigate to edit offer
                        initUpdateOffer(offer); // Pass the offer model
                        Get.to(const UpdateOfferScreen());
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined,
                              size: 20, color: Colors.blue),
                          SizedBox(width: ManagerWidth.w12),
                          Text(
                            ManagerStrings.viewOffer,
                            style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: ManagerColors.black),
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: View offer details
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline,
                              size: 20, color: Colors.red),
                          SizedBox(width: ManagerWidth.w12),
                          Text(
                            ManagerStrings.deleteOffer,
                            style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showDeleteConfirmation(offer);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Offer details
          Padding(
            padding: EdgeInsets.all(ManagerWidth.w16),
            child: Column(
              children: [
                _buildOfferDetailRow(
                  Icons.description_outlined,
                  ManagerStrings.description,
                  offer.offerDescription ?? ManagerStrings.notAvailable,
                ),
                SizedBox(height: ManagerHeight.h12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOfferInfoChip(
                        Icons.calendar_today_outlined,
                        offer.offerStartDate ?? ManagerStrings.notAvailable,
                      ),
                    ),
                    SizedBox(width: ManagerWidth.w8),
                    Expanded(
                      child: _buildOfferInfoChip(
                        Icons.event_outlined,
                        offer.offerEndDate ?? ManagerStrings.notAvailable,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Offer detail row
  Widget _buildOfferDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: ManagerColors.primaryColor),
        SizedBox(width: ManagerWidth.w8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: Colors.grey[600]!,
                ),
              ),
              SizedBox(height: ManagerHeight.h4),
              Text(
                value,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: ManagerColors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Offer info chip
  Widget _buildOfferInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w12,
        vertical: ManagerHeight.h10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(ManagerRadius.r8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          SizedBox(width: ManagerWidth.w6),
          Flexible(
            child: Text(
              text,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: Colors.grey[700]!,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Get offer status details
  Map<String, dynamic> _getOfferStatus(String statusId) {
    switch (statusId) {
      case '1':
        return {
          'label': ManagerStrings.statusPublished,
          'color': const Color(0xFF10B981),
          'icon': Icons.check_circle_rounded,
        };
      case '2':
        return {
          'label': ManagerStrings.statusDraft,
          'color': const Color(0xFF6B7280),
          'icon': Icons.edit_note_rounded,
        };
      case '3':
        return {
          'label': ManagerStrings.statusExpired,
          'color': const Color(0xFFEF4444),
          'icon': Icons.event_busy_rounded,
        };
      case '4':
        return {
          'label': ManagerStrings.statusCancelled,
          'color': const Color(0xFF8B5CF6),
          'icon': Icons.cancel_rounded,
        };
      case '5':
        return {
          'label': ManagerStrings.statusPending,
          'color': const Color(0xFFF59E0B),
          'icon': Icons.pending_rounded,
        };
      default:
        return {
          'label': ManagerStrings.statusUnknown,
          'color': Colors.grey,
          'icon': Icons.help_outline_rounded,
        };
    }
  }

  /// Delete confirmation dialog
  void _showDeleteConfirmation(dynamic offer) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ManagerRadius.r16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.red[600],
              size: 28,
            ),
            SizedBox(width: ManagerWidth.w12),
            Flexible(
              child: Text(
                ManagerStrings.deleteOfferTitle,
                style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18, color: ManagerColors.black),
              ),
            ),
          ],
        ),
        content: Text(
          ManagerStrings.deleteOfferConfirmation,
          style: getRegularTextStyle(
              fontSize: ManagerFontSize.s15, color: ManagerColors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              ManagerStrings.cancel,
              style: getMediumTextStyle(
                fontSize: ManagerFontSize.s14,
                color: Colors.grey[600]!,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _deleteOffer(offer.id ?? '');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ManagerRadius.r8),
              ),
            ),
            child: Text(
              ManagerStrings.delete,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Delete offer method
  void _deleteOffer(String offerId) {
    // TODO: Implement delete offer logic
    Get.snackbar(
      ManagerStrings.success,
      ManagerStrings.offerDeletedSuccessfully,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: EdgeInsets.all(ManagerWidth.w16),
      borderRadius: ManagerRadius.r10,
    );
  }

  /// Settings tab content
  Widget _buildSettingsTab() {
    return ListView(
      padding: EdgeInsets.all(ManagerWidth.w16),
      children: [
        _buildSettingSection(
          title: ManagerStrings.companyManagement,
          items: [
            _buildSettingTile(
              icon: Icons.edit_outlined,
              title: ManagerStrings.editCompanyData,
              subtitle: ManagerStrings.updateCompanyInfo,
              onTap: () {
                // TODO: Navigate to edit company
              },
            ),
            // _buildSettingTile(
            //   icon: Icons.image_outlined,
            //   title: ManagerStrings.changeLogo,
            //   subtitle: ManagerStrings.updateCompanyLogo,
            //   onTap: () {
            //     // TODO: Change logo
            //   },
            // ),
          ],
        ),
        // SizedBox(height: ManagerHeight.h20),
        // _buildSettingSection(
        //   title: ManagerStrings.subscriptionAndPayment,
        //   items: [
        //     _buildSettingTile(
        //       icon: Icons.card_membership_outlined,
        //       title: ManagerStrings.subscriptionInfo,
        //       subtitle: ManagerStrings.viewSubscriptionDetails,
        //       onTap: () {
        //         // TODO: View subscription
        //       },
        //     ),
        //     _buildSettingTile(
        //       icon: Icons.history_outlined,
        //       title: ManagerStrings.paymentHistory,
        //       subtitle: ManagerStrings.viewPaymentHistory,
        //       onTap: () {
        //         // TODO: View payment history
        //       },
        //     ),
        //   ],
        // ),
        SizedBox(height: ManagerHeight.h20),
        _buildSettingSection(
          title: ManagerStrings.supportAndHelp,
          items: [
            _buildSettingTile(
              icon: Icons.headset_mic_outlined,
              title: ManagerStrings.contactSupport,
              subtitle: ManagerStrings.getTechnicalSupport,
              onTap: () {
                // TODO: Contact support
              },
            ),
            _buildSettingTile(
              icon: Icons.help_outline,
              title: ManagerStrings.helpCenter,
              subtitle: ManagerStrings.viewGuides,
              onTap: () {
                // TODO: Help center
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Setting section
  Widget _buildSettingSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              right: ManagerWidth.w8, bottom: ManagerHeight.h12),
          child: Text(
            title,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s16,
              color: ManagerColors.black,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ManagerRadius.r16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  /// Setting tile
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ManagerRadius.r16),
        child: Padding(
          padding: EdgeInsets.all(ManagerWidth.w16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ManagerRadius.r12),
                ),
                child: Icon(
                  icon,
                  color: ManagerColors.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: ManagerWidth.w16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s15,
                        color: ManagerColors.black,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h4),
                    Text(
                      subtitle,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s13,
                        color: Colors.grey[600]!,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
