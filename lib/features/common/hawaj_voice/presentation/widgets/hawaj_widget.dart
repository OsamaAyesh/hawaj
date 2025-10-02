import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../controller/hawaj_ai_controller.dart';

class HawajWidget extends StatefulWidget {
  final String? welcomeMessage;
  final String section;
  final String screen;

  const HawajWidget({
    Key? key,
    this.welcomeMessage,
    required this.section,
    required this.screen,
  }) : super(key: key);

  @override
  State<HawajWidget> createState() => _HawajWidgetState();
}

class _HawajWidgetState extends State<HawajWidget>
    with TickerProviderStateMixin {
  // ============ Animations ============
  late AnimationController _orbitController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _waveController;
  late AnimationController _shimmerController;
  late AnimationController _audioBarController;
  late AnimationController _recordingRippleController; // ✅ جديد: لتأثير التسجيل
  late AnimationController
      _recordingIndicatorController; // ✅ جديد: مؤشر التسجيل

  // ============ Speech Recognition ============
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _permissionGranted = false;

  // ============ State ============
  HawajController? _controller;
  bool _isInitialized = false;
  bool _hasSentRequest = false;
  String _finalText = '';
  String _partialText = '';
  double _confidence = 0;
  bool _isRecording = false; // ✅ جديد: حالة التسجيل النشط

  // ✅ للتفاعل الصوتي
  List<double> _audioBars = List.generate(12, (i) => 0.3 + (i % 3) * 0.2);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initSpeech();
    _initController();
  }

  void _initAnimations() {
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // ✅ للموجات الصوتية
    _audioBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )
      ..addListener(() {
        if (mounted && _controller?.isListening == true) {
          setState(() {
            for (int i = 0; i < _audioBars.length; i++) {
              _audioBars[i] = 0.2 + math.Random().nextDouble() * 0.8;
            }
          });
        }
      })
      ..repeat();

    // ✅ جديد: تأثير Ripple عند بدء التسجيل
    _recordingRippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // ✅ جديد: مؤشر دائري للتسجيل
    _recordingIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  Future<void> _initSpeech() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        _permissionGranted = true;
        _speechEnabled = await _speechToText.initialize(debugLogging: true);
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('❌ Speech init error: $e');
    }
  }

  void _initController() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _controller = Get.find<HawajController>();
        _controller?.updateContext(
          widget.section,
          widget.screen,
          message: widget.welcomeMessage,
        );
        if (mounted) setState(() => _isInitialized = true);
      } catch (e) {
        debugPrint('❌ Controller not found');
      }
    });
  }

  // ============ UI BUILD ============
  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const SizedBox.shrink();
    }

    return GetX<HawajController>(
      builder: (controller) {
        // ✅ دمج Loading مع Processing
        final isProcessing =
            controller.isProcessing || controller.isLoadingAudio;
        final isActive =
            controller.isListening || isProcessing || controller.isSpeaking;

        return GestureDetector(
          onLongPressStart: (_) => _onPressStart(),
          onLongPressEnd: (_) => _onPressEnd(),
          child: SizedBox(
            width: 250, // ✅ مصغر من 300
            height: 270, // ✅ مصغر من 320
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ✅ خلفية ديناميكية
                _buildDynamicBackground(controller, isActive, isProcessing),

                // ✅ موجات Siri
                if (isActive) _buildSiriWaves(controller, isProcessing),

                // ✅ حلقات دوارة (Processing)
                if (isProcessing)
                  _buildOrbitingParticles(controller.stateColor),

                // ✅ موجات النطق (Speaking) - لون مختلف
                if (controller.isSpeaking) _buildSpeakingWaves(),

                // ✅ الموجات الصوتية (Listening) - تفاعلية
                if (controller.isListening) _buildAudioBars(),

                // ✅ تأثير Ripple عند بدء التسجيل
                if (_isRecording) _buildRecordingRipple(),

                // ✅ مؤشر دائري للتسجيل
                if (_isRecording) _buildRecordingIndicator(),

                // ✅ الهالة الرئيسية
                _buildMainGlow(controller.stateColor, isActive),

                // ✅ الزر المركزي
                _buildCenterButton(controller, isProcessing),

                // ✅ النص الجزئي
                if (_partialText.isNotEmpty && !_hasSentRequest)
                  Positioned(
                    top: 20,
                    child: _buildPartialTextDisplay(),
                  ),

                // ✅ مؤشر الحالة
                Positioned(
                  bottom: 20,
                  child: _buildStatusChip(controller, isProcessing),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============ خلفية ديناميكية ============
  Widget _buildDynamicBackground(
      HawajController controller, bool isActive, bool isProcessing) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment(
                math.sin(_shimmerController.value * 2 * math.pi) * 0.2,
                math.cos(_shimmerController.value * 2 * math.pi) * 0.2,
              ),
              colors: isActive
                  ? [
                      _getStateColor(controller, isProcessing)
                          .withOpacity(0.15),
                      _getStateColor(controller, isProcessing)
                          .withOpacity(0.05),
                      Colors.transparent,
                    ]
                  : [
                      Colors.grey.withOpacity(0.05),
                      Colors.transparent,
                    ],
            ),
          ),
        );
      },
    );
  }

  // ============ موجات Siri ============
  Widget _buildSiriWaves(HawajController controller, bool isProcessing) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(230, 230),
          painter: SiriWavePainter(
            animation: _waveController,
            color: _getStateColor(controller, isProcessing),
            isActive: controller.isListening || controller.isSpeaking,
          ),
        );
      },
    );
  }

  // ============ الموجات الصوتية (Listening) - تفاعلية ============
  Widget _buildAudioBars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(12, (index) {
        final height = 5 + (_audioBars[index] * 40);
        return Container(
          width: 3,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.5),
                blurRadius: 4,
              ),
            ],
          ),
        );
      }),
    );
  }

  // ============ تأثير Ripple عند بدء التسجيل ============
  Widget _buildRecordingRipple() {
    return AnimatedBuilder(
      animation: _recordingRippleController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final adjustedValue =
                (_recordingRippleController.value - delay).clamp(0.0, 1.0);
            final size = 90 + (adjustedValue * 120);
            final opacity = (1.0 - adjustedValue) * 0.5;

            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green.withOpacity(opacity),
                  width: 3,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ============ مؤشر دائري للتسجيل ============
  Widget _buildRecordingIndicator() {
    return AnimatedBuilder(
      animation: _recordingIndicatorController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(110, 110),
          painter: RecordingIndicatorPainter(
            progress: _recordingIndicatorController.value,
            color: Colors.green,
          ),
        );
      },
    );
  }

  // ============ حلقات دوارة (Processing) ============
  Widget _buildOrbitingParticles(Color color) {
    return AnimatedBuilder(
      animation: _orbitController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(3, (index) {
            final angle = (_orbitController.value * 2 * math.pi) +
                (index * math.pi * 2 / 3);
            final radius = 70.0 + (index * 10);

            return Transform.translate(
              offset: Offset(
                math.cos(angle) * radius,
                math.sin(angle) * radius,
              ),
              child: Container(
                width: 8 - (index * 1.5),
                height: 8 - (index * 1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withOpacity(0.9),
                      color.withOpacity(0.4),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ============ موجات النطق (Speaking) - لون أصفر ============
  Widget _buildSpeakingWaves() {
    final speakingColor = Colors.amber; // ✅ أصفر ذهبي

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(4, (index) {
            final size = 110 + (index * 18) + (_pulseController.value * 12);
            final opacity = 0.5 - (index * 0.1);

            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: speakingColor.withOpacity(opacity),
                  width: 2,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ============ الهالة الرئيسية ============
  Widget _buildMainGlow(Color color, bool isActive) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final double size =
            isActive ? (160 + (_glowController.value * 40)).toDouble() : 120.0;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withOpacity(isActive ? 0.5 : 0.25),
                color.withOpacity(isActive ? 0.25 : 0.1),
                Colors.transparent,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        );
      },
    );
  }

  // ============ الزر المركزي ============
  Widget _buildCenterButton(HawajController controller, bool isProcessing) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        // ✅ تكبير أكبر عند بدء التسجيل
        final scale = _isRecording
            ? 1.15 + (_pulseController.value * 0.08) // أكبر عند التسجيل
            : controller.isListening
                ? 1.0 + (_pulseController.value * 0.12)
                : 1.0;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  _getStateColor(controller, isProcessing),
                  _getStateColor(controller, isProcessing).withOpacity(0.7),
                  _getStateColor(controller, isProcessing),
                ],
                stops: const [0.0, 0.5, 1.0],
                transform:
                    GradientRotation(_shimmerController.value * 2 * math.pi),
              ),
              boxShadow: [
                BoxShadow(
                  color: _getStateColor(controller, isProcessing)
                      .withOpacity(_isRecording ? 0.9 : 0.7),
                  blurRadius: _isRecording ? 40 : 30, // ✅ توهج أقوى عند التسجيل
                  spreadRadius: _isRecording ? 8 : 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ✅ أيقونة ديناميكية
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    _getStateIcon(controller, isProcessing),
                    key: ValueKey(controller.currentState),
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============ عرض النص الجزئي ============
  Widget _buildPartialTextDisplay() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 210),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        _partialText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.3,
        ),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // ============ شريحة الحالة ============
  Widget _buildStatusChip(HawajController controller, bool isProcessing) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: _getStateColor(controller, isProcessing).withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getStateColor(controller, isProcessing).withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ مؤشر متحرك
          if (isProcessing)
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(left: 6),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),

          // ✅ نص الحالة
          Text(
            _getStateText(controller, isProcessing),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ============ PRESS START ============
  void _onPressStart() async {
    if (!_permissionGranted) {
      _showPermissionDialog();
      return;
    }

    debugPrint('🎤 ═══════════════════════════════');
    debugPrint('🎤 START: بدء الضغط المطول');

    HapticFeedback.mediumImpact();

    setState(() {
      _hasSentRequest = false;
      _finalText = '';
      _partialText = '';
      _confidence = 0;
      _isRecording = true; // ✅ تفعيل حالة التسجيل
    });

    // ✅ تشغيل تأثيرات التسجيل
    _recordingRippleController.forward(from: 0.0);
    _recordingIndicatorController.repeat();

    if (_controller?.isSpeaking ?? false) {
      await _controller?.stopSpeaking();
    }

    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: "ar-SA",
        listenMode: ListenMode.confirmation,
        partialResults: true,
        cancelOnError: false,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
      );

      debugPrint('✅ بدأ الاستماع');
    }
  }

  void _onSpeechResult(result) {
    if (!mounted) return;

    final recognizedWords = result.recognizedWords as String;
    final isFinal = result.finalResult as bool;
    final confidence = result.confidence as double;

    setState(() {
      _confidence = confidence;

      if (isFinal) {
        _finalText = recognizedWords;
        debugPrint('📝 نص نهائي: "$recognizedWords"');
      } else {
        _partialText = recognizedWords;
      }
    });
  }

  // ============ PRESS END ============
  void _onPressEnd() async {
    if (!mounted) return;

    debugPrint('🖐️ END: رفع الإصبع');

    HapticFeedback.lightImpact();

    // ✅ إيقاف تأثيرات التسجيل
    setState(() {
      _isRecording = false;
    });
    _recordingIndicatorController.stop();

    if (_speechToText.isListening) {
      await _speechToText.stop();
      debugPrint('🛑 أوقفت الاستماع');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    final textToSend =
        _finalText.trim().isNotEmpty ? _finalText.trim() : _partialText.trim();

    debugPrint('📤 النص المحدد: "$textToSend"');

    if (textToSend.isNotEmpty && !_hasSentRequest) {
      _hasSentRequest = true;

      debugPrint('✅ ═══════════════════════════════');
      debugPrint('✅ إرسال: "$textToSend"');
      debugPrint('✅ ═══════════════════════════════');

      _controller?.processVoiceInputFromWidget(
        textToSend,
        _confidence,
        screen: widget.screen,
        section: widget.section,
      );

      setState(() {
        _partialText = '';
        _finalText = '';
      });
    } else if (textToSend.isEmpty) {
      _showMessage('لم يتم التقاط أي صوت');
    }

    debugPrint('🎤 ═══════════════════════════════\n');
  }

  // ============ Helpers ============
  Color _getStateColor(HawajController controller, bool isProcessing) {
    if (controller.isSpeaking) return Colors.amber; // ✅ أصفر عند النطق
    if (isProcessing) return Colors.blue; // أزرق للتفكير/التحميل
    if (controller.isListening) return Colors.green;
    if (controller.hasError) return Colors.red;
    return Colors.grey;
  }

  IconData _getStateIcon(HawajController controller, bool isProcessing) {
    if (controller.isSpeaking) return Icons.volume_up; // ✅ سماعة عند النطق
    if (isProcessing) return Icons.psychology;
    if (controller.isListening) return Icons.mic;
    if (controller.hasError) return Icons.error;
    return Icons.assistant;
  }

  String _getStateText(HawajController controller, bool isProcessing) {
    if (controller.isSpeaking) return 'أتحدث...';
    if (isProcessing) return 'أفكر...'; // ✅ دمج التفكير والتحضير
    if (controller.isListening) return 'أستمع إليك...';
    if (controller.hasError) return 'خطأ';
    return 'اضغط مطولاً للتحدث';
  }

  void _showMessage(String msg) {
    Get.snackbar(
      '',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.orange.withOpacity(0.95),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
    );
  }

  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text('إذن الميكروفون مطلوب'),
        content: const Text('يجب منح إذن الميكروفون لاستخدام المساعد الصوتي'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    _waveController.dispose();
    _shimmerController.dispose();
    _audioBarController.dispose();
    _recordingRippleController.dispose(); // ✅ جديد
    _recordingIndicatorController.dispose(); // ✅ جديد
    _speechToText.stop();
    super.dispose();
  }
}

// ============ Siri Wave Painter ============
class SiriWavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final bool isActive;

  SiriWavePainter({
    required this.animation,
    required this.color,
    required this.isActive,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < 3; i++) {
      final progress = ((animation.value + (i * 0.33)) % 1.0);
      final radius = 50 + (progress * 70);
      final opacity = isActive ? (1.0 - progress) * 0.6 : 0.2;

      paint.color = color.withOpacity(opacity);

      final path = Path();
      for (double angle = 0; angle < 2 * math.pi; angle += 0.1) {
        final wave = math.sin(angle * 4 + animation.value * 2 * math.pi) * 6;
        final x = center.dx + (radius + wave) * math.cos(angle);
        final y = center.dy + (radius + wave) * math.sin(angle);

        if (angle == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SiriWavePainter oldDelegate) => true;
}

// ============ Recording Indicator Painter ============
class RecordingIndicatorPainter extends CustomPainter {
  final double progress;
  final Color color;

  RecordingIndicatorPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // ✅ قوس دائري متحرك يشير للتسجيل
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // رسم 3 أقواس صغيرة تدور
    for (int i = 0; i < 3; i++) {
      final startAngle =
          (progress * 2 * math.pi) + (i * 2 * math.pi / 3) - math.pi / 2;
      final sweepAngle = math.pi / 4; // طول القوس

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint..color = color.withOpacity(0.8 - (i * 0.2)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant RecordingIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// ============ Extension ============
extension HawajExtension on Widget {
  Widget withHawaj({
    String section = "1",
    String screen = "1",
    String? message,
    AlignmentGeometry alignment = Alignment.bottomCenter,
    EdgeInsets padding = const EdgeInsets.only(bottom: 50),
  }) {
    return Stack(
      children: [
        this,
        Positioned.fill(
          child: Align(
            alignment: alignment,
            child: Padding(
              padding: padding,
              child: HawajWidget(
                section: section,
                screen: screen,
                welcomeMessage: message,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
