import 'dart:ui';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserBlurInfo extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imageUrl;

  const UserBlurInfo({
    super.key,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: ManagerWidth.w6,
                right: ManagerWidth.w6,
                top: ManagerHeight.h4,
                bottom: ManagerHeight.h4),
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: ManagerWidth.w32,
                    height: ManagerHeight.h32,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: ManagerWidth.w32,
                      height: ManagerHeight.h32,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: ManagerWidth.w32,
                      height: ManagerHeight.h32,
                      color: Colors.grey[400],
                      child: const Icon(
                        Icons.error,
                        color: Colors.black,
                        size: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ManagerWidth.w12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s10,
                        color: ManagerColors.black,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h2),
                    Text(
                      subtitle,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s8,
                        color: ManagerColors.blackWithOpcity,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.white.withOpacity(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
