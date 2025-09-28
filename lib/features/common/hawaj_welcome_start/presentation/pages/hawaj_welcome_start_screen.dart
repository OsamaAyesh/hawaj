import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/features/common/map/presenation/pages/map_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  late AnimationController _buttonAnimationController;
  late ConfettiController _confettiController;

  /// Speech to Text
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  bool _permissionGranted = false;
  bool _showActionButton = false;
  double _audioLevel = 0.0;
  List<double> _audioLevels = List.generate(20, (index) => 0.0);

  @override
  void initState() {
    super.initState();

    // Animations
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    // Speech
    _initSpeech();
  }

  /// Initialize Speech Recognition
  Future<void> _initSpeech() async {
    /// ======== Request microphone permission first
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
      });

      ///====== Initialize speech recognition after getting permission
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          print('Speech recognition status: $status');
          if (status == 'notListening' && _isListening) {
            setState(() {
              _isListening = false;
              _showActionButton = _wordsSpoken.isNotEmpty;
              if (_showActionButton) {
                _buttonAnimationController.forward();
                _confettiController.play();
              }
            });
          }
        },
        onError: (error) {
          print('Speech recognition error: $error');
        },
      );
      setState(() {});
    } else {
      ///===== If permission was not granted
      print('Microphone permission denied');
    }
  }

  Future<void> _startListening() async {
    if (!_permissionGranted) {
      /// ====== If we don't have permission, request it again
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        /// ==== Inform the user that permission is required
        if (mounted) {
          AppSnackbar.error(
            "يجب منح إذن استخدام الميكروفون للتمكن من التحدث",
            englishMessage:
                "You must grant microphone permission in order to speak",
          );
        }
        return;
      } else {
        setState(() {
          _permissionGranted = true;
        });

        ///====== Initialize speech recognition after obtaining permission
        _speechEnabled = await _speechToText.initialize(
          onStatus: (status) {
            print('Speech recognition status: $status');
          },
          onError: (error) {
            print('Speech recognition error: $error');
          },
        );
      }
    }

    setState(() {
      _showActionButton = false;
      _wordsSpoken = "";
      _buttonAnimationController.reset();
    });

    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: "ar-SA",
        listenMode: ListenMode.confirmation,
        onSoundLevelChange: (level) {
          setState(() {
            _audioLevel = level;
            _audioLevels.removeAt(0);
            _audioLevels.add(level);
          });
        },
      );
      setState(() {
        _isListening = true;
      });
    } else {
      /// ====== Reinitialize speech recognition if necessary
      await _initSpeech();
      if (_speechEnabled) {
        await _startListening();
      }
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
      _showActionButton = _wordsSpoken.isNotEmpty;
      if (_showActionButton) {
        _buttonAnimationController.forward();
        _confettiController.play();
      }
    });
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      _confidenceLevel = result.confidence;

      ///======= If recognized speech is detected, we can add an automatic response
      if (_wordsSpoken.isNotEmpty &&
          _wordsSpoken.length > 3 &&
          !_speechToText.isListening) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _wordsSpoken =
                  "حوّاج: سأساعدك في العثور على ${result.recognizedWords}";
            });
          }
        });
      }
    });
  }

  void _navigateToResults() {
    ///====== Navigate to the results or map page
    Get.to(
      () => const MapScreen(),
      binding: MapBindings(),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _waveController.dispose();
    _buttonAnimationController.dispose();
    _confettiController.dispose();
    _speechToText.stop();
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

          /// Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
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
                  padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w28),
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

                /// Suggestions Card + Spoken Words
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ManagerWidth.w20,
                    vertical: ManagerHeight.h12,
                  ),
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
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          key: ValueKey(_wordsSpoken),
                          _wordsSpoken.isNotEmpty
                              ? _wordsSpoken
                              : "حوّاج: خليني أنصحك بأفضل عروض الأكل اليوم ",
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (_speechToText.isNotListening && _confidenceLevel > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "مستوى الثقة: ${(_confidenceLevel * 100.0).toStringAsFixed(1)}%",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
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

                    // Waves around mic based on audio level
                    CustomPaint(
                      painter: VoiceWavePainter(_waveController, _audioLevels),
                      size: const Size(180, 180),
                    ),

                    // Main Mic button
                    ElevatedButton(
                      onPressed: _speechToText.isListening
                          ? _stopListening
                          : _startListening,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(28),
                        backgroundColor: _permissionGranted
                            ? ManagerColors.primaryColor
                            : Colors.grey,
                        shadowColor: _permissionGranted
                            ? ManagerColors.primaryColor.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.5),
                        elevation: 12,
                      ),
                      child: Icon(
                        _speechToText.isListening ? Icons.mic : Icons.mic_none,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                ///======== Display a message if permission is not granted
                if (!_permissionGranted)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'يجب منح إذن استخدام الميكروفون للتمكن من التحدث',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: ManagerFontSize.s14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const Spacer(),

                ///====== Animated action button that appears after speech
                // if (_showActionButton)
                // ScaleTransition(
                //   scale: CurvedAnimation(
                //     parent: _buttonAnimationController,
                //     curve: Curves.elasticOut,
                //   ),
                //   child:
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: _navigateToResults,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ManagerColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                    ),
                    icon: const Icon(Icons.search, size: 24),
                    label: Text(
                      "استمر للنتائج",
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.white,
                      ),
                    ),
                  ),
                ),
                // ),

                if (!_showActionButton) SizedBox(height: ManagerHeight.h20),
              ],
            ),
          )
          //           .withHawajVoiceAdvanced(
          //         section: "2",
          // screen: "1",
          // welcomeMessage: "مرحباً بك في المنتجات",
          // x: 20,
          // y: 100,
          // ),
        ],
      ),
    );
    // .withHawajVoiceSmart();
  }
}

/// ====== Voice Wave Painter for Animated Mic ======
class VoiceWavePainter extends CustomPainter {
  final Animation<double> animation;
  final List<double> audioLevels;

  VoiceWavePainter(this.animation, this.audioLevels)
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 4;

    /// ======= Draw multiple waves based on the sound level
    for (int i = 0; i < audioLevels.length; i++) {
      final level = audioLevels[i];
      if (level > 0) {
        final progress = ((animation.value + (i * 0.05)) % 1.0);
        final waveRadius = baseRadius + (progress * 40) + (level * 5);

        final paint = Paint()
          ..color = Colors.deepPurple
              .withOpacity((1 - progress).clamp(0.1, 0.5) * (level / 100))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 + (level / 30);

        canvas.drawCircle(center, waveRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWavePainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.audioLevels != audioLevels;
}
