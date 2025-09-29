import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/presentation/controller/details_my_company_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_font_size.dart';

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
      title: "تفاصيل الشركة",
      body: GetBuilder<DetailsMyCompanyController>(
        builder: (_) {
          return Stack(
            children: [
              if (controller.isLoading)
                const LoadingWidget()
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
                          'قائمة الإعدادات',
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.black,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h16),
                        _settingTile(
                          'تعديل بيانات المكتب او الشركة',
                          Icons.edit_outlined,
                          onTap: () {},
                        ),
                        _settingTile(
                          'معلومات الإشتراك وتفاصيله',
                          Icons.info_outline,
                          onTap: () {},
                        ),
                        _settingTile(
                          'التواصل مع الدعم الفني',
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
        _infoCard(
            '$offersCount+', 'العروض الحالية', Icons.local_offer_outlined),
        _infoCard(workingHours, 'ساعات العمل', Icons.access_time_outlined),
        _infoCard(city, 'الموقع', Icons.location_on_outlined),
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
