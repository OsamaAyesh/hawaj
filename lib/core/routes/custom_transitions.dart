import 'package:flutter/material.dart';

/// 🔹 Fade فقط
/// 📍 استخدام: Splash, Login, Dialogs بسيطة
Route fadeRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

/// 🔹 Slide من اليمين
/// 📍 استخدام: التنقل الطبيعي بين الصفحات (مثال: Profile ← Settings)
Route slideFromRight(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final offsetTween = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));

      return SlideTransition(
        position: animation.drive(offsetTween),
        child: child,
      );
    },
  );
}

/// 🔹 Slide من الأسفل + Fade
/// 📍 استخدام: Show details, small overlay screens (مثال: Bottom Sheet أو وصف منتج)
Route fadeSlideFromBottom(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final fade = Tween<double>(begin: 0, end: 1).animate(animation);
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

/// 🔹 Scale (Zoom In)
/// 📍 استخدام: فتح صور، صفحات Focus (مثل: QR Scanner أو Photo Viewer)
Route zoomInRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final scale = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
      );

      return ScaleTransition(
        scale: scale,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

/// 🔹 Slide من اليسار (رجوع عكسي)
/// 📍 استخدام: عند الرجوع من الشاشة الداخلية إلى الشاشة الأساسية يدويًا
Route slideFromLeft(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final offsetTween = Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));

      return SlideTransition(
        position: animation.drive(offsetTween),
        child: child,
      );
    },
  );
}

/// 🔹 Rotation + Scale
/// 📍 استخدام: شاشات خاصة أو Splash خاص بتصميم إبداعي
Route rotateScaleRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final rotation = Tween<double>(begin: 0.98, end: 1).animate(animation);
      final scale = Tween<double>(begin: 0.8, end: 1).animate(animation);

      return RotationTransition(
        turns: rotation,
        child: ScaleTransition(
          scale: scale,
          child: FadeTransition(opacity: animation, child: child),
        ),
      );
    },
  );
}
