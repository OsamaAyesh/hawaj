import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/hawaj_ai_controller.dart';

class HawajGlobalWidget extends StatelessWidget {
  final String section;
  final String screen;
  final String? welcomeMessage;
  final double? left;
  final double? bottom;

  const HawajGlobalWidget({
    Key? key,
    required this.section,
    required this.screen,
    this.welcomeMessage,
    this.left = 20,
    this.bottom = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تفعيل حواج تلقائياً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final controller = Get.find<HawajAIController>();
        controller.show();
        controller.updateContext(section, screen, message: welcomeMessage);
      } catch (e) {
        print('خطأ في تفعيل حواج: $e');
      }
    });

    return GetX<HawajAIController>(
      builder: (controller) {
        if (!controller.isVisible) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: left,
          bottom: bottom,
          child: GestureDetector(
            onTap: () => _handleTap(controller),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: controller.isExpanded ? 280 : 70,
              height: controller.isExpanded ? 150 : 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    controller.stateColor,
                    controller.stateColor.withOpacity(0.8),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(controller.isExpanded ? 20 : 35),
                boxShadow: [
                  BoxShadow(
                    color: controller.stateColor.withOpacity(0.4),
                    blurRadius: controller.isListening ? 20 : 10,
                    spreadRadius: controller.isListening ? 5 : 2,
                  ),
                ],
              ),
              child: controller.isExpanded
                  ? _buildExpandedContent(controller)
                  : _buildCompactContent(controller),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactContent(HawajAIController controller) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            controller.stateIcon,
            key: ValueKey(controller.currentState),
            color: Colors.white,
            size: 32,
          ),
        ),
        if (controller.isProcessing)
          const SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: Colors.white70,
              strokeWidth: 3,
            ),
          ),
      ],
    );
  }

  Widget _buildExpandedContent(HawajAIController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(controller.stateIcon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${controller.stateEmoji} حواج',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => controller.collapse(),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Message
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                controller.currentMessage,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                controller.isListening ? Icons.mic_off : Icons.mic,
                () => controller.toggleListening(),
              ),
              if (controller.isSpeaking)
                _buildButton(Icons.stop, () => controller.stopSpeaking()),
              _buildButton(Icons.refresh, () => controller.clearResponse()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  void _handleTap(HawajAIController controller) {
    if (controller.isExpanded) {
      controller.toggleListening();
    } else {
      controller.expand();
    }
  }
}
