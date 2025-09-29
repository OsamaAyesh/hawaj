import 'package:flutter/material.dart';

/// Model for a single drawer item
class DrawerItemModel {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  DrawerItemModel({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });
}
