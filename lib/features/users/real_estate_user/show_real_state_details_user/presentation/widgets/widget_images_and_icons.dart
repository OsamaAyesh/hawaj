import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../offer_user/company_with_offer/presentation/widgets/circle_icon_widget.dart';

class WidgetImagesAndIcons extends StatelessWidget {
  const WidgetImagesAndIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          ManagerImages.removeRealState,
          height: ManagerHeight.h316,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: ManagerHeight.h51,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconWidget(
                    icon: Icons.arrow_back,
                    onPressed: () => Get.back(),
                  ),
                  CircleIconWidget(
                    icon: Icons.share_outlined,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ManagerHeight.h190,
            ),
            Container(
              height: ManagerHeight.h32,
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ManagerRadius.r4),
                color: ManagerColors.black.withOpacity(ManagerOpacity.op0_4),
              ),
              child: _viewPhotosWidget(),
            ),
          ],
        )
      ],
    );
  }

  Widget _viewPhotosWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "3",
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s14,
              color: Colors.white,
            ),
          ),
          SizedBox(width: ManagerWidth.w4),
          Icon(
            Icons.image_outlined,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: ManagerWidth.w4),
          Text(
            "شاهد الصور",
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
