class OfferPlanModel {
  String id;
  String planName;
  String planPrice;
  String days;
  String planFeatures;

  OfferPlanModel({
    required this.id,
    required this.planName,
    required this.planPrice,
    required this.days,
    required this.planFeatures,
  });

  double get dailyPrice {
    final price = double.tryParse(planPrice) ?? 0.0;
    final totalDays = int.tryParse(days) ?? 1;
    return price / totalDays;
  }

  int get allowedOffersCount {
    final match = RegExp(r'\d+').firstMatch(planFeatures);
    return match != null ? int.tryParse(match.group(0)!) ?? 0 : 0;
  }

  bool get isPremium => planName.toLowerCase().contains('gold');

  String get planColor {
    final name = planName.toLowerCase();
    if (name.contains('platinum')) return '#E5E4E2';
    if (name.contains('gold')) return '#FFD700';
    if (name.contains('silver')) return '#C0C0C0';
    return '#808080';
  }
}
