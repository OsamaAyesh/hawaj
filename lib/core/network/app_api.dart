import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_response.dart';
import 'package:app_mobile/features/common/profile/data/response/get_profile_response.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/response/offer_response.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_response.dart';
import 'package:app_mobile/features/splash_and_boarding/data/response/on_boarding_response.dart';
import 'package:app_mobile/features/users/offer_user/list_offers/data/response/offer_user_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../constants/env/env_constants.dart';
import '../../constants/request_constants/request_constants.dart';
import '../../constants/request_constants/request_constants_endpoints.dart';
import '../../features/common/auth/data/response/verfiy_otp_response.dart';
import '../../features/providers/offers_provider/subscription_offer_provider/data/response/get_my_organization_offer_provider_response.dart';
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
  @GET(RequestConstantsEndpoints.getOnBoarding)
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

  ///=> Offer Provider
  ///===== Get Plan Request
  @GET(RequestConstantsEndpoints.getPlans)
  Future<PlanResponse> getPlansOfferProvider(
      );


  ///==== Register My Company Custom Offer Provider
  @POST(RequestConstantsEndpoints.registerMyCompanyOfferProvider)
  @MultiPart()
  Future<WithOutDataResponse> registerMyCompanyOfferProviderRequest(
      @Body() FormData formData
      );


  ///==== Create Offer Provider
  @POST(RequestConstantsEndpoints.createOfferProvider)
  @MultiPart()
  Future<WithOutDataResponse> createOfferProvider(
      @Body() FormData formData
      );

  ///====== Set Subscription Offer Provider Request.
  @POST(RequestConstantsEndpoints.setSubscriptionOfferProvider)
  Future<WithOutDataResponse> setSubscriptionOfferProvider(
      @Field(RequestConstants.organizationsId) int organizationsId,
      @Field(RequestConstants.plansId) int plansId,
      );

  ///=== Get My Offer
  @GET(RequestConstantsEndpoints.getMyOffer)
  Future<OfferResponse> getMyOffer(
      );

  ///===== Update Profile ======\
  @PUT(RequestConstantsEndpoints.getMyOffer)
  Future<WithOutDataResponse> updateProfile(
      @Query(RequestConstants.name) String? name,
      );

  ///====== Update Avatar =====
  @POST(RequestConstantsEndpoints.updateAvatar)
  @MultiPart()
  Future<WithOutDataResponse> updateAvatar(
      @Body() FormData formData
      );

  ///=====Get Profile Request
  @GET(RequestConstantsEndpoints.getProfile)
  Future<GetProfileResponse> getProfile(
      );


  ///===== Get Offers Data
  @GET(RequestConstantsEndpoints.getOffers)
  Future<OfferUserResponse> getOffers(
      );

  ///=== Get My Organization Request.
  @GET(RequestConstantsEndpoints.getMyOrganizations)
  Future<GetMyOrganizationOfferProviderResponse> getMyOrganizations(
      );

}
