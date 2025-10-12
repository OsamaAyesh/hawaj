import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/features/users/real_estate_user/show_real_state_details_user/presentation/widgets/visit_request_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/util/currency_and_icon/currency_text_widget.dart';

class RealEstateActionButtonsRow extends StatelessWidget {
  const RealEstateActionButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "فيلا للبيع",
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.black,
              ),
            ),
            SizedBox(
              height: ManagerHeight.h4,
            ),
            Row(
              children: [
                Text(
                  "450,000",
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s20,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(
                  width: ManagerWidth.w4,
                ),
                CurrencyTextWidget(
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.primaryColor,
                  ),
                )
              ],
            ),
            SizedBox(
              height: ManagerHeight.h4,
            ),
            Text(
              "معلومات عن العقار",
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.black,
              ),
            ),
          ],
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
              height: ManagerHeight.h26,
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor,
                borderRadius: BorderRadius.circular(ManagerRadius.r4),
              ),
              child: Center(
                child: Text(
                  "اخبرني عند نزول الاسعار",
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s8,
                    color: ManagerColors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ManagerHeight.h6,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => VisitRequestDialog(
                    dateController: TextEditingController(),
                    fromTimeController: TextEditingController(),
                    toTimeController: TextEditingController(),
                    onConfirm: () {
                      Navigator.pop(context);
                      // تنفيذ الطلب هنا
                    },
                    onCancel: () => Navigator.pop(context),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
                height: ManagerHeight.h26,
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ManagerRadius.r4),
                ),
                child: Center(
                  child: Text(
                    "طلب زيارة",
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s8,
                      color: ManagerColors.primaryColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
