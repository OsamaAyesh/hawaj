import 'package:app_mobile/features/common/auth/data/data_source/completed_profile_data_source.dart';
import 'package:app_mobile/features/common/auth/data/data_source/send_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/data_source/verfiy_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/repository/completed_profile_repository.dart';
import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/repository/verfiy_otp_repository.dart';
import 'package:app_mobile/features/common/auth/domain/use_case/send_otp_use_case.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';

import '../../../../../constants/di/dependency_injection.dart';
import '../../../../../core/network/app_api.dart';
import '../../presentation/controller/completed_profile_controller.dart';
import '../../presentation/controller/send_otp_controller.dart';
import '../use_case/completed_profile_use_case.dart';
import '../use_case/verfiy_otp_use_case.dart';

initSendOtpRequest() {
  if (!GetIt.I.isRegistered<SendOtpDataSource>()) {
    instance.registerLazySingleton<SendOtpDataSource>(
            () => SendOtpDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<SendOtpRepository>()) {
    instance.registerLazySingleton<SendOtpRepository>(
            () => SendOtpRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<SendOtpUseCase>()) {
    instance.registerFactory<SendOtpUseCase>(
            () => SendOtpUseCase(instance<SendOtpRepository>()));
  }
}

disposeSendOtpRequest() {
  if (GetIt.I.isRegistered<SendOtpDataSource>()) {
    instance.unregister<SendOtpDataSource>();
  }

  if (GetIt.I.isRegistered<SendOtpRepository>()) {
    instance.unregister<SendOtpRepository>();
  }

  if (GetIt.I.isRegistered<SendOtpUseCase>()) {
    instance.unregister<SendOtpUseCase>();
  }
}

void initSendOtp() {
  initSendOtpRequest();
  initVerfiyOtp();
  Get.put(SendOtpController(
    instance<SendOtpUseCase>(),
    instance<VerfiyOtpUseCase>(),
  ));
}

void disposeSendOtp() {
  disposeSendOtpRequest();
  Get.delete<SendOtpController>();
}

initVerfiyOtpRequest() {
  if (!GetIt.I.isRegistered<VerfiyOtpDataSource>()) {
    instance.registerLazySingleton<VerfiyOtpDataSource>(
            () => VerfiyOtpDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<VerfiyOtpRepository>()) {
    instance.registerLazySingleton<VerfiyOtpRepository>(
            () => VerfiyOtpRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<VerfiyOtpUseCase>()) {
    instance.registerFactory<VerfiyOtpUseCase>(
            () => VerfiyOtpUseCase(instance<VerfiyOtpRepository>()));
  }
}

disposeVerfiyOtpRRequest() {
  if (GetIt.I.isRegistered<VerfiyOtpDataSource>()) {
    instance.unregister<VerfiyOtpDataSource>();
  }

  if (GetIt.I.isRegistered<VerfiyOtpRepository>()) {
    instance.unregister<VerfiyOtpRepository>();
  }

  if (GetIt.I.isRegistered<VerfiyOtpUseCase>()) {
    instance.unregister<VerfiyOtpUseCase>();
  }
}

void initVerfiyOtp() {
  initVerfiyOtpRequest();

  // Get.put(LoginController(
  //   instance<LoginUseCase>(),
  //   instance<AppSettingsPrefs>(),
  // ));
}

void disposeVerfiyOtp() {
  disposeVerfiyOtpRRequest();
  // Get.delete<LoginController>();
}


initCompletedProfileRequest() {
  if (!GetIt.I.isRegistered<CompletedProfileDataSource>()) {
    instance.registerLazySingleton<CompletedProfileDataSource>(
            () => CompletedProfileDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<CompletedProfileRepository>()) {
    instance.registerLazySingleton<CompletedProfileRepository>(
            () => CompletedProfileRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<CompletedProfileUseCase>()) {
    instance.registerFactory<CompletedProfileUseCase>(
            () => CompletedProfileUseCase(instance<CompletedProfileRepository>()));
  }
}

disposeCompletedProfileRequest() {
  if (GetIt.I.isRegistered<CompletedProfileDataSource>()) {
    instance.unregister<CompletedProfileDataSource>();
  }

  if (GetIt.I.isRegistered<CompletedProfileRepository>()) {
    instance.unregister<CompletedProfileRepository>();
  }

  if (GetIt.I.isRegistered<CompletedProfileRepository>()) {
    instance.unregister<CompletedProfileRepository>();
  }
}

void initCompletedProfile() {
  initCompletedProfileRequest();

  Get.put(CompletedProfileController(
    instance<CompletedProfileUseCase>(),
  ));
}

void disposeCompletedProfile() {
  disposeCompletedProfileRequest();
  Get.delete<CompletedProfileController>();
}