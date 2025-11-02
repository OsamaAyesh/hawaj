import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_radius.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../hawaj_voice/domain/models/job_item_hawaj_details_model.dart';
import '../../../hawaj_voice/domain/models/organization_item_hawaj_details_model.dart';
import '../../../hawaj_voice/domain/models/property_item_hawaj_details_model.dart';
import '../../../hawaj_voice/presentation/controller/hawaj_ai_controller.dart';

/// ═══════════════════════════════════════════════════════════
/// 🎯 Widget رئيسي لعرض نتائج Hawaj
/// ═══════════════════════════════════════════════════════════
class HawajResultsPanel extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onViewAll;

  const HawajResultsPanel({
    super.key,
    required this.onClose,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final hawajC = Get.find<HawajController>();

    return Obx(() {
      if (!hawajC.hasHawajData) return const SizedBox.shrink();

      final dataType = hawajC.currentDataType;

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w16,
          vertical: ManagerHeight.h16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== Header =====
            _buildHeader(hawajC, dataType),

            // ===== Content بناءً على نوع البيانات =====
            if (dataType == 'jobs')
              _buildJobsList(hawajC.hawajJobs)
            else if (dataType == 'offers')
              _buildOffersList(hawajC.hawajOffers)
            else if (dataType == 'properties')
              _buildPropertiesList(hawajC.hawajProperties),

            // ===== Footer =====
            _buildFooter(),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(HawajController hawajC, String? dataType) {
    String title = '';
    IconData icon = Icons.list;
    Color color = ManagerColors.primaryColor;

    if (dataType == 'jobs') {
      title = 'الوظائف المتاحة';
      icon = Icons.work;
      color = Colors.blue;
    } else if (dataType == 'offers') {
      title = 'العروض القريبة';
      icon = Icons.local_offer;
      color = Colors.orange;
    } else if (dataType == 'properties') {
      title = 'العقارات المتاحة';
      icon = Icons.home;
      color = Colors.green;
    }

    return Container(
      padding: EdgeInsets.all(ManagerWidth.w16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ManagerRadius.r20),
          topRight: Radius.circular(ManagerRadius.r20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ManagerWidth.w10),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: ManagerWidth.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.black,
                  ),
                ),
                Text(
                  '${hawajC.hawajDataCount} نتيجة',
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList(List<JobItemHawajDetailsModel> jobs) {
    return SizedBox(
      height: ManagerHeight.h250,
      child: ListView.separated(
        padding: EdgeInsets.all(ManagerWidth.w12),
        itemCount: jobs.length > 5 ? 5 : jobs.length,
        separatorBuilder: (_, __) => SizedBox(height: ManagerHeight.h8),
        itemBuilder: (context, index) {
          final job = jobs[index];
          return _JobCard(job: job);
        },
      ),
    );
  }

  Widget _buildOffersList(List<OrganizationItemHawajDetailsModel> offers) {
    return SizedBox(
      height: ManagerHeight.h250,
      child: ListView.separated(
        padding: EdgeInsets.all(ManagerWidth.w12),
        itemCount: offers.length > 5 ? 5 : offers.length,
        separatorBuilder: (_, __) => SizedBox(height: ManagerHeight.h8),
        itemBuilder: (context, index) {
          final offer = offers[index];
          return _OfferCard(offer: offer);
        },
      ),
    );
  }

  Widget _buildPropertiesList(List<PropertyItemHawajDetailsModel> properties) {
    return SizedBox(
      height: ManagerHeight.h250,
      child: ListView.separated(
        padding: EdgeInsets.all(ManagerWidth.w12),
        itemCount: properties.length > 5 ? 5 : properties.length,
        separatorBuilder: (_, __) => SizedBox(height: ManagerHeight.h8),
        itemBuilder: (context, index) {
          final property = properties[index];
          return _PropertyCard(property: property);
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w12),
      child: ElevatedButton(
        onPressed: onViewAll,
        style: ElevatedButton.styleFrom(
          backgroundColor: ManagerColors.primaryColor,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, ManagerHeight.h48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ManagerRadius.r12),
          ),
        ),
        child: Text(
          'عرض جميع النتائج',
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// 💼 Job Card
/// ═══════════════════════════════════════════════════════════
class _JobCard extends StatelessWidget {
  final JobItemHawajDetailsModel job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(ManagerRadius.r12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ManagerWidth.w8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(ManagerRadius.r8),
                ),
                child: const Icon(Icons.work, color: Colors.white, size: 16),
              ),
              SizedBox(width: ManagerWidth.w8),
              Expanded(
                child: Text(
                  job.jobTitle,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h8),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.business,
                label: job.companyName,
                color: Colors.blue,
              ),
              SizedBox(width: ManagerWidth.w8),
              _buildInfoChip(
                icon: Icons.access_time,
                label: job.jobTypeLabel,
                color: Colors.orange,
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h8),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.money,
                label: '${job.salary} ₪',
                color: Colors.green,
              ),
              SizedBox(width: ManagerWidth.w8),
              _buildInfoChip(
                icon: Icons.school,
                label: '${job.experienceYears} سنوات',
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w8,
        vertical: ManagerHeight.h4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ManagerRadius.r8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: ManagerWidth.w4),
          Text(
            label,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// 🏪 Offer Card
/// ═══════════════════════════════════════════════════════════
class _OfferCard extends StatelessWidget {
  final OrganizationItemHawajDetailsModel offer;

  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(ManagerRadius.r12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(ManagerRadius.r8),
              image: offer.organizationLogo.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(offer.organizationLogo),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: offer.organizationLogo.isEmpty
                ? const Icon(Icons.store, color: Colors.white)
                : null,
          ),
          SizedBox(width: ManagerWidth.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.organizationName,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ManagerHeight.h4),
                Text(
                  offer.organizationServices,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// 🏠 Property Card
/// ═══════════════════════════════════════════════════════════
class _PropertyCard extends StatelessWidget {
  final PropertyItemHawajDetailsModel property;

  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(ManagerRadius.r12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ManagerWidth.w8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(ManagerRadius.r8),
                ),
                child: const Icon(Icons.home, color: Colors.white, size: 16),
              ),
              SizedBox(width: ManagerWidth.w8),
              Expanded(
                child: Text(
                  property.propertySubject,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h8),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.money,
                label: '${property.price} ₪',
                color: Colors.green,
              ),
              SizedBox(width: ManagerWidth.w8),
              _buildInfoChip(
                icon: Icons.square_foot,
                label: '${property.areaSqm} م²',
                color: Colors.blue,
              ),
              SizedBox(width: ManagerWidth.w8),
              _buildInfoChip(
                icon: Icons.category,
                label: property.propertyTypeLabel,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w8,
        vertical: ManagerHeight.h4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ManagerRadius.r8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: ManagerWidth.w4),
          Text(
            label,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
