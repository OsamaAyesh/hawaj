import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/util/snack_bar.dart';
import '../controller/get_applications_job_controller.dart';

class GetApplicationsJobScreen extends StatefulWidget {
  final String jobId;

  const GetApplicationsJobScreen({super.key, required this.jobId});

  @override
  State<GetApplicationsJobScreen> createState() =>
      _GetApplicationsJobScreenState();
}

class _GetApplicationsJobScreenState extends State<GetApplicationsJobScreen> {
  late final GetJobApplicationsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<GetJobApplicationsController>();
    controller.fetchJobApplications(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "تفاصيل الطلبات",
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        final data = controller.jobApplications.value?.data;
        if (data == null || data.job == null) {
          return const Center(child: Text("لا توجد بيانات متاحة."));
        }

        final job = data.job!;
        final applications = data.applications ?? [];

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w16,
              vertical: ManagerHeight.h16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 عنوان الوظيفة
                Text(
                  job.jobTitle,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s18,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(height: ManagerHeight.h8),

                /// 🔹 وصف الوظيفة (فقرة كاملة)
                Text(
                  job.jobShortDescription,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s13,
                    color: ManagerColors.greyWithColor,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(height: ManagerHeight.h20),

                /// 🟣 تاريخ انتهاء التقديم
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: ManagerHeight.h12,
                    horizontal: ManagerWidth.w12,
                  ),
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      job.applicationDeadline,
                      style: getMediumTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ManagerHeight.h16),

                /// عنوان القسم + عدد المتقدمين
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "قائمة الطلبات",
                      style: getMediumTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.black,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ManagerWidth.w10,
                        vertical: ManagerHeight.h4,
                      ),
                      decoration: BoxDecoration(
                        color: ManagerColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "عدد المتقدمين ${applications.length}",
                        style: getMediumTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ManagerHeight.h16),

                /// 🔹 الطلبات
                ...applications.map((app) {
                  final resume = app.resume;
                  return Container(
                    margin: EdgeInsets.only(bottom: ManagerHeight.h14),
                    padding: EdgeInsets.all(ManagerHeight.h14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// 👤 صورة المتقدم
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                resume?.personalPhoto ?? "",
                                width: ManagerWidth.w55,
                                height: ManagerWidth.w55,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.person, size: 55),
                              ),
                            ),
                            SizedBox(width: ManagerWidth.w12),

                            /// 📋 معلومات المتقدم
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "#${resume?.mobileNumber ?? '-'}",
                                    style: getMediumTextStyle(
                                      fontSize: ManagerFontSize.s14,
                                      color: ManagerColors.black,
                                    ),
                                  ),
                                  SizedBox(height: ManagerHeight.h4),
                                  Text(
                                    resume?.jobTitlesSeeking ?? "اسم المتقدم",
                                    style: getRegularTextStyle(
                                      fontSize: ManagerFontSize.s13,
                                      color: ManagerColors.black,
                                    ),
                                  ),
                                  SizedBox(height: ManagerHeight.h4),
                                  Text(
                                    app.applicationDate,
                                    style: getRegularTextStyle(
                                      fontSize: ManagerFontSize.s12,
                                      color: ManagerColors.greyWithColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// ❌ ✅ الأزرار الصغيرة (رفض - قبول)
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () {
                                      AppSnackbar.warning("تم رفض الطلب");
                                    },
                                  ),
                                ),
                                SizedBox(width: ManagerWidth.w8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.check,
                                        color: Colors.green),
                                    onPressed: () {
                                      AppSnackbar.success("تم قبول الطلب");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: ManagerHeight.h16),

                        /// زر رؤية السيرة الذاتية
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ManagerColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "رؤية السيرة الذاتية",
                            style: getRegularTextStyle(
                                fontSize: ManagerFontSize.s12,
                                color: ManagerColors.white),
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h8),

                        if (resume?.cvFile != null)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ManagerColors.primaryColor.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              AppSnackbar.success("تم بدء التنزيل");
                            },
                            child: const Text(
                              "تنزيل",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
