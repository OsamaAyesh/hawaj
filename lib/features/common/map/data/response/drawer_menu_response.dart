import 'package:json_annotation/json_annotation.dart';

part 'drawer_menu_response.g.dart';

@JsonSerializable()
class DrawerMenuResponse {
  @JsonKey(name: 'error')
  bool? error;

  @JsonKey(name: 'data')
  List<DrawerItemResponse>? data;

  @JsonKey(name: 'message')
  String? message;

  DrawerMenuResponse({
    this.error,
    this.data,
    this.message,
  });

  factory DrawerMenuResponse.fromJson(Map<String, dynamic> json) =>
      _$DrawerMenuResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DrawerMenuResponseToJson(this);
}

@JsonSerializable()
class DrawerItemResponse {
  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'style')
  String? style;

  @JsonKey(name: 'link')
  String? link;

  @JsonKey(name: 'icon')
  String? icon;

  DrawerItemResponse({
    this.title,
    this.style,
    this.link,
    this.icon,
  });

  factory DrawerItemResponse.fromJson(Map<String, dynamic> json) =>
      _$DrawerItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DrawerItemResponseToJson(this);
}