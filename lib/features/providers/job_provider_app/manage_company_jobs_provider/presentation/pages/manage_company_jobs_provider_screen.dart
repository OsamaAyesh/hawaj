import 'package:app_mobile/constants/constants/constants.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/presentation/pages/add_jobs_provider_screen.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/presentation/list_company_jobs_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_strings.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';
import '../../../../../../core/storage/local/app_settings_prefs.dart';
import '../../../../../../core/widgets/quick_access_widget.dart';
import '../../../../../../core/widgets/scaffold_with_back_button.dart';
import '../../../../../common/map/domain/di/di.dart';
import '../../../../../common/map/presenation/controller/hawaj_map_data_controller.dart';
import '../../../../../common/map/presenation/pages/map_screen.dart';
import '../../../add_job_provider/domain/di/di.dart' show initAddJobsModule;
import '../../../list_company_job/domain/di/di.dart'
    show initGetListCompanyJobs;
import '../../../manager_jobs_provider/domain/di/di.dart' show initGetListJobs;
import '../../../manager_jobs_provider/presentation/presentation/pages/manager_jobs_provider_screen.dart';

class ManageCompanyJobsProviderScreen extends StatefulWidget {
  const ManageCompanyJobsProviderScreen({super.key});

  @override
  State<ManageCompanyJobsProviderScreen> createState() =>
      _ManageCompanyJobsProviderScreenState();
}

class _ManageCompanyJobsProviderScreenState
    extends State<ManageCompanyJobsProviderScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  final appSettingsPrefs = instance<AppSettingsPrefs>();
  List<Map<String, String>> itemsManagerProviderJobs = [];
  late List<VoidCallback> quickAccessActions;

  @override
  void initState() {
    super.initState();
    itemsManagerProviderJobs = Constants.itemsManagerProviderJobs;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    quickAccessActions = [
      () {
        if (kDebugMode) {
          print("شركاتي");
        }
        initGetListCompanyJobs();
        Get.to(ListCompanyJobsScreen());
      },
      () {
        if (kDebugMode) {
          print("إضافة وظيفة");
        }
        initAddJobsModule();
        Get.to(AddJobsProviderScreen());
      },
      () {
        if (kDebugMode) {
          print("إدارة الوظائف");
        }
        initGetListJobs();
        Get.to(ManagerJobsScreen());
      },
      () {
        if (kDebugMode) {
          print("إدارة بيانات الشركة");
        }
      },
    ];

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScaffoldWithBackButton(
          onBack: () {
            Get.put(HawajMapDataController(), permanent: true);
            Get.to(
              () => const MapScreen(),
              binding: MapBindings(),
            );
          },
          title: ManagerStrings.realEstateManagementTitle,
          body: Column(
            children: [
              SizedBox(height: ManagerHeight.h14),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ManagerWidth.w16),
                            child: Text(
                              ManagerStrings.quickAccess,
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s12,
                                color: ManagerColors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: ManagerHeight.h4),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ManagerWidth.w16),
                            child: GridView.builder(
                              padding: EdgeInsets.only(top: ManagerHeight.h8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio:
                                    ManagerWidth.w164 / ManagerHeight.h156,
                              ),
                              itemCount: itemsManagerProviderJobs.length,
                              itemBuilder: (context, index) {
                                final item = itemsManagerProviderJobs[index];
                                return QuickAccessWidget(
                                  iconPath: item['icon'] ?? "",
                                  title: item['title'] ?? "",
                                  subtitle: item['subtitle'] ?? "",
                                  onTap: quickAccessActions[index],
                                  top: ManagerHeight.h8,
                                  right: ManagerWidth.w6,
                                  left: ManagerWidth.w6,
                                  bottom: ManagerHeight.h8,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ManagerHeight.h16),
            ],
          ),
        ),
      ],
    );
  }
}
