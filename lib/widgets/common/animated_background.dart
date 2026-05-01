import 'package:flutter/material.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;
  final String imagenFondo;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.imagenFondo = 'assets/images/fondo_menus.png',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            imagenFondo,
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    );
  }
}