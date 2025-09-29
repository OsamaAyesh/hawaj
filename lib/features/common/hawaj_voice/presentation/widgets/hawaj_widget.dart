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
  // Animation Controllers
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _waveController;
  late AnimationController _rotateController;
  late AnimationController _scaleController;
  late AnimationController _rippleController;

  // Speech to Text
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _permissionGranted = false;

  // State
  HawajController? _controller;
  bool _isInitialized = false;
  bool _isPressing = false;
  String _currentText = '';
  String _partialText = ''; // ✅ جديد: للنصوص الجزئية
  double _confidence = 0;
  double _audioLevel = 0;
  List<double> _audioLevels = List.generate(8, (index) => 0.0);

  // ✅ جديد: لتتبع حالة الالتقاط
  bool _isCapturingFinalResult = false;
  DateTime? _lastWordTime;
  bool _isProcessing = false; // ✅ لمنع الإرسال المكرر

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initSpeech();
    _initController();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.9,
      upperBound: 1.0,
    )..value = 1.0;

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  Future<void> _initSpeech() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        _permissionGranted = true;
        _speechEnabled = await _speechToText.initialize(
          onStatus: (status) => _handleSpeechStatus(status),
          onError: (error) => _handleSpeechError(error),
          debugLogging: true, // ✅ للمساعدة في التشخيص
        );
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('خطأ في تهيئة الكلام: $e');
    }
  }

  void _initController() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _controller = Get.find<HawajController>();
        if (widget.section != null && widget.screen != null) {
          _controller?.updateContext(
            widget.section!,
            widget.screen!,
            message: widget.welcomeMessage,
          );
        }
        if (mounted) {
          setState(() => _isInitialized = true);
        }
      } catch (e) {
        debugPrint('Error finding HawajController: $e');
      }
    });
  }

  // ✅ معالج حالة الكلام المحسّن
  void _handleSpeechStatus(String status) {
    debugPrint('🎤 Widget - حالة الكلام: $status');

    if (status == 'done') {
      // ✅ اكتمل التعرف - انتظار قصير ثم المعالجة
      debugPrint('✅ Widget - اكتمل التعرف على الكلام');

      if (_isCapturingFinalResult) {
        // المستخدم رفع إصبعه والنظام جاهز للمعالجة
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) _finalizeSpeech();
        });
      }
    } else if (status == 'notListening') {
      if (_isCapturingFinalResult) {
        // ✅ توقف الاستماع - انتظار النتيجة النهائية
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && _isCapturingFinalResult) {
            _finalizeSpeech();
          }
        });
      }
    } else if (status == 'listening') {
      setState(() => _isPressing = true);
    }
  }

  // ✅ معالج أخطاء الكلام المحسّن
  void _handleSpeechError(dynamic error) {
    debugPrint('❌ Widget - خطأ في التعرف على الكلام: $error');

    if (mounted) {
      setState(() {
        _isPressing = false;
        _isCapturingFinalResult = false;
      });

      // ✅ إذا كان هناك نص جزئي ولم يكن قيد المعالجة، استخدمه
      if (_partialText.isNotEmpty && !_isProcessing) {
        _currentText = _partialText;
        _processSpeech();
      } else {
        _showErrorSnackbar('حدث خطأ. حاول مرة أخرى');
      }
    }
  }

  // ✅ إنهاء التسجيل ومعالجة النتيجة
  void _finalizeSpeech() {
    debugPrint('✅ Widget - إنهاء التسجيل');

    if (!mounted || _isProcessing) {
      debugPrint('⚠️ Widget - إلغاء: غير mounted أو قيد المعالجة');
      return;
    }

    setState(() {
      _isPressing = false;
      _isCapturingFinalResult = false;
    });

    // ✅ استخدام النص النهائي فقط، وإذا كان فارغاً استخدم الجزئي كخيار أخير
    final finalText = _currentText.trim();
    final fallbackText = _partialText.trim();

    debugPrint('📋 النص النهائي: "$finalText"');
    debugPrint('📋 النص الجزئي: "$fallbackText"');

    final textToSend = finalText.isNotEmpty ? finalText : fallbackText;

    if (textToSend.isNotEmpty) {
      debugPrint('📤 Widget - إرسال النص النهائي: "$textToSend"');
      HapticFeedback.mediumImpact(); // ✅ اهتزازة تأكيد

      // ✅ تحديث النص قبل الإرسال
      _currentText = textToSend;

      _processSpeech();
    } else {
      debugPrint('⚠️ Widget - لا يوجد نص للإرسال');
      _showErrorSnackbar('لم يتم التقاط أي صوت');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const SizedBox.shrink();
    }

    return GetX<HawajController>(
      builder: (controller) {
        final isActive = controller.isListening ||
            controller.isProcessing ||
            controller.isSpeaking;

        return GestureDetector(
          onTapDown: (_) => _onPressStart(controller),
          onTapUp: (_) => _onPressEnd(controller),
          onTapCancel: () => _onPressEnd(controller),
          child: AnimatedBuilder(
            animation: _scaleController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleController.value,
                child: SizedBox(
                  width: 200,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // الموجات الخارجية - تظهر فقط عند النشاط
                      if (isActive) ...[
                        _buildAnimatedWave(180, 0.0, controller.stateColor),
                        _buildAnimatedWave(160, 0.3, controller.stateColor),
                        _buildAnimatedWave(140, 0.6, controller.stateColor),
                      ],

                      // الهالة المتوهجة
                      AnimatedBuilder(
                        animation: _glowController,
                        builder: (context, child) {
                          final glowSize = 120 + (_glowController.value * 20);
                          return Container(
                            width: glowSize,
                            height: glowSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  controller.stateColor
                                      .withOpacity(isActive ? 0.4 : 0.15),
                                  controller.stateColor
                                      .withOpacity(isActive ? 0.2 : 0.05),
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                            ),
                          );
                        },
                      ),

                      // ✅ حلقة المعالجة - تظهر فقط أثناء المعالجة
                      if (controller.isProcessing)
                        AnimatedBuilder(
                          animation: _rotateController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotateController.value * 2 * math.pi,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        controller.stateColor.withOpacity(0.4),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      // ✅ موجات الصوت - تظهر فقط أثناء الاستماع
                      if (controller.isListening && _audioLevel > 0)
                        CustomPaint(
                          painter: VoiceWavePainter(
                            _waveController,
                            _audioLevels,
                            controller.stateColor,
                          ),
                          size: const Size(180, 180),
                        ),

                      // الزر الرئيسي
                      _buildMainButton(controller, isActive),

                      // ✅ مؤشر الحالة المحسّن
                      Positioned(
                        bottom: 8,
                        child: _buildStatusIndicator(controller),
                      ),

                      // ✅ مؤشر النص الجزئي أثناء الاستماع
                      if (controller.isListening && _partialText.isNotEmpty)
                        Positioned(
                          bottom: 50,
                          child: _buildPartialTextIndicator(),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ✅ بناء الزر الرئيسي
  Widget _buildMainButton(HawajController controller, bool isActive) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = isActive ? 1.0 + (_pulseController.value * 0.05) : 1.0;
        final opacity = isActive ? 1.0 : 0.8;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  controller.stateColor.withOpacity(opacity),
                  controller.stateColor.withOpacity(opacity * 0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: controller.stateColor.withOpacity(0.5),
                  blurRadius: isActive ? 20 : 15,
                  spreadRadius: isActive ? 4 : 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () {},
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // أيقونة الحالة
                    Icon(
                      _getIcon(controller),
                      color: Colors.white,
                      size: 32,
                    ),

                    // ✅ مؤشر الاستماع - يظهر فقط أثناء الاستماع
                    if (controller.isListening) _buildSimpleSoundIndicator(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ مؤشر الصوت المبسط
  Widget _buildSimpleSoundIndicator() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.3;
            final value =
                math.sin((_waveController.value + delay) * 2 * math.pi).abs();
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 3,
              height: 8 + (value * 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(1.5),
              ),
            );
          }),
        );
      },
    );
  }

  // ✅ الموجات الخارجية
  Widget _buildAnimatedWave(double size, double delay, Color color) {
    return AnimatedBuilder(
      animation: _rippleController,
      builder: (context, child) {
        final progress = (_rippleController.value + delay) % 1.0;
        final opacity = (1.0 - progress) * 0.4;
        final waveSize = size * (0.7 + (progress * 0.3));

        return Container(
          width: waveSize,
          height: waveSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(opacity),
              width: 1.5,
            ),
          ),
        );
      },
    );
  }

  // ✅ مؤشر الحالة المحسّن
  Widget _buildStatusIndicator(HawajController controller) {
    final isActive = controller.isListening ||
        controller.isProcessing ||
        controller.isSpeaking;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? controller.stateColor.withOpacity(0.9)
            : Colors.grey.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: controller.stateColor.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ مؤشر التحميل أثناء المعالجة
          if (controller.isProcessing)
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(left: 6),
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          Text(
            _getStateText(controller),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ جديد: مؤشر النص الجزئي
  Widget _buildPartialTextIndicator() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _partialText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // ✅ عند بداية الضغط
  void _onPressStart(HawajController controller) async {
    if (!mounted || !_permissionGranted) {
      _showPermissionDialog();
      return;
    }

    debugPrint('👆 بدء الضغط');
    HapticFeedback.lightImpact(); // ✅ اهتزازة خفيفة

    setState(() {
      _isPressing = true;
      _currentText = '';
      _partialText = '';
      _confidence = 0;
      _isCapturingFinalResult = false;
      _lastWordTime = DateTime.now();
    });

    _scaleController.reverse();

    // ✅ إيقاف أي نطق جاري
    if (controller.isSpeaking) {
      await controller.stopSpeaking();
    }

    // ✅ بدء الاستماع
    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: (result) => _handleSpeechResult(result),
        localeId: "ar-SA",
        listenMode: ListenMode.confirmation,
        partialResults: true,
        // ✅ تفعيل النتائج الجزئية
        cancelOnError: false,
        listenFor: const Duration(seconds: 30),
        // ✅ مدة استماع أطول
        pauseFor: const Duration(seconds: 5),
        // ✅ وقت توقف أطول
        onSoundLevelChange: (level) {
          if (mounted) {
            setState(() {
              _audioLevel = level;
              _audioLevels.removeAt(0);
              _audioLevels.add(level);
            });
          }
        },
      );

      debugPrint('🎤 بدأ الاستماع');
    }
  }

  // ✅ معالج نتائج الكلام المحسّن
  void _handleSpeechResult(result) {
    if (!mounted) return;

    final recognizedWords = result.recognizedWords as String;
    final isFinal = result.finalResult as bool;
    final confidence = result.confidence as double;

    setState(() {
      _lastWordTime = DateTime.now();
      _confidence = confidence;

      if (isFinal) {
        // ✅ نتيجة نهائية - الأولوية القصوى
        _currentText = recognizedWords;
        debugPrint(
            '✅ Widget - نهائي: "$recognizedWords" (ثقة: ${(confidence * 100).toStringAsFixed(1)}%)');
      } else {
        // ✅ نتيجة جزئية - للعرض فقط
        _partialText = recognizedWords;
        debugPrint(
            '📝 Widget - جزئي: "$recognizedWords" (ثقة: ${(confidence * 100).toStringAsFixed(1)}%)');
      }
    });
  }

  // ✅ عند رفع الإصبع
  void _onPressEnd(HawajController controller) async {
    if (!mounted) return;

    debugPrint('🖐️ رفع الإصبع');
    HapticFeedback.selectionClick(); // ✅ اهتزازة تأكيد

    _scaleController.forward();

    if (_speechToText.isListening) {
      setState(() => _isCapturingFinalResult = true);

      // ✅ إيقاف الاستماع
      await _speechToText.stop();

      // ✅ انتظار أطول للحصول على النتيجة النهائية
      // النظام يستغرق وقتاً لمعالجة آخر الكلمات
      await Future.delayed(const Duration(milliseconds: 800));

      _finalizeSpeech();
    }
  }

  // ✅ معالجة الكلام وإرساله للـ Controller
  void _processSpeech() {
    // ✅ فحص إذا كان قيد المعالجة بالفعل
    if (_isProcessing) {
      debugPrint('⚠️ _processSpeech - إلغاء: قيد المعالجة بالفعل');
      return;
    }

    // ✅ استخدام النص النهائي المحفوظ فقط
    final textToSend = _currentText.trim();

    debugPrint('📤 _processSpeech - النص المُرسل: "$textToSend"');

    if (_controller != null && textToSend.isNotEmpty) {
      // ✅ تعيين علامة المعالجة لمنع التكرار
      setState(() => _isProcessing = true);

      _controller!
          .processVoiceInputFromWidget(
        textToSend,
        _confidence,
        screen: widget.screen,
        section: widget.section,
      )
          .then((_) {
        // ✅ إعادة تعيين بعد اكتمال الإرسال
        if (mounted) {
          setState(() {
            _isProcessing = false;
            _currentText = '';
            _partialText = '';
          });
        }
      }).catchError((error) {
        debugPrint('❌ خطأ في الإرسال: $error');
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      });
    } else {
      debugPrint('⚠️ لا يوجد نص للإرسال (فارغ أو controller null)');
      _showErrorSnackbar('لم يتم التقاط أي صوت');
    }
  }

  // ✅ عرض رسالة خطأ
  void _showErrorSnackbar(String message) {
    if (!mounted) return;

    Get.snackbar(
      'تنبيه',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.orange.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }

  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.mic_off, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'إذن الميكروفون مطلوب',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: const Text(
          'للتمكن من استخدام المساعد الصوتي، يجب منح التطبيق إذن الوصول للميكروفون',
          style: TextStyle(height: 1.5),
        ),
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
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(HawajController controller) {
    if (controller.isListening) return Icons.mic;
    if (controller.isProcessing) return Icons.psychology_alt;
    if (controller.isSpeaking) return Icons.volume_up_rounded;
    if (controller.hasError) return Icons.error_outline_rounded;
    return Icons.assistant_rounded;
  }

  String _getStateText(HawajController controller) {
    if (controller.isListening) return 'أستمع إليك';
    if (controller.isProcessing) return 'أفكر';
    if (controller.isSpeaking) return 'أجيب';
    if (controller.hasError) return 'حاول مرة أخرى';
    return 'انقر للتحدث';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _waveController.dispose();
    _rotateController.dispose();
    _scaleController.dispose();
    _rippleController.dispose();
    _speechToText.stop();
    super.dispose();
  }
}

