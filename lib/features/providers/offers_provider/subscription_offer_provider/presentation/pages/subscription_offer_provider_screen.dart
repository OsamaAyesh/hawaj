import 'package:app_mobile/constants/constants/constants.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/features/common/common_widgets/subscription_screen_widgets/title_plan_name_widget.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/presentation/controller/get_plans_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_strings.dart';
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
    final controller = Get.find<PlansController>();
    controller.initData(); // تحميل البيانات (plans + orgs)

    return SafeArea(
      child: Scaffold(
        backgroundColor: ManagerColors.primaryColor,
        appBar: CustomHeader(
          title: ManagerStrings.subscribeNow,
          onBack: () => Navigator.pop(context),
        ),
        body: Obx(() {
          final plan = controller.selectedPlan.value;
          final org = controller.selectedOrganization.value;

          return Stack(
            children: [
              if (controller.errorMessage.isNotEmpty)
                Center(child: Text(controller.errorMessage.value))
              else if (plan == null || org == null)
                 Center(child: Text(ManagerStrings.noContent))
              else
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ManagerHeight.h32),

                       TitleSubscriptionOfferProviderWidget(
                          title: ManagerStrings.publishOffersTitle),
                      SizedBox(height: ManagerHeight.h4),
                       SubTitleSubscriptionOfferProviderWidget(
                        subTitleString:ManagerStrings.publishOffersSubTitle,
                      ),
                      SizedBox(height: ManagerHeight.h21),

                      /// ===== Company Overview =====
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(ManagerWidth.w16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ManagerStrings.myOrganization,
                                style: getBoldTextStyle(
                                    fontSize: ManagerFontSize.s14,
                                    color: ManagerColors.black)),
                            SizedBox(height: ManagerHeight.h8),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey[200],
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: "${Constants.baseUrlAttachments}/${org.organizationLogo}",
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ManagerWidth.w12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(org.organizationName,
                                          style: getBoldTextStyle(
                                              fontSize: ManagerFontSize.s14,
                                              color: ManagerColors.black)),
                                      SizedBox(height: 4),
                                      Text(org.organizationServices,
                                          style: getRegularTextStyle(
                                              fontSize: ManagerFontSize.s12,
                                              color: ManagerColors
                                                  .titleDropDownSubscriptionWidget)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ManagerHeight.h8),
                            Text(org.organizationDetailedAddress,
                                style: getRegularTextStyle(
                                    fontSize: ManagerFontSize.s12,
                                    color: ManagerColors
                                        .titleDropDownSubscriptionWidget)),
                          ],
                        ),
                      ),

                      /// ===== Plan Card =====
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: ManagerHeight.h16),

                            /// عنوان الخطة
                             TitleContainerWidget(title: ManagerStrings.selectedPlan),
                            SizedBox(height: ManagerHeight.h8),

                            /// اسم الخطة
                            TitlePlanNameWidget(title: plan.planName),
                            SizedBox(height: ManagerHeight.h4),

                            /// السعر
                            RowWithDollarIconPriceWidget(
                              pricePlan: plan.planPrice.toString(),
                            ),
                            SizedBox(height: ManagerHeight.h12),

                            /// Dropdown مدة الاشتراك (من السيرفر)
                            LabelDropDownSubscriptionWidget<double>(
                              label: ManagerStrings.subscriptionDuration,
                              hint: ManagerStrings.chooseSubscriptionDuration,
                              value: plan.days,
                              items: controller.plans
                                  .map((p) => DropdownMenuItem<double>(
                                value: p.days,
                                child: Text("${p.days.toInt()} يوم"),
                              ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  controller.selectPlanByDays(val);
                                }
                              },
                            ),
                            SizedBox(height: ManagerHeight.h12),

                            /// الميزات
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ManagerWidth.w16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ManagerStrings.includedFeatures,
                                    style: getBoldTextStyle(
                                      fontSize: ManagerFontSize.s14,
                                      color: ManagerColors.black,
                                    ),
                                  ),
                                  SizedBox(height: ManagerHeight.h4),
                                  FeatureItem(text: plan.planFeatures),
                                ],
                              ),
                            ),

                            SizedBox(height: ManagerHeight.h16),
                            ButtonApp(
                              title: ManagerStrings.subscribeThisPlan,
                              onPressed: () {
                                controller.subscribe();
                              },
                              paddingWidth: ManagerWidth.w14,
                            ),
                            SizedBox(height: ManagerHeight.h8),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      Text(
                        ManagerStrings.changePlanNote,
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

              /// Loading Overlay
              if (controller.isLoading.value)
                const LoadingWidget(),
            ],
          );
        }),
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
                color: ManagerColors.titleDropDownSubscriptionWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/widgets/button_app.dart';
