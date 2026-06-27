import 'dart:math';
import 'package:flutter/material.dart';

class SoundWaveAnimation extends StatefulWidget {
  final bool isAnimating;

  const SoundWaveAnimation({super.key, required this.isAnimating});

  @override
  State<SoundWaveAnimation> createState() => _SoundWaveAnimationState();
}

class _SoundWaveAnimationState extends State<SoundWaveAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final int _barCount = 20;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_barCount, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + _random.nextInt(600)),
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.15,
        end: 0.5 + _random.nextDouble() * 0.5,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    if (widget.isAnimating) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted && widget.isAnimating) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  void _stopAnimations() {
    for (var controller in _controllers) {
      controller.stop();
      controller.animateTo(
        0.15,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didUpdateWidget(SoundWaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _startAnimations();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _stopAnimations();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_barCount, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final heightFraction = _animations[index].value;
              final maxHeight = 160.0;
              final barHeight = maxHeight * heightFraction;

              // Gradient: ortadaki çubuklar daha parlak
              final distFromCenter =
                  (index - _barCount / 2).abs() / (_barCount / 2);
              final opacity = 1.0 - (distFromCenter * 0.6);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                width: 4,
                height: barHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xFF00B8D4).withValues(alpha: opacity),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF00B8D4,
                      ).withValues(alpha: opacity * 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
