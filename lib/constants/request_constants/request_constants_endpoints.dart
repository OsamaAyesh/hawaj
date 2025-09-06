const String apiPath = "/api/auth/user";
const String apiUrlBase = "/api/v1";


class RequestConstantsEndpoints {
  static const String login = '$apiPath/login';
  static const String getOnBoarding = '$apiUrlBase/getwelcomescreens';
  static const String sendOtp = '$apiUrlBase/otpsend';
  static const String verfiyOtp = '$apiUrlBase/otpverify';
  static const String getPlans = '$apiUrlBase/offers/getplans';
  static const String registerMyCompanyOfferProvider = '$apiUrlBase/setorganizations';
  static const String createOfferProvider = '$apiUrlBase/setoffer';
  static const String setSubscriptionOfferProvider = '$apiUrlBase/setsubscriptions';
  static const String getMyOffer = '$apiUrlBase/getmyoffer';
  static const String updateProfile = '$apiUrlBase/myprofile';
  static const String updateAvatar = '$apiUrlBase/updateavatar';
  static const String getProfile = '$apiUrlBase/myprofile';
  static const String getOffers = '$apiUrlBase/getoffers';
  static const String getMyOrganizations = '$apiUrlBase/getmyorganization';
}
