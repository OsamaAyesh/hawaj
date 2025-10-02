import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_radius.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../controller/map_sections_controller.dart';

/// Widget لتبديل الأقسام على الخريطة
class MapSectionsSwitcher extends StatelessWidget {
  final MapSectionsController controller;

  const MapSectionsSwitcher({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ManagerHeight.h70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w8),
        itemCount: MapSectionType.values.length,
        itemBuilder: (context, index) {
          final section = MapSectionType.values[index];

          // ✅ نقل Obx هنا - داخل كل item
          return Obx(() {
            final isActive = controller.currentSection.value == section;
            final isLoading =
                controller.sectionsLoading[section]?.value ?? false;

            return _SectionItem(
              section: section,
              isActive: isActive,
              isLoading: isLoading,
              onTap: () => controller.changeSection(section),
            );
          });
        },
      ),
    );
  }
}

/// عنصر قسم واحد
class _SectionItem extends StatelessWidget {
  final MapSectionType section;
  final bool isActive;
  final bool isLoading;
  final VoidCallback onTap;

  const _SectionItem({
    required this.section,
    required this.isActive,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w4,
          vertical: ManagerHeight.h8,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w16,
          vertical: ManagerHeight.h8,
        ),
        decoration: BoxDecoration(
          color: isActive ? ManagerColors.primaryColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(ManagerRadius.r12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getSectionIcon(section),
              size: 20,
              color: isActive ? Colors.white : Colors.grey.shade600,
            ),
            SizedBox(width: ManagerWidth.w8),
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    isActive ? Colors.white : ManagerColors.primaryColor,
                  ),
                ),
              )
            else
              Text(
                _getSectionName(section),
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: isActive ? Colors.white : Colors.grey.shade700,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getSectionIcon(MapSectionType section) {
    switch (section) {
      case MapSectionType.dailyOffers:
        return Icons.local_offer;
      case MapSectionType.contracts:
        return Icons.description;
      case MapSectionType.realEstate:
        return Icons.home;
      case MapSectionType.delivery:
        return Icons.delivery_dining;
      case MapSectionType.jobs:
        return Icons.work;
    }
  }

  String _getSectionName(MapSectionType section) {
    switch (section) {
      case MapSectionType.dailyOffers:
        return 'العروض';
      case MapSectionType.contracts:
        return 'العقود';
      case MapSectionType.realEstate:
        return 'العقارات';
      case MapSectionType.delivery:
        return 'التوصيل';
      case MapSectionType.jobs:
        return 'الوظائف';
    }
  }
}
