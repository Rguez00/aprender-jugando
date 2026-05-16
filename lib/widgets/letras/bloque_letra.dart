import 'package:flutter/material.dart';

class BloqueLetra extends StatelessWidget {
  final String letra;
  final int indice;
  final bool usada;
  final VoidCallback onTap;

  const BloqueLetra({
    super.key,
    required this.letra,
    required this.indice,
    required this.usada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final bloque = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: usada ? 0.25 : 1.0,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:0.3),  // ← igual que hueco vacío
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha:0.6),  // ← igual que hueco vacío
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letra,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black38,
                  blurRadius: 4,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (usada) return bloque;

    return Draggable<String>(
      data: letra,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.2,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha:0.8),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                letra,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: bloque,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: bloque,
      ),
    );
  }
}