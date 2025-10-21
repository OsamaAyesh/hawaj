class GetRealEstateUserRequest {
  final String language;
  final String id;
  final String lat;
  final String lng;

  GetRealEstateUserRequest({
    required this.lat,
    required this.lng,
    required this.id,
    required this.language,
  });
}
