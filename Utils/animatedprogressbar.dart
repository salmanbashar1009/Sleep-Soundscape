import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedProgressBar extends StatefulWidget {
  final double barWidth;
  final double completedValue;
  final double totalValue;

  const AnimatedProgressBar({
    super.key,
    required this.barWidth,
    required this.completedValue,
    required this.totalValue,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Color activeColor = Color(0xFF72CE9D);

  @override
  void initState() {
    super.initState();
    if (widget.completedValue <= 20) {
      activeColor = Color(0xFFED7876);
    }
    if (widget.completedValue > 20 && widget.completedValue <= 60) {
      activeColor = Color(0xFFFCF066);
    } else if (widget.completedValue > 60) {
      activeColor = Color(0xFF72CE9D);
    }

    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Setup initial animation
    _setupAnimation(widget.completedValue);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the completedValue has changed, update the animation
    if (oldWidget.completedValue != widget.completedValue) {
      _setupAnimation(widget.completedValue);
      _controller.forward(from: 0); // Restart the animation
    }
  }

  void _setupAnimation(double targetValue) {
    final completeWidth = (widget.barWidth * targetValue) / widget.totalValue;

    _animation = Tween<double>(
      begin: 0, // Start animation from 0
      end: completeWidth, // End animation at calculated width
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Bar
        Container(
          width: widget.barWidth,
          height: 16.h,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        // Animated Foreground Bar
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: _animation.value, // Animated width
              height: 16.h,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
            );
          },
        ),
      ],
    );
  }
}