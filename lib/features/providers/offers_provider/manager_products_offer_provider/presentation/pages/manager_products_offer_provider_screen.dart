import 'package:app_mobile/constants/constants/constants.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/storage/local/app_settings_prefs.dart';
import '../../../../../../core/widgets/quick_access_widget.dart';

class ManagerProductsOfferProviderScreen extends StatefulWidget {
  const ManagerProductsOfferProviderScreen({super.key});

  @override
  State<ManagerProductsOfferProviderScreen> createState() => _ManagerProductsOfferProviderScreenState();
}

class _ManagerProductsOfferProviderScreenState extends State<ManagerProductsOfferProviderScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  final appSettingsPrefs = instance<AppSettingsPrefs>();
  List<Map<String, String>> itemsOfferManagerProvider = [];
  late List<VoidCallback> quickAccessActions;

  @override
  void initState() {
    super.initState();
    itemsOfferManagerProvider = Constants.itemsOfferManagerProvider;

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
          print("إدارة المنتجات");
        }

      },
          () {
        if (kDebugMode) {
          print("إضافة منتج");
        }

      },
          () {
        if (kDebugMode) {
          print("تفاصيل المنشأة");
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
    return ScaffoldWithBackButton(
      title: ManagerStrings.productManagement,
      body: Column(
        children: [
          SizedBox(height: ManagerHeight.h14,),
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
                      SizedBox(height: ManagerHeight.h4,),
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
                          itemCount: itemsOfferManagerProvider.length,
                          itemBuilder: (context, index) {
                            final item = itemsOfferManagerProvider[index];
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
    );

  }
}
