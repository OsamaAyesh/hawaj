class RealEstateHelper {
  static String getFirstImage(String propertyImages) {
    if (propertyImages.isEmpty) return '';
    final images = propertyImages.split(',');
    return images.isNotEmpty ? images.first.trim() : '';
  }

  static List<String> getAllImages(String propertyImages) {
    if (propertyImages.isEmpty) return [];
    return propertyImages
        .split(',')
        .map((img) => img.trim())
        .where((img) => img.isNotEmpty)
        .toList();
  }

  static List<String> getFeatures(String featureIds) {
    if (featureIds.isEmpty) return [];
    return featureIds
        .split(',')
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toList();
  }

  static String formatArea(String areaSqm) {
    if (areaSqm.isEmpty) return '-';
    return '$areaSqm م²';
  }

  static String formatCommission(String commissionPercentage) {
    if (commissionPercentage.isEmpty) return '-';
    return '$commissionPercentage%';
  }
}
