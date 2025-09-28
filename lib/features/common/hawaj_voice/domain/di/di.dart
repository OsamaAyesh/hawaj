import 'package:app_mobile/core/network/app_api.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/controller/hawaj_ai_controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../data/data_source/send_data_to_hawaj_data_source.dart';
import '../../data/repository/send_data_to_hawaj_repositoy.dart';
import '../use_cases/send_data_to_hawaj_use_case.dart';

final GetIt instance = GetIt.instance;

initSendDataRequest() {
  if (!GetIt.I.isRegistered<SendDataToHawajDataSource>()) {
    instance.registerLazySingleton<SendDataToHawajDataSource>(
        () => SendDataToHawajDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<SendDataToHawajRepositoy>()) {
    instance.registerLazySingleton<SendDataToHawajRepositoy>(
        () => SendDataToHawajRepositoyImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<SendDataToHawajUseCase>()) {
    instance.registerFactory<SendDataToHawajUseCase>(
        () => SendDataToHawajUseCase(instance<SendDataToHawajRepositoy>()));
  }
}

disposeSendDataRequest() {
  if (GetIt.I.isRegistered<SendDataToHawajDataSource>()) {
    instance.unregister<SendDataToHawajDataSource>();
  }

  if (GetIt.I.isRegistered<SendDataToHawajRepositoy>()) {
    instance.unregister<SendDataToHawajRepositoy>();
  }

  if (GetIt.I.isRegistered<SendDataToHawajUseCase>()) {
    instance.unregister<SendDataToHawajUseCase>();
  }
}

void initHawajAI() {
  initSendDataRequest();

  // Get.put(HawajAIController());
  Get.put(HawajController(instance<SendDataToHawajUseCase>()));
}

void disposeHawajAI() {
  disposeSendDataRequest();
  Get.delete<HawajController>();
}
