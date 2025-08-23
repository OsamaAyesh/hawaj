import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/resources/manager_images.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimations = List.generate(5, (i) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.1 * i, 0.6 + 0.1 * i, curve: Curves.easeIn),
        ),
      );
    });

    _slideAnimations = List.generate(5, (i) {
      return Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.1 * i, 0.6 + 0.1 * i, curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildAnimated({required int index, required Widget child}) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.contactUsTitle,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ManagerHeight.h20),
              buildAnimated(
                index: 0,
                child: Center(
                  child: Image.asset(
                    ManagerImages.contactUsImage,
                    height: ManagerHeight.h180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: ManagerHeight.h20),
              buildAnimated(
                index: 1,
                child: Column(
                  children: [
                    Text(
                      ManagerStrings.contactUsHeader,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h8),
                    Text(
                      ManagerStrings.contactUsSubtitle,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.greyWithColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ManagerHeight.h24),
              buildAnimated(
                index: 2,
                child: Text(
                  ManagerStrings.contactUsFieldLabel,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: ManagerHeight.h8),
              buildAnimated(
                index: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ManagerRadius.r6),
                    border: Border.all(
                      color: ManagerColors.greyWithColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: TextEditingController(),
                    maxLines: 5,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: ManagerStrings.contactUsFieldHint,
                      hintStyle: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.greyWithColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(ManagerHeight.h12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ManagerHeight.h48),
              buildAnimated(
                index: 4,
                child: ButtonApp(
                  title: ManagerStrings.sendMessageButton,
                  onPressed: () {

                  },
                  paddingWidth: 0,
                ),
              ),
              SizedBox(height: ManagerHeight.h20),
            ],
          ),
        ),
      ),
    );
  }
}
