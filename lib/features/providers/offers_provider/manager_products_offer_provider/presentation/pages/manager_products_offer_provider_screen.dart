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
import '../../../add_offer/domain/di/di.dart';
import '../../../add_offer/presentation/pages/add_offer_provider_screen.dart';

class ManagerProductsOfferProviderScreen extends StatefulWidget {
  const ManagerProductsOfferProviderScreen({super.key});

  @override
  State<ManagerProductsOfferProviderScreen> createState() =>
      _ManagerProductsOfferProviderScreenState();
}

class _ManagerProductsOfferProviderScreenState
    extends State<ManagerProductsOfferProviderScreen>
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
          print("إضافة منتج");
        }
        initCreateOfferProvider();
        Get.to(AddOfferProviderScreen());
      },
      () {
        if (kDebugMode) {
          print("إدارة المنتجات");
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
    return Stack(
      children: [
        ScaffoldWithBackButton(
          title: ManagerStrings.productManagement,
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
        ),
      ],
    );
  }

  // Widget _buildCompactHawaj(HawajAIController controller) {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: [
  //       AnimatedSwitcher(
  //         duration: const Duration(milliseconds: 300),
  //         child: Icon(
  //           controller.stateIcon,
  //           key: ValueKey(controller.currentState),
  //           color: Colors.white,
  //           size: 32,
  //         ),
  //       ),
  //       if (controller.isProcessing)
  //         const SizedBox(
  //           width: 50,
  //           height: 50,
  //           child: CircularProgressIndicator(
  //             color: Colors.white70,
  //             strokeWidth: 3,
  //           ),
  //         ),
  //     ],
  //   );
  // }

  // Widget _buildExpandedHawaj(HawajAIController controller) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Header
  //         Row(
  //           children: [
  //             Icon(controller.stateIcon, color: Colors.white, size: 20),
  //             const SizedBox(width: 8),
  //             Expanded(
  //               child: Text(
  //                 '${controller.stateEmoji} حواج',
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () => controller.collapse(),
  //               child: const Icon(Icons.close, color: Colors.white, size: 18),
  //             ),
  //           ],
  //         ),
  //
  //         const SizedBox(height: 8),
  //
  //         // Message
  //         Expanded(
  //           child: SingleChildScrollView(
  //             child: Text(
  //               controller.currentMessage,
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ),
  //         ),
  //
  //         // Controls
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             _buildMiniButton(
  //               controller.isListening ? Icons.mic_off : Icons.mic,
  //               () => controller.toggleListening(),
  //             ),
  //             if (controller.isSpeaking)
  //               _buildMiniButton(Icons.stop, () => controller.stopSpeaking()),
  //             _buildMiniButton(Icons.refresh, () => controller.clearResponse()),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMiniButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

// void _handleHawajTap(HawajAIController controller) {
//   if (controller.isExpanded) {
//     controller.toggleListening();
//   } else {
//     controller.expand();
//   }
// }
}
// import 'package:app_mobile/constants/constants/constants.dart';
// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_font_size.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_strings.dart';
// import 'package:app_mobile/core/resources/manager_styles.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
// import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_voice_extension.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
//
// import '../../../../../../constants/di/dependency_injection.dart';
// import '../../../../../../core/storage/local/app_settings_prefs.dart';
// import '../../../../../../core/widgets/quick_access_widget.dart';
// import '../../../add_offer/domain/di/di.dart';
// import '../../../add_offer/presentation/pages/add_offer_provider_screen.dart';
//
// class ManagerProductsOfferProviderScreen extends StatefulWidget {
//   const ManagerProductsOfferProviderScreen({super.key});
//
//   @override
//   State<ManagerProductsOfferProviderScreen> createState() =>
//       _ManagerProductsOfferProviderScreenState();
// }
//
// class _ManagerProductsOfferProviderScreenState
//     extends State<ManagerProductsOfferProviderScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fade;
//   late Animation<Offset> _slide;
//   final appSettingsPrefs = instance<AppSettingsPrefs>();
//   List<Map<String, String>> itemsOfferManagerProvider = [];
//   late List<VoidCallback> quickAccessActions;
//
//   @override
//   void initState() {
//     super.initState();
//     itemsOfferManagerProvider = Constants.itemsOfferManagerProvider;
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//
//     _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _slide =
//         Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//     );
//     quickAccessActions = [
//       () {
//         if (kDebugMode) {
//           print("إضافة منتج");
//         }
//         initCreateOfferProvider();
//         Get.to(AddOfferProviderScreen());
//       },
//       () {
//         if (kDebugMode) {
//           print("إدارة المنتجات");
//         }
//       },
//       () {
//         if (kDebugMode) {
//           print("تفاصيل المنشأة");
//         }
//       },
//     ];
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldWithBackButton(
//       title: ManagerStrings.productManagement,
//       body: Column(
//         children: [
//           SizedBox(
//             height: ManagerHeight.h14,
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: FadeTransition(
//                 opacity: _fade,
//                 child: SlideTransition(
//                   position: _slide,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
//                         child: Text(
//                           ManagerStrings.quickAccess,
//                           style: getBoldTextStyle(
//                             fontSize: ManagerFontSize.s12,
//                             color: ManagerColors.black,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: ManagerHeight.h4,
//                       ),
//                       Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
//                         child: GridView.builder(
//                           padding: EdgeInsets.only(top: ManagerHeight.h8),
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 12,
//                             mainAxisSpacing: 12,
//                             childAspectRatio:
//                                 ManagerWidth.w164 / ManagerHeight.h156,
//                           ),
//                           itemCount: itemsOfferManagerProvider.length,
//                           itemBuilder: (context, index) {
//                             final item = itemsOfferManagerProvider[index];
//                             return QuickAccessWidget(
//                               iconPath: item['icon'] ?? "",
//                               title: item['title'] ?? "",
//                               subtitle: item['subtitle'] ?? "",
//                               onTap: quickAccessActions[index],
//                               top: ManagerHeight.h8,
//                               right: ManagerWidth.w6,
//                               left: ManagerWidth.w6,
//                               bottom: ManagerHeight.h8,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: ManagerHeight.h16),
//         ],
//       ),
//     ).withHawajVoiceAdvanced(
//       section: '2',
//       screen: '1',
//       welcomeMessage: 'مرحباً بك في إدارة المنتجات!',
//       expandOnShow: true,
//     );
//   }
// }
