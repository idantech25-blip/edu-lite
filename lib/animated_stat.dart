import 'package:flutter/material.dart';

class AnimatedStat extends StatefulWidget {
  final String label;
  final int endValue;
  final Duration duration;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? backgroundColor;
  final Color? textColor;

  const AnimatedStat({
    super.key,
    required this.label,
    required this.endValue,
    this.duration = const Duration(seconds: 2),
    this.labelStyle,
    this.valueStyle,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<AnimatedStat> createState() => _AnimatedStatState();
}

class _AnimatedStatState extends State<AnimatedStat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: widget.endValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = widget.textColor ?? Theme.of(context).textTheme.bodyMedium?.color;
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 13,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: widget.labelStyle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor ?? Theme.of(context).textTheme.bodyMedium?.color,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Text(
            _animation.value.toString(),
            style: widget.valueStyle ??
                TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor ?? Theme.of(context).textTheme.bodyMedium?.color,
                ),
          ),
        ],
      ),
    );

  }
}
