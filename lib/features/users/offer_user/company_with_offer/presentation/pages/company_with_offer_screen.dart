import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/get_company_with_offer_controller.dart';
import '../widgets/circle_icon_widget.dart';
import '../widgets/user_offer_card_widget.dart';

class CompanyWithOfferScreen extends StatefulWidget {
  final int idOrganization;

  const CompanyWithOfferScreen({super.key, required this.idOrganization});

  @override
  State<CompanyWithOfferScreen> createState() => _CompanyWithOfferScreenState();
}

class _CompanyWithOfferScreenState extends State<CompanyWithOfferScreen> {
  late GetCompanyController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<GetCompanyController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCompany(widget.idOrganization);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingWidget();
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  SizedBox(height: ManagerHeight.h16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: ManagerHeight.h16),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.refreshCompany(widget.idOrganization);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ManagerColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          final company = controller.companyModel.value?.data;
          if (company == null) {
            return const Center(child: Text("لا توجد بيانات متاحة"));
          }

          return RefreshIndicator(
            color: ManagerColors.primaryColor,
            onRefresh: () => controller.refreshCompany(widget.idOrganization),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // Header Image
                SliverToBoxAdapter(
                  child: _buildHeader(company),
                ),

                // Discount Banner
                SliverToBoxAdapter(
                  child: _buildDiscountBanner(),
                ),

                // Products Title
                SliverToBoxAdapter(
                  child: _buildProductsTitle(company.offers.length),
                ),

                // Products Grid
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: ManagerHeight.h230,
                      crossAxisSpacing: ManagerWidth.w10,
                      mainAxisSpacing: ManagerHeight.h10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final offer = company.offers[index];
                        return UserOfferCardWidget(
                          offer: offer,
                          onTap: () {},
                        );
                      },
                      childCount: company.offers.length,
                    ),
                  ),
                ),

                // Bottom Spacing
                SliverToBoxAdapter(
                  child: SizedBox(height: ManagerHeight.h24),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Header مع الصورة والأيقونات
  Widget _buildHeader(company) {
    return Stack(
      children: [
        // Background Image
        Image.asset(
          ManagerImages.imageRemoveIt,
          height: ManagerHeight.h200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Padding(
            padding: EdgeInsets.only(top: ManagerHeight.h160),
            child: _buildCompanyCard(company)),
        // Top Icons
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: ManagerWidth.w16,
          right: ManagerWidth.w16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleIconWidget(
                icon: Icons.arrow_back,
                onPressed: () => Get.back(),
              ),
              Row(
                children: [
                  CircleIconWidget(
                    icon: Icons.share_outlined,
                    onPressed: () {},
                  ),
                  SizedBox(width: ManagerWidth.w8),
                  CircleIconWidget(
                    icon: Icons.favorite_border,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Company Card
  Widget _buildCompanyCard(company) {
    return Transform.translate(
      offset: Offset(0, -ManagerHeight.h16),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: Container(
          padding: EdgeInsets.all(ManagerWidth.w16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ManagerRadius.r8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + Discount Badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Company Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(ManagerRadius.r8),
                        child: Image.network(
                          company.organizationLogo,
                          height: ManagerHeight.h60,
                          width: ManagerWidth.w60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            ManagerImages.image3remove,
                            height: ManagerHeight.h60,
                            width: ManagerWidth.w60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: ManagerWidth.w8),

                  // Company Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.organization,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h2),
                        Text(
                          company.organizationServices,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s9,
                            color: Colors.grey[600]!,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: ManagerWidth.w12),
                  // Phone Button
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ManagerWidth.w10,
                      vertical: ManagerHeight.h6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D3B6B),
                      borderRadius: BorderRadius.circular(ManagerRadius.r8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: ManagerWidth.w4),
                        Text(
                          company.phoneNumber,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s9,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: ManagerHeight.h12),

              // Info Icons Row
              Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    size: 14,
                    color: Colors.grey[700],
                  ),
                  SizedBox(width: ManagerWidth.w4),
                  Expanded(
                    child: Text(
                      company.address,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s9,
                        color: Colors.grey[700]!,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: ManagerHeight.h10),

              // Working Hours
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w12,
                  vertical: ManagerHeight.h8,
                ),
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ManagerRadius.r4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: ManagerColors.primaryColor,
                    ),
                    SizedBox(width: ManagerWidth.w6),
                    Flexible(
                      child: Text(
                        company.workingHours,
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s8,
                          color: ManagerColors.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Discount Banner
  Widget _buildDiscountBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
      child: Container(
        // margin: EdgeInsets.only(bottom: ManagerHeight.h8),
        padding: EdgeInsets.all(ManagerWidth.w16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF3D3B6B),
              const Color(0xFF5A4BA3),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(ManagerRadius.r8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3D3B6B).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'لا تفوت فرصة خصم 30% على',
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'منتجات مختارة ومميزة!',
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w12,
                vertical: ManagerHeight.h8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ManagerRadius.r8),
              ),
              child: Text(
                'عرض المنتجات',
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s10,
                  color: const Color(0xFF3D3B6B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Products Title
  Widget _buildProductsTitle(int count) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
        vertical: ManagerHeight.h12,
      ),
      child: Text(
        'قائمة المنتجات',
        style: getBoldTextStyle(
          fontSize: ManagerFontSize.s14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
