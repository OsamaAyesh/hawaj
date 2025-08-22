import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:flutter/material.dart';

class SizedBoxBetweenFieldWidgets extends StatelessWidget {
  final double? height;

  const SizedBoxBetweenFieldWidgets({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? ManagerHeight.h12,
    );
  }
}
