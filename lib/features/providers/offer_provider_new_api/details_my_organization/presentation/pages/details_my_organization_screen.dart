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

import '../controller/details_my_organization_controller.dart';

class DetailsMyOrganizationScreen extends StatefulWidget {
  final String id;

  const DetailsMyOrganizationScreen({super.key, required this.id});

  @override
  State<DetailsMyOrganizationScreen> createState() =>
      _DetailsMyOrganizationScreenState();
}

class _DetailsMyOrganizationScreenState
    extends State<DetailsMyOrganizationScreen> {
  late final DetailsMyOrganizationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<DetailsMyOrganizationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyCompanyDetails(widget.id);
    });
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
            onRefresh: ctrl.onRefresh,
            color: ManagerColors.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ManagerHeight.h24),
                  _buildCompanyHeader(),
                  SizedBox(height: ManagerHeight.h20),
                  _buildStatisticsCards(),
                  SizedBox(height: ManagerHeight.h24),
                  Text(
                    ManagerStrings.settingsList,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s16,
                      color: ManagerColors.black,
                    ),
                  ),
                  SizedBox(height: ManagerHeight.h16),
                  _settingTile(
                    ManagerStrings.editCompanyData,
                    Icons.edit_outlined,
                    onTap: () {
                      // TODO: Navigate to edit screen
                    },
                  ),
                  _settingTile(
                    ManagerStrings.subscriptionInfo,
                    Icons.info_outline,
                    onTap: () {
                      // TODO: Navigate to subscription screen
                    },
                  ),
                  _settingTile(
                    ManagerStrings.contactSupport,
                    Icons.headset_mic_outlined,
                    onTap: () {
                      // TODO: Navigate to support screen
                    },
                  ),
                  SizedBox(height: ManagerHeight.h24),
                ],
              ),
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
                Container(
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

  /// Company header with logo, name, and info
  Widget _buildCompanyHeader() {
    final data = controller.companyDetailsData?.data;
    if (data == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(ManagerWidth.w20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ManagerColors.primaryColor.withOpacity(0.08),
            ManagerColors.primaryColor.withOpacity(0.03),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(ManagerRadius.r16),
        border: Border.all(
          color: ManagerColors.primaryColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: data.organizationLogo ?? "",
                  width: ManagerHeight.h100,
                  height: ManagerHeight.h100,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: ManagerHeight.h100,
                    height: ManagerHeight.h100,
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
                    width: ManagerHeight.h100,
                    height: ManagerHeight.h100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ManagerColors.primaryColor.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      size: 50,
                      color: ManagerColors.primaryColor,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.verified,
                  color: ManagerColors.primaryColor,
                  size: 22,
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h16),
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
          Text(
            data.organizationServices ?? "",
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s14,
              color: Colors.grey[600]!,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ManagerHeight.h12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w16,
              vertical: ManagerHeight.h8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ManagerRadius.r8),
              border: Border.all(
                color: ManagerColors.primaryColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone_rounded,
                  size: 18,
                  color: ManagerColors.primaryColor,
                ),
                SizedBox(width: ManagerWidth.w8),
                Text(
                  data.phoneNumber ?? "",
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Statistics cards section
  Widget _buildStatisticsCards() {
    final data = controller.companyDetailsData?.data;
    if (data == null) return const SizedBox.shrink();

    final offersCount = data.offers.length ?? 0;
    final address = data.organizationDetailedAddress ?? "";
    final city = address.split(',').length > 1
        ? address.split(',').last.trim()
        : address;
    final workingHours = data.workingHours ?? "";

    return Row(
      children: [
        _infoCard(
          '$offersCount',
          ManagerStrings.currentOffers,
          Icons.local_offer_rounded,
        ),
        SizedBox(width: ManagerWidth.w12),
        _infoCard(
          workingHours,
          ManagerStrings.workingHours,
          Icons.access_time_rounded,
        ),
        SizedBox(width: ManagerWidth.w12),
        _infoCard(
          city,
          ManagerStrings.location,
          Icons.location_on_rounded,
        ),
      ],
    );
  }

  /// Info card widget
  Widget _infoCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w12,
          vertical: ManagerHeight.h16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r12),
          border: Border.all(
            color: ManagerColors.primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ManagerColors.primaryColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: ManagerColors.primaryColor,
                size: 24,
              ),
            ),
            SizedBox(height: ManagerHeight.h10),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s16,
                color: ManagerColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h6),
            Text(
              label,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: Colors.grey[600]!,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Setting tile widget
  Widget _settingTile(String title, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: ManagerHeight.h12),
        padding: EdgeInsets.all(ManagerWidth.w16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r12),
          border: Border.all(
            color: ManagerColors.primaryColor.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ManagerRadius.r10),
              ),
              child: Icon(
                icon,
                size: 22,
                color: ManagerColors.primaryColor,
              ),
            ),
            SizedBox(width: ManagerWidth.w14),
            Expanded(
              child: Text(
                title,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s15,
                  color: ManagerColors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_back_ios_rounded,
              size: 18,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
