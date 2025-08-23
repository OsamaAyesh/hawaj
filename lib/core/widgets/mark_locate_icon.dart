import 'package:flutter/material.dart';

class CustomMapMarker extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const CustomMapMarker({
    super.key,
    required this.icon,
    this.size = 100,
    this.backgroundColor = const Color(0xFF3E206D),
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Drop Pin
            CustomPaint(
              size: Size(size, size),
              painter: _MarkerPainter(backgroundColor),
            ),
            // دائرة بيضاء + أيقونة
            Container(
              width: size * 0.45,
              height: size * 0.45,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: backgroundColor, size: size * 0.25),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkerPainter extends CustomPainter {
  final Color color;
  _MarkerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;

    final double w = size.width;
    final double h = size.height;

    final Path path = Path();
    path.moveTo(w / 2, h);
    path.quadraticBezierTo(w, h * 0.6, w / 2, 0);
    path.quadraticBezierTo(0, h * 0.6, w / 2, h);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
