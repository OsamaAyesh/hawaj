import 'dart:async';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../controller/send_otp_controller.dart';
import '../widgets/sub_title_text_auth_widget.dart';
import '../widgets/title_auth_text_widget.dart';

class OtpLoginScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpLoginScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  Timer? _timer;
  int _seconds = 59;
  bool _isTimerFinished = false;

  /// Controller for OTP input
  final TextEditingController otpController = TextEditingController();

  /// GetX Controller
  final SendOtpController authController = Get.find<SendOtpController>();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
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
      body: Stack(
        children: [
          /// Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: ManagerHeight.h146),

                /// OTP Icon
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ManagerWidth.w14,
                    vertical: ManagerHeight.h14,
                  ),
                  height: ManagerHeight.h64,
                  width: ManagerWidth.w64,
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(ManagerRadius.r24),
                  ),
                  child: Image.asset(
                    ManagerIcons.otpIcon,
                    width: ManagerWidth.w36,
                    height: ManagerHeight.h36,
                  ),
                ),

                SizedBox(height: ManagerHeight.h16),

                /// Title
                TitleAuthTextWidget(title: ManagerStrings.otpTitle),
                SizedBox(height: ManagerHeight.h6),

                /// Subtitle
                SubTitleTextAuthWidget(subTitle: ManagerStrings.otpSubtitle),
                SizedBox(height: ManagerHeight.h4),

                /// Phone Number Text
                Text(
                  widget.phoneNumber,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(height: ManagerHeight.h42),

                /// OTP Input
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                    child: Pinput(
                      controller: otpController,
                      length: 6,
                      defaultPinTheme: _pinTheme(),
                      focusedPinTheme: _pinTheme(focused: true),
                      submittedPinTheme: _pinTheme(submitted: true),
                      followingPinTheme: _pinTheme(following: true),
                    ),
                  ),
                ),
                SizedBox(height: ManagerHeight.h20),

                /// Timer
                Text(
                  timerText,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(height: ManagerHeight.h8),

                /// Resend
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
                          authController.sendOtp(widget.phoneNumber);
                        },
                        child: Text(
                          ManagerStrings.otpResend,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.gery1OnBoarding,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: ManagerHeight.h32),

                /// Verify Button
                ButtonApp(
                  title: ManagerStrings.otpVerifyButton,
                  onPressed: () {
                    authController.verifyOtp(
                      widget.phoneNumber,
                      otpController.text,
                    );
                  },
                  paddingWidth: ManagerWidth.w12,
                ),
              ],
            ),
          ),

          ///  Loading Overlay
          Obx(() {
            return authController.isLoading.value
                ? const LoadingWidget()
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  PinTheme _pinTheme(
      {bool focused = false, bool submitted = false, bool following = false}) {
    return PinTheme(
      width: ManagerWidth.w56,
      height: ManagerHeight.h56,
      textStyle: getBoldTextStyle(
        fontSize: ManagerFontSize.s20,
        color: focused ? ManagerColors.primaryColor : ManagerColors.black,
      ),
      decoration: BoxDecoration(
        color: submitted
            ? ManagerColors.backgroundColorOtp.withOpacity(0.24)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(ManagerRadius.r8),
        border: Border.all(
          color: focused
              ? ManagerColors.primaryColor
              : following
                  ? ManagerColors.greyWithColor.withOpacity(0.3)
                  : ManagerColors.primaryColor.withOpacity(0.5),
          width: focused ? 1.5 : 1,
        ),
      ),
    );
  }
}
