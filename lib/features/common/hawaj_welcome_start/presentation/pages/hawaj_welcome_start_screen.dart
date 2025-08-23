import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';

import '../../../../../core/resources/manager_width.dart';
class HawajWelcomeStartScreen extends StatelessWidget {
  const HawajWelcomeStartScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ///======= This BackGround Color With Opcity
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(ManagerImages.welcomeStartBackground1,
              height: ManagerHeight.h392,
              width: ManagerWidth.w327,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(ManagerImages.welcomeStartBackground2,
              height: ManagerHeight.h392,
              width: ManagerWidth.w327,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(height: ManagerHeight.h191,),
              Image.asset(ManagerImages.welcomeStartImage,
              )
            ],
          )

        ],
      ),
    );
  }
}
