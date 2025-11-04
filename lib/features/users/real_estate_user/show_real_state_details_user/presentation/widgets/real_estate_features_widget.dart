import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class RealEstateFeaturesWidget extends StatelessWidget {
  final List<String> features;

  const RealEstateFeaturesWidget({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) {
      return Center(
        child: Text(
          "لا توجد ميزات مضافة لهذا العقار",
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s12,
            color: ManagerColors.locationColorText,
          ),
        ),
      );
    }

    final int half = (features.length / 2).ceil();
    final List<String> leftColumn = features.sublist(0, half);
    final List<String> rightColumn = features.sublist(half);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildFeatureColumn(rightColumn)),
          const SizedBox(width: 16),
          Expanded(child: _buildFeatureColumn(leftColumn)),
        ],
      ),
    );
  }

  Widget _buildFeatureColumn(List<String> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: features
          .map(
            (text) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: ManagerWidth.w18,
                    height: ManagerHeight.h18,
                    decoration: const BoxDecoration(
                      color: ManagerColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w6),
                  Flexible(
                    child: Text(
                      text,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.locationColorText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
