import 'dart:math' as math;

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';

class HawajWelcomeStartScreen extends StatefulWidget {
  const HawajWelcomeStartScreen({super.key});

  @override
  State<HawajWelcomeStartScreen> createState() =>
      _HawajWelcomeStartScreenState();
}

class _HawajWelcomeStartScreenState extends State<HawajWelcomeStartScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            /// 🌈 خلفية متحركة مع دوائر ملونة
            _buildAnimatedBackground(),

            /// المحتوى الرئيسي
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: ManagerHeight.h40),

                    /// 👋 الرأس بتأثير انزلاق
                    _buildHeader(),

                    SizedBox(height: ManagerHeight.h50),

                    /// 🤖 صورة المساعد بتأثير طفو
                    _buildFloatingImage(),

                    SizedBox(height: ManagerHeight.h50),

                    /// ✨ المميزات الأساسية
                    _buildFeatureCards(),

                    SizedBox(height: ManagerHeight.h30),

                    /// 💬 اقتراح اليوم بتصميم جذاب
                    // _buildSuggestionCard(),

                    // SizedBox(height: ManagerHeight.h40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).withHawaj(
        screen: HawajScreens.hawajStartScreen,
        section: HawajSections.settingsSection,
        onHawajCommand: (command) async {
          debugPrint("[HawajWelcome] 🎯 Command received: $command");
        },
      ),
    );
  }

  /// خلفية متحركة مع دوائر ملونة
  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // دائرة علوية يمين
        Positioned(
          top: -50,
          right: -50,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 200 + (_pulseController.value * 20),
                height: 200 + (_pulseController.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      ManagerColors.primaryColor.withOpacity(0.15),
                      ManagerColors.primaryColor.withOpacity(0.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // دائرة وسطى يسار
        Positioned(
          top: 200,
          left: -80,
          child: AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingController.value * 15),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        ManagerColors.primaryColor.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // دائرة سفلية
        Positioned(
          bottom: -100,
          left: MediaQuery.of(context).size.width * 0.3,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  ManagerColors.primaryColor.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// رأس الصفحة بتأثير انزلاق
  Widget _buildHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutBack,
      )),
      child: FadeTransition(
        opacity: _slideController,
        child: Column(
          children: [
            /// أيقونة متحركة
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + (_pulseController.value * 0.1),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          ManagerColors.primaryColor,
                          ManagerColors.primaryColor.withOpacity(0.7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ManagerColors.primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: ManagerHeight.h20),

            Text(
              "مرحباً بك في حوّاج",
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s26,
                color: ManagerColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: ManagerHeight.h12),

            Text(
              "مساعدك الذكي للحصول على تجربة مميزة",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s16,
                color: Colors.grey[600]!,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// صورة طافية بتأثير حركي
  Widget _buildFloatingImage() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_floatingController.value * math.pi) * 15),
          child: Transform.rotate(
            angle: math.sin(_floatingController.value * math.pi) * 0.05,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: ManagerColors.primaryColor.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  ManagerImages.welcomeStartImage,
                  width: ManagerWidth.w260,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// كروت المميزات
  Widget _buildFeatureCards() {
    final features = [
      {
        'icon': Icons.flash_on_rounded,
        'title': 'سريع وذكي',
        'color': Colors.amber,
      },
      {
        'icon': Icons.favorite_rounded,
        'title': 'مخصص لك',
        'color': Colors.red,
      },
      {
        'icon': Icons.shield_rounded,
        'title': 'آمن تماماً',
        'color': Colors.green,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 600 + (index * 200)),
          curve: Curves.easeOutBack,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: ManagerWidth.w100,
                padding: EdgeInsets.symmetric(
                  vertical: ManagerHeight.h16,
                  horizontal: ManagerWidth.w12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (feature['color'] as Color).withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (feature['color'] as Color).withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(ManagerWidth.w12),
                      decoration: BoxDecoration(
                        color: (feature['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        color: feature['color'] as Color,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h8),
                    Text(
                      feature['title'] as String,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  /// كرت الاقتراح اليومي
  Widget _buildSuggestionCard() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(ManagerWidth.w20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ManagerColors.primaryColor,
                    ManagerColors.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: ManagerColors.primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(ManagerWidth.w8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: ManagerWidth.w12),
                      Text(
                        "اقتراح اليوم",
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ManagerHeight.h16),
                  Container(
                    padding: EdgeInsets.all(ManagerWidth.w16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ManagerWidth.w12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "🍽️",
                            style: TextStyle(fontSize: ManagerFontSize.s24),
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "مطاعم مميزة",
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h4),
                              Text(
                                "أفضل أماكن العشاء قريبة منك",
                                style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s13,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
