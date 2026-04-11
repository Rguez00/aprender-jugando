import 'dart:math';
import 'package:flutter/material.dart';

class Star {
  double x;
  double y;
  double size;
  double opacity;
  double speed;
  double blinkSpeed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.blinkSpeed,
  });
}

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final int numEstrellas;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFF1A237E),
    this.numEstrellas = 50,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _estrellas;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _estrellas = List.generate(widget.numEstrellas, (_) => _crearEstrella());
  }

  Star _crearEstrella() {
    return Star(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 3 + 1,
      opacity: _random.nextDouble(),
      speed: _random.nextDouble() * 0.02 + 0.005,
      blinkSpeed: _random.nextDouble() * 0.05 + 0.01,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Actualizamos posición y parpadeo de cada estrella
        for (var estrella in _estrellas) {
          estrella.y -= estrella.speed * 0.01;
          if (estrella.y < 0) estrella.y = 1.0;
          estrella.opacity += estrella.blinkSpeed;
          if (estrella.opacity > 1.0 || estrella.opacity < 0.0) {
            estrella.blinkSpeed = -estrella.blinkSpeed;
          }
        }

        return CustomPaint(
          painter: _StarPainter(
            estrellas: _estrellas,
            backgroundColor: widget.backgroundColor,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _StarPainter extends CustomPainter {
  final List<Star> estrellas;
  final Color backgroundColor;

  _StarPainter({required this.estrellas, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Fondo
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // Estrellas
    for (var estrella in estrellas) {
      canvas.drawCircle(
        Offset(estrella.x * size.width, estrella.y * size.height),
        estrella.size,
        Paint()..color = Colors.white.withOpacity(estrella.opacity.clamp(0.0, 1.0)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}