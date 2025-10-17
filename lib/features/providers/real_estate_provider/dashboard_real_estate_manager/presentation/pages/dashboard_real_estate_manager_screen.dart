import 'package:app_mobile/constants/constants/constants.dart';
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
import '../../../../../common/map/presenation/pages/map_screen.dart';
import '../../../edit_profile_real_state_owner/domain/di/di.dart';
import '../../../edit_profile_real_state_owner/presentation/pages/edit_profile_real_state_owner_screen.dart';
import '../../../register_to_real_estate_provider_service/domain/di/di.dart'
    show initAddMyPropertyOwners;
import '../../../register_to_real_estate_provider_service/presentation/pages/register_to_real_estate_provider_service_screen.dart';

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
          print("إضافة عقار");
        }
        initAddMyPropertyOwners();
        Get.to(RegisterToRealEstateProviderServiceScreen());
      },
      () {
        if (kDebugMode) {
          // initGetMyCompany();
          // Get.to(ManageListOfferProviderScreen());
          print("عقاراتي");
        }
      },
      () {
        if (kDebugMode) {
          initEditProfileMyPropertyOwnerModule();
          Get.to(EditProfileRealStateOwnerScreen());
          print("تعديل بياناتي");
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
