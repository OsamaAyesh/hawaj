import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/features/common/common_widgets/subscription_screen_widgets/title_plan_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // مهم لاستعمال Get.locale

import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/widgets/custom_header_subscription_widget.dart';
import '../../../../../common/common_widgets/subscription_screen_widgets/label_drop_down_subscription_widget.dart';
import '../../../../../common/common_widgets/subscription_screen_widgets/row_with_dollar_icon_price_widget.dart';
import '../../../../../common/common_widgets/subscription_screen_widgets/sub_title_subscription_offer_provider_widget.dart';
import '../../../../../common/common_widgets/subscription_screen_widgets/title_container_widget.dart';
import '../../../../../common/common_widgets/subscription_screen_widgets/title_subscription_offer_provider_widget.dart';

class SubscriptionOfferProviderScreen extends StatelessWidget {
  const SubscriptionOfferProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ManagerColors.primaryColor,
        appBar: CustomHeader(
          title: "اشترك الآن",
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ManagerHeight.h42,
                  ),
              
                  ///======== Title Widget Text ======
                  const TitleSubscriptionOfferProviderWidget(
                      title: " انشر عروضك اليومية الآن مع حواج!"),
                  SizedBox(
                    height: ManagerHeight.h4,
                  ),
              
                  ///======== Sub Title Text ======
                  const SubTitleSubscriptionOfferProviderWidget(
                    subTitleString:
                        'اشترك بخطتك المناسبة وابدأ بنشر عروضك بطريقة جذابة واحترافية، ووصلها للعملاء القريبين منك بخريطة تفاعلية.',
                  ),
                  SizedBox(
                    height: ManagerHeight.h21,
                  ),
              
                  ///======= Container Choose Plan
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: ManagerHeight.h16,
                        ),
              
                        /// ============ Plan Title  =============
                        const TitleContainerWidget(
                          title: 'الخطة الرائجة',
                        ),
                        SizedBox(height: ManagerHeight.h8),
              
                        /// ============ Plan Name  =============
                        const TitlePlanNameWidget(title: "Super"),
              
                        SizedBox(height: ManagerHeight.h4),
              
                        /// ====== Price Plan Widget ========
                        const RowWithDollarIconPriceWidget(
                          pricePlan: '59.99',
                        ),
              
                        ///======= Drop Down Type  Company Widget =======
                        LabelDropDownSubscriptionWidget<String>(
                          label: "نوع المؤسسة",
                          hint: "اختر نوع المؤسسة",
                          value: "مطعم",
                          items: const [
                            DropdownMenuItem(value: "مطعم", child: Text("مطعم")),
                            DropdownMenuItem(
                                value: "سوبرماركت", child: Text("سوبرماركت")),
                            DropdownMenuItem(value: "مقهى", child: Text("مقهى")),
                          ],
                          onChanged: (val) {
                            print("تم الاختيار: $val");
                          },
                        ),
              
                        SizedBox(
                          height: ManagerHeight.h12,
                        ),
              
                        ///======= Drop Down Type Plan Time =======
                        LabelDropDownSubscriptionWidget<String>(
                          label: "مدة الإشتراك",
                          hint: "اختر مدة الإشتراك",
                          value: "شهرية",
                          items: const [
                            DropdownMenuItem(
                                value: "شهرية", child: Text("شهرية")),
                            DropdownMenuItem(
                                value: "سنوية", child: Text("سنوية")),
                            DropdownMenuItem(
                                value: "نصف سنوية", child: Text("نصف سنوية")),
                          ],
                          onChanged: (val) {
                            print("تم الاختيار: $val");
                          },
                        ),
              
                        ///========== Column With Padding 16 Feature
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: ManagerHeight.h8,
                              ),
                              Text(
                                "الميزات المشمولة",
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s14,
                                  color: ManagerColors.black,
                                ),
                              ),
                              SizedBox(
                                height: ManagerHeight.h4,
                              ),
                              const FeatureItem(
                                  text: "نشر عدد محدد من العروض يومياً"),
                              const FeatureItem(
                                  text: "عرض موقع متجرك أو نشاطك على الخريطة"),
                              const FeatureItem(
                                  text: "إحصاءات وتقارير أداء العروض"),
                              const FeatureItem(
                                  text: "عرض منتجاتك في قنواتك بطريقة احترافية"),
                            ],
                          ),
                        ),
              
                        SizedBox(height: ManagerHeight.h16),
                        ButtonApp(
                            title: "الاشتراك في هذه الخطة",
                            onPressed: () {},
                            paddingWidth: ManagerWidth.w14),
                        SizedBox(height: ManagerHeight.h8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ///========== Text Hint
                  Text(
                    "من الممكن تغيير الباقة التي قمت باختيارها بعد انتهاء المدة الحالية "
                    "أو عن طريق التواصل مع الدعم الفني.",
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
        ),
      ),
    );
  }
}

/// ===== Reusable Widget for Feature Item =====
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
                  color: ManagerColors.titleDropDownSubscriptionWidget),
            ),
          ),
        ],
      ),
    );
  }
}
