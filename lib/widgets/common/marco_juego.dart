import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFA3D1FA),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Título
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Contenido del juego
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFA3D1FA),
                ),
                child: child,
              ),
            ),
            // Botones
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onSalir,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: const Text(
                      "Salir",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 32),
                  ElevatedButton(
                    onPressed: onReiniciar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: const Text(
                      "Reiniciar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}