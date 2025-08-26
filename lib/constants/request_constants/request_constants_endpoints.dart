const String apiPath = "/api/auth/user";
const String apiUrlBase = "/api/v1";


class RequestConstantsEndpoints {
  static const String login = '$apiPath/login';
  static const String getOnBoarding = '$apiUrlBase/getwelcomescreens';
  static const String sendOtp = '$apiUrlBase/otpsend';
  static const String verfiyOtp = '$apiUrlBase/otpverify';
  static const String getPlans = '$apiUrlBase/offers/getplans';
}
