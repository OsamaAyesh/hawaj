import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../core/model/job_item_model.dart';
import '../../../../../../../core/resources/manager_colors.dart';
import '../../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../../core/resources/manager_height.dart';
import '../../../../../../../core/resources/manager_images.dart';
import '../../../../../../../core/resources/manager_radius.dart';
import '../../../../../../../core/resources/manager_styles.dart';
import '../../../../../../../core/resources/manager_width.dart';
import '../../../../../../../core/widgets/custom_tab_bar_widget.dart';
import '../../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../../core/widgets/scaffold_with_back_button.dart';
import '../../../../get_applications_job/domain/di/di.dart';
import '../../../../get_applications_job/presentation/pages/get_applications_job_screen.dart';
import '../../../domain/di/di.dart';
import '../../controller/get_list_jobs_controller.dart';

class ManagerJobsScreen extends StatefulWidget {
  const ManagerJobsScreen({super.key});

  @override
  State<ManagerJobsScreen> createState() => _ManagerJobsScreenState();
}

class _ManagerJobsScreenState extends State<ManagerJobsScreen> {
  late ManagerJobsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ManagerJobsController>();
  }

  @override
  void dispose() {
    disposeGetListJobs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "إدارة الوظائف",
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        return CustomTabBarWidget(
          tabs: const ["الوظائف المتاحة", "الوظائف غير المتاحة"],
          indicatorColor: ManagerColors.white,
          backgroundColor: ManagerColors.primaryColor.withOpacity(0.1),
          views: [
            _JobsListView(isAvailable: true, jobs: controller.availableJobs),
            _JobsListView(isAvailable: false, jobs: controller.unavailableJobs),
          ],
        );
      }),
    );
  }
}

class _JobsListView extends StatelessWidget {
  final bool isAvailable;
  final List<JobItemModel> jobs;

  const _JobsListView({
    required this.isAvailable,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (jobs.isEmpty) {
      return Center(
        child: Text(
          isAvailable ? "لا توجد وظائف متاحة" : "لا توجد وظائف غير متاحة",
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s14,
            color: ManagerColors.black.withOpacity(0.5),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
        vertical: ManagerHeight.h16,
      ),
      itemCount: jobs.length,
      separatorBuilder: (_, __) => SizedBox(height: ManagerHeight.h12),
      itemBuilder: (_, index) {
        final job = jobs[index];

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
              /// ===== الصف العلوي: عدد المشاهدات =====
              Row(
                children: [
                  Icon(Icons.remove_red_eye_outlined,
                      size: ManagerFontSize.s14,
                      color: ManagerColors.primaryColor),
                  SizedBox(width: ManagerWidth.w4),
                  Text(
                    "${job.viewsCount} مشاهدة",
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
                "تاريخ الانتهاء: ${job.applicationDeadline}",
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s11,
                  color: ManagerColors.black.withOpacity(0.5),
                ),
              ),
              SizedBox(height: ManagerHeight.h12),

              /// ===== الصف الأوسط: بيانات الوظيفة =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// بيانات الوظيفة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.jobTitle,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.black,
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h4),
                        Text(
                          job.jobTypeLabel,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.black.withOpacity(0.5),
                          ),
                        ),
                        SizedBox(height: ManagerHeight.h6),
                        Row(
                          children: [
                            Text(
                              "${job.salary.isEmpty ? 'غير محدد' : job.salary} \$",
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

                  /// صورة الشركة (إن وجدت)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(ManagerRadius.r8),
                    child: Image.network(
                      job.company?.companyLogo ?? ManagerImages.image3remove,
                      width: width * 0.22,
                      height: width * 0.22,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        ManagerImages.image3remove,
                        width: width * 0.22,
                        height: width * 0.22,
                        fit: BoxFit.cover,
                      ),
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
                    child: GestureDetector(
                      onTap: () {
                        initGetJobApplications();
                        Get.to(GetApplicationsJobScreen(
                          jobId: job.id,
                        ));
                      },
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
