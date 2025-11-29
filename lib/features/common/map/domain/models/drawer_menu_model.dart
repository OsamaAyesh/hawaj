enum DrawerItemStyle {
  h1,
  hr,
  item,
  itemUnactive,
}

class DrawerMenuModel {
  final List<DrawerItemModel> items;

  DrawerMenuModel({required this.items});
}

class DrawerItemModel {
  final String title;
  final DrawerItemStyle style;
  final String? link;
  final String? icon;

  DrawerItemModel({
    required this.title,
    required this.style,
    this.link,
    this.icon,
  });

  bool get isHeader => style == DrawerItemStyle.h1;

  bool get isDivider => style == DrawerItemStyle.hr;

  bool get isItem => style == DrawerItemStyle.item;

  bool get isInactive => style == DrawerItemStyle.itemUnactive;

  bool get isActive => isItem && !isInactive;

  String? get actionName => link?.replaceAll('@', '').trim();
}
