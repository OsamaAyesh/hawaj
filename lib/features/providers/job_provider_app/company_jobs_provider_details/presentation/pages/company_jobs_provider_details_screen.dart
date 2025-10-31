import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';

class CompanyJobsProviderDetailsScreen extends StatelessWidget {
  const CompanyJobsProviderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: ManagerHeight.h276,
            child: Stack(
              children: [
                Image.asset(
                  ManagerImages.backRemove,
                  width: double.infinity,
                  height: ManagerHeight.h276,
                  fit: BoxFit.cover,
                ),
                Row(
                  children: [
                    // Container(
                    //   height: ManagerHeight.h28,
                    //   width: ManagerWidth.w28,
                    //   decoration: BoxDecoration.,
                    // )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
