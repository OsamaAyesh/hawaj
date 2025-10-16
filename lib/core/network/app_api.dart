import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_response.dart';
import 'package:app_mobile/features/common/profile/data/response/get_profile_response.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_response.dart';
import 'package:app_mobile/features/splash_and_boarding/data/response/on_boarding_response.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/response/get_company_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../constants/env/env_constants.dart';
import '../../constants/request_constants/request_constants.dart';
import '../../constants/request_constants/request_constants_endpoints.dart';
import '../../features/common/auth/data/response/verfiy_otp_response.dart';
import '../../features/common/hawaj_voice/data/response/send_data_response.dart';
import '../../features/providers/offers_provider/add_offer/data/response/get_my_company_set_offer_response.dart';
import '../../features/providers/offers_provider/details_my_company/data/response/get_my_company_details_response.dart';
import '../../features/providers/offers_provider/subscription_offer_provider/data/response/get_my_organization_offer_provider_response.dart';
import '../../features/users/offer_user/list_offers/data/response/get_organizations_response.dart';
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
  Future<OnBoardingResponse> getOnBoardingData();

  ///==== Send Otp Request
  @POST(RequestConstantsEndpoints.sendOtp)
  Future<SendOtpResponse> sendOtp(@Field(RequestConstants.phone) String phone,);

  ///==== Verfiy Otp Request
  @POST(RequestConstantsEndpoints.verfiyOtp)
  Future<VerfiyOtpResponse> verfiyOtp(
      @Field(RequestConstants.phone) String phone,
      @Field(RequestConstants.otp) String otp,);

  ///=> Offer Provider
  ///===== Get Plan Request
  @GET(RequestConstantsEndpoints.getPlans)
  Future<PlanResponse> getPlansOfferProvider();

  ///==== Register My Company Custom Offer Provider
  @POST(RequestConstantsEndpoints.registerMyCompanyOfferProvider)
  @MultiPart()
  Future<WithOutDataResponse> registerMyCompanyOfferProviderRequest(
      @Body() FormData formData);

  ///==== Create Offer Provider
  @POST(RequestConstantsEndpoints.createOfferProvider)
  @MultiPart()
  Future<WithOutDataResponse> createOfferProvider(@Body() FormData formData);

  ///====== Set Subscription Offer Provider Request.
  @POST(RequestConstantsEndpoints.setSubscriptionOfferProvider)
  Future<WithOutDataResponse> setSubscriptionOfferProvider(
      @Field(RequestConstants.organizationsId) int organizationsId,
      @Field(RequestConstants.plansId) int plansId,);

  // ///=== Get My Offer
  // @GET(RequestConstantsEndpoints.getMyOffer)
  // Future<OfferResponse> getMyOffer();

  ///===== Update Profile Request .======
  @PUT(RequestConstantsEndpoints.getMyOffer)
  Future<WithOutDataResponse> updateProfile(
      @Query(RequestConstants.name) String? name,);

  ///====== Update Avatar =====
  @POST(RequestConstantsEndpoints.updateAvatar)
  @MultiPart()
  Future<WithOutDataResponse> updateAvatar(@Body() FormData formData);

  ///=====Get Profile Request
  @GET(RequestConstantsEndpoints.getProfile)
  Future<GetProfileResponse> getProfile();

  // ///===== Get Offers Data
  // @GET(RequestConstantsEndpoints.getOffers)
  // Future<OfferUserResponse> getOffers(
  //   @Query(RequestConstants.language) String language,
  // );

  ///=== Get My Organization Request.
  @GET(RequestConstantsEndpoints.getCompany)
  Future<GetMyOrganizationOfferProviderResponse> getMyOrganizations(
      @Query(RequestConstants.language) String? language,
      @Query(RequestConstants.id) int? id,
      @Query(RequestConstants.my) bool? my,
      @Query(RequestConstants.lat) String? lat,
      @Query(RequestConstants.lng) String? lng,);

  ///===== Get Company Request By Id Org.
  @GET(RequestConstantsEndpoints.getCompany)
  Future<GetCompanyResponse> getCompany(@Query(RequestConstants.id) int id,);

  ///===== Completed Profile Request.
  @POST(RequestConstantsEndpoints.completedProfile)
  Future<WithOutDataResponse> completedProfile(
      @Query(RequestConstants.firstName) String firstName,
      @Query(RequestConstants.lastName) String lastName,
      @Query(RequestConstants.gender) int gender,
      @Query(RequestConstants.dateOfBirth) String dateOfBirth,);

  ///==================================================
  ///======= Get My Company Request.
  @GET(RequestConstantsEndpoints.getCompany)
  Future<GetMyCompanySetOfferResponse> getMyCompanySetOffer(
      @Query(RequestConstants.language) String? language,
      @Query(RequestConstants.id) int? id,
      @Query(RequestConstants.my) bool? my,
      @Query(RequestConstants.lat) String? lat,
      @Query(RequestConstants.lng) String? lng,);

  ///===== GetMyCompanyDetailsRequest.
  @GET(RequestConstantsEndpoints.getCompany)
  Future<GetMyCompanyDetailsResponse> getMyCompanyDetails(
      @Query(RequestConstants.language) String? language,
      @Query(RequestConstants.id) int? id,
      @Query(RequestConstants.my) bool? my,
      @Query(RequestConstants.lat) String? lat,
      @Query(RequestConstants.lng) String? lng,);

//===== Hawaj AI Send Data Request
  @POST(RequestConstantsEndpoints.sendData)
  Future<SendDataResponse> sendData(
      @Field(RequestConstants.stringUser) String stringUser,
      @Field(RequestConstants.lat) String lat,
      @Field(RequestConstants.lng) String lng,
      @Field(RequestConstants.language) String language,
      @Field(RequestConstants.q) String q,
      @Field(RequestConstants.s) String s,);

  ///====>Get Organizations
  ///
  @GET(RequestConstantsEndpoints.getCompany)
  Future<GetOrganizationsResponse> getOrganizations(
      @Query(RequestConstants.lat) String? lat,
      @Query(RequestConstants.lng) String? lng,
      @Query(RequestConstants.language) String? language,);

  ///====> Get Organization With Id Org.
  @GET(RequestConstantsEndpoints.getCompany)
  Future<GetCompanyResponse> getOrganization(
      @Query(RequestConstants.lat) String? lat,
      @Query(RequestConstants.id) double? id,
      @Query(RequestConstants.lng) String? lng,
      @Query(RequestConstants.language) String? language,);

  ///==== Add My Property Owners Request
  @POST(RequestConstantsEndpoints.addMyPropertyOwners)
  @MultiPart()
  Future<WithOutDataResponse> addMyPropertyOwners(@Body() FormData formData);
}
