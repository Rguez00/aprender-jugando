import 'package:flutter/material.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';

class ContadorJuego extends StatelessWidget {
  final String texto;

  const ContadorJuego({
    super.key,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTema.dorado,
        borderRadius: AppTema.radiusMedio,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: AppTema.azulOscuro,
        ),
      ),
    );
  }
}