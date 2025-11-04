class AddMyVisitRequest {
  final String visitDate;
  final String timeFrom;
  final String timeTo;
  final String visitorMemberId;
  final String propertyId;
  final String visitStatus;

  AddMyVisitRequest({
    required this.visitDate,
    required this.timeFrom,
    required this.timeTo,
    required this.visitorMemberId,
    required this.propertyId,
    required this.visitStatus,
  });
}
