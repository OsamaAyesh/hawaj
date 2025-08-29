import 'package:app_mobile/features/common/map/presenation/pages/map_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' show Get;

import '../../../map/domain/di/di.dart';

class HawajWelcomeStartScreen extends StatefulWidget {
  const HawajWelcomeStartScreen({super.key});

  @override
  State<HawajWelcomeStartScreen> createState() =>
      _HawajWelcomeStartScreenState();
}

class _HawajWelcomeStartScreenState extends State<HawajWelcomeStartScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    // Glow effect
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Wave effect
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ManagerColors.primaryColor.withOpacity(0.05),
                  Colors.white,
                  ManagerColors.primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// Main Column
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                /// Title
                Text(
                  "شو بتحب أساعدك فيه اليوم؟",
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.primaryColor,
                  ),
                ),
                SizedBox(height: ManagerHeight.h12),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: ManagerWidth.w28),
                  child: Text(
                    "حوّاج موجود ليسهل حياتك… يقترح عليك اللي بتحتاجه قبل حتى ما تطلبه ",
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s18,
                      color: ManagerColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(),

                /// AI Robot
                Image.asset(
                  ManagerImages.welcomeStartImage,
                  width: ManagerWidth.w220,
                ),

                const Spacer(),

                /// Suggestions Card
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: ManagerWidth.w20,
                      vertical: ManagerHeight.h12),
                  padding: EdgeInsets.all(ManagerWidth.w16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "اقتراح اليوم",
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s18,
                          color: ManagerColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: ManagerHeight.h8),
                      Text(
                        "حوّاج: خليني أنصحك بأفضل عروض الأكل اليوم ",
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// Mic button with glow + waves
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glowing background
                    ScaleTransition(
                      scale: Tween(begin: 0.9, end: 1.1).animate(
                        CurvedAnimation(
                          parent: _glowController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ManagerColors.primaryColor.withOpacity(0.1),
                        ),
                      ),
                    ),

                    // Waves around mic
                    CustomPaint(
                      painter: WavePainter(_waveController),
                      size: const Size(180, 180),
                    ),

                    // Main Mic button
                    ElevatedButton(
                      onPressed: () {
                        // Start Listening Logic
                        Get.to(() => MapScreen(), binding: MapBindings());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(28),
                        backgroundColor: ManagerColors.primaryColor,
                        shadowColor:
                        ManagerColors.primaryColor.withOpacity(0.5),
                        elevation: 12,
                      ),
                      child: const Icon(
                        Icons.mic,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ====== Wave Painter for Animated Mic ======
class WavePainter extends CustomPainter {
  final Animation<double> animation;

  WavePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 4;

    for (int i = 0; i < 3; i++) {
      final progress = ((animation.value + (i * 0.3)) % 1.0);
      final waveRadius = radius + (progress * 60);
      paint.color = paint.color.withOpacity((1 - progress).clamp(0.0, 1.0));
      canvas.drawCircle(center, waveRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
