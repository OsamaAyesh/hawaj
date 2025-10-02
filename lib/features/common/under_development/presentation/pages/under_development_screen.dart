import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ═══════════════════════════════════════════════════════════
/// Under Development Screen - شاشة قيد التطوير
/// ═══════════════════════════════════════════════════════════
class UnderDevelopmentScreen extends StatefulWidget {
  final String? sectionId;
  final String? screenId;
  final String? message;

  const UnderDevelopmentScreen({
    Key? key,
    this.sectionId,
    this.screenId,
    this.message,
  }) : super(key: key);

  @override
  State<UnderDevelopmentScreen> createState() => _UnderDevelopmentScreenState();
}

class _UnderDevelopmentScreenState extends State<UnderDevelopmentScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _floatingController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat();

    _rotationAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _scaleController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this)
      ..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this)
      ..repeat(reverse: true);

    _fadeAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _floatingController = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this)
      ..repeat(reverse: true);

    _floatingAnimation =
        Tween<double>(begin: -10, end: 10).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
                Color(0xFFf093fb),
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedIcon(),
                        const SizedBox(height: 40),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            '🚧 قيد التطوير',
                            style: getBoldTextStyle(
                              fontSize: ManagerFontSize.s32,
                              color: ManagerColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'نعمل بجد لإطلاق هذه الميزة قريباً',
                              textAlign: TextAlign.center,
                              style: getMediumTextStyle(
                                fontSize: ManagerFontSize.s16,
                                color: ManagerColors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (widget.sectionId != null || widget.screenId != null)
                          _buildInfoCard(),
                        const SizedBox(height: 32),
                        if (widget.message != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              widget.message!,
                              textAlign: TextAlign.center,
                              style: getRegularTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: ManagerColors.white,
                              ),
                            ),
                          ),
                        const SizedBox(height: 40),
                        _buildFloatingIcons(),
                        const SizedBox(height: 40),
                        _buildBackButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // دوائر خلفية
        ...List.generate(3, (index) {
          return ScaleTransition(
            scale: Tween<double>(
              begin: 1.0 + (index * 0.2),
              end: 1.3 + (index * 0.2),
            ).animate(
              CurvedAnimation(
                parent: _scaleController,
                curve: Interval(index * 0.1, 1.0, curve: Curves.easeInOut),
              ),
            ),
            child: Container(
              width: 140 + (index * 20.0),
              height: 140 + (index * 20.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2 - (index * 0.05)),
                  width: 2,
                ),
              ),
            ),
          );
        }),

        RotationTransition(
          turns: _rotationAnimation,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(Icons.settings, size: 60, color: Colors.white),
          ),
        ),

        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          if (widget.sectionId != null)
            _buildInfoRow('القسم', widget.sectionId!),
          if (widget.sectionId != null && widget.screenId != null)
            Divider(color: Colors.white.withOpacity(0.3), height: 24),
          if (widget.screenId != null)
            _buildInfoRow('الشاشة', widget.screenId!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getMediumTextStyle(
            fontSize: ManagerFontSize.s14,
            color: ManagerColors.white,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s14,
              color: ManagerColors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFloatingIcon(Icons.construction, 0),
        const SizedBox(width: 30),
        _buildFloatingIcon(Icons.engineering, 0.3),
        const SizedBox(width: 30),
        _buildFloatingIcon(Icons.build_circle, 0.6),
      ],
    );
  }

  Widget _buildFloatingIcon(IconData icon, double delay) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * (1 - delay)),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF667eea),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: Colors.black38,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back_rounded, size: 24),
            const SizedBox(width: 8),
            Text(
              'العودة',
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s18,
                color: ManagerColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
