import 'package:flutter/material.dart';

import '../resources/manager_colors.dart';
class AnimatedMicButton extends StatefulWidget {
  const AnimatedMicButton({super.key});

  @override
  _AnimatedMicButtonState createState() => _AnimatedMicButtonState();
}

class _AnimatedMicButtonState extends State<AnimatedMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double scale = 1 + (_controller.value * 0.3);
          return Container(
            width: 90 * scale,
            height: 90 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ManagerColors.primaryColor.withOpacity(0.3),
            ),
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ManagerColors.primaryColor,
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 36),
              ),
            ),
          );
        },
      ),
    );
  }
}
