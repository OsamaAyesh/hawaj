import 'package:app_mobile/constants/constants/constants.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_global_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/storage/local/app_settings_prefs.dart';
import '../../../../../common/hawaj_voice/presentation/controller/hawaj_ai_controller.dart';
import '../../../add_offer/domain/di/di.dart';
import '../../../add_offer/presentation/pages/add_offer_provider_screen.dart';
// إضافة هذا الـ import

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

    // تفعيل حواج بعد بناء الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeHawaj();
    });
  }

  void _initializeHawaj() {
    try {
      final controller = Get.find<HawajAIController>();
      controller.show();
      controller.updateContext('2', '1', message: '''
🛍️ أهلاً بك في إدارة المنتجات!

يمكنني مساعدتك في:
- إضافة منتجات جديدة
- إدارة المنتجات الحالية  
- عرض تفاصيل المنشأة

فقط اضغط علي واسألني أي شيء!
        ''');
    } catch (e) {
      print('خطأ في تهيئة حواج: $e');
    }
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
        // ScaffoldWithBackButton(
        //   title: ManagerStrings.productManagement,
        //   body: Column(
        //     children: [
        //       SizedBox(height: ManagerHeight.h14),
        //       Expanded(
        //         child: SingleChildScrollView(
        //           physics: const BouncingScrollPhysics(),
        //           child: FadeTransition(
        //             opacity: _fade,
        //             child: SlideTransition(
        //               position: _slide,
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Padding(
        //                     padding: EdgeInsets.symmetric(
        //                         horizontal: ManagerWidth.w16),
        //                     child: Text(
        //                       ManagerStrings.quickAccess,
        //                       style: getBoldTextStyle(
        //                         fontSize: ManagerFontSize.s12,
        //                         color: ManagerColors.black,
        //                       ),
        //                     ),
        //                   ),
        //                   SizedBox(height: ManagerHeight.h4),
        //                   Padding(
        //                     padding: EdgeInsets.symmetric(
        //                         horizontal: ManagerWidth.w16),
        //                     child: GridView.builder(
        //                       padding: EdgeInsets.only(top: ManagerHeight.h8),
        //                       shrinkWrap: true,
        //                       physics: const NeverScrollableScrollPhysics(),
        //                       gridDelegate:
        //                           SliverGridDelegateWithFixedCrossAxisCount(
        //                         crossAxisCount: 2,
        //                         crossAxisSpacing: 12,
        //                         mainAxisSpacing: 12,
        //                         childAspectRatio:
        //                             ManagerWidth.w164 / ManagerHeight.h156,
        //                       ),
        //                       itemCount: itemsOfferManagerProvider.length,
        //                       itemBuilder: (context, index) {
        //                         final item = itemsOfferManagerProvider[index];
        //                         return QuickAccessWidget(
        //                           iconPath: item['icon'] ?? "",
        //                           title: item['title'] ?? "",
        //                           subtitle: item['subtitle'] ?? "",
        //                           onTap: quickAccessActions[index],
        //                           top: ManagerHeight.h8,
        //                           right: ManagerWidth.w6,
        //                           left: ManagerWidth.w6,
        //                           bottom: ManagerHeight.h8,
        //                         );
        //                       },
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //       SizedBox(height: ManagerHeight.h16),
        //     ],
        //   ),
        // ),
        HawajGlobalWidget(section: "1", screen: "2")
        // حواج المساعد الذكي - مباشرة
        // GetX<HawajAIController>(
        //   builder: (controller) {
        //     if (!controller.isVisible) {
        //       return const SizedBox.shrink();
        //     }
        //
        //     return Positioned(
        //       left: 20,
        //       bottom: 100,
        //       child: GestureDetector(
        //         onTap: () => _handleHawajTap(controller),
        //         child: AnimatedContainer(
        //           duration: const Duration(milliseconds: 400),
        //           width: controller.isExpanded ? 280 : 70,
        //           height: controller.isExpanded ? 150 : 70,
        //           decoration: BoxDecoration(
        //             gradient: LinearGradient(
        //               colors: [
        //                 controller.stateColor,
        //                 controller.stateColor.withOpacity(0.8),
        //               ],
        //             ),
        //             borderRadius:
        //                 BorderRadius.circular(controller.isExpanded ? 20 : 35),
        //             boxShadow: [
        //               BoxShadow(
        //                 color: controller.stateColor.withOpacity(0.4),
        //                 blurRadius: controller.isListening ? 20 : 10,
        //                 spreadRadius: controller.isListening ? 5 : 2,
        //               ),
        //             ],
        //           ),
        //           child: controller.isExpanded
        //               ? _buildExpandedHawaj(controller)
        //               : _buildCompactHawaj(controller),
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _buildCompactHawaj(HawajAIController controller) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            controller.stateIcon,
            key: ValueKey(controller.currentState),
            color: Colors.white,
            size: 32,
          ),
        ),
        if (controller.isProcessing)
          const SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: Colors.white70,
              strokeWidth: 3,
            ),
          ),
      ],
    );
  }

  Widget _buildExpandedHawaj(HawajAIController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(controller.stateIcon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${controller.stateEmoji} حواج',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => controller.collapse(),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Message
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                controller.currentMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMiniButton(
                controller.isListening ? Icons.mic_off : Icons.mic,
                () => controller.toggleListening(),
              ),
              if (controller.isSpeaking)
                _buildMiniButton(Icons.stop, () => controller.stopSpeaking()),
              _buildMiniButton(Icons.refresh, () => controller.clearResponse()),
            ],
          ),
        ],
      ),
    );
  }

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

  void _handleHawajTap(HawajAIController controller) {
    if (controller.isExpanded) {
      controller.toggleListening();
    } else {
      controller.expand();
    }
  }
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
