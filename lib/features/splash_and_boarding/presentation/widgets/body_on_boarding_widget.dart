import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';

import '../model_view/on_boarding_model.dart';

class BodyOnBoardingWidget extends StatefulWidget {
  final OnBoardingModel onBoardingModel;

  const BodyOnBoardingWidget({
    super.key,
    required this.onBoardingModel,
  });

  @override
  State<BodyOnBoardingWidget> createState() => _BodyOnBoardingWidgetState();
}

class _BodyOnBoardingWidgetState extends State<BodyOnBoardingWidget> with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late Animation<Offset> _imageSlide;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _imageSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _imageController,
      curve: Curves.easeOut,
    ));

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    // تشغيل الأنميشن بتأخير بسيط
    _imageController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _textController.forward();
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.onBoardingModel;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: model.heightSizeBoxBeforeImage),
        SlideTransition(
          position: _imageSlide,
          child: FadeTransition(
            opacity: _imageController,
            child: Image.asset(
               model.image,
              height: model.heightImage,
              width: model.widthImage,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: model.heightSizeBoxBeforeTextAfterImage),
        SlideTransition(
          position: _textSlide,
          child: FadeTransition(
            opacity: _textController,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w14),
                  child: Text(
                    model.title,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s16,
                      color: ManagerColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: ManagerHeight.h6),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w24),
                  child: Text(
                    model.subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.gery1OnBoarding,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
