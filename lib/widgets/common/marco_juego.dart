import 'package:flutter/material.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';

class MarcoJuego extends StatelessWidget {
  final String titulo;
  final Widget child;
  final VoidCallback onSalir;
  final VoidCallback onReiniciar;

  const MarcoJuego({
    super.key,
    required this.titulo,
    required this.child,
    required this.onSalir,
    required this.onReiniciar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          SizedBox.expand(
            child: Image.asset(
              'assets/images/fondo_juegos.png',
              fit: BoxFit.cover,
            ),
          ),
          // Contenido encima del fondo
          SafeArea(
            child: Column(
              children: [
                // Cabecera
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: AppTema.azulMedio,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1)),
                      ],
                    ),
                  ),
                ),
                // Contenido del juego
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTema.espaciadoMedio),
                    child: child,
                  ),
                ),
                // Botones
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTema.espaciadoExtraGrande,
                      vertical: AppTema.espaciadoMedio),
                  child: Row(
                    children: [
                      Expanded(
                        child: ScalePulse(
                          onTap: onSalir,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: AppTema.decoracionBotonRojo,
                            child: const Text(
                              "Salir",
                              textAlign: TextAlign.center,
                              style: AppTema.textoBoton,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTema.espaciadoGrande),
                      Expanded(
                        child: ScalePulse(
                          onTap: onReiniciar,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: AppTema.decoracionBotonNaranja,
                            child: const Text(
                              "Reiniciar",
                              textAlign: TextAlign.center,
                              style: AppTema.textoBoton,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}