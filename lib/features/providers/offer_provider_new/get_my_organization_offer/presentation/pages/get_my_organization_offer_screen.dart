import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/get_organization_item_with_offer_model.dart';
import '../controller/get_my_organization_offer_controller.dart';

class GetMyOrganizationOfferScreen extends StatelessWidget {
  const GetMyOrganizationOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetMyCompanyController>();

    return ScaffoldWithBackButton(
      title: "إدارة مؤسساتي",
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.companies.isEmpty) {
          return const Center(child: Text("لا توجد مؤسسات حالياً"));
        }

        return RefreshIndicator(
          onRefresh: controller.getMyCompany,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(ManagerWidth.w16),
            itemCount: controller.companies.length,
            itemBuilder: (context, index) {
              final company = controller.companies[index];
              return _buildCompanyCard(company);
            },
          ),
        );
      }),
    );
  }

  Widget _buildCompanyCard(GetOrganizationItemWithOfferModel company) {
    return Container(
      margin: EdgeInsets.only(bottom: ManagerHeight.h16),
      padding: EdgeInsets.all(ManagerWidth.w16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerWidth.w12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 اسم المؤسسة + الحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                company.organizationName,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s16,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w10,
                  vertical: ManagerHeight.h6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(ManagerWidth.w8),
                ),
                child: Text(
                  company.organizationStatusLabel,
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: Colors.orange[800]!,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: ManagerHeight.h8),

          // 🔸 وصف المؤسسة
          Text(
            company.organizationServices,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s13,
              color: Colors.grey[700]!,
            ),
          ),

          SizedBox(height: ManagerHeight.h16),

          // 🔸 الإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallStat(
                  "معلق", _countOffers(company, "معلق"), Colors.orange),
              _buildSmallStat(
                  "مسودة", _countOffers(company, "مسودة"), Colors.grey),
              _buildSmallStat(
                  "منشور", _countOffers(company, "منشور"), Colors.green),
              _buildSmallStat("إجمالي", company.offers.length.toString(),
                  ManagerColors.primaryColor),
            ],
          ),

          SizedBox(height: ManagerHeight.h16),

          // 🟣 زر إدارة العروض
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ManagerColors.primaryColor,
              borderRadius: BorderRadius.circular(ManagerWidth.w8),
            ),
            padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
            alignment: Alignment.center,
            child: Text(
              "إدارة العروض (${company.offers.length})",
              style: getMediumTextStyle(
                fontSize: ManagerFontSize.s14,
                color: Colors.white,
              ),
            ),
          ),

          // 🔻 ملاحظة في حال وجود عروض منتهية
          if (company.offers.any((offer) => offer.offerStatusLabel == "منتهي"))
            Padding(
              padding: EdgeInsets.only(top: ManagerHeight.h12),
              child: Container(
                padding: EdgeInsets.all(ManagerWidth.w12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(ManagerWidth.w8),
                ),
                child: Text(
                  "هناك عروض منتهية تحتاج إلى تحديث",
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s13,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s16,
            color: color,
          ),
        ),
        Text(
          title,
          style: getMediumTextStyle(
            fontSize: ManagerFontSize.s13,
            color: color,
          ),
        ),
      ],
    );
  }

  String _countOffers(
      GetOrganizationItemWithOfferModel company, String status) {
    return company.offers
        .where((offer) => offer.offerStatusLabel == status)
        .length
        .toString();
  }
}
