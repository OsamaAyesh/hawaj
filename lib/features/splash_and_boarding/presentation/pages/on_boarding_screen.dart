import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/routes/custom_transitions.dart';
import '../../../../core/storage/local/app_settings_prefs.dart';
import '../../../../core/widgets/button_app.dart';
import '../../../../core/routes/routes.dart';
import '../../../common/auth/presentation/pages/login_screen.dart';
import '../../domain/model/on_boarding_model.dart';
import '../controller/get_on_boarding_controller.dart';
import '../model_view/on_boarding_model.dart';
import '../widgets/container_page_indicator.dart';
import '../widgets/body_on_boarding_widget.dart';
import '../widgets/skip_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  final controller = Get.find<OnBoardingPreloadController>();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: Obx(() {
        final items = controller.items;

        if (items.isEmpty) {
          ///====If there is no data, go to the login screen
          Future.microtask(() => Get.offAllNamed(Routes.loginScreen));
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            Column(
              children: [
                /// Pages
                Expanded(
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _pageController,
                    itemCount: items.length,
                    onPageChanged: (index) {
                      setState(() => currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final page = items[index];

                      return BodyOnBoardingWidget(
                        onBoardingModel: OnBoardingPageModel(
                          image: controller.getImageUrl(page),
                          title: page.mainTitle,
                          subtitle: page.screenDescription,
                          heightImage: ManagerHeight.h297,
                          widthImage: ManagerWidth.w329,
                          heightSizeBoxBeforeImage: ManagerHeight.h140,
                          heightSizeBoxBeforeTextAfterImage: ManagerHeight.h16,
                        ),
                        fromNetwork: true,
                      );
                    },
                  ),
                ),

                /// Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(items.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: ContainerPageIndicator(
                        selected: currentIndex == index,
                        marginEnd: index != items.length - 1 ? 12.0 : 0.0,
                      ),
                    );
                  }),
                ),

                SizedBox(height: ManagerHeight.h120),

                /// Next / Login Button
                ButtonApp(
                  title: currentIndex == items.length - 1
                      ? ManagerStrings.login
                      : ManagerStrings.next,
                  onPressed: () async {
                    if (currentIndex == items.length - 1) {
                      if (kDebugMode) {
                        print("OnBoarding Finished ✅");
                        final prefs = instance<AppSettingsPrefs>();
                        Navigator.pushReplacementNamed(context, Routes.loginScreen);
                        prefs.setOutBoardingScreenViewed();
                      }
                      Navigator.of(context).pushReplacement(fadeSlideFromBottom(const LoginScreen()));
                      Get.offAllNamed(Routes.loginScreen);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  paddingWidth: ManagerWidth.w16,
                ),

                currentIndex == items.length - 1
                    ? SizedBox(height: ManagerHeight.h36)
                    : SkipButton(
                        onPressed: () {
                          final prefs = instance<AppSettingsPrefs>();
                          Navigator.pushReplacementNamed(context, Routes.loginScreen);
                          prefs.setOutBoardingScreenViewed();
                          Navigator.of(context).pushReplacement(fadeSlideFromBottom(const LoginScreen()));
                        },
                      ),
                SizedBox(height: ManagerHeight.h12),
              ],
            ),

            /// Skip (Top)
            Padding(
              padding: EdgeInsets.only(top: ManagerHeight.h28),
              child: Align(
                alignment: Get.locale?.languageCode == 'ar'
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      items.length - 1,
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
        );
      }),
    );
  }
}
