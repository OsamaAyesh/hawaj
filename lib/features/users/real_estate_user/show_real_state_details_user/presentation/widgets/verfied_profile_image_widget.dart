import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:flutter/material.dart';

class VerifiedProfileImageWidget extends StatelessWidget {
  final String imagePath;
  final double radius;
  final bool isVerified;

  const VerifiedProfileImageWidget({
    super.key,
    required this.imagePath,
    this.radius = 40,
    this.isVerified = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade200,
              width: 2,
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        if (isVerified)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: radius * 0.35,
              height: radius * 0.35,
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.verified,
                size: radius * 0.18,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
