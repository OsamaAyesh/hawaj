import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_width.dart';
class AvatarWidgetProfile extends StatelessWidget {
  final String imageUrl;
  const AvatarWidgetProfile({super.key,
  required this.imageUrl,});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: ManagerHeight.h26,
          backgroundColor: Colors.grey.shade200,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: ManagerWidth.w60, // ضعف ال radius
              height: ManagerHeight.h60,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
              const CircularProgressIndicator(strokeWidth: 2),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(2),
          decoration:  BoxDecoration(
            shape: BoxShape.circle,
            color: ManagerColors.white,
          ),
          child: const Icon(
            Icons.verified,
            color: ManagerColors.primaryColor,
            size: 16,
          ),
        ),
      ],
    );
  }
}
