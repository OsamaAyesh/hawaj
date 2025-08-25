import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_response.dart';
import 'package:app_mobile/features/splash_and_boarding/data/response/on_boarding_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../constants/env/env_constants.dart';
import '../../constants/request_constants/request_constants.dart';
import '../../constants/request_constants/request_constants_endpoints.dart';
import '../../features/common/auth/data/response/verfiy_otp_response.dart';
import '../service/env_service.dart';

part 'app_api.g.dart';

@RestApi()
abstract class AppService {
  factory AppService(Dio dio) {
    return _AppService(
      dio,
      baseUrl: EnvService.getString(
        key: EnvConstants.apiUrl,
      ),
    );
  }

  ///On Boarding Request
  @GET(RequestConstantsEndpoints.login)
  Future<OnBoardingResponse> getOnBoardingData(
      );

  ///==== Send Otp Request
  @POST(RequestConstantsEndpoints.sendOtp)
  Future<SendOtpResponse> sendOtp(
      @Field(RequestConstants.phone) String phone,
      );

  ///==== Verfiy Otp Request
  @POST(RequestConstantsEndpoints.verfiyOtp)
  Future<VerfiyOtpResponse> verfiyOtp(
      @Field(RequestConstants.phone) String phone,
      @Field(RequestConstants.otp) String otp,
      );

}
