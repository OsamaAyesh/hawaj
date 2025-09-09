import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

import '../widgets/circle_icon_widget.dart';

class CompanyWithOfferScreen extends StatelessWidget {
  final int idOrganization;
  const CompanyWithOfferScreen({super.key,required this.idOrganization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: Stack(children: [
        Image.asset(
          ManagerImages.imageRemoveIt,
          height: ManagerHeight.h239,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ManagerHeight.h51,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w16,
              ),
              child: Row(
                children: [
                  ///==== This Icon Arrow Back Widget
                  CircleIconWidget(
                    icon: Icons.arrow_back,
                    onPressed: () {},
                  ),

                  ///==== Spacer Between Widgets
                  Spacer(),

                  ///==== Share And Favorite Icons
                  CircleIconWidget(
                    icon: Icons.share_outlined,
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: ManagerWidth.w12,
                  ),
                  CircleIconWidget(
                    icon: Icons.favorite_border,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ManagerHeight.h80,
            ),
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
                      color: ManagerColors.black.withOpacity(0.01),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: Offset(
                        0,
                        2,
                      ),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: ManagerHeight.h8,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(ManagerRadius.r4),
                            child: Image.asset(
                              ManagerImages.image3remove,
                              height: ManagerHeight.h64,
                              width: ManagerWidth.w64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: ManagerWidth.w8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "شاورما الضيعة",
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s12,
                                  color: ManagerColors.black,
                                ),
                              ),
                              SizedBox(
                                height: ManagerHeight.h2,
                              ),
                              Text(
                                "شاورما, مشاوي , أكل شرقي , أكل غربي",
                                style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s8,
                                  color: ManagerColors.colorCompanyDetails,
                                ),
                              ),
                              SizedBox(
                                height: ManagerHeight.h4,
                              ),
                              Container(
                                height: ManagerHeight.h14,
                                decoration: BoxDecoration(
                                  color: ManagerColors.colorCompanyDetails2,
                                  borderRadius: BorderRadius.circular(
                                    ManagerRadius.r2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ManagerWidth.w8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: Color(0XFFE2A80B),
                                        size: 12,
                                      ),
                                      SizedBox(
                                        width: ManagerWidth.w2,
                                      ),
                                      Text(
                                        "4.5",
                                        style: getBoldTextStyle(
                                          fontSize: ManagerFontSize.s8,
                                          color: ManagerColors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: ManagerWidth.w2,
                                      ),
                                      Text(
                                        "(+1,000)",
                                        style: getBoldTextStyle(
                                          fontSize: ManagerFontSize.s6,
                                          color:
                                              ManagerColors.colorCompanyDetails,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                          Container(
                            height: ManagerHeight.h18,
                            padding: EdgeInsets.symmetric(
                              horizontal: ManagerWidth.w6,
                              vertical: ManagerHeight.h4,
                            ),
                            decoration: BoxDecoration(
                                color: ManagerColors.primaryColor,
                                borderRadius:
                                    BorderRadius.circular(ManagerRadius.r2)),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  color: ManagerColors.white,
                                  size: 12,
                                ),
                                SizedBox(
                                  width: ManagerWidth.w2,
                                ),
                                Text(
                                  "962799988776",
                                  style: getRegularTextStyle(
                                    fontSize: ManagerFontSize.s8,
                                    color: ManagerColors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ManagerHeight.h6,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ManagerWidth.w12,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: ManagerColors.black,
                          ),
                          SizedBox(
                            width: ManagerWidth.w2,
                          ),
                          Text(
                            "25-40 دقيقة للوصول بالسيارة",
                            style: getRegularTextStyle(
                              fontSize: ManagerFontSize.s8,
                              color: ManagerColors.black,
                            ),
                          ),
                          SizedBox(
                            width: ManagerWidth.w6,
                          ),
                          const Icon(
                            Icons.location_pin,
                            size: 12,
                            color: ManagerColors.black,
                          ),
                          SizedBox(
                            width: ManagerWidth.w2,
                          ),
                          Text(
                            "دوار الداخلية، شارع عبدالله غوشة",
                            style: getRegularTextStyle(
                              fontSize: ManagerFontSize.s8,
                              color: ManagerColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ManagerHeight.h6,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
                      child: Container(
                          height: ManagerHeight.h25,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(ManagerRadius.r4),
                              color:
                                  ManagerColors.primaryColor.withOpacity(0.1)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ManagerWidth.w8,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "يعمل من الساعة 7:00 صباحا وحتى 10:00 مساءا  كل يوم ما عدا الخميس",
                                  style: getRegularTextStyle(
                                    fontSize: ManagerFontSize.s8,
                                    color: ManagerColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: ManagerHeight.h8,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ManagerHeight.h14,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w16,
              ),
              child: Text(
                "قائمة المنتجات",
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.primaryColor,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
