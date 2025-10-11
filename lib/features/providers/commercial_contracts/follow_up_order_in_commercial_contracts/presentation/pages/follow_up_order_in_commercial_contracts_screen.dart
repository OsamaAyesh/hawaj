import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';

class FollowUpOrderInCommercialContractsScreen extends StatelessWidget {
  const FollowUpOrderInCommercialContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.followUpOrdersTitle,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                ManagerStrings.ordersListTitle,
                style: getRegularTextStyle(
                  color: ManagerColors.black,
                  fontSize: ManagerFontSize.s16,
                ),
              ),
            ),
            SizedBox(height: ManagerHeight.h12),
            Expanded(
              child: ListView.separated(
                itemCount: 12,
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return const _OrderCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ManagerColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
        vertical: ManagerHeight.h8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${ManagerStrings.offerDateLabel} 2024-07-14",
              style: getRegularTextStyle(
                color: Colors.grey[600] ?? Colors.grey,
                fontSize: ManagerFontSize.s12,
              ),
            ),
          ),
          SizedBox(height: ManagerHeight.h4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // العنوان
              Expanded(
                child: Text(
                  ManagerStrings.offerTitle,
                  style: getBoldTextStyle(
                    color: ManagerColors.black,
                    fontSize: ManagerFontSize.s14,
                  ),
                ),
              ),

              // السعر + نص عرض السعر
              Row(
                children: [
                  Text(
                    "100 \$",
                    style: getBoldTextStyle(
                      color: ManagerColors.primaryColor,
                      fontSize: ManagerFontSize.s20,
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w2),
                  Text(
                    ManagerStrings.offerPriceLabel,
                    style: getRegularTextStyle(
                      color: Colors.grey[600] ?? Colors.grey,
                      fontSize: ManagerFontSize.s12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h8),
          Text(
            ManagerStrings.offerDescription,
            style: getRegularTextStyle(
              color: Colors.grey[600] ?? Colors.grey,
              fontSize: ManagerFontSize.s10,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: ManagerHeight.h12),
          Container(
            height: ManagerHeight.h24,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ManagerColors.primaryColor,
              borderRadius: BorderRadius.circular(ManagerRadius.r4),
            ),
            child: Center(
              child: Text(
                ManagerStrings.downloadOfferButton,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s10,
                  color: ManagerColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
