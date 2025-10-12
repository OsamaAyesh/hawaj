import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../widgets/real_estate_action_buttons_row.dart';
import '../widgets/real_estate_ad_info_widget.dart';
import '../widgets/real_estate_advertiser_info_widget.dart';
import '../widgets/real_estate_features_widget.dart';
import '../widgets/real_estate_info_card_widget.dart';
import '../widgets/real_state_status_location_row.dart';
import '../widgets/widget_images_and_icons.dart';

class ShowRealStateDetailsUserScreen extends StatelessWidget {
  const ShowRealStateDetailsUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///==== Images With Back And Share Button Stack
            const WidgetImagesAndIcons(),
            SizedBox(
              height: ManagerHeight.h12,
            ),

            ///==== Information Location And Status Real Estate And Price And Two Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
              child: const Column(
                children: [
                  RealStateStatusLocationRow(),
                  RealEstateActionButtonsRow()
                ],
              ),
            ),
            SizedBox(
              height: ManagerHeight.h8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: const RealEstateInfoCardWidget(),
            ),
            SizedBox(
              height: ManagerHeight.h12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Text(
                "مميزات العقار",
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.black,
                ),
              ),
            ),
            SizedBox(
              height: ManagerHeight.h8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w16,
              ),
              child: const RealEstateFeaturesWidget(),
            ),
            SizedBox(
              height: ManagerHeight.h8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Text(
                "وصف العقار",
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Text(
                "تتميز الفيلا بتصميم داخلي راقٍ يجمع بين الفخامة والراحة، حيث تستقبلك صالة واسعة بإضاءة طبيعية ونوافذ تطل على الحديقة، يليها مجلس أنيق وغرفة معيشة دافئة متصلة بمطبخ أمريكي عصري. غرف النوم موزعة بأناقة مع حمامات بتشطيبات حديثة، وكل زاوية داخل الفيلا تعكس ذوقًا رفيعًا وتفاصيل مدروسة لحياة هادئة ومريحة.",
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.locationColorText,
                ),
              ),
            ),
            SizedBox(
              height: ManagerHeight.h12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Text(
                "معلومات المعلن",
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.black,
                ),
              ),
            ),
            SizedBox(
              height: ManagerHeight.h8,
            ),
            const RealEstateAdvertiserInfoWidget(),
            SizedBox(
              height: ManagerHeight.h12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Text(
                "معلومات الإعلان",
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.black,
                ),
              ),
            ),
            SizedBox(
              height: ManagerHeight.h8,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                child: const RealEstateAdInfoWidget()),
          ],
        ),
      ),
    );
  }
}
