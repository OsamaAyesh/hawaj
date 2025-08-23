import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/presentation/model_view/offer_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/manager_icons.dart';
import 'offer_status_color.dart';

class OfferCard extends StatelessWidget {
  final OfferModel offer;

  const OfferCard({required this.offer, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ManagerRadius.r8),
        color: getStatusColor(offer),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(ManagerRadius.r8)),
                child: Image.asset(
                  ManagerImages.imageFoodOneRemove,
                  width: double.infinity,
                  height: ManagerHeight.h109,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: ManagerHeight.h6,
                left: ManagerWidth.w6,
                child: Container(
                  height: ManagerHeight.h24,
                  width: ManagerWidth.w24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ManagerWidth.w4,
                      vertical: ManagerHeight.h4,
                    ),
                    child: Image.asset(
                      ManagerIcons.editIconWidget,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: ManagerHeight.h8),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w5),
                    child: Text(
                      offer.name,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s10,
                        color: ManagerColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: ManagerHeight.h6,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w5),
                    child: Row(
                      children: [
                        Container(
                          // width: ManagerWidth.w70,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(ManagerRadius.r2),
                            color: ManagerColors.white.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ManagerHeight.h2,
                                horizontal: ManagerWidth.w12,
                              ),
                              child: Text(
                                "40 ريال سعودي",
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s6,
                                  color: ManagerColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w4,),
                        Text(
                          "45 ر.س",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s9,
                            color: ManagerColors.white,
                            decoration: TextDecoration.lineThrough,
                          ),
                          textDirection: TextDirection.rtl,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: ManagerHeight.h6,
          ),

          //
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w5),
            child: Container(
              // width: ManagerWidth.w70,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(ManagerRadius.r2),
                color: ManagerColors.white.withOpacity(0.2),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ManagerHeight.h2,
                    horizontal: ManagerWidth.w12,
                  ),
                  child: Text(
                    "05-07-2025",
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s6,
                      color: ManagerColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),          //
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w8),
          //   child: Row(
          //     children: [
          //       /// السعر القديم مشطوب
          //       Text(
          //         "40 ريال سعودي",
          //         style: getRegularTextStyle(
          //           fontSize: ManagerFontSize.s12,
          //           color: ManagerColors.greyWithColor,
          //         ).copyWith(decoration: TextDecoration.lineThrough),
          //       ),
          //       SizedBox(width: ManagerWidth.w8),
          //
          //       /// السعر الجديد داخل Container
          //       Container(
          //         padding: EdgeInsets.symmetric(
          //           horizontal: ManagerWidth.w8,
          //           vertical: ManagerHeight.h2,
          //         ),
          //         decoration: BoxDecoration(
          //           color: Colors.white.withOpacity(0.2),
          //           borderRadius: BorderRadius.circular(ManagerRadius.r4),
          //         ),
          //         child: Text(
          //           "10 ريال سعودي",
          //           style: getBoldTextStyle(
          //             fontSize: ManagerFontSize.s12,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          //
          // const Spacer(),
          //
          // /// زر أسفل الكارد (إعادة تفعيل العرض)
          // Container(
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.15),
          //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(ManagerRadius.r8)),
          //   ),
          //   padding: EdgeInsets.symmetric(vertical: ManagerHeight.h6),
          //   alignment: Alignment.center,
          //   child: Text(
          //     "إعادة تفعيل العرض",
          //     style: getBoldTextStyle(
          //       fontSize: ManagerFontSize.s12,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
