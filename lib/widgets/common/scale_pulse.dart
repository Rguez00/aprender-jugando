import 'package:flutter/material.dart';

class ScalePulse extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;


  const ScalePulse({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<ScalePulse> createState() => _ScalePulseState();
}

class _ScalePulseState extends State<ScalePulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
