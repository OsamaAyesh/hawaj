import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';

class AvailableJobsUserScreen extends StatelessWidget {
  const AvailableJobsUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobs = List.generate(6, (index) => index); // بيانات مؤقتة

    return ScaffoldWithBackButton(
      title: "الوظائف المتاحة",
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w14,
          vertical: ManagerHeight.h10,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final bool isPrimaryJob = index == 0;

          return Container(
            margin: EdgeInsets.only(bottom: ManagerHeight.h14),
            decoration: BoxDecoration(
              color: ManagerColors.white,
              borderRadius: BorderRadius.circular(ManagerRadius.r10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: ManagerHeight.h6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: ManagerWidth.w8,
                  ),

                  /// ===== صورة الوظيفة =====
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: ManagerHeight.h8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(ManagerRadius.r10),
                      child: Image.asset(
                        ManagerImages.removeRealState,
                        width: ManagerWidth.w85,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// ===== المحتوى =====
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ManagerWidth.w10,
                        vertical: ManagerHeight.h8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ===== المتقدمين والتاريخ =====
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ManagerWidth.w6,
                                  vertical: ManagerHeight.h3,
                                ),
                                decoration: BoxDecoration(
                                  color: ManagerColors.primaryColor
                                      .withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(
                                    ManagerRadius.r6,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "37 متقدم ومشاهد",
                                      style: getMediumTextStyle(
                                        fontSize: ManagerHeight.h11,
                                        color: ManagerColors.primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: ManagerWidth.w4),
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: ManagerHeight.h13,
                                      color: ManagerColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h5),
                              Text(
                                "تاريخ الانتهاء: 2024-07-14",
                                style: getRegularTextStyle(
                                  fontSize: ManagerHeight.h11,
                                  color: ManagerColors.colorGrey,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: ManagerHeight.h8),

                          /// ===== عنوان الوظيفة =====
                          Text(
                            "مهندس برمجيات",
                            style: getBoldTextStyle(
                              fontSize: ManagerHeight.h14,
                              color: ManagerColors.primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: ManagerHeight.h3),

                          /// ===== الشركة =====
                          Text(
                            "شركة الإستشارات التقنية",
                            style: getRegularTextStyle(
                              fontSize: ManagerHeight.h12,
                              color: ManagerColors.colorDescription,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: ManagerHeight.h5),

                          /// ===== الراتب =====
                          Row(
                            children: [
                              Icon(
                                Icons.attach_money_rounded,
                                size: ManagerHeight.h14,
                                color: ManagerColors.primaryColor,
                              ),
                              SizedBox(width: ManagerWidth.w3),
                              Text(
                                "\$1000 - \$5,000",
                                style: getBoldTextStyle(
                                  fontSize: ManagerHeight.h12,
                                  color: ManagerColors.primaryColor,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: ManagerHeight.h10),

                          /// ===== الأزرار =====
                          Row(
                            children: [
                              if (!isPrimaryJob)
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ManagerColors.redStatus
                                          .withOpacity(0.15),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            ManagerRadius.r6),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: ManagerHeight.h8,
                                      ),
                                    ),
                                    child: Text(
                                      "إلغاء",
                                      style: getBoldTextStyle(
                                        fontSize: ManagerHeight.h12,
                                        color: ManagerColors.redStatus,
                                      ),
                                    ),
                                  ),
                                ),
                              if (!isPrimaryJob)
                                SizedBox(width: ManagerWidth.w6),
                              Expanded(
                                flex: isPrimaryJob ? 1 : 2,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isPrimaryJob
                                        ? ManagerColors.primaryColor
                                        : Colors.green,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ManagerRadius.r6),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: ManagerHeight.h8,
                                    ),
                                  ),
                                  child: Text(
                                    isPrimaryJob
                                        ? "تفاصيل الوظيفة"
                                        : "عرض التفاصيل",
                                    style: getMediumTextStyle(
                                      fontSize: ManagerHeight.h12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
