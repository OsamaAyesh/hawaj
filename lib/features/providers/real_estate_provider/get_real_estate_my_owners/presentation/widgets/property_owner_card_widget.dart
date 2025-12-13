import 'package:app_mobile/core/model/property_item_owner_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PropertyOwnerCardWidget extends StatelessWidget {
  final PropertyItemOwnerModel owner;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const PropertyOwnerCardWidget({
    super.key,
    required this.owner,
    required this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ManagerHeight.h16),
      decoration: BoxDecoration(
        color: ManagerColors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(ManagerRadius.r16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(ManagerWidth.w16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة الشركة
                    _buildCompanyLogo(),
                    SizedBox(width: ManagerWidth.w14),

                    // معلومات المالك
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // اسم المالك
                          Text(
                            owner.ownerName,
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s17,
                              color: ManagerColors.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: ManagerHeight.h4),

                          // اسم الشركة
                          if (owner.companyName.isNotEmpty)
                            Text(
                              owner.companyName,
                              style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: Colors.grey[700]!,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          SizedBox(height: ManagerHeight.h6),

                          // نوع الحساب
                          _buildAccountTypeBadge(),
                        ],
                      ),
                    ),

                    // زر التعديل
                    if (onEdit != null)
                      Material(
                        color: ManagerColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: onEdit,
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.edit_rounded,
                              size: 20,
                              color: ManagerColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // نبذة عن الشركة
                if (owner.companyBrief.isNotEmpty) ...[
                  SizedBox(height: ManagerHeight.h12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(ManagerWidth.w12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(ManagerRadius.r10),
                    ),
                    child: Text(
                      owner.companyBrief,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s13,
                        color: Colors.blue[900]!,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],

                SizedBox(height: ManagerHeight.h12),
                const Divider(height: 1, color: Color(0xFFE0E0E0)),
                SizedBox(height: ManagerHeight.h12),

                // معلومات الاتصال
                _buildContactInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo() {
    if (owner.companyLogo.isNotEmpty) {
      return Container(
        width: ManagerWidth.w72,
        height: ManagerHeight.h72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ManagerRadius.r12),
          border: Border.all(
            color: ManagerColors.primaryColor.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ManagerRadius.r10),
          child: CachedNetworkImage(
            imageUrl: owner.companyLogo,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[100],
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ManagerColors.primaryColor,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[100],
              child: Icon(
                Icons.broken_image_outlined,
                size: 32,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: ManagerWidth.w72,
      height: ManagerHeight.h72,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ManagerColors.primaryColor.withOpacity(0.8),
            ManagerColors.primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ManagerRadius.r12),
        border: Border.all(
          color: ManagerColors.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.business_rounded,
        size: 36,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAccountTypeBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w10,
        vertical: ManagerHeight.h4,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ManagerColors.primaryColor.withOpacity(0.8),
            ManagerColors.primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(ManagerRadius.r20),
      ),
      child: Text(
        owner.accountTypeLabel,
        style: getMediumTextStyle(
          fontSize: ManagerFontSize.s11,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        // الموبايل
        if (owner.mobileNumber.isNotEmpty)
          _buildContactRow(
            Icons.phone_rounded,
            'الجوال',
            owner.mobileNumber,
            Colors.green,
          ),

        if (owner.mobileNumber.isNotEmpty && owner.whatsappNumber.isNotEmpty)
          SizedBox(height: ManagerHeight.h8),

        // الواتساب
        if (owner.whatsappNumber.isNotEmpty)
          _buildContactRow(
            Icons.telegram,
            'واتساب',
            owner.whatsappNumber,
            const Color(0xFF25D366),
          ),

        if ((owner.mobileNumber.isNotEmpty ||
                owner.whatsappNumber.isNotEmpty) &&
            owner.detailedAddress.isNotEmpty)
          SizedBox(height: ManagerHeight.h8),

        // العنوان
        if (owner.detailedAddress.isNotEmpty)
          _buildContactRow(
            Icons.location_on_rounded,
            'العنوان',
            owner.detailedAddress,
            Colors.red,
          ),
      ],
    );
  }

  Widget _buildContactRow(
      IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: iconColor,
          ),
        ),
        SizedBox(width: ManagerWidth.w10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s11,
                  color: Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: Colors.grey[800]!,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
