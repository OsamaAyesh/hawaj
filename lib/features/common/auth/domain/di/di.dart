import 'package:app_mobile/features/common/auth/data/data_source/send_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/domain/use_case/send_otp_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../constants/di/dependency_injection.dart';
import '../../../../../core/network/app_api.dart';

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

  // Get.put(LoginController(
  //   instance<LoginUseCase>(),
  //   instance<AppSettingsPrefs>(),
  // ));
}

void disposeSendOtp() {
  disposeSendOtpRequest();
  // Get.delete<LoginController>();
}