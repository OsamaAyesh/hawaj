import 'package:app_mobile/core/extensions/extensions.dart';

import '../../domain/models/drawer_menu_model.dart';
import '../response/drawer_menu_response.dart';

extension DrawerMenuMapper on DrawerMenuResponse {
  DrawerMenuModel toDomain() {
    return DrawerMenuModel(
      items: data?.map((item) => item.toDomain()).toList() ?? [],
    );
  }
}

extension DrawerItemMapper on DrawerItemResponse {
  DrawerItemModel toDomain() {
    return DrawerItemModel(
      title: title.onNull(),
      style: _parseStyle(style.onNull()),
      link: link,
      icon: icon,
    );
  }

  DrawerItemStyle _parseStyle(String styleStr) {
    final lower = styleStr.toLowerCase().trim();

    if (lower.contains('h1')) return DrawerItemStyle.h1;
    if (lower.contains('hr')) return DrawerItemStyle.hr;
    if (lower.contains('unactive')) return DrawerItemStyle.itemUnactive;
    if (lower.contains('item')) return DrawerItemStyle.item;

    // default
    return DrawerItemStyle.item;
  }
}
