import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/presentation/pages/add_company_jobs_provider_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../add_company_jobs_provider/domain/di/di.dart';
import 'controller/list_company_jobs_controller.dart';

class ListCompanyJobsScreen extends StatelessWidget {
  const ListCompanyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetListCompanyJobsController>();

    return ScaffoldWithBackButton(
      title: "شركاتي",
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          final state = _buildState(controller);
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: state,
          );
        }),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildState(GetListCompanyJobsController controller) {
    if (controller.isLoading.value) {
      return const _LoadingState();
    }

    if (controller.errorMessage.isNotEmpty) {
      return _ErrorState(error: controller.errorMessage.value);
    }

    if (controller.companies.isEmpty) {
      return const _EmptyState();
    }

    return _CompanyList(controller: controller);
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _navigateToAddCompany,
      backgroundColor: ManagerColors.primaryColor,
      icon: const Icon(Icons.add_business_rounded, color: Colors.white),
      label: Text(
        "إضافة شركة",
        style: getMediumTextStyle(
          fontSize: ManagerFontSize.s14,
          color: Colors.white,
        ),
      ),
    );
  }

  void _navigateToAddCompany() {
    initAddCompanyJobs();
    Get.to(() => const AddCompanyJobsProviderScreen());
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("جاري تحميل الشركات..."),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: ManagerColors.secondColor,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            "حدث خطأ",
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s18,
              color: ManagerColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.greyWithColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.find<GetListCompanyJobsController>().refreshCompanies();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ManagerColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "إعادة المحاولة",
              style: getMediumTextStyle(
                fontSize: ManagerFontSize.s14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_center_outlined,
            color: ManagerColors.greyWithColor,
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            "لا توجد شركات",
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s18,
              color: ManagerColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "ابدأ بإضافة شركتك الأولى",
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s14,
              color: ManagerColors.greyWithColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyList extends StatelessWidget {
  final GetListCompanyJobsController controller;

  const _CompanyList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshCompanies,
      color: ManagerColors.primaryColor,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        itemCount: controller.companies.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: ManagerHeight.h16),
        itemBuilder: (context, index) {
          final company = controller.companies[index];
          return _CompanyCard(company: company);
        },
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final dynamic company;

  const _CompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: ManagerColors.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showCompanyDetails(context),
        child: Padding(
          padding: EdgeInsets.all(ManagerWidth.w16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              SizedBox(height: ManagerHeight.h12),

              // Divider
              Container(
                  height: 1,
                  color: ManagerColors.greyWithColor.withOpacity(0.3)),
              SizedBox(height: ManagerHeight.h12),

              // Contact Info
              _buildContactInfo(),
              SizedBox(height: ManagerHeight.h12),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Logo
        Hero(
          tag: 'company_logo_${company.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: company.companyLogo,
              width: ManagerWidth.w70,
              height: ManagerHeight.h70,
              fit: BoxFit.cover,
              placeholder: (context, url) => _buildImagePlaceholder(),
              errorWidget: (context, url, error) => _buildImageError(),
            ),
          ),
        ),
        SizedBox(width: ManagerWidth.w12),

        // Company Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                company.companyName,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: ManagerColors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ManagerHeight.h4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  company.industry,
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: ManagerHeight.h8),
              Text(
                company.companyShortDescription,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: ManagerColors.greyWithColor,
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

  Widget _buildContactInfo() {
    return Column(
      children: [
        _buildInfoItem(Icons.phone_android, company.mobileNumber),
        if (company.detailedAddress != null &&
            company.detailedAddress.isNotEmpty)
          _buildInfoItem(Icons.location_on_outlined, company.detailedAddress),
        if (company.contactPersonName != null &&
            company.contactPersonName.isNotEmpty)
          _buildInfoItem(Icons.person, company.contactPersonName),
        if (company.contactPersonEmail != null &&
            company.contactPersonEmail.isNotEmpty)
          _buildInfoItem(Icons.email_outlined, company.contactPersonEmail),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.visibility_outlined,
            label: "عرض التفاصيل",
            color: ManagerColors.primaryColor,
            onTap: () => _showCompanyDetails,
          ),
        ),
        SizedBox(width: ManagerWidth.w8),
        Expanded(
          child: _buildActionButton(
            icon: Icons.edit_outlined,
            label: "تعديل",
            color: ManagerColors.secondColor,
            onTap: _editCompany,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: color.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: ManagerHeight.h6),
      child: Row(
        children: [
          Icon(icon, color: ManagerColors.greyWithColor, size: 16),
          SizedBox(width: ManagerWidth.w8),
          Expanded(
            child: Text(
              value,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s13,
                color: ManagerColors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: ManagerWidth.w70,
      height: ManagerHeight.h70,
      decoration: BoxDecoration(
        color: ManagerColors.greyWithColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.business, color: Colors.grey, size: 24),
    );
  }

  Widget _buildImageError() {
    return Container(
      width: ManagerWidth.w70,
      height: ManagerHeight.h70,
      decoration: BoxDecoration(
        color: ManagerColors.greyWithColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.broken_image, color: Colors.grey, size: 24),
    );
  }

  void _showCompanyDetails(BuildContext context) {
    Get.to(
      () => _CompanyDetailsScreen(company: company),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _editCompany() {
    initAddCompanyJobs();
    Get.to(
      () => const AddCompanyJobsProviderScreen(),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 300),
    );
  }
}

class _CompanyDetailsScreen extends StatelessWidget {
  final dynamic company;

  const _CompanyDetailsScreen({required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          company.companyName,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s18,
            color: Colors.white,
          ),
        ),
        backgroundColor: ManagerColors.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo
            _buildCompanyLogo(),
            SizedBox(height: ManagerHeight.h24),

            // Company Info
            _buildCompanyInfo(),
            SizedBox(height: ManagerHeight.h24),

            // Contact Information
            _buildContactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyLogo() {
    return Center(
      child: Hero(
        tag: 'company_logo_${company.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: company.companyLogo,
            width: ManagerWidth.w120,
            height: ManagerHeight.h120,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: ManagerWidth.w120,
              height: ManagerHeight.h120,
              decoration: BoxDecoration(
                color: ManagerColors.greyWithColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.business, color: Colors.grey, size: 40),
            ),
            errorWidget: (context, url, error) => Container(
              width: ManagerWidth.w120,
              height: ManagerHeight.h120,
              decoration: BoxDecoration(
                color: ManagerColors.greyWithColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child:
                  const Icon(Icons.broken_image, color: Colors.grey, size: 40),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          company.companyName,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s20,
            color: ManagerColors.black,
          ),
        ),
        SizedBox(height: ManagerHeight.h8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ManagerColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            company.industry,
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s14,
              color: ManagerColors.primaryColor,
            ),
          ),
        ),
        SizedBox(height: ManagerHeight.h16),
        if (company.companyDescription != null &&
            company.companyDescription.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الوصف",
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: ManagerColors.black,
                ),
              ),
              SizedBox(height: ManagerHeight.h8),
              Text(
                company.companyDescription,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: ManagerColors.greyWithColor,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "معلومات التواصل",
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s16,
            color: ManagerColors.black,
          ),
        ),
        SizedBox(height: ManagerHeight.h16),
        _buildDetailItem(Icons.phone, company.mobileNumber),
        _buildDetailItem(Icons.location_on, company.detailedAddress),
        _buildDetailItem(Icons.person, company.contactPersonName),
        _buildDetailItem(Icons.email, company.contactPersonEmail),
        if (company.memberIdLable != null && company.memberIdLable.isNotEmpty)
          _buildDetailItem(Icons.verified_user, company.memberIdLable),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: ManagerHeight.h12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ManagerColors.primaryColor, size: 20),
          SizedBox(width: ManagerWidth.w12),
          Expanded(
            child: Text(
              value,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
