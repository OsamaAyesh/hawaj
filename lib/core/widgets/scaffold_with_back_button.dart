import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'back_button_icon.dart';

class ScaffoldWithBackButton extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBack;
  final Future<void> Function()? onRefresh;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const ScaffoldWithBackButton({
    super.key,
    required this.title,
    required this.body,
    this.onBack,
    this.onRefresh,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ManagerColors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ManagerHeight.h48),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Get.locale?.languageCode == 'ar'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: BackButtonIconApp(
                      onPressed: onBack ?? () => Navigator.pop(context),
                    ),
                  ),
                  Center(
                    child: Text(
                      title,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ManagerHeight.h8),
            Expanded(
              child: onRefresh != null
                  ? RefreshIndicator(
                      onRefresh: onRefresh!,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        physics: const BouncingScrollPhysics(),
                        // physics: const AlwaysScrollableScrollPhysics(),
                        child: body,
                      ),
                    )
                  : body,
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
