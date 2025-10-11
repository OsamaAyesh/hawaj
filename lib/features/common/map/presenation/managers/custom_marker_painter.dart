import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// رسام Markers مخصص بالألوان المطلوبة
class CustomMarkerPainter {
  /// إنشاء marker مخصص بلون معين
  static Future<BitmapDescriptor> createCustomMarker({
    required Color color,
    required String label,
    double size = 120,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = color;

    // رسم الدائرة
    const double radius = 40;
    canvas.drawCircle(
      const Offset(60, 60),
      radius,
      paint,
    );

    // رسم الحدود البيضاء
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(
      const Offset(60, 60),
      radius,
      borderPaint,
    );

    // رسم الظل
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      const Offset(60, 65),
      radius - 2,
      shadowPaint,
    );

    // إضافة النص (رقم)
    if (label.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          60 - textPainter.width / 2,
          60 - textPainter.height / 2,
        ),
      );
    }

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(120, 120);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// إنشاء marker لموقع المستخدم
  static Future<BitmapDescriptor> createUserLocationMarker() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // الدائرة الخارجية (شفافة)
    final outerPaint = Paint()
      ..color = const Color(0xFF128C7E).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(60, 60), 50, outerPaint);

    // الدائرة الداخلية
    final innerPaint = Paint()
      ..color = const Color(0xFF128C7E)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(60, 60), 25, innerPaint);

    // الحدود البيضاء
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(const Offset(60, 60), 25, borderPaint);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(120, 120);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
}
