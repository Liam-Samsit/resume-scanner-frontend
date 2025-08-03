import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AnimatedScoreCircle extends StatefulWidget {
  final int score;
  final double size;
  final double fontSize;
  final bool boldText;

  const AnimatedScoreCircle({
    Key? key,
    required this.score,
    this.size = 400, // huge radius
    this.fontSize = 40,
    this.boldText = false,
  }) : super(key: key);

  @override
  State<AnimatedScoreCircle> createState() => _AnimatedScoreCircleState();
}

class _AnimatedScoreCircleState extends State<AnimatedScoreCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Color _scoreColor(int score) {
    if (score < 40) return Colors.redAccent;
    if (score < 70) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: widget.score.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final percent = _animation.value / 100;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: widget.size,
              width: widget.size,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 18,
                color: _scoreColor(widget.score),
                backgroundColor: Colors.white10,
              ),
            ),
            const SizedBox(width: 20), // space between circle and text
            Text(
              "${_animation.value.toInt()}%",
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight:
                    widget.boldText ? FontWeight.bold : FontWeight.normal,
                color: AppColors.wheatBeige,
              ),
            ),
          ],
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
