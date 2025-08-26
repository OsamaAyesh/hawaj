import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/features/common/auth/presentation/pages/otp_login_screen.dart';
import 'package:app_mobile/features/common/auth/presentation/pages/success_login_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../constants/di/dependency_injection.dart';
import '../../../../../core/storage/local/app_settings_prefs.dart';
import '../../domain/use_case/send_otp_use_case.dart';
import '../../domain/use_case/verfiy_otp_use_case.dart';
import '../../data/request/send_otp_request.dart';
import '../../data/request/verfiy_otp_request.dart';
import '../../domain/model/send_otp_model.dart';
import '../../domain/model/verfiy_otp_model.dart';
import '../../../../../core/routes/routes.dart';

class SendOtpController extends GetxController {
  final SendOtpUseCase _sendOtpUseCase;
  final VerfiyOtpUseCase _verfiyOtpUseCase;

  SendOtpController(this._sendOtpUseCase, this._verfiyOtpUseCase);

  /// Loading state
  var isLoading = false.obs;

  /// Error message
  var errorMessage = "".obs;

  /// OTP response data
  Rx<SendOtpModel?> otpData = Rx<SendOtpModel?>(null);

  /// Verify response data
  Rx<VerfiyOtpModel?> verifyData = Rx<VerfiyOtpModel?>(null);

  /// Send OTP
  Future<void> sendOtp(String phone) async {
    if (phone.trim().isEmpty) {
      final msg = Get.locale?.languageCode == 'ar'
          ? "الرجاء إدخال رقم الهاتف"
          : "Please enter your phone number";
      AppSnackbar.error(msg,);
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";
    otpData.value = null;

    final request = SendOtpRequest(phone: phone);

    final result = await _sendOtpUseCase.execute(request);

    result.fold(
          (failure) {
        errorMessage.value = failure.message;
        AppSnackbar.error(errorMessage.value,);
      },
          (data) {
        otpData.value = data;
        final msg = Get.locale?.languageCode == 'ar'
            ? "تم إرسال رمز التحقق بنجاح"
            : "OTP sent successfully";
        AppSnackbar.success(msg,);


        /// Navigate to OTP scree
        Get.to(OtpLoginScreen(phoneNumber: phone));
      },
    );

    isLoading.value = false;
  }

  /// Verify OTP
  Future<void> verifyOtp(String phone, String otp) async {
    if (otp.trim().isEmpty) {
      final msg = Get.locale?.languageCode == 'ar'
          ? "الرجاء إدخال رمز التحقق"
          : "Please enter the OTP code";
      AppSnackbar.error(msg,);

      return;
    }

    isLoading.value = true;
    errorMessage.value = "";
    verifyData.value = null;

    final request = VerfiyOtpRequest(phone: phone, otp: otp);

    final result = await _verfiyOtpUseCase.execute(request);

    result.fold(
          (failure) {
        errorMessage.value = failure.message;
        AppSnackbar.error(errorMessage.value);
      },
          (data) async {
        verifyData.value = data;

        final msg = Get.locale?.languageCode == 'ar'
            ? "تم التحقق بنجاح "
            : "Verification successful ";
        AppSnackbar.success(msg);

        ///  Save login state
        await instance<AppSettingsPrefs>().setUserLoggedIn();

        ///  Save token
        final token = data.data.token; // assuming VerfiyOtpModel has data.token
        if (token.isNotEmpty) {
          await instance<AppSettingsPrefs>().setToken(token: token);
        }

        /// Navigate to Success screen
        Get.offAll(() => const SuccessLoginScreen());
      },
    );

    isLoading.value = false;
  }
}
