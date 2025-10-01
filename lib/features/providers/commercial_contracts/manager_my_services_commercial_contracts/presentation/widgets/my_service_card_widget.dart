import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/manager_strings.dart';

class MyServiceCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final bool isActive;

  const MyServiceCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ManagerHeight.h12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ManagerWidth.w12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.black)),
                SizedBox(height: ManagerHeight.h4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.blackWithOpcity),
                ),
                SizedBox(height: ManagerHeight.h8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$price \$",
                      style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.primaryColor),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        isActive
                            ? ManagerStrings.disableService
                            : ManagerStrings.enableService,
                        style: TextStyle(
                          color: isActive ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
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
