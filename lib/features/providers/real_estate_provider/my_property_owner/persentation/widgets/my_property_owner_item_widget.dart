import 'package:app_mobile/core/model/property_item_owner_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../../manager_my_real_estate_provider/domain/di/di.dart';
import '../../../manager_my_real_estate_provider/presentation/pages/manager_my_real_estate_provider_screen.dart';

class PropertyOwnerCard extends StatefulWidget {
  final PropertyItemOwnerModel owner;
  final int index;

  const PropertyOwnerCard({
    required this.owner,
    required this.index,
  });

  @override
  State<PropertyOwnerCard> createState() => PropertyOwnerCardState();
}

class PropertyOwnerCardState extends State<PropertyOwnerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 80)),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: ManagerColors.black.withOpacity(0.10),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ManagerWidth.w16, vertical: ManagerHeight.h16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: ManagerWidth.w68,
                          height: ManagerHeight.h68,
                          decoration: BoxDecoration(
                            color: ManagerColors.secondColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: ManagerColors.secondColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: widget.owner.companyLogo!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    width: ManagerWidth.w20,
                                    height: ManagerHeight.h20,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: ManagerColors.secondColor,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 34,
                                  color: Color(0xFF1976D2),
                                ),
                              )),
                        ),
                        SizedBox(width: ManagerWidth.w14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.owner.ownerName ?? 'غير محدد',
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s18,
                                  color: const Color(0xFF212121),
                                ),
                              ),
                              ...[
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.apartment_rounded,
                                      size: 15,
                                      color: Color(0xFF757575),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        widget.owner.companyName!,
                                        style: getRegularTextStyle(
                                          fontSize: 13,
                                          color: const Color(0xFF757575),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ManagerWidth.w12,
                            vertical: ManagerHeight.h6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.owner.accountType == '1'
                                ? const Color(0xFF1976D2)
                                : ManagerColors.secondColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.owner.accountType == '1'
                                    ? Icons.business_center_rounded
                                    : Icons.person_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.owner.accountTypeLabel ?? 'فرد',
                                style: getMediumTextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.owner.companyBrief != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.owner.companyBrief!,
                          style: getRegularTextStyle(
                            fontSize: 12,
                            color: const Color(0xFF616161),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    SizedBox(height: ManagerHeight.h14),
                    const Divider(
                        height: 1, color: ManagerColors.greyWithColor),
                    SizedBox(height: ManagerHeight.h14),
                    Column(
                      children: [
                        _InfoRow(
                          icon: Icons.phone_android_rounded,
                          label: 'رقم الجوال',
                          value: widget.owner.mobileNumber ?? 'غير متوفر',
                          iconColor: const Color(0xFF1976D2),
                        ),
                        const SizedBox(height: 10),
                        _InfoRow(
                          icon: Icons.telegram_rounded,
                          label: 'واتساب',
                          value: widget.owner.whatsappNumber ?? 'غير متوفر',
                          iconColor: const Color(0xFF25D366),
                        ),
                        const SizedBox(height: 10),
                        _InfoRow(
                          icon: Icons.location_on_rounded,
                          label: 'العنوان',
                          value: widget.owner.detailedAddress ?? 'غير محدد',
                          iconColor: const Color(0xFFE53935),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: Material(
                  color: ManagerColors.primaryColor,
                  borderRadius: BorderRadius.circular(ManagerRadius.r8),
                  elevation: 0,
                  child: InkWell(
                    onTap: () {
                      initGetMyRealEstates();
                      initDeleteMyRealEstate();
                      Get.to(ManagerMyRealEstateProviderScreen(
                        id: widget.owner.id,
                      ));
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.view_list_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: ManagerWidth.w8),
                          Text(
                            'عرض قائمة العقارات التابعة',
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: ManagerWidth.w8),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getRegularTextStyle(
                  fontSize: 11,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: getMediumTextStyle(
                  fontSize: 13,
                  color: const Color(0xFF424242),
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
