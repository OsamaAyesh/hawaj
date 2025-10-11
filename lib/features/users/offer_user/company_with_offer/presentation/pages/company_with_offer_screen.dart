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

import '../../domain/di/di.dart';
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

    // ✅ تحميل البيانات مرة واحدة فقط عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCompany(widget.idOrganization);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeGetCompany();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: ManagerColors.white,
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
            // ✅ استدعاء refreshCompany بدلاً من fetchCompany
            onRefresh: () => controller.refreshCompany(widget.idOrganization),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                /// Header Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Banner Background
                      Stack(
                        children: [
                          Image.asset(
                            ManagerImages.imageRemoveIt,
                            height: ManagerHeight.h239,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ManagerHeight.h51),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ManagerWidth.w16,
                                ),
                                child: Row(
                                  children: [
                                    CircleIconWidget(
                                      icon: Icons.arrow_back,
                                      onPressed: () => Get.back(),
                                    ),
                                    const Spacer(),
                                    CircleIconWidget(
                                      icon: Icons.share_outlined,
                                      onPressed: () {},
                                    ),
                                    SizedBox(width: ManagerWidth.w12),
                                    CircleIconWidget(
                                      icon: Icons.favorite_border,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h80),

                              /// Card with company details
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ManagerWidth.w16,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ManagerColors.white,
                                    borderRadius: BorderRadius.circular(
                                      ManagerRadius.r6,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ManagerColors.black
                                            .withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: ManagerHeight.h8),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: ManagerWidth.w12),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /// Company Logo
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ManagerRadius.r4),
                                              child: Image.network(
                                                company.organizationLogo,
                                                height: ManagerHeight.h64,
                                                width: ManagerWidth.w64,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Image.asset(
                                                  ManagerImages.image3remove,
                                                  height: ManagerHeight.h64,
                                                  width: ManagerWidth.w64,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: ManagerWidth.w8),

                                            /// Company Details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    company.organization,
                                                    style: getBoldTextStyle(
                                                      fontSize:
                                                          ManagerFontSize.s12,
                                                      color:
                                                          ManagerColors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: ManagerHeight.h4),
                                                  Text(
                                                    company
                                                        .organizationServices,
                                                    style: getRegularTextStyle(
                                                      fontSize:
                                                          ManagerFontSize.s8,
                                                      color: ManagerColors
                                                          .colorCompanyDetails,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                      height: ManagerHeight.h4),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.phone,
                                                        size: 14,
                                                        color: ManagerColors
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              ManagerWidth.w4),
                                                      Text(
                                                        company.phoneNumber,
                                                        style:
                                                            getRegularTextStyle(
                                                          fontSize:
                                                              ManagerFontSize
                                                                  .s8,
                                                          color: ManagerColors
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: ManagerHeight.h8),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: ManagerHeight.h16),

                      /// Products Title
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                        child: Row(
                          children: [
                            Text(
                              "قائمة المنتجات",
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s13,
                                color: ManagerColors.primaryColor,
                              ),
                            ),
                            SizedBox(width: ManagerWidth.w6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ManagerWidth.w8,
                                vertical: ManagerHeight.h2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    ManagerColors.primaryColor.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(ManagerRadius.r12),
                              ),
                              child: Text(
                                "${company.offers.length}",
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s10,
                                  color: ManagerColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ManagerHeight.h12),
                    ],
                  ),
                ),

                /// ✅ GridView للعروض (مع تعديل المسافات)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: ManagerHeight.h230, // ✅ ارتفاع ثابت
                      crossAxisSpacing: ManagerWidth.w10, // ✅ مسافة أفقية
                      mainAxisSpacing: ManagerHeight.h10, // ✅ مسافة عمودية
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final offer = company.offers[index];
                        return UserOfferCardWidget(
                          offer: offer,
                          onTap: () {
                            // الانتقال لتفاصيل العرض
                          },
                        );
                      },
                      childCount: company.offers.length,
                    ),
                  ),
                ),

                /// Bottom Spacing
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
}
