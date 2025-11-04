import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class RealStateStatusLocationRow extends StatelessWidget {
  final String status;
  final String address;

  const RealStateStatusLocationRow({
    super.key,
    required this.status,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 18,
                color: ManagerColors.primaryColor,
              ),
              SizedBox(width: ManagerWidth.w2),
              Flexible(
                child: Text(
                  address.isNotEmpty ? address : "غير محدد",
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(ManagerRadius.r8),
          ),
          child: Text(
            status.isNotEmpty ? status : "غير محدد",
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s12,
              color: ManagerColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
