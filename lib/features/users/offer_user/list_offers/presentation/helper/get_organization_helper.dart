/// Extension مساعد على Map (response من الـ API مباشرة)
extension OrganizationHelper on Map<String, dynamic> {
  /// تحويل lat من String/int إلى double
  double? get latitudeAsDouble {
    final lat = this['lat'];
    if (lat == null) return null;
    if (lat is double) return lat;
    if (lat is int) return lat.toDouble();
    if (lat is String) return double.tryParse(lat.trim());
    return null;
  }

  /// تحويل lng من String/int إلى double
  double? get longitudeAsDouble {
    final lng = this['lng'];
    if (lng == null) return null;
    if (lng is double) return lng;
    if (lng is int) return lng.toDouble();
    if (lng is String) return double.tryParse(lng.trim());
    return null;
  }

  /// هل الإحداثيات صالحة؟
  bool get hasValidCoordinates {
    final lat = latitudeAsDouble;
    final lng = longitudeAsDouble;
    return lat != null && lng != null && lat != 0 && lng != 0;
  }

  /// هل لديها شعار؟
  bool get hasLogo {
    final logo = this['organization_logo'];
    return logo != null && logo.toString().isNotEmpty;
  }

  /// هل لديها عروض؟
  bool get hasOffers {
    final offers = this['offers'];
    return offers != null && offers is List && offers.isNotEmpty;
  }

  /// عدد العروض
  int get offersCount {
    final offers = this['offers'];
    if (offers != null && offers is List) {
      return offers.length;
    }
    return 0;
  }
}
