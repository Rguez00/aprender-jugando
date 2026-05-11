import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_aprender_jugando/providers/perfil_provider.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/animated_background.dart';
import 'package:proyecto_aprender_jugando/widgets/common/fade_in_slide.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';

import '../juegos/letras/letras_screen.dart';
import '../juegos/parejas/parejas_screen.dart';
import '../juegos/puzzle/puzzle_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perfilProvider = Provider.of<PerfilProvider>(context);
    final perfil = perfilProvider.perfilActivo;

    final juegos = [
      {
        'nombre': 'Puzzle',
        'logo': 'assets/images/logo_puzzle.png',
      },
      {
        'nombre': 'Números',
        'logo': 'assets/images/logo_mates.png',
      },
      {
        'nombre': 'Colores',
        'logo': 'assets/images/logo_colores.png',
      },
      {
        'nombre': 'Letras',
        'logo': 'assets/images/logo_letras.png',
      },
      {
        'nombre': 'Parejas',
        'logo': 'assets/images/logo_parejas.png',
      },
    ];

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double alturaDisponible = constraints.maxHeight;
              final double anchoDisponible = constraints.maxWidth;
              final double alturaGrid = alturaDisponible * 0.6;
              final double anchoGrid = anchoDisponible > 800 ? 800 : anchoDisponible * 0.90;
              // Calculamos el tamaño de cada celda para que la imagen se adapte perfectamente
              final double anchoCelda = (anchoGrid - AppTema.espaciadoSmall * 2) / 3;

              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInSlide(
                          delay: const Duration(milliseconds: 0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 2)),
                                ],
                              ),
                              children: [
                                TextSpan(text: '¡', style: TextStyle(color: Colors.orange[700])),
                                TextSpan(text: 'A', style: TextStyle(color: Colors.red[400])),
                                TextSpan(text: ' j', style: TextStyle(color: Colors.orange[600])),
                                TextSpan(text: 'u', style: TextStyle(color: Colors.yellow[700])),
                                TextSpan(text: 'g', style: TextStyle(color: Colors.green[500])),
                                TextSpan(text: 'a', style: TextStyle(color: Colors.blue[400])),
                                TextSpan(text: 'r', style: TextStyle(color: Colors.purple[400])),
                                TextSpan(text: '!', style: TextStyle(color: Colors.red[400])),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTema.espaciadoSmall),
                        SizedBox(
                          width: anchoGrid,
                          height: alturaGrid,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: AppTema.espaciadoSmall,
                              mainAxisSpacing: AppTema.espaciadoSmall,
                              childAspectRatio: anchoCelda / (alturaGrid / 2 - AppTema.espaciadoSmall),
                            ),
                            itemCount: juegos.length,
                            itemBuilder: (context, index) {
                              final juego = juegos[index];
                              return FadeInSlide(
                                delay: Duration(milliseconds: 100 * index),
                                child: ScalePulse(
                                  onTap: () {
                                    switch (juego['nombre']) {
                                      case 'Puzzle':
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PuzzleScreen()));
                                        break;
                                      case 'Números':
                                      // próximamente
                                        break;
                                      case 'Colores':
                                      // próximamente
                                        break;
                                      case 'Letras':
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const LetrasScreen()),
                                        );
                                        break;
                                      case 'Parejas':
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const ParejasScreen()),
                                        );
                                        break;
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: AppTema.radiusMedio,
                                    child: Image.asset(
                                      juego['logo'] as String,
                                      fit: BoxFit.contain, // ← contain para no cortar nada
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tarjeta perfil — esquina superior izquierda
                  if (perfil != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppTema.radiusGrande,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: AppTema.radiusCirculo,
                              child: Image.asset(
                                perfil.avatar,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: AppTema.espaciadoSmall),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  perfil.nombre,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTema.azulOscuro,
                                  ),
                                ),
                                Text(
                                  "⭐ ${perfil.puntuacionTotal} pts",
                                  style: AppTema.textoPuntos.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}