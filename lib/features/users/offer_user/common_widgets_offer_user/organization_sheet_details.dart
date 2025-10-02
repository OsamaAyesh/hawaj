import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../constants/constants/constants.dart';
import '../../../../../../core/model/orgnization_company_daily_offer_item_model.dart';
import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_radius.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';

/// Bottom Sheet لعرض تفاصيل المنظمة
class OrganizationDetailsSheet extends StatelessWidget {
  final OrganizationCompanyDailyOfferItemModel organization;
  final VoidCallback onViewDetails;
  final VoidCallback? onClose;

  const OrganizationDetailsSheet({
    super.key,
    required this.organization,
    required this.onViewDetails,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ManagerRadius.r20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          _buildHandle(),

          // محتوى الـ Sheet
          Padding(
            padding: EdgeInsets.all(ManagerWidth.w16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: ManagerHeight.h16),
                _buildInfo(),
                SizedBox(height: ManagerHeight.h16),
                _buildActionButton(),
                SizedBox(height: ManagerHeight.h8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Handle للسحب
  Widget _buildHandle() {
    return Container(
      margin: EdgeInsets.only(top: ManagerHeight.h12),
      width: ManagerWidth.w40,
      height: ManagerHeight.h5,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(ManagerRadius.r10),
      ),
    );
  }

  /// رأس الـ Sheet (الصورة والاسم)
  Widget _buildHeader() {
    return Row(
      children: [
        // صورة المنظمة
        Container(
          width: ManagerWidth.w60,
          height: ManagerHeight.h60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ManagerRadius.r12),
            border: Border.all(color: Colors.grey.shade200, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ManagerRadius.r10),
            child: _buildOrganizationImage(),
          ),
        ),

        SizedBox(width: ManagerWidth.w12),

        // اسم المنظمة
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                organization.organization,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: ManagerColors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ManagerHeight.h4),
              Row(
                children: [
                  Icon(
                    Icons.verified,
                    size: 16,
                    color: ManagerColors.primaryColor,
                  ),
                  SizedBox(width: ManagerWidth.w4),
                  Text(
                    'موثق',
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s13,
                      color: ManagerColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// صورة المنظمة
  Widget _buildOrganizationImage() {
    if (organization.organizationLogo == null ||
        organization.organizationLogo!.isEmpty) {
      return Container(
        color: Colors.grey.shade100,
        child: Icon(
          Icons.business,
          color: Colors.grey.shade400,
          size: 30,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl:
          '${Constants.baseUrlAttachments}/${organization.organizationLogo}',
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey.shade100,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade100,
        child: Icon(
          Icons.business,
          color: Colors.grey.shade400,
          size: 30,
        ),
      ),
    );
  }

  /// معلومات إضافية
  Widget _buildInfo() {
    return Column(
      children: [
        // عدد العروض
        if (organization.offers != null && organization.offers!.isNotEmpty)
          _buildInfoRow(
            Icons.local_offer_outlined,
            'عدد العروض المتاحة',
            '${organization.offers!.length} عرض',
            Colors.green,
          ),

        if (organization.offers != null && organization.offers!.isNotEmpty)
          SizedBox(height: ManagerHeight.h8),

        // موقع المنظمة
        _buildInfoRow(
          Icons.location_on_outlined,
          'الموقع',
          'عرض الموقع على الخريطة',
          ManagerColors.primaryColor,
        ),
      ],
    );
  }

  /// صف معلومات
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ManagerWidth.w8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(ManagerRadius.r8),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        SizedBox(width: ManagerWidth.w12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: ManagerColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// زر عرض التفاصيل
  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onViewDetails,
        style: ElevatedButton.styleFrom(
          backgroundColor: ManagerColors.primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: ManagerHeight.h14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ManagerRadius.r12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store, size: 20),
            SizedBox(width: ManagerWidth.w8),
            Text(
              'عرض جميع العروض',
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// عرض الـ Bottom Sheet
  static Future<void> show(
    BuildContext context,
    OrganizationCompanyDailyOfferItemModel organization,
    VoidCallback onViewDetails,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrganizationDetailsSheet(
        organization: organization,
        onViewDetails: () {
          Navigator.pop(context);
          onViewDetails();
        },
      ),
    );
  }
}
