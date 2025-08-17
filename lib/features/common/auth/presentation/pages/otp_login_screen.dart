import 'dart:async';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/features/common/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/resources/manager_opacity.dart';
import '../../../../../core/routes/custom_transitions.dart';
import '../widgets/sub_title_text_auth_widget.dart';
import '../widgets/title_auth_text_widget.dart';

class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({super.key});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  Timer? _timer;
  int _seconds = 59;
  bool _isTimerFinished = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer([int from = 59]) {
    _timer?.cancel();
    setState(() {
      _seconds = from;
      _isTimerFinished = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        setState(() => _isTimerFinished = true);
        timer.cancel();
      }
    });
  }

  String get timerText {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ManagerHeight.h146),

            ///This Icon Otp Verfication
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w14,
                vertical: ManagerHeight.h14,
              ),
              height: ManagerHeight.h64,
              width: ManagerWidth.w64,
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor
                    .withOpacity(ManagerOpacity.op0_14),
                borderRadius: BorderRadius.circular(ManagerRadius.r24),
              ),
              child: Image.asset(
                ManagerIcons.otpIcon,
                width: ManagerWidth.w36,
                height: ManagerHeight.h36,
              ),
            ),

            SizedBox(height: ManagerHeight.h16),

            ///Title Otp Screen
            TitleAuthTextWidget(
              title: ManagerStrings.otpTitle,
            ),
            SizedBox(height: ManagerHeight.h6),

            ///Subtitle Otp Screen
            SubTitleTextAuthWidget(
              subTitle: ManagerStrings.otpSubtitle,
            ),
            SizedBox(height: ManagerHeight.h4),

            ///Phone Number Text Widget
            Text(
              "966597450057+",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.black,
              ),
            ),
            SizedBox(height: ManagerHeight.h42),

            ///Otp Widget
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                child: Pinput(
                  controller: TextEditingController(),
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: ManagerWidth.w56,
                    height: ManagerHeight.h56,
                    textStyle: getBoldTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.black,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ManagerRadius.r8),
                      border: Border.all(
                        color: ManagerColors.primaryColor.withOpacity(
                          0.5,
                        ),
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: ManagerWidth.w56,
                    height: ManagerHeight.h56,
                    textStyle: getBoldTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.black,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ManagerRadius.r8),
                      border: Border.all(
                        color: ManagerColors.primaryColor,
                        width: 1,
                      ),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: ManagerWidth.w56,
                    height: ManagerHeight.h56,
                    textStyle: getBoldTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.black,
                    ),
                    decoration: BoxDecoration(
                      color: ManagerColors.backgroundColorOtp.withOpacity(0.24),
                      borderRadius: BorderRadius.circular(ManagerRadius.r8),
                      border: Border.all(color: ManagerColors.primaryColor),
                    ),
                  ),
                  followingPinTheme: PinTheme(
                    width: ManagerWidth.w56,
                    height: ManagerHeight.h56,
                    textStyle: getBoldTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.black.withOpacity(0.5),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ManagerRadius.r8),
                      border: Border.all(
                        color: ManagerColors.greyWithColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: ManagerHeight.h20),

            ///Timer Widget
            Text(
              timerText,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.black,
              ),
            ),
            SizedBox(height: ManagerHeight.h8),

            ///Show I didn't get code Resend It
            if (_isTimerFinished)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ManagerStrings.otpDidNotReceive,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.black,
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w4),
                  GestureDetector(
                    onTap: () {
                      startTimer();
                    },
                    child: Text(
                      ManagerStrings.otpResend,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.gery1OnBoarding,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: ManagerHeight.h32,
            ),

            ///Button Verfied Text
            ButtonApp(
              title: ManagerStrings.otpVerifyButton,
              onPressed: () {},
              paddingWidth: ManagerWidth.w12,
            ),
          ],
        ),
      ),
    );
  }
}
