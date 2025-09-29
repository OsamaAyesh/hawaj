import 'package:app_mobile/features/common/map/presenation/widgets/notfication_icon_button.dart';
import 'package:flutter/material.dart';

import 'menu_icon_button.dart';

class MapTopBar extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onNotificationPressed;
  final bool hasNotifications;

  const MapTopBar({
    super.key,
    required this.onMenuPressed,
    required this.onNotificationPressed,
    this.hasNotifications = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MenuIconButton(onPressed: onMenuPressed),
        NotificationIconButton(
          onPressed: onNotificationPressed,
          showDot: hasNotifications,
        )
      ],
    );
  }
}
