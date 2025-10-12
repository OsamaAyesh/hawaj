import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class RealEstateCardWidget extends StatelessWidget {
  final bool isAvailable;
  final String imageUrl;
  final String title;
  final String location;
  final String area;
  final String rooms;
  final String age;
  final String baths;
  final String direction;
  final String commission;
  final String price;
  final List<String> features;

  const RealEstateCardWidget({
    super.key,
    required this.isAvailable,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.area,
    required this.rooms,
    required this.age,
    required this.baths,
    required this.direction,
    required this.commission,
    required this.price,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ManagerColors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// صورة العقار
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),

              /// أيقونات التحكم (في حال العقار غير متاح)
              if (!isAvailable)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 20),
                  ),
                ),
              if (!isAvailable)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ManagerColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.settings,
                        color: Colors.white, size: 20),
                  ),
                ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(ManagerWidth.w12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// العنوان والموقع
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                /// تفاصيل العقار (صفوف)
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildDetail("المساحة", area),
                    _buildDetail("عدد الغرف", rooms),
                    _buildDetail("عدد الحمامات", baths),
                    _buildDetail("عمر العقار", age),
                    _buildDetail("الواجهة", direction),
                    _buildDetail("عمولة البيع", commission),
                  ],
                ),

                const SizedBox(height: 12),
                Text("مميزات العقار",
                    style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s13,
                        color: ManagerColors.primaryColor)),
                const SizedBox(height: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: features
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    color: ManagerColors.primaryColor,
                                    size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  f,
                                  style: getRegularTextStyle(
                                    fontSize: ManagerFontSize.s12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),

                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      price,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$title: ",
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s11,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s11,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
