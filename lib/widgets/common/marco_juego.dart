import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_aprender_jugando/providers/perfil_provider.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';

class MarcoJuego extends StatelessWidget {
  final String titulo;
  final Widget child;
  final VoidCallback onSalir;
  final VoidCallback onReiniciar;
  final Widget? cabeceraExtra; // ← nuevo

  const MarcoJuego({
    super.key,
    required this.titulo,
    required this.child,
    required this.onSalir,
    required this.onReiniciar,
    this.cabeceraExtra, // ← nuevo
  });

  @override
  Widget build(BuildContext context) {
    final perfil = context.watch<PerfilProvider>().perfilActivo;

    return Scaffold(
      body: Stack(
        children: [
          // ── FONDO ─────────────────────────────────────
          SizedBox.expand(
            child: Image.asset(
              'assets/images/fondo_juegos.png',
              fit: BoxFit.cover,
            ),
          ),
          // ── CONTENIDO ─────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // ── CABECERA ────────────────────────────
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: AppTema.espaciadoGrande),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF1A237E), Color(0xFF283593)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border(
                          bottom: BorderSide(
                            color: AppTema.naranja.withOpacity(0.6),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        titulo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                                color: Colors.black45,
                                blurRadius: 6,
                                offset: Offset(1, 2)),
                          ],
                        ),
                      ),
                    ),
                    if (perfil != null)
                      Positioned(
                        left: 12,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: AppTema.radiusGrande,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: AppTema.radiusCirculo,
                                  child: Image.asset(
                                    perfil.avatar,
                                    width: 56,
                                    height: 56,
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTema.azulOscuro,
                                      ),
                                    ),
                                    Text(
                                      '⭐ ${perfil.puntuacionTotal} pts',
                                      style: AppTema.textoPuntos
                                          .copyWith(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (cabeceraExtra != null)
                      Positioned(
                        right: 12,
                        top: 0,
                        bottom: 0,
                        child: Center(child: cabeceraExtra!),
                      ),
                  ],
                ),
                // ── CONTENIDO DEL JUEGO ─────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTema.espaciadoMedio),
                    child: child,
                  ),
                ),
                // ── BOTONES ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTema.espaciadoExtraGrande,
                      vertical: AppTema.espaciadoMedio),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BotonMarco(
                          label: 'Salir',
                          icono: Icons.exit_to_app_rounded,
                          gradiente: AppTema.gradienteRojo,
                          colorSombra: AppTema.rojo,
                          onTap: onSalir,
                        ),
                      ),
                      const SizedBox(width: AppTema.espaciadoGrande),
                      Expanded(
                        child: _BotonMarco(
                          label: 'Reiniciar',
                          icono: Icons.refresh_rounded,
                          gradiente: AppTema.gradienteNaranja,
                          colorSombra: AppTema.naranja,
                          onTap: onReiniciar,
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

// ── WIDGET PRIVADO BOTÓN ─────────────────────────────────────────────────────
class _BotonMarco extends StatelessWidget {
  final String label;
  final IconData icono;
  final LinearGradient gradiente;
  final Color colorSombra;
  final VoidCallback onTap;

  const _BotonMarco({
    required this.label,
    required this.icono,
    required this.gradiente,
    required this.colorSombra,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScalePulse(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: gradiente,
          borderRadius: AppTema.radiusMedio,
          boxShadow: [
            BoxShadow(
              color: colorSombra.withOpacity(0.45),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(label, style: AppTema.textoBoton),
          ],
        ),
      ),
    );
  }
}