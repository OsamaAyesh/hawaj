import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/hawaj_ai_controller.dart';

class HawajFloatingAssistant extends StatefulWidget {
  final String? initialMessage;
  final double? left;
  final double? bottom;
  final double? right;
  final double? top;
  final bool autoShow;
  final VoidCallback? onDragEnd;

  const HawajFloatingAssistant({
    Key? key,
    this.initialMessage,
    this.left,
    this.bottom,
    this.right,
    this.top,
    this.autoShow = true,
    this.onDragEnd,
  }) : super(key: key);

  @override
  State<HawajFloatingAssistant> createState() => _HawajFloatingAssistantState();
}

class _HawajFloatingAssistantState extends State<HawajFloatingAssistant>
    with TickerProviderStateMixin {
  bool _isDragging = false;
  Offset _dragStart = Offset.zero;

  @override
  void initState() {
    super.initState();

    if (widget.autoShow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeAssistant();
      });
    }
  }

  void _initializeAssistant() {
    try {
      final controller = Get.find<HawajAIController>();
      controller.show();

      if (widget.initialMessage != null) {
        controller.setMessage(widget.initialMessage!);
      }
    } catch (e) {
      print('Error initializing Hawaj Assistant: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HawajAIController>(
      builder: (controller) {
        if (!controller.isVisible) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: widget.left ?? controller.positionX,
          bottom: widget.bottom,
          right: widget.right,
          top: widget.top ?? controller.positionY,
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: (details) => _onPanUpdate(details, controller),
            onPanEnd: _onPanEnd,
            onTap: () => _handleTap(controller),
            child: AnimatedBuilder(
              animation: Listenable.merge([
                controller.pulseAnimation,
                controller.breathingAnimation,
                controller.scaleAnimation,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _getScaleTransform(controller),
                  child: _buildAssistantWidget(controller),
                );
              },
            ),
          ),
        );
      },
    );
  }

  double _getScaleTransform(HawajAIController controller) {
    double scale = 1.0;

    if (controller.currentState == AssistantState.idle) {
      scale *= controller.breathingAnimation.value;
    }

    if (controller.isListening ||
        controller.isSpeaking ||
        controller.isProcessing) {
      scale *= controller.pulseAnimation.value;
    }

    if (_isDragging) {
      scale *= 0.95;
    }

    return scale * controller.scaleAnimation.value;
  }

  Widget _buildAssistantWidget(HawajAIController controller) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      width: _getWidgetWidth(controller),
      height: _getWidgetHeight(controller),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background with gradient and shadows
          _buildBackground(controller),

          // Wave effect for listening
          if (controller.isListening) _buildWaveEffect(controller),

          // Main content
          controller.isExpanded
              ? _buildExpandedContent(controller)
              : _buildCompactContent(controller),

          // Floating particles effect
          if (controller.isSpeaking) _buildParticleEffect(controller),

          // Error indicator
          if (controller.hasError) _buildErrorIndicator(controller),
        ],
      ),
    );
  }

  double _getWidgetWidth(HawajAIController controller) {
    if (controller.isExpanded) {
      return MediaQuery.of(context).size.width * 0.85;
    }
    return 72.0;
  }

  double _getWidgetHeight(HawajAIController controller) {
    if (controller.isExpanded) {
      return 180.0;
    }
    return 72.0;
  }

  Widget _buildBackground(HawajAIController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            controller.stateColor,
            controller.stateColor.withOpacity(0.8),
            controller.stateColor.withOpacity(0.6),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(controller.isExpanded ? 24 : 36),
        boxShadow: [
          // Main shadow
          BoxShadow(
            color: controller.stateColor.withOpacity(0.4),
            blurRadius: controller.isListening ? 25 : 15,
            spreadRadius: controller.isListening ? 8 : 4,
            offset: const Offset(0, 6),
          ),
          // Glow effect
          BoxShadow(
            color: controller.stateColor.withOpacity(0.2),
            blurRadius: controller.isListening ? 40 : 25,
            spreadRadius: controller.isListening ? 15 : 8,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveEffect(HawajAIController controller) {
    return Positioned.fill(
      child: CustomPaint(
        painter: VoiceWavePainter(
          animation: controller.waveAnimation,
          audioLevels: controller.audioLevels,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildCompactContent(HawajAIController controller) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main icon with animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0,
            end: controller.isListening ? math.pi * 2 : 0,
          ),
          duration: const Duration(milliseconds: 1000),
          builder: (context, rotation, child) {
            return Transform.rotate(
              angle: controller.isProcessing ? rotation : 0,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: AnimatedSwitcher(
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
                    controller.stateIcon,
                    key: ValueKey(controller.currentState),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            );
          },
        ),

        // Loading indicator
        if (controller.isProcessing)
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.8),
              ),
            ),
          ),

        // Confidence indicator
        if (controller.confidenceLevel > 0 && !controller.isExpanded)
          Positioned(
            bottom: -2,
            right: -2,
            child: _buildConfidenceBadge(controller),
          ),
      ],
    );
  }

  Widget _buildExpandedContent(HawajAIController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status and close button
          _buildExpandedHeader(controller),

          const SizedBox(height: 16),

          // Message area with typing effect
          Expanded(child: _buildMessageArea(controller)),

          const SizedBox(height: 16),

          // Voice input preview
          if (controller.voiceText.isNotEmpty) _buildVoicePreview(controller),

          const SizedBox(height: 12),

          // Control buttons
          _buildControlButtons(controller),
        ],
      ),
    );
  }

  Widget _buildExpandedHeader(HawajAIController controller) {
    return Row(
      children: [
        // Status indicator with animation
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              controller.stateIcon,
              key: ValueKey(controller.currentState),
              color: Colors.white,
              size: 16,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Status text with emoji
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${controller.stateEmoji} حواج المساعد الذكي',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.stateText,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Close button with hover effect
        GestureDetector(
          onTap: () => controller.collapse(),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageArea(HawajAIController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            controller.currentMessage,
            key: ValueKey(controller.currentMessage),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoicePreview(HawajAIController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: Colors.white.withOpacity(0.8),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '"${controller.voiceText}"',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (controller.confidenceLevel > 0) _buildConfidenceBadge(controller),
        ],
      ),
    );
  }

  Widget _buildControlButtons(HawajAIController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Microphone button
        _buildControlButton(
          icon: controller.isListening
              ? Icons.mic_off_rounded
              : Icons.mic_rounded,
          onTap: () => controller.toggleListening(),
          isActive: controller.isListening,
          color: controller.isListening ? Colors.red : Colors.white,
        ),

        // Stop speaking button
        if (controller.isSpeaking)
          _buildControlButton(
            icon: Icons.stop_rounded,
            onTap: () => controller.stopSpeaking(),
            isActive: true,
            color: Colors.red,
          ),

        // Clear button
        _buildControlButton(
          icon: Icons.refresh_rounded,
          onTap: () => controller.clearResponse(),
          isActive: false,
          color: Colors.white,
        ),

        // Settings button
        _buildControlButton(
          icon: Icons.settings_rounded,
          onTap: () => _showSettings(controller),
          isActive: false,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isActive,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
        // Haptic feedback
        final controller = Get.find<HawajAIController>();
        controller.performInteraction();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color:
              isActive ? color.withOpacity(0.3) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: color.withOpacity(isActive ? 0.6 : 0.3),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildConfidenceBadge(HawajAIController controller) {
    final confidence = (controller.confidenceLevel * 100).toInt();
    final badgeColor = _getConfidenceColor(controller.confidenceLevel);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$confidence%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildParticleEffect(HawajAIController controller) {
    return Positioned.fill(
      child: CustomPaint(
        painter: ParticleEffectPainter(
          animation: controller.pulseAnimation,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildErrorIndicator(HawajAIController controller) {
    return Positioned(
      top: -8,
      right: -8,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 14,
        ),
      ),
    );
  }

  // Event handlers
  void _onPanStart(DragStartDetails details) {
    _isDragging = true;
    _dragStart = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details, HawajAIController controller) {
    if (_isDragging) {
      final newX = details.globalPosition.dx - _dragStart.dx;
      final newY = details.globalPosition.dy - _dragStart.dy;
      controller.updatePosition(newX, newY);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _isDragging = false;
    widget.onDragEnd?.call();
  }

  void _handleTap(HawajAIController controller) {
    controller.performInteraction();

    if (controller.hasError) {
      controller.clearResponse();
      return;
    }

    if (controller.isExpanded) {
      // In expanded mode, toggle listening
      controller.toggleListening();
    } else {
      // In compact mode, expand the widget
      controller.expand();
    }
  }

  void _showSettings(HawajAIController controller) {
    // Show settings bottom sheet
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إعدادات المساعد الصوتي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: controller.stateColor,
              ),
            ),
            const SizedBox(height: 20),

            // Statistics
            _buildStatItem('المحادثات', '${controller.conversationCount}'),
            _buildStatItem('وقت الاستجابة', '${controller.responseTime}ms'),
            _buildStatItem('مستوى الثقة',
                '${(controller.confidenceLevel * 100).toInt()}%'),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                controller.resetStats();
                Get.back();
              },
              child: const Text('إعادة تعيين الإحصائيات'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }
}

// ==================== Custom Painters ====================

class VoiceWavePainter extends CustomPainter {
  final Animation<double> animation;
  final List<double> audioLevels;
  final Color color;

  VoiceWavePainter({
    required this.animation,
    required this.audioLevels,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 4;

    for (int i = 0; i < math.min(audioLevels.length, 5); i++) {
      final level = audioLevels[i];
      if (level > 0.1) {
        final progress = ((animation.value + (i * 0.2)) % 1.0);
        final waveRadius = baseRadius + (progress * 40) + (level * 8);

        final paint = Paint()
          ..color = color.withOpacity(
            (1 - progress).clamp(0.1, 0.8) * (level / 100),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 + (level / 20);

        canvas.drawCircle(center, waveRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWavePainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.audioLevels != audioLevels;
}

class ParticleEffectPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  ParticleEffectPainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = color;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (math.pi / 180);
      final distance = 20 + (animation.value * 15);

      final particleX = center.dx + math.cos(angle) * distance;
      final particleY = center.dy + math.sin(angle) * distance;

      canvas.drawCircle(
        Offset(particleX, particleY),
        2 + (animation.value * 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticleEffectPainter oldDelegate) =>
      oldDelegate.animation != animation;
}
// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_font_size.dart';
// import 'package:app_mobile/core/resources/manager_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controller/hawaj_ai_controller.dart';
//
// class EliteFloatingVoiceAssistant extends StatefulWidget {
//   final double? initialX;
//   final double? initialY;
//   final bool autoShow;
//   final String? initialMessage;
//   final VoidCallback? onDragEnd;
//
//   const EliteFloatingVoiceAssistant({
//     super.key,
//     this.initialX,
//     this.initialY,
//     this.autoShow = true,
//     this.initialMessage,
//     this.onDragEnd,
//   });
//
//   @override
//   State<EliteFloatingVoiceAssistant> createState() =>
//       _EliteFloatingVoiceAssistantState();
// }
//
// class _EliteFloatingVoiceAssistantState
//     extends State<EliteFloatingVoiceAssistant> with TickerProviderStateMixin {
//   late AnimationController _breathingController;
//   late AnimationController _waveController;
//   late AnimationController _expandController;
//   late AnimationController _glowController;
//
//   late Animation<double> _breathingAnimation;
//   late Animation<double> _waveAnimation;
//   late Animation<double> _expandAnimation;
//   late Animation<double> _glowAnimation;
//
//   bool _isDragging = false;
//   Offset _dragOffset = Offset.zero;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//
//     if (widget.autoShow) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         final controller = Get.find<HawajAIController>();
//         controller.show();
//
//         if (widget.initialMessage != null) {
//           controller.setMessage(widget.initialMessage!);
//         }
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _breathingController.dispose();
//     _waveController.dispose();
//     _expandController.dispose();
//     _glowController.dispose();
//     super.dispose();
//   }
//
//   void _initializeAnimations() {
//     // Breathing animation for idle state
//     _breathingController = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );
//     _breathingAnimation = Tween<double>(
//       begin: 0.95,
//       end: 1.05,
//     ).animate(CurvedAnimation(
//       parent: _breathingController,
//       curve: Curves.easeInOut,
//     ));
//
//     // Wave animation for listening state
//     _waveController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _waveAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _waveController,
//       curve: Curves.easeOut,
//     ));
//
//     // Expand animation for showing/hiding
//     _expandController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//     _expandAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _expandController,
//       curve: Curves.elasticOut,
//     ));
//
//     // Glow animation for speaking state
//     _glowController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
//     _glowAnimation = Tween<double>(
//       begin: 0.3,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _glowController,
//       curve: Curves.easeInOut,
//     ));
//
//     _breathingController.repeat(reverse: true);
//   }
//
//   void _updateAnimations(AssistantState state) {
//     switch (state) {
//       case AssistantState.listening:
//         _waveController.repeat();
//         _glowController.stop();
//         break;
//       case AssistantState.speaking:
//         _glowController.repeat(reverse: true);
//         _waveController.stop();
//         break;
//       case AssistantState.processing:
//         _waveController.repeat();
//         _glowController.repeat(reverse: true);
//         break;
//       case AssistantState.idle:
//       case AssistantState.error:
//       default:
//         _waveController.stop();
//         _glowController.stop();
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HawajAIController>(
//       builder: (controller) {
//         if (!controller.isVisible) return const SizedBox.shrink();
//
//         _updateAnimations(controller.currentState);
//
//         return Positioned(
//           left: widget.initialX ?? controller.positionX,
//           top: widget.initialY ?? controller.positionY,
//           child: GestureDetector(
//             onPanStart: (details) {
//               _isDragging = true;
//               _dragOffset = details.localPosition;
//             },
//             onPanUpdate: (details) {
//               if (_isDragging) {
//                 final newX = details.globalPosition.dx - _dragOffset.dx;
//                 final newY = details.globalPosition.dy - _dragOffset.dy;
//                 controller.updatePosition(newX, newY);
//               }
//             },
//             onPanEnd: (details) {
//               _isDragging = false;
//               widget.onDragEnd?.call();
//             },
//             onTap: () => _handleTap(controller),
//             child: AnimatedBuilder(
//               animation: Listenable.merge([
//                 _expandAnimation,
//                 _breathingAnimation,
//               ]),
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: _expandAnimation.value * _breathingAnimation.value,
//                   child: controller.isExpanded
//                       ? _buildExpandedWidget(controller)
//                       : _buildCompactWidget(controller),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildCompactWidget(HawajAIController controller) {
//     return Container(
//       width: 70,
//       height: 70,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Glow effect
//           AnimatedBuilder(
//             animation: _glowAnimation,
//             builder: (context, child) {
//               return Container(
//                 width: 80 + (_glowAnimation.value * 20),
//                 height: 80 + (_glowAnimation.value * 20),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: controller.stateColor
//                           .withOpacity(0.4 * _glowAnimation.value),
//                       blurRadius: 20 + (_glowAnimation.value * 10),
//                       spreadRadius: 5 + (_glowAnimation.value * 5),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//
//           // Wave effect for listening
//           if (controller.isListening)
//             CustomPaint(
//               painter: VoiceWavePainter(
//                 animation: _waveAnimation,
//                 audioLevels: controller.audioLevels,
//                 color: controller.stateColor,
//               ),
//               size: const Size(100, 100),
//             ),
//
//           // Main button
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   controller.stateColor.withOpacity(0.8),
//                   controller.stateColor,
//                   controller.stateColor.withOpacity(0.9),
//                 ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: controller.stateColor.withOpacity(0.5),
//                   blurRadius: 15,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(30),
//                 onTap: () => _handleTap(controller),
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   child: Icon(
//                     controller.stateIcon,
//                     key: ValueKey(controller.currentState),
//                     color: Colors.white,
//                     size: 28,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // Loading indicator for processing
//           if (controller.isProcessing)
//             Positioned.fill(
//               child: CircularProgressIndicator(
//                 strokeWidth: 3,
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                     Colors.white.withOpacity(0.8)),
//                 backgroundColor: Colors.white.withOpacity(0.2),
//               ),
//             ),
//
//           // Confidence indicator
//           if (controller.confidenceLevel > 0 && !controller.isExpanded)
//             Positioned(
//               bottom: -5,
//               right: -5,
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: _getConfidenceColor(controller.confidenceLevel),
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 child: Text(
//                   '${(controller.confidenceLevel * 100).toInt()}%',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 8,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildExpandedWidget(HawajAIController controller) {
//     return Container(
//       width: 320,
//       constraints: const BoxConstraints(maxHeight: 400),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//           BoxShadow(
//             color: controller.stateColor.withOpacity(0.1),
//             blurRadius: 40,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildExpandedHeader(controller),
//           _buildExpandedContent(controller),
//           _buildExpandedControls(controller),
//           if (controller.hasError) _buildErrorSection(controller),
//           _buildExpandedFooter(controller),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildExpandedHeader(HawajAIController controller) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             controller.stateColor.withOpacity(0.1),
//             controller.stateColor.withOpacity(0.05),
//           ],
//         ),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//       ),
//       child: Row(
//         children: [
//           // State indicator with animation
//           AnimatedBuilder(
//             animation: _glowAnimation,
//             builder: (context, child) {
//               return Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: controller.stateColor,
//                   boxShadow: [
//                     BoxShadow(
//                       color: controller.stateColor
//                           .withOpacity(0.4 * _glowAnimation.value),
//                       blurRadius: 10 + (_glowAnimation.value * 5),
//                       spreadRadius: 2 + (_glowAnimation.value * 2),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   controller.stateIcon,
//                   color: Colors.white,
//                   size: 24,
//                 ),
//               );
//             },
//           ),
//
//           const SizedBox(width: 15),
//
//           // Title and status
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'حوّاج المساعد الذكي',
//                   style: getBoldTextStyle(
//                     fontSize: ManagerFontSize.s16,
//                     color: ManagerColors.primaryColor,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   child: Text(
//                     key: ValueKey(controller.stateText),
//                     controller.stateText,
//                     style: getRegularTextStyle(
//                       fontSize: ManagerFontSize.s12,
//                       color: controller.stateColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Close button
//           IconButton(
//             onPressed: controller.collapse,
//             icon: const Icon(Icons.close, color: Colors.grey),
//             iconSize: 20,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildExpandedContent(HawajAIController controller) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           // Current message with typewriter effect
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(
//                 color: controller.stateColor.withOpacity(0.2),
//               ),
//             ),
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 500),
//               child: Text(
//                 key: ValueKey(controller.currentMessage),
//                 controller.currentMessage,
//                 style: getRegularTextStyle(
//                   fontSize: ManagerFontSize.s14,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//
//           // Voice text preview
//           if (controller.voiceText.isNotEmpty)
//             Container(
//               margin: const EdgeInsets.only(top: 12),
//               padding: const EdgeInsets.all(12),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     controller.stateColor.withOpacity(0.1),
//                     controller.stateColor.withOpacity(0.05),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: controller.stateColor.withOpacity(0.3),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.format_quote_rounded,
//                     color: controller.stateColor,
//                     size: 18,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       '"${controller.voiceText}"',
//                       style: getRegularTextStyle(
//                         fontSize: ManagerFontSize.s13,
//                         color: controller.stateColor,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   if (controller.confidenceLevel > 0)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: _getConfidenceColor(controller.confidenceLevel),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         '${(controller.confidenceLevel * 100).toInt()}%',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//
//           // Audio level visualization
//           if (controller.isListening)
//             Container(
//               margin: const EdgeInsets.only(top: 12),
//               height: 60,
//               child: CustomPaint(
//                 painter: AudioVisualizerPainter(
//                   audioLevels: controller.audioLevels,
//                   color: controller.stateColor,
//                 ),
//                 size: const Size(double.infinity, 60),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildExpandedControls(HawajAIController controller) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           // Stop speaking button
//           if (controller.isSpeaking)
//             _buildControlButton(
//               icon: Icons.stop_circle_outlined,
//               label: 'إيقاف',
//               color: Colors.red,
//               onTap: controller.stopSpeaking,
//               isActive: true,
//             ),
//
//           // Microphone toggle button
//           _buildControlButton(
//             icon: controller.isListening
//                 ? Icons.mic_off_rounded
//                 : Icons.mic_rounded,
//             label: controller.isListening ? 'إيقاف' : 'استمع',
//             color: controller.isListening ? Colors.red : controller.stateColor,
//             onTap: controller.toggleListening,
//             isActive: controller.isListening,
//           ),
//
//           // Clear button
//           _buildControlButton(
//             icon: Icons.refresh_rounded,
//             label: 'مسح',
//             color: Colors.grey[600]!,
//             onTap: () {
//               controller.clearResponse();
//               controller.setMessage('مرحباً! كيف يمكنني مساعدتك؟ 🤖');
//             },
//             isActive: false,
//           ),
//
//           // Settings button
//           _buildControlButton(
//             icon: Icons.settings_rounded,
//             label: 'إعدادات',
//             color: Colors.grey[500]!,
//             onTap: () {
//               // Handle settings
//             },
//             isActive: false,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorSection(HawajAIController controller) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.red[50],
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.red[300]!),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.error_outline, color: Colors.red[700], size: 20),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               controller.errorMessage,
//               style: getRegularTextStyle(
//                 fontSize: ManagerFontSize.s12,
//                 color: Colors.red[700]!,
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               // Clear error and try again
//               controller.clearResponse();
//             },
//             icon: Icon(Icons.close, color: Colors.red[700], size: 16),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildExpandedFooter(HawajAIController controller) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(25),
//           bottomRight: Radius.circular(25),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildStatItem(
//             icon: Icons.chat_bubble_outline_rounded,
//             label: 'المحادثات',
//             value: '${controller.conversationCount}',
//             color: Colors.blue,
//           ),
//           _buildStatItem(
//             icon: Icons.speed_rounded,
//             label: 'الاستجابة',
//             value: '${controller.responseTime}ms',
//             color: Colors.green,
//           ),
//           _buildStatItem(
//             icon: Icons.location_on_outlined,
//             label: 'الموقع',
//             value: '${controller.currentSection}.${controller.currentScreen}',
//             color: Colors.orange,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildControlButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//     required bool isActive,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: isActive ? color.withOpacity(0.1) : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: color.withOpacity(isActive ? 0.5 : 0.3),
//             width: isActive ? 2 : 1,
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isActive ? color : color.withOpacity(0.1),
//               ),
//               child: Icon(
//                 icon,
//                 color: isActive ? Colors.white : color,
//                 size: 18,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: getRegularTextStyle(
//                 fontSize: ManagerFontSize.s10,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, color: color, size: 16),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: getBoldTextStyle(
//             fontSize: ManagerFontSize.s12,
//             color: color,
//           ),
//         ),
//         Text(
//           label,
//           style: getRegularTextStyle(
//             fontSize: ManagerFontSize.s10,
//             color: Colors.grey[600]!,
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _handleTap(HawajAIController controller) {
//     if (controller.hasError) {
//       controller.clearResponse();
//       return;
//     }
//
//     if (controller.isExpanded) {
//       // In expanded mode, handle microphone toggle
//       controller.toggleListening();
//     } else {
//       // In compact mode, expand the widget
//       controller.expand();
//       _expandController.forward();
//     }
//   }
//
//   Color _getConfidenceColor(double confidence) {
//     if (confidence >= 0.8) return Colors.green;
//     if (confidence >= 0.6) return Colors.orange;
//     return Colors.red;
//   }
// }
//
// // Custom Painter for Voice Waves
// class VoiceWavePainter extends CustomPainter {
//   final Animation<double> animation;
//   final List<double> audioLevels;
//   final Color color;
//
//   VoiceWavePainter({
//     required this.animation,
//     required this.audioLevels,
//     required this.color,
//   }) : super(repaint: animation);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final baseRadius = size.width / 4;
//
//     for (int i = 0; i < audioLevels.length && i < 5; i++) {
//       final level = audioLevels[i];
//       if (level > 0.1) {
//         final progress = ((animation.value + (i * 0.1)) % 1.0);
//         final waveRadius = baseRadius + (progress * 30) + (level * 3);
//
//         final paint = Paint()
//           ..color =
//               color.withOpacity((1 - progress).clamp(0.1, 0.6) * (level / 100))
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2.0 + (level / 20);
//
//         canvas.drawCircle(center, waveRadius, paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant VoiceWavePainter oldDelegate) =>
//       oldDelegate.animation != animation ||
//       oldDelegate.audioLevels != audioLevels;
// }
//
// // Custom Painter for Audio Visualizer
// class AudioVisualizerPainter extends CustomPainter {
//   final List<double> audioLevels;
//   final Color color;
//
//   AudioVisualizerPainter({
//     required this.audioLevels,
//     required this.color,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//
//     final barWidth = size.width / audioLevels.length;
//
//     for (int i = 0; i < audioLevels.length; i++) {
//       final level = audioLevels[i];
//       final barHeight = (level / 100) * size.height;
//
//       final rect = Rect.fromLTWH(
//         i * barWidth,
//         size.height - barHeight,
//         barWidth * 0.8,
//         barHeight,
//       );
//
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, const Radius.circular(2)),
//         paint..color = color.withOpacity(0.3 + (level / 100) * 0.7),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant AudioVisualizerPainter oldDelegate) =>
//       oldDelegate.audioLevels != audioLevels;
// }