// ✅ Voice Wave Painter - تصميم محسّن
class VoiceWavePainter extends CustomPainter {
  final Animation<double> animation;
  final List<double> audioLevels;
  final Color color;

  VoiceWavePainter(this.animation, this.audioLevels, this.color)
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 4;

    for (int i = 0; i < audioLevels.length; i++) {
      final level = audioLevels[i];
      if (level > 0) {
        final progress = ((animation.value + (i * 0.1)) % 1.0);
        final waveRadius = baseRadius + (progress * 25) + (level * 2);

        final paint = Paint()
          ..color =
              color.withOpacity((1 - progress).clamp(0.1, 0.4) * (level / 100))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 + (level / 50);

        canvas.drawCircle(center, waveRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWavePainter oldDelegate) => true;
}

// Extension للإضافة السهلة
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
// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:speech_to_text/speech_to_text.dart';
//
// import '../controller/hawaj_ai_controller.dart';
//
// class HawajWidget extends StatefulWidget {
//   final String? welcomeMessage;
//   final String section;
//   final String screen;
//
//   const HawajWidget({
//     Key? key,
//     this.welcomeMessage,
//     required this.section,
//     required this.screen,
//   }) : super(key: key);
//
//   @override
//   State<HawajWidget> createState() => _HawajWidgetState();
// }
//
// class _HawajWidgetState extends State<HawajWidget>
//     with TickerProviderStateMixin {
//   // Animation Controllers
//   late AnimationController _pulseController;
//   late AnimationController _glowController;
//   late AnimationController _waveController;
//   late AnimationController _rotateController;
//   late AnimationController _scaleController;
//   late AnimationController _rippleController;
//
//   // Speech to Text
//   final SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//   bool _permissionGranted = false;
//
//   // State
//   HawajController? _controller;
//   bool _isInitialized = false;
//   bool _isPressing = false;
//   String _currentText = '';
//   double _confidence = 0;
//   double _audioLevel = 0;
//   List<double> _audioLevels = List.generate(8, (index) => 0.0);
//
//   @override
//   void initState() {
//     super.initState();
//     _initAnimations();
//     _initSpeech();
//     _initController();
//   }
//
//   void _initAnimations() {
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..repeat(reverse: true);
//
//     _glowController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 3000),
//     )..repeat(reverse: true);
//
//     _waveController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     )..repeat();
//
//     _rotateController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//     )..repeat();
//
//     _scaleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//       lowerBound: 0.9,
//       upperBound: 1.0,
//     )..value = 1.0;
//
//     _rippleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..repeat();
//   }
//
//   Future<void> _initSpeech() async {
//     try {
//       final status = await Permission.microphone.request();
//       if (status.isGranted) {
//         _permissionGranted = true;
//         _speechEnabled = await _speechToText.initialize(
//           onStatus: (status) {
//             if (status == 'notListening' && _currentText.isNotEmpty) {
//               _processSpeech();
//             }
//           },
//           onError: (error) {
//             debugPrint('خطأ في التعرف على الكلام: $error');
//             if (mounted) {
//               setState(() {
//                 _isPressing = false;
//               });
//             }
//           },
//         );
//         if (mounted) setState(() {});
//       }
//     } catch (e) {
//       debugPrint('خطأ في تهيئة الكلام: $e');
//     }
//   }
//
//   void _initController() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       try {
//         _controller = Get.find<HawajController>();
//         if (widget.section != null && widget.screen != null) {
//           _controller?.updateContext(
//             widget.section!,
//             widget.screen!,
//             message: widget.welcomeMessage,
//           );
//         }
//         if (mounted) {
//           setState(() => _isInitialized = true);
//         }
//       } catch (e) {
//         debugPrint('Error finding HawajController: $e');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isInitialized || _controller == null) {
//       return const SizedBox.shrink();
//     }
//
//     return GetX<HawajController>(
//       builder: (controller) {
//         final isActive = controller.isListening ||
//             controller.isProcessing ||
//             controller.isSpeaking;
//
//         return GestureDetector(
//           onTapDown: (_) => _onPressStart(controller),
//           onTapUp: (_) => _onPressEnd(controller),
//           onTapCancel: () => _onPressEnd(controller),
//           child: AnimatedBuilder(
//             animation: _scaleController,
//             builder: (context, child) {
//               return Transform.scale(
//                 scale: _scaleController.value,
//                 child: SizedBox(
//                   width: 200,
//                   height: 240,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       // الموجات الخارجية المتحركة - تصميم أنيق
//                       if (isActive) ...[
//                         _buildAnimatedWave(180, 0.0, controller.stateColor),
//                         _buildAnimatedWave(160, 0.3, controller.stateColor),
//                         _buildAnimatedWave(140, 0.6, controller.stateColor),
//                       ],
//
//                       // الهالة المتوهجة المركزية
//                       AnimatedBuilder(
//                         animation: _glowController,
//                         builder: (context, child) {
//                           final glowSize = 120 + (_glowController.value * 20);
//                           return Container(
//                             width: glowSize,
//                             height: glowSize,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: RadialGradient(
//                                 colors: [
//                                   controller.stateColor
//                                       .withOpacity(isActive ? 0.4 : 0.15),
//                                   controller.stateColor
//                                       .withOpacity(isActive ? 0.2 : 0.05),
//                                   Colors.transparent,
//                                 ],
//                                 stops: [0.0, 0.5, 1.0],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//
//                       // الحلقة الدوّارة عند المعالجة - تصميم بسيط وأنيق
//                       if (controller.isProcessing)
//                         AnimatedBuilder(
//                           animation: _rotateController,
//                           builder: (context, child) {
//                             return Transform.rotate(
//                               angle: _rotateController.value * 2 * math.pi,
//                               child: Container(
//                                 width: 100,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color:
//                                         controller.stateColor.withOpacity(0.4),
//                                     width: 2.0,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//
//                       // موجات الصوت التفاعلية - تصميم أكثر أناقة
//                       if (controller.isListening && _audioLevel > 0)
//                         CustomPaint(
//                           painter: VoiceWavePainter(
//                             _waveController,
//                             _audioLevels,
//                             controller.stateColor,
//                           ),
//                           size: const Size(180, 180),
//                         ),
//
//                       // الزر الرئيسي - تصميم عصري
//                       _buildMainButton(controller, isActive),
//
//                       // مؤشر الحالة البسيط
//                       Positioned(
//                         bottom: 8,
//                         child: _buildStatusIndicator(controller),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   // بناء الزر الرئيسي بتصميم عصري
//   Widget _buildMainButton(HawajController controller, bool isActive) {
//     return AnimatedBuilder(
//       animation: _pulseController,
//       builder: (context, child) {
//         final scale = isActive ? 1.0 + (_pulseController.value * 0.05) : 1.0;
//         final opacity = isActive ? 1.0 : 0.8;
//
//         return Transform.scale(
//           scale: scale,
//           child: Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   controller.stateColor.withOpacity(opacity),
//                   controller.stateColor.withOpacity(opacity * 0.7),
//                 ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: controller.stateColor.withOpacity(0.5),
//                   blurRadius: isActive ? 20 : 15,
//                   spreadRadius: isActive ? 4 : 2,
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(40),
//                 onTap: () {},
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // أيقونة الحالة
//                     Icon(
//                       _getIcon(controller),
//                       color: Colors.white,
//                       size: 32,
//                     ),
//
//                     // مؤشر الاستماع البسيط
//                     if (controller.isListening) _buildSimpleSoundIndicator(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // مؤشر الصوت المبسط
//   Widget _buildSimpleSoundIndicator() {
//     return AnimatedBuilder(
//       animation: _waveController,
//       builder: (context, child) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(3, (index) {
//             final delay = index * 0.3;
//             final value =
//                 math.sin((_waveController.value + delay) * 2 * math.pi).abs();
//             return Container(
//               margin: const EdgeInsets.symmetric(horizontal: 2),
//               width: 3,
//               height: 8 + (value * 12),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.9),
//                 borderRadius: BorderRadius.circular(1.5),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
//
//   // الموجات الخارجية المتحركة - تصميم أنيق
//   Widget _buildAnimatedWave(double size, double delay, Color color) {
//     return AnimatedBuilder(
//       animation: _rippleController,
//       builder: (context, child) {
//         final progress = (_rippleController.value + delay) % 1.0;
//         final opacity = (1.0 - progress) * 0.4;
//         final waveSize = size * (0.7 + (progress * 0.3));
//
//         return Container(
//           width: waveSize,
//           height: waveSize,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: color.withOpacity(opacity),
//               width: 1.5,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // مؤشر الحالة البسيط
//   Widget _buildStatusIndicator(HawajController controller) {
//     final isActive = controller.isListening ||
//         controller.isProcessing ||
//         controller.isSpeaking;
//
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: isActive
//             ? controller.stateColor.withOpacity(0.9)
//             : Colors.grey.withOpacity(0.7),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           if (isActive)
//             BoxShadow(
//               color: controller.stateColor.withOpacity(0.4),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (controller.isProcessing)
//             Container(
//               width: 10,
//               height: 10,
//               margin: const EdgeInsets.only(left: 6),
//               child: CircularProgressIndicator(
//                 strokeWidth: 1.5,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//           Text(
//             _getStateText(controller),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // عند بداية الضغط
//   void _onPressStart(HawajController controller) async {
//     if (!mounted || !_permissionGranted) {
//       _showPermissionDialog();
//       return;
//     }
//
//     HapticFeedback.lightImpact();
//
//     setState(() {
//       _isPressing = true;
//       _currentText = '';
//       _confidence = 0;
//     });
//
//     _scaleController.reverse();
//
//     if (controller.isSpeaking) {
//       await controller.stopSpeaking();
//     }
//
//     if (_speechEnabled) {
//       await _speechToText.listen(
//         onResult: (result) {
//           if (mounted) {
//             setState(() {
//               _currentText = result.recognizedWords;
//               _confidence = result.confidence;
//             });
//           }
//         },
//         localeId: "ar-SA",
//         listenMode: ListenMode.confirmation,
//         partialResults: true,
//         onSoundLevelChange: (level) {
//           if (mounted) {
//             setState(() {
//               _audioLevel = level;
//               _audioLevels.removeAt(0);
//               _audioLevels.add(level);
//             });
//           }
//         },
//       );
//     }
//   }
//
//   // عند رفع الإصبع
//   void _onPressEnd(HawajController controller) async {
//     if (!mounted) return;
//
//     HapticFeedback.selectionClick();
//
//     setState(() => _isPressing = false);
//     _scaleController.forward();
//
//     if (_speechToText.isListening) {
//       await _speechToText.stop();
//     }
//
//     if (_currentText.isNotEmpty) {
//       _processSpeech();
//     }
//   }
//
//   // معالجة الكلام وإرساله للـ Controller
//   void _processSpeech() {
//     if (_controller != null && _currentText.isNotEmpty) {
//       _controller!.processVoiceInputFromWidget(
//         _currentText,
//         _confidence,
//         screen: widget.screen,
//         section: widget.section,
//       );
//     }
//   }
//
//   void _showPermissionDialog() {
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: const [
//             Icon(Icons.mic_off, color: Colors.orange, size: 28),
//             SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 'إذن الميكروفون مطلوب',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//         content: const Text(
//           'للتمكن من استخدام المساعد الصوتي، يجب منح التطبيق إذن الوصول للميكروفون',
//           style: TextStyle(height: 1.5),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text('لاحقاً'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               openAppSettings();
//             },
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text('فتح الإعدادات'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   IconData _getIcon(HawajController controller) {
//     if (controller.isListening) return Icons.mic;
//     if (controller.isProcessing) return Icons.psychology_alt;
//     if (controller.isSpeaking) return Icons.volume_up_rounded;
//     if (controller.hasError) return Icons.error_outline_rounded;
//     return Icons.assistant_rounded;
//   }
//
//   String _getStateText(HawajController controller) {
//     if (controller.isListening) return 'أستمع إليك';
//     if (controller.isProcessing) return 'أفكر';
//     if (controller.isSpeaking) return 'أجيب';
//     if (controller.hasError) return 'حاول مرة أخرى';
//     return 'انقر للتحدث';
//   }
//
//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _glowController.dispose();
//     _waveController.dispose();
//     _rotateController.dispose();
//     _scaleController.dispose();
//     _rippleController.dispose();
//     _speechToText.stop();
//     super.dispose();
//   }
// }
//
// // Voice Wave Painter - تصميم مبسط
// class VoiceWavePainter extends CustomPainter {
//   final Animation<double> animation;
//   final List<double> audioLevels;
//   final Color color;
//
//   VoiceWavePainter(this.animation, this.audioLevels, this.color)
//       : super(repaint: animation);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final baseRadius = size.width / 4;
//
//     for (int i = 0; i < audioLevels.length; i++) {
//       final level = audioLevels[i];
//       if (level > 0) {
//         final progress = ((animation.value + (i * 0.1)) % 1.0);
//         final waveRadius = baseRadius + (progress * 25) + (level * 2);
//
//         final paint = Paint()
//           ..color =
//               color.withOpacity((1 - progress).clamp(0.1, 0.4) * (level / 100))
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 1.5 + (level / 50);
//
//         canvas.drawCircle(center, waveRadius, paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant VoiceWavePainter oldDelegate) => true;
// }
//
// // Extension للإضافة السهلة
// extension HawajExtension on Widget {
//   Widget withHawaj({
//     String section = "1",
//     String screen = "1",
//     String? message,
//     AlignmentGeometry alignment = Alignment.bottomCenter,
//     EdgeInsets padding = const EdgeInsets.only(bottom: 50),
//   }) {
//     return Stack(
//       children: [
//         this,
//         Positioned.fill(
//           child: Align(
//             alignment: alignment,
//             child: Padding(
//               padding: padding,
//               child: HawajWidget(
//                 section: section,
//                 screen: screen,
//                 welcomeMessage: message,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
