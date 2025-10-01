import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/custom_header_subscription_widget.dart';
import 'package:app_mobile/features/common/common_widgets/subscription_screen_widgets/label_drop_down_subscription_widget.dart';
import 'package:app_mobile/features/common/common_widgets/subscription_screen_widgets/row_with_dollar_icon_price_widget.dart';
import 'package:app_mobile/features/common/common_widgets/subscription_screen_widgets/sub_title_subscription_offer_provider_widget.dart';
import 'package:app_mobile/features/common/common_widgets/subscription_screen_widgets/title_container_widget.dart';
import 'package:app_mobile/features/common/common_widgets/subscription_screen_widgets/title_plan_name_widget.dart';
import 'package:app_mobile/features/common/common_widgets/subscription_screen_widgets/title_subscription_offer_provider_widget.dart';
import 'package:flutter/material.dart';

class SubscriptionCommercialContractsProviderScreen extends StatelessWidget {
  const SubscriptionCommercialContractsProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ManagerColors.primaryColor,
        appBar: CustomHeader(
          title: ManagerStrings.subscriptionCommercialTitle,
          onBack: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ManagerHeight.h32),

              /// ===== العنوان الرئيسي =====
              TitleSubscriptionOfferProviderWidget(
                  title: ManagerStrings.subscriptionCommercialMainTitle),
              SizedBox(height: ManagerHeight.h4),
              SubTitleSubscriptionOfferProviderWidget(
                subTitleString: ManagerStrings.subscriptionCommercialSubTitle,
              ),
              SizedBox(height: ManagerHeight.h21),

              /// ===== الكارد الخاصة بالخطة =====
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: ManagerHeight.h16),

                    /// عنوان الخطة
                    TitleContainerWidget(
                        title: ManagerStrings.subscriptionCommercialPlanTitle),
                    SizedBox(height: ManagerHeight.h8),

                    /// اسم الخطة
                    TitlePlanNameWidget(
                        title: ManagerStrings.subscriptionCommercialPlanName),
                    SizedBox(height: ManagerHeight.h4),

                    /// السعر
                    RowWithDollarIconPriceWidget(
                        pricePlan:
                            ManagerStrings.subscriptionCommercialPlanPrice),
                    SizedBox(height: ManagerHeight.h12),

                    /// Dropdown لاختيار مدة الاشتراك
                    LabelDropDownSubscriptionWidget<String>(
                      label: ManagerStrings.subscriptionCommercialDuration,
                      hint: ManagerStrings.subscriptionCommercialDurationHint,
                      value: "شهرية",
                      items: const [
                        DropdownMenuItem(value: "شهرية", child: Text("شهرية")),
                        DropdownMenuItem(value: "سنوية", child: Text("سنوية")),
                        DropdownMenuItem(
                            value: "نصف سنوية", child: Text("نصف سنوية")),
                      ],
                      onChanged: (val) {
                        // TODO: منطق تغيير المدة
                      },
                    ),
                    SizedBox(height: ManagerHeight.h12),

                    /// الميزات
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ManagerStrings
                                .subscriptionCommercialIncludedFeatures,
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s14,
                              color: ManagerColors.black,
                            ),
                          ),
                          SizedBox(height: ManagerHeight.h4),
                          FeatureItem(
                              text: ManagerStrings
                                  .subscriptionCommercialFeature1),
                          FeatureItem(
                              text: ManagerStrings
                                  .subscriptionCommercialFeature2),
                          FeatureItem(
                              text: ManagerStrings
                                  .subscriptionCommercialFeature3),
                          FeatureItem(
                              text: ManagerStrings
                                  .subscriptionCommercialFeature4),
                        ],
                      ),
                    ),

                    SizedBox(height: ManagerHeight.h16),
                    ButtonApp(
                      title: ManagerStrings.subscriptionCommercialButton,
                      onPressed: () {
                        // TODO: منطق الاشتراك
                      },
                      paddingWidth: ManagerWidth.w14,
                    ),
                    SizedBox(height: ManagerHeight.h8),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// الملاحظة في الأسفل
              Text(
                ManagerStrings.subscriptionCommercialNote,
                textAlign: TextAlign.center,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s10,
                  color: ManagerColors.white,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===== Widget لإظهار الميزة =====
class FeatureItem extends StatelessWidget {
  final String text;

  const FeatureItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle,
              color: ManagerColors.primaryColor, size: 20),
          SizedBox(width: ManagerWidth.w4),
          Expanded(
            child: Text(
              text,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.titleDropDownSubscriptionWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
