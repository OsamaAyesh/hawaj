import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_opacity.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';

class InfoCard extends StatelessWidget {
  final String value;
  final String label;

  const InfoCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w4),
        child: DottedBorder(
          color: ManagerColors.strokColor,
          borderType: BorderType.RRect,
          radius: Radius.circular(ManagerRadius.r6),
          dashPattern: const [6, 3],
          strokeWidth: 1.2,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w2),
                    child: Text(value,
                        maxLines: 1,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.black,
                        )),
                  ),
                  SizedBox(height: ManagerHeight.h4),
                  Text(label,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s11,
                        color: Colors.grey,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
