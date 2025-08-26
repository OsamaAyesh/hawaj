import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../../constants/di/dependency_injection.dart';
import '../../../../../core/locale/locale_controller.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/storage/local/app_settings_prefs.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  String? selectedLang;

  /// يغير اللغة مباشرة لما المستخدم يختار
  Future<void> _selectLanguage(String lang) async {
    setState(() {
      selectedLang = lang;
    });

    final localeController = Get.find<LocaleController>();
    await localeController.changeLanguage(lang);

    /// حفظ اللغة مباشرة
    // await instance<AppSettingsPrefs>().setLocale(lang);
  }

  Future<void> _confirmLanguage() async {
    if (selectedLang == null) {
      AppSnackbar.warning("يجب اختيار اللغة");
      return;
    }

    /// تعليم أن المستخدم شاف شاشة اختيار اللغة
    await instance<AppSettingsPrefs>().setViewedChooseLanguage();

    /// الانتقال بعد التأكيد
    Get.offAllNamed(Routes.onBoardingScreen);
  }

  @override
  void initState() {
    super.initState();
    final prefs = instance<AppSettingsPrefs>();
    selectedLang = prefs.getLocale() ?? "ar";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: ManagerHeight.h130),

          /// Logo
          Center(
            child: Image.asset(
              ManagerImages.logoSecondWithPrimaryColor,
              height: ManagerHeight.h156,
              width: ManagerWidth.w180,
              fit: BoxFit.contain,
            )
                .animate()
                .fadeIn(duration: 700.ms)
                .scale(curve: Curves.easeOutBack, duration: 700.ms),
          ),

          SizedBox(height: ManagerHeight.h42),

          /// Title
          Text(
            ManagerStrings.chooseLanguageTitle,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s20,
              color: ManagerColors.primaryColor,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

          /// Subtitle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w34),
            child: Text(
              ManagerStrings.chooseLanguageSubtitle,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.chooseLanguageSubtitleColor,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 500.ms)
                .slideY(begin: 0.3, end: 0),
          ),

          SizedBox(height: ManagerHeight.h42),

          /// Arabic Button
          _buildLangButton(
            lang: "ar",
            bgColor: ManagerColors.primaryColor,
            title: ManagerStrings.arabic,
            subtitle: ManagerStrings.arabicEn,
            textColor: Colors.white,
            delay: 700,
          ),

          SizedBox(height: ManagerHeight.h16),

          /// English Button
          _buildLangButton(
            lang: "en",
            bgColor: ManagerColors.secondColor,
            title: ManagerStrings.english,
            subtitle: ManagerStrings.englishAr,
            textColor: ManagerColors.black,
            delay: 900,
          ),

          const Spacer(),

          /// Confirm Button
          ElevatedButton(
            onPressed: _confirmLanguage,
            style: ElevatedButton.styleFrom(
              backgroundColor: ManagerColors.primaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w34,
                vertical: ManagerHeight.h12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ManagerRadius.r6),
              ),
            ),
            child: Text(
              selectedLang == "ar" ? "متابعة" : "Continue",
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s14,
                color: Colors.white,
              ),
            ),
          ).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.3, end: 0),

          SizedBox(height: ManagerHeight.h24),
        ],
      ),
    );
  }

  Widget _buildLangButton({
    required String lang,
    required Color bgColor,
    required String title,
    required String subtitle,
    required Color textColor,
    required int delay,
  }) {
    final bool isSelected = selectedLang == lang;

    return GestureDetector(
      onTap: () => _selectLanguage(lang),
      child: Container(
        height: ManagerHeight.h58,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: ManagerWidth.w24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(ManagerRadius.r4),
          border: Border.all(
            color: isSelected ? Colors.transparent : bgColor,
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: bgColor.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
              : [],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: textColor.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Icon(Icons.check_circle,
                    color: textColor, size: ManagerHeight.h20),
              ]
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(delay: delay.ms, duration: 500.ms)
          .slideX(
          begin: lang == "ar" ? -0.3 : 0.3, end: 0, curve: Curves.easeOut),
    );
  }
}
