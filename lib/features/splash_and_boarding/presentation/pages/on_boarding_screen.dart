import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/features/splash_and_boarding/presentation/widgets/body_on_boarding_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/routes/custom_transitions.dart';
import '../../../../core/storage/local/app_settings_prefs.dart';
import '../../../../core/widgets/button_app.dart';
import '../model_view/on_boarding_model.dart';
import '../widgets/container_page_indicator.dart';
import '../widgets/skip_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<OnBoardingModel> pages = [
      OnBoardingModel(
          image: ManagerImages.onBoardingImage1,
          title: ManagerStrings.page1Title,
          subtitle: ManagerStrings.page1Text,
          heightImage: ManagerHeight.h297,
          widthImage: ManagerWidth.w329,
          heightSizeBoxBeforeImage: ManagerHeight.h140,
          heightSizeBoxBeforeTextAfterImage: ManagerHeight.h24),
      OnBoardingModel(
          image: ManagerImages.onBoardingImage2,
          title: ManagerStrings.page2Title,
          subtitle: ManagerStrings.page2Text,
          heightImage: ManagerHeight.h297,
          widthImage: ManagerWidth.w329,
          heightSizeBoxBeforeImage: ManagerHeight.h140,
          heightSizeBoxBeforeTextAfterImage: ManagerHeight.h16),
      OnBoardingModel(
          image: ManagerImages.onBoardingImage3,
          title: ManagerStrings.page3Title,
          subtitle: ManagerStrings.page3Text,
          heightImage: ManagerHeight.h297,
          widthImage: ManagerWidth.w329,
          heightSizeBoxBeforeImage: ManagerHeight.h140,
          heightSizeBoxBeforeTextAfterImage: ManagerHeight.h16),
    ];

    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return BodyOnBoardingWidget(
                      onBoardingModel: page,
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: ContainerPageIndicator(
                      selected: currentIndex == index,
                      marginEnd: index != pages.length - 1 ? 12.0 : 0.0,
                    ),
                  );
                }),
              ),
              SizedBox(height: ManagerHeight.h120),
              ButtonApp(
                title: currentIndex == pages.length - 1
                    ? ManagerStrings.login
                    : ManagerStrings.next,
                onPressed: () async {
                  if (currentIndex == pages.length - 1) {
                    if (kDebugMode) {
                      print("Success");
                    }
                    // Navigator.of(context).push(
                    //   fadeRoute(const LoginScreen()),
                    // );
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                paddingWidth: ManagerWidth.w16,
              ),
              currentIndex == pages.length - 1
                  ? SizedBox(height: ManagerHeight.h36)
                  : SkipButton(
                onPressed: () {
                  _pageController.animateToPage(
                    pages.length - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              SizedBox(height: ManagerHeight.h12),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: ManagerHeight.h28),
            child: Align(
              alignment:  Get.locale?.languageCode == 'ar'?Alignment.topLeft:Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  _pageController.animateToPage(
                    pages.length - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  ManagerStrings.skip,
                  style: getRegularTextStyle(
                    color: ManagerColors.gery1OnBoarding,
                    fontSize: ManagerFontSize.s14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
