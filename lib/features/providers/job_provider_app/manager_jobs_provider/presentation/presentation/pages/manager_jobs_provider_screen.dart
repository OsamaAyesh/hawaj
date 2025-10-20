import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_tab_bar_widget.dart';

class ManagerJobsScreen extends StatelessWidget {
  const ManagerJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "إدارة الوظائف",
      body: CustomTabBarWidget(
        tabs: const ["الوظائف المتاحة", "الوظائف الغير متاحة"],
        indicatorColor: ManagerColors.white,
        backgroundColor: ManagerColors.primaryColor.withOpacity(0.1),
        views: const [
          _JobsListView(isAvailable: true),
          _JobsListView(isAvailable: false),
        ],
      ),
    );
  }
}

class _JobsListView extends StatelessWidget {
  final bool isAvailable;

  const _JobsListView({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
        vertical: ManagerHeight.h16,
      ),
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: ManagerHeight.h12),
      itemBuilder: (_, index) {
        return Container(
          padding: EdgeInsets.all(ManagerWidth.w12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ManagerRadius.r12),
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
              /// ===== الصف العلوي: المتقدمين والمشاهدات =====
              Row(
                children: [
                  Icon(Icons.people_outline,
                      size: ManagerFontSize.s14,
                      color: ManagerColors.primaryColor),
                  SizedBox(width: ManagerWidth.w4),
                  Text(
                    "22 متقدم",
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.black.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w16),
                  Icon(Icons.remove_red_eye_outlined,
                      size: ManagerFontSize.s14,
                      color: ManagerColors.primaryColor),
                  SizedBox(width: ManagerWidth.w4),
                  Text(
                    "37 مشاهد",
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ManagerHeight.h6),

              /// ===== تاريخ الانتهاء =====
              Text(
                "تاريخ الانتهاء: 14-07-2024",
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s11,
                  color: ManagerColors.black.withOpacity(0.5),
                ),
              ),
              SizedBox(height: ManagerHeight.h12),

              /// ===== الصف الأوسط: بيانات الوظيفة والصورة =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// ===== بيانات الوظيفة =====
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مهندس برمجيات",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.black,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h4),
                        Text(
                          "دوام كامل",
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.black.withOpacity(0.5),
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h6),
                        Row(
                          children: [
                            Text(
                              "\$5,000 - \$1,000",
                              style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s12,
                                color: ManagerColors.primaryColor,
                              ),
                            ),
                            SizedBox(width: ManagerWidth.w4),
                            Icon(Icons.attach_money_rounded,
                                size: ManagerFontSize.s14,
                                color: ManagerColors.primaryColor),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// ===== صورة الوظيفة =====
                  ClipRRect(
                    borderRadius: BorderRadius.circular(ManagerRadius.r8),
                    child: Image.asset(
                      ManagerImages.image3remove,
                      width: width * 0.22,
                      height: width * 0.22,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ManagerHeight.h16),

              /// ===== الأزرار =====
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: ManagerHeight.h40,
                      decoration: BoxDecoration(
                        color: ManagerColors.primaryColor,
                        borderRadius: BorderRadius.circular(ManagerRadius.r8),
                      ),
                      child: Center(
                        child: Text(
                          "إدارة الوظيفة",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w8),
                  Expanded(
                    child: Container(
                      height: ManagerHeight.h40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: ManagerColors.primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(ManagerRadius.r8),
                      ),
                      child: Center(
                        child: Text(
                          "إدارة الطلبات",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
