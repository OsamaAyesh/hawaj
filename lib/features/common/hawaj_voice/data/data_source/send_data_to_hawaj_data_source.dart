import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../constants/env/env_constants.dart';
import '../../../../../core/network/app_api.dart';
import '../request/send_data_request.dart';
import '../response/send_data_response.dart';

abstract class SendDataToHawajDataSource {
  Future<SendDataResponse> sendData(SendDataRequest request);
}

class SendDataToHawajDataSourceImplement implements SendDataToHawajDataSource {
  AppService _appService;

  // حماية ضد الطلبات المكررة
  bool _isSending = false;
  DateTime? _lastRequestTime;
  String? _lastRequestText;

  SendDataToHawajDataSourceImplement(this._appService);

  @override
  Future<SendDataResponse> sendData(SendDataRequest request) async {
    // منع الطلبات المكررة خلال ثانية واحدة
    final now = DateTime.now();
    if (_isSending &&
        _lastRequestText == request.strl &&
        _lastRequestTime != null &&
        now.difference(_lastRequestTime!).inMilliseconds < 1000) {
      debugPrint('⚠️ DataSource - منع طلب مكرر: "${request.strl}"');
      throw Exception('طلب مكرر تم منعه');
    }

    _isSending = true;
    _lastRequestTime = now;
    _lastRequestText = request.strl;

    try {
      if (dotenv.env[EnvConstants.debug].onNullBool()) {
        // Mock response for debugging
        return SendDataResponse.fromJson(
          json.decode(
            await rootBundle.rootBundle.loadString(
              ManagerMokUp.login,
            ),
          ),
        );
      }

      // Real API call using AppService
      final response = await _appService.sendData(
        request.strl,
        request.lat,
        request.lng,
        request.language,
        request.q,
        request.s,
      );

      debugPrint('✅ DataSource - استلام الرد بنجاح');

      return response;
    } catch (e) {
      debugPrint('❌ DataSource - خطأ: $e');
      rethrow;
    } finally {
      // إعادة تعيين بعد ثانيتين
      Future.delayed(const Duration(seconds: 2), () {
        _isSending = false;
      });
    }
  }
}
// import 'dart:convert';
//
// import 'package:app_mobile/core/extensions/extensions.dart';
// import 'package:app_mobile/core/resources/manager_mockup.dart';
// import 'package:flutter/services.dart' as rootBundle;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// import '../../../../../constants/env/env_constants.dart';
// import '../../../../../core/network/app_api.dart';
// import '../request/send_data_request.dart';
// import '../response/send_data_response.dart';
//
// abstract class SendDataToHawajDataSource {
//   Future<SendDataResponse> sendData(SendDataRequest request);
// }
//
// class SendDataToHawajDataSourceImplement implements SendDataToHawajDataSource {
//   AppService _appService;
//
//   SendDataToHawajDataSourceImplement(this._appService);
//
//   @override
//   Future<SendDataResponse> sendData(SendDataRequest request) async {
//     if (dotenv.env[EnvConstants.debug].onNullBool()) {
//       // Mock response for debugging
//       return SendDataResponse.fromJson(
//         json.decode(
//           await rootBundle.rootBundle.loadString(
//             ManagerMokUp.login, // Add this to ManagerMokUp
//           ),
//         ),
//       );
//     }
//
//     // Real API call using AppService
//     return await _appService.sendData(
//       request.strl,
//       request.lat,
//       request.lng,
//       request.language,
//       request.q,
//       request.s,
//     );
//   }
// }
