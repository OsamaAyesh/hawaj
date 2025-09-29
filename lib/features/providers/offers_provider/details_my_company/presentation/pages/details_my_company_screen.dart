import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/presentation/controller/details_my_company_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsMyCompanyScreen extends StatefulWidget {
  const DetailsMyCompanyScreen({super.key});

  @override
  State<DetailsMyCompanyScreen> createState() => _DetailsMyCompanyScreenState();
}

class _DetailsMyCompanyScreenState extends State<DetailsMyCompanyScreen> {
  final controller = Get.find<DetailsMyCompanyController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyCompanyDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.companyDetailsTitle,
      body: GetBuilder<DetailsMyCompanyController>(
        builder: (_) {
          return Stack(
            children: [
              if (controller.isLoading)
                const LoadingWidget()
              else if (controller.hasError)
                _buildEmptyState()
              else
                RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ManagerHeight.h24),
                        _buildCompanyHeader(),
                        SizedBox(height: ManagerHeight.h16),
                        _buildStatisticsCards(),
                        SizedBox(height: ManagerHeight.h24),
                        Text(
                          ManagerStrings.settingsList,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.black,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h16),
                        _settingTile(
                          ManagerStrings.editCompanyData,
                          Icons.edit_outlined,
                          onTap: () {},
                        ),
                        _settingTile(
                          ManagerStrings.subscriptionInfo,
                          Icons.info_outline,
                          onTap: () {},
                        ),
                        _settingTile(
                          ManagerStrings.contactSupport,
                          Icons.headset_mic_outlined,
                          onTap: () {},
                        ),
                        SizedBox(height: ManagerHeight.h24),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
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

                /// العنوان
                Text(
                  ManagerStrings.noRegisteredCompanyTitle,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: ManagerHeight.h12),

                /// الوصف
                Text(
                  ManagerStrings.noRegisteredCompanySubtitle,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: ManagerHeight.h32),

                /// زر إعادة المحاولة
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

  Widget _buildCompanyHeader() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      controller.companyDetailsData?.data?.organizationLogo ??
                          "",
                  width: ManagerHeight.h90,
                  height: ManagerHeight.h90,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const CircularProgressIndicator(
                    color: ManagerColors.primaryColor,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: ManagerHeight.h90,
                    height: ManagerHeight.h90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1E293B),
                    ),
                    child: const Icon(
                      Icons.business,
                      size: 40,
                      color: ManagerColors.primaryColor,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.verified,
                  color: ManagerColors.primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h12),
          Text(
            controller.companyDetailsData?.data?.organization ?? "",
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s16,
              color: ManagerColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ManagerHeight.h4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w24),
            child: Text(
              controller.companyDetailsData?.data?.organizationServices ?? "",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s11,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: ManagerHeight.h4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.companyDetailsData?.data?.phoneNumber ?? "",
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.black,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.phone, size: 14, color: ManagerColors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    final offersCount = controller.companyDetailsData?.data?.offersCount ?? 0;
    final address = controller.companyDetailsData?.data?.address ?? "";
    final city = address.split(',').length > 1
        ? address.split(',').last.trim()
        : address;
    final workingHours =
        controller.companyDetailsData?.data?.workingHours ?? "";

    return Row(
      children: [
        _infoCard('$offersCount+', ManagerStrings.currentOffers,
            Icons.local_offer_outlined),
        _infoCard(workingHours, ManagerStrings.workingHours,
            Icons.access_time_outlined),
        _infoCard(city, ManagerStrings.location, Icons.location_on_outlined),
      ],
    );
  }

  Widget _infoCard(String value, String label, IconData icon) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w4),
        child: DottedBorder(
          color: ManagerColors.primaryColor,
          borderType: BorderType.RRect,
          radius: Radius.circular(ManagerRadius.r6),
          dashPattern: const [6, 3],
          strokeWidth: 1.2,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(icon, color: ManagerColors.primaryColor, size: 16),
                ),
                SizedBox(height: ManagerHeight.h8),
                Center(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: ManagerColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: ManagerHeight.h4),
                Center(
                  child: Text(
                    label,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s11,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _settingTile(String title, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r6),
          border:
              Border.all(color: ManagerColors.primaryColor.withOpacity(0.34)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: ManagerColors.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
