import 'package:flutter/material.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';
import 'package:proyecto_aprender_jugando/widgets/common/texto_arcoiris.dart';

class PantallaFelicitacion extends StatelessWidget {
  final String subtitulo;
  final String infoPuntos;
  final VoidCallback onJugarDeNuevo;

  const PantallaFelicitacion({
    super.key,
    required this.subtitulo,
    required this.infoPuntos,
    required this.onJugarDeNuevo,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TextoArcoiris(texto: '¡FELICIDADES!'),
          const SizedBox(height: 16),
          TextoArcoiris(texto: subtitulo, fontSize: 40),
          const SizedBox(height: 16),
          Text(
            infoPuntos,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
              shadows: const [
                Shadow(
                  color: Colors.black38,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ScalePulse(
            onTap: onJugarDeNuevo,
            child: Image.asset(
              'assets/images/jugar_de_nuevo_redondo.png',
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}