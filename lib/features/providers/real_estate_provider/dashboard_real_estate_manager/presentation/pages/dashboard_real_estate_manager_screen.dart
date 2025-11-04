import 'package:app_mobile/constants/constants/constants.dart';
import 'package:app_mobile/features/providers/real_estate_provider/get_real_estate_my_owners/presentation/pages/get_real_estate_my_owners_screen.dart';
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
import '../../../add_real_estate/domain/di/di.dart';
import '../../../add_real_estate/presentation/pages/add_real_estate_screen.dart';
import '../../../get_real_estate_my_owners/domain/di.dart';
import '../../../manager_my_real_estate_provider/domain/di/di.dart';
import '../../../manager_my_real_estate_provider/presentation/pages/manager_my_real_estate_provider_screen.dart';

class DashboardRealEstateManagerScreen extends StatefulWidget {
  const DashboardRealEstateManagerScreen({super.key});

  @override
  State<DashboardRealEstateManagerScreen> createState() =>
      _DashboardRealEstateManagerScreenState();
}

class _DashboardRealEstateManagerScreenState
    extends State<DashboardRealEstateManagerScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  final appSettingsPrefs = instance<AppSettingsPrefs>();
  List<Map<String, String>> itemsManagerProviderRealEstate = [];
  late List<VoidCallback> quickAccessActions;

  @override
  void initState() {
    super.initState();
    itemsManagerProviderRealEstate = Constants.itemsManagerProviderRealEstate;

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
          print("ملكياتي");
        }
        initGetPropertyOwnersModule();
        Get.to(GetRealEstateMyOwnersScreen());
      },
      () {
        if (kDebugMode) {
          print("عقاراتي");
        }
        initGetMyRealEstates();
        initDeleteMyRealEstate();
        Get.to(ManagerMyRealEstateProviderScreen());
      },
      () {
        if (kDebugMode) {
          print("إضافة عقار");
        }
        initAddRealEstateModule();
        Get.to(AddRealEstateScreen());
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
                              itemCount: itemsManagerProviderRealEstate.length,
                              itemBuilder: (context, index) {
                                final item =
                                    itemsManagerProviderRealEstate[index];
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
