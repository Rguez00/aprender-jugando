import 'package:flutter/material.dart';

class HuecoLetra extends StatelessWidget {
  final String? letra;
  final bool esCorrecta;
  final ValueChanged<String>? onLetraSoltada; // ← añadir esto

  const HuecoLetra({
    super.key,
    this.letra,
    this.esCorrecta = true,
    this.onLetraSoltada, // ← añadir esto
  });

  @override
  Widget build(BuildContext context) {
    final tieneLetra = letra != null;

    Color fondo;
    Color borde;

    if (!tieneLetra) {
      fondo = Colors.white.withOpacity(0.3);
      borde = Colors.white.withOpacity(0.6);
    } else if (esCorrecta) {
      fondo = Colors.white.withOpacity(0.95);
      borde = Colors.white;
    } else {
      fondo = const Color(0xFFFFCDD2);
      borde = const Color(0xFFE53935);
    }

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => !tieneLetra && onLetraSoltada != null,
      onAcceptWithDetails: (details) {
        onLetraSoltada?.call(details.data);
      },
      builder: (context, candidatos, _) {
        final destacado = candidatos.isNotEmpty && !tieneLetra;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: destacado ? Colors.yellow.withOpacity(0.5) : fondo,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: destacado ? Colors.yellow : borde,
              width: destacado ? 3 : 2.5,
            ),
            boxShadow: tieneLetra
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Center(
            child: Text(
              letra ?? '',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A237E),
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}