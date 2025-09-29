import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// مدير لإنشاء وإدارة أيقونات الـ Markers بطريقة محسّنة
class MarkerIconManager {
  // Cache للأيقونات المُنشأة
  final Map<String, BitmapDescriptor> _iconCache = {};

  // الأيقونة الافتراضية
  BitmapDescriptor? _defaultIcon;

  /// تهيئة الأيقونة الافتراضية
  Future<void> initialize() async {
    _defaultIcon = await _createModernMarker(
      color: Colors.blue,
      icon: Icons.place,
    );
  }

  /// الحصول على أيقونة من الـ Cache أو إنشاؤها
  Future<BitmapDescriptor> getIcon({
    required String key,
    required Color color,
    IconData? icon,
    String? imageUrl,
  }) async {
    // تحقق من الـ Cache
    if (_iconCache.containsKey(key)) {
      return _iconCache[key]!;
    }

    // إنشاء أيقونة جديدة
    final newIcon = await _createModernMarker(
      color: color,
      icon: icon ?? Icons.place,
      imageUrl: imageUrl,
    );

    _iconCache[key] = newIcon;
    return newIcon;
  }

  /// الحصول على الأيقونة الافتراضية
  BitmapDescriptor get defaultIcon =>
      _defaultIcon ?? BitmapDescriptor.defaultMarker;

  /// مسح الـ Cache
  void clearCache() {
    _iconCache.clear();
  }

  /// إنشاء Marker حديث وأنيق
  Future<BitmapDescriptor> _createModernMarker({
    required Color color,
    required IconData icon,
    String? imageUrl,
    double size = 100,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // ===== رسم الدائرة الخارجية مع Shadow =====
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(
      Offset(size / 2, size / 2 + 2),
      size / 2.2,
      shadowPaint,
    );

    // ===== الدائرة الرئيسية مع Gradient =====
    final gradient = ui.Gradient.radial(
      Offset(size / 2, size / 2),
      size / 2,
      [
        color.withOpacity(0.9),
        color,
      ],
      [0.0, 1.0],
    );

    final circlePaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2.5,
      circlePaint,
    );

    // ===== Border أبيض =====
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2.5,
      borderPaint,
    );

    // ===== الأيقونة الداخلية =====
    _drawIcon(canvas, size / 2, size / 2, icon, Colors.white, size / 3);

    // ===== Pulse Ring (دائرة نابضة) =====
    final pulsePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2.2,
      pulsePaint,
    );

    // تحويل إلى صورة
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  /// رسم الأيقونة
  void _drawIcon(
    Canvas canvas,
    double x,
    double y,
    IconData icon,
    Color color,
    double size,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size,
          fontFamily: icon.fontFamily,
          color: color,
          package: icon.fontPackage,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  /// إنشاء Marker مع صورة
  Future<BitmapDescriptor> createMarkerWithImage(
    String imageUrl,
    Color color,
  ) async {
    // TODO: تحميل الصورة من الشبكة ودمجها مع الـ Marker
    return _createModernMarker(color: color, icon: Icons.image);
  }
}