// import 'package:app_mobile/core/widgets/loading_widget.dart';
// import 'package:app_mobile/features/common/common_widgets/subscription_screen_widgets/title_plan_name_widget.dart';
// import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/presentation/controller/get_plans_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../../../core/resources/manager_font_size.dart';
// import '../../../../../../core/resources/manager_strings.dart';
// import '../../../../../../core/resources/manager_styles.dart';
// import '../../../../../../core/widgets/custom_header_subscription_widget.dart';
// import '../../../../../common/common_widgets/subscription_screen_widgets/label_drop_down_subscription_widget.dart';
// import '../../../../../common/common_widgets/subscription_screen_widgets/row_with_dollar_icon_price_widget.dart';
// import '../../../../../common/common_widgets/subscription_screen_widgets/sub_title_subscription_offer_provider_widget.dart';
// import '../../../../../common/common_widgets/subscription_screen_widgets/title_container_widget.dart';
// import '../../../../../common/common_widgets/subscription_screen_widgets/title_subscription_offer_provider_widget.dart';
//
// class SubscriptionOfferProviderScreen extends StatelessWidget {
//   const SubscriptionOfferProviderScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<PlansController>();
//     controller.fetchPlans();
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ManagerColors.primaryColor,
//         appBar: CustomHeader(
//           title: "اشترك الآن",
//           onBack: () => Navigator.pop(context),
//         ),
//         body: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: LoadingWidget());
//           }
//           if (controller.errorMessage.isNotEmpty) {
//             return Center(child: Text(controller.errorMessage.value));
//           }
//           if (controller.selectedPlan.value == null) {
//             return const Center(child: Text("لا يوجد خطط متاحة حالياً"));
//           }
//
//           final plan = controller.selectedPlan.value!;
//
//           return SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: ManagerHeight.h42),
//
//                 const TitleSubscriptionOfferProviderWidget(
//                     title: "انشر عروضك اليومية الآن مع حواج!"),
//                 SizedBox(height: ManagerHeight.h4),
//                 const SubTitleSubscriptionOfferProviderWidget(
//                   subTitleString:
//                   'اشترك بخطتك المناسبة وابدأ بنشر عروضك بطريقة جذابة واحترافية، '
//                       'ووصلها للعملاء القريبين منك بخريطة تفاعلية.',
//                 ),
//                 SizedBox(height: ManagerHeight.h21),
//
//                 /// ===== Card =====
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(height: ManagerHeight.h16),
//
//                       /// عنوان الخطة
//                       const TitleContainerWidget(title: 'الخطة المختارة'),
//                       SizedBox(height: ManagerHeight.h8),
//
//                       /// اسم الخطة
//                       TitlePlanNameWidget(title: plan.planName),
//                       SizedBox(height: ManagerHeight.h4),
//
//                       /// السعر
//                       RowWithDollarIconPriceWidget(
//                         pricePlan: plan.planPrice.toString(),
//                       ),
//                       SizedBox(height: ManagerHeight.h12),
//
//                       /// Dropdown مدة الاشتراك (من السيرفر)
//                       LabelDropDownSubscriptionWidget<double>(
//                         label: "مدة الإشتراك",
//                         hint: "اختر مدة الإشتراك",
//                         value: plan.days,
//                         items: controller.plans
//                             .map((p) => DropdownMenuItem<double>(
//                           value: p.days,
//                           child: Text("${p.days.toInt()} يوم"),
//                         ))
//                             .toList(),
//                         onChanged: (val) {
//                           if (val != null) {
//                             controller.selectPlanByDays(val);
//                           }
//                         },
//                       ),
//                       SizedBox(height: ManagerHeight.h12),
//
//                       /// الميزات
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: ManagerWidth.w16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "الميزات المشمولة",
//                               style: getBoldTextStyle(
//                                 fontSize: ManagerFontSize.s14,
//                                 color: ManagerColors.black,
//                               ),
//                             ),
//                             SizedBox(height: ManagerHeight.h4),
//                             FeatureItem(text: plan.planFeatures),
//                           ],
//                         ),
//                       ),
//
//                       SizedBox(height: ManagerHeight.h16),
//                       ButtonApp(
//                         title: "الاشتراك في هذه الخطة",
//                         onPressed: () {
//                           // زر الاشتراك
//                           controller.selectPlanByDays(plan.days);
//                         },
//                         paddingWidth: ManagerWidth.w14,
//                       ),
//                       SizedBox(height: ManagerHeight.h8),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//                 Text(
//                   "من الممكن تغيير الباقة التي قمت باختيارها بعد انتهاء المدة الحالية "
//                       "أو عن طريق التواصل مع الدعم الفني.",
//                   textAlign: TextAlign.center,
//                   style: getRegularTextStyle(
//                     fontSize: ManagerFontSize.s10,
//                     color: ManagerColors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
//
// /// ===== Reusable Widget for Feature Item =====
// class FeatureItem extends StatelessWidget {
//   final String text;
//
//   const FeatureItem({super.key, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           const Icon(Icons.check_circle,
//               color: ManagerColors.primaryColor, size: 20),
//           SizedBox(width: ManagerWidth.w4),
//           Expanded(
//             child: Text(
//               text,
//               style: getRegularTextStyle(
//                 fontSize: ManagerFontSize.s12,
//                 color: ManagerColors.titleDropDownSubscriptionWidget,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
// // import 'package:app_mobile/core/resources/manager_colors.dart';
// // import 'package:app_mobile/core/resources/manager_height.dart';
// // import 'package:app_mobile/core/resources/manager_width.dart';
// // import 'package:app_mobile/core/widgets/button_app.dart';
// // import 'package:app_mobile/features/common/common_widgets/subscription_screen_widgets/title_plan_name_widget.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart'; // مهم لاستعمال Get.locale
// //
// // import '../../../../../../core/resources/manager_font_size.dart';
// // import '../../../../../../core/resources/manager_strings.dart';
// // import '../../../../../../core/resources/manager_styles.dart';
// // import '../../../../../../core/widgets/custom_header_subscription_widget.dart';
// // import '../../../../../common/common_widgets/subscription_screen_widgets/label_drop_down_subscription_widget.dart';
// // import '../../../../../common/common_widgets/subscription_screen_widgets/row_with_dollar_icon_price_widget.dart';
// // import '../../../../../common/common_widgets/subscription_screen_widgets/sub_title_subscription_offer_provider_widget.dart';
// // import '../../../../../common/common_widgets/subscription_screen_widgets/title_container_widget.dart';
// // import '../../../../../common/common_widgets/subscription_screen_widgets/title_subscription_offer_provider_widget.dart';
// //
// // class SubscriptionOfferProviderScreen extends StatelessWidget {
// //   const SubscriptionOfferProviderScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         backgroundColor: ManagerColors.primaryColor,
// //         appBar: CustomHeader(
// //           title: ManagerStrings.subscribeNow,
// //           onBack: () {
// //             Navigator.pop(context);
// //           },
// //         ),
// //         body: SizedBox(
// //           width: double.infinity,
// //           child: Padding(
// //             padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   SizedBox(
// //                     height: ManagerHeight.h42,
// //                   ),
// //
// //                   ///======== Title Widget Text ======
// //                    TitleSubscriptionOfferProviderWidget(
// //                       title: ManagerStrings.subscribeDescription1),
// //                   SizedBox(
// //                     height: ManagerHeight.h4,
// //                   ),
// //
// //                   ///======== Sub Title Text ======
// //                    SubTitleSubscriptionOfferProviderWidget(
// //                     subTitleString:
// //                         ManagerStrings.subscribeDescription,
// //                   ),
// //                   SizedBox(
// //                     height: ManagerHeight.h21,
// //                   ),
// //
// //                   ///======= Container Choose Plan
// //                   Container(
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         SizedBox(
// //                           height: ManagerHeight.h16,
// //                         ),
// //
// //                         /// ============ Plan Title  =============
// //                          TitleContainerWidget(
// //                           title: ManagerStrings.popularPlan,
// //                         ),
// //                         SizedBox(height: ManagerHeight.h8),
// //
// //                         /// ============ Plan Name  =============
// //                          TitlePlanNameWidget(title: "Super"),
// //
// //                         SizedBox(height: ManagerHeight.h4),
// //
// //                         /// ====== Price Plan Widget ========
// //                         const RowWithDollarIconPriceWidget(
// //                           pricePlan: '59.99',
// //                         ),
// //
// //                         ///======= Drop Down Type  Company Widget =======
// //                         LabelDropDownSubscriptionWidget<String>(
// //                           label: ManagerStrings.institutionType,
// //                           hint: "اختر نوع المؤسسة",
// //                           value: "مطعم",
// //                           items: const [
// //                             DropdownMenuItem(value: "مطعم", child: Text("مطعم")),
// //                             DropdownMenuItem(
// //                                 value: "سوبرماركت", child: Text("سوبرماركت")),
// //                             DropdownMenuItem(value: "مقهى", child: Text("مقهى")),
// //                           ],
// //                           onChanged: (val) {
// //                             print("تم الاختيار: $val");
// //                           },
// //                         ),
// //
// //                         SizedBox(
// //                           height: ManagerHeight.h12,
// //                         ),
// //
// //                         ///======= Drop Down Type Plan Time =======
// //                         LabelDropDownSubscriptionWidget<String>(
// //                           label: "مدة الإشتراك",
// //                           hint: "اختر مدة الإشتراك",
// //                           value: "شهرية",
// //                           items: const [
// //                             DropdownMenuItem(
// //                                 value: "شهرية", child: Text("شهرية")),
// //                             DropdownMenuItem(
// //                                 value: "سنوية", child: Text("سنوية")),
// //                             DropdownMenuItem(
// //                                 value: "نصف سنوية", child: Text("نصف سنوية")),
// //                           ],
// //                           onChanged: (val) {
// //                             print("تم الاختيار: $val");
// //                           },
// //                         ),
// //
// //                         ///========== Column With Padding 16 Feature
// //                         Padding(
// //                           padding:
// //                               EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               SizedBox(
// //                                 height: ManagerHeight.h8,
// //                               ),
// //                               Text(
// //                                 "الميزات المشمولة",
// //                                 style: getBoldTextStyle(
// //                                   fontSize: ManagerFontSize.s14,
// //                                   color: ManagerColors.black,
// //                                 ),
// //                               ),
// //                               SizedBox(
// //                                 height: ManagerHeight.h4,
// //                               ),
// //                               const FeatureItem(
// //                                   text: "نشر عدد محدد من العروض يومياً"),
// //                               const FeatureItem(
// //                                   text: "عرض موقع متجرك أو نشاطك على الخريطة"),
// //                               const FeatureItem(
// //                                   text: "إحصاءات وتقارير أداء العروض"),
// //                               const FeatureItem(
// //                                   text: "عرض منتجاتك في قنواتك بطريقة احترافية"),
// //                             ],
// //                           ),
// //                         ),
// //
// //                         SizedBox(height: ManagerHeight.h16),
// //                         ButtonApp(
// //                             title: "الاشتراك في هذه الخطة",
// //                             onPressed: () {},
// //                             paddingWidth: ManagerWidth.w14),
// //                         SizedBox(height: ManagerHeight.h8),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 12),
// //                   ///========== Text Hint
// //                   Text(
// //                     "من الممكن تغيير الباقة التي قمت باختيارها بعد انتهاء المدة الحالية "
// //                     "أو عن طريق التواصل مع الدعم الفني.",
// //                     textAlign: TextAlign.center,
// //                     style: getRegularTextStyle(
// //                       fontSize: ManagerFontSize.s10,
// //                       color: ManagerColors.white,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // /// ===== Reusable Widget for Feature Item =====
// // class FeatureItem extends StatelessWidget {
// //   final String text;
// //
// //   const FeatureItem({super.key, required this.text});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4),
// //       child: Row(
// //         children: [
// //           const Icon(Icons.check_circle,
// //               color: ManagerColors.primaryColor, size: 20),
// //           SizedBox(width: ManagerWidth.w4),
// //           Expanded(
// //             child: Text(
// //               text,
// //               style: getRegularTextStyle(
// //                   fontSize: ManagerFontSize.s12,
// //                   color: ManagerColors.titleDropDownSubscriptionWidget),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
