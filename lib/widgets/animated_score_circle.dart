import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedScoreCircle extends StatefulWidget {
  final int score;
  final double size;

  const AnimatedScoreCircle({Key? key, required this.score, this.size = 100}) : super(key: key);

  @override
  State<AnimatedScoreCircle> createState() => _AnimatedScoreCircleState();
}

class _AnimatedScoreCircleState extends State<AnimatedScoreCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Color _scoreColor(int score) {
    if (score < 40) return Colors.red;
    if (score < 70) return Colors.orange;
    return Colors.green;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: widget.score.toDouble()).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final percent = _animation.value / 100;
        return SizedBox(
          height: widget.size,
          width: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percent,
                strokeWidth: 8,
                color: _scoreColor(widget.score),
                backgroundColor: Colors.grey[300],
              ),
              Text("${_animation.value.toInt()}%", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
