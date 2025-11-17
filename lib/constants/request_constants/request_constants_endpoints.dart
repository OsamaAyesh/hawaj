const String apiPath = "/api/auth/user";
const String apiUrlBase = "/api/v1";

class RequestConstantsEndpoints {
  static const String login = '$apiPath/login';
  static const String getOnBoarding = '$apiUrlBase/getwelcomescreens';
  static const String sendOtp = '$apiUrlBase/otpsend';
  static const String verfiyOtp = '$apiUrlBase/otpverify';
  static const String getPlans = '$apiUrlBase/offers/getplans';
  static const String registerMyCompanyOfferProvider =
      '$apiUrlBase/setorganization';
  static const String createOfferProvider = '$apiUrlBase/setoffer';
  static const String setSubscriptionOfferProvider =
      '$apiUrlBase/setsubscriptions';
  static const String getMyOffer = '$apiUrlBase/getmyoffer';
  static const String updateProfile = '$apiUrlBase/myprofile';
  static const String updateAvatar = '$apiUrlBase/updateavatar';
  static const String getProfile = '$apiUrlBase/myprofile';
  static const String getOffers = '$apiUrlBase/getoffer';
  static const String completedProfile = '$apiUrlBase/myprofile';
  static const String getCompany = '$apiUrlBase/getorganization';
  static const String getLists = '$apiUrlBase/getlists';
  static const String sendData = '$apiUrlBase/senddata';
  static const String addMyPropertyOwners = '$apiUrlBase/addmypropertyowners';
  static const String getMyPropertyOwners = '$apiUrlBase/getmypropertyowners';
  static const String getMyRealEstate = '$apiUrlBase/getmypropertys';
  static const String addRalEstate = '$apiUrlBase/addmypropertys';
  static const String editRealEstate = '$apiUrlBase/setmyproperty';
  static const String deleteMyRealEstate = '$apiUrlBase/deletemyproperty';
  static const String editProfileMyPropertyOwner =
      '$apiUrlBase/setmypropertyowner';
  static const String getMyRealUserEstate = '$apiUrlBase/getproperty';
  static const String addCompanyJobs = '$apiUrlBase/companies';
  static const String getListCompanyJobs = '$apiUrlBase/companies';
  static const String editCompanyJobsProvider = '$apiUrlBase/companies/1';
  static const String jobsSettingsRequest = '$apiUrlBase/form-help';
  static const String addJobRequest = '$apiUrlBase/jobs/add';
  static const String getListJobsRequest = '$apiUrlBase/jobs';
  static const String getMyCompany = '$apiUrlBase/getmyorganizations';
  static const String getJobApplications =
      '$apiUrlBase/jobs/{jobId}/applications';
  static const String getOrganizationById = '$apiUrlBase/getorganization';
  static const String addVisitRealEstate = '$apiUrlBase/addmyvisitrequests';

  ////////////////New Api Requests//////
  static const String registerOrganizationOfferProvider =
      '$apiUrlBase/addmyorganization';
  static const String getOrganizationTypes = "$apiUrlBase/getlists";
  static const String getPlansOfferProviderRegister = "$apiUrlBase/getplans";
  static const String getOfferProviderPlans = "$apiUrlBase/getplans";
  static const String getMyOrganizationsNew = "$apiUrlBase/getmyorganizations";
  static const String addOfferNewRequest = '$apiUrlBase/addoffer';
  static const String getMyOrganizationWithId = '$apiUrlBase/getmyorganization';
  static const String updateOfferRequest = '$apiUrlBase/setmyoffer';
  static const String deleteMyOfferRequest = '$apiUrlBase/deletemyoffer';
}
