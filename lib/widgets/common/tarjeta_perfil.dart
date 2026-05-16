import 'package:flutter/material.dart';
import 'package:proyecto_aprender_jugando/models/perfil.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';

class TarjetaPerfil extends StatelessWidget {
  final Perfil perfil;
  final VoidCallback onTap;
  final VoidCallback onEliminar;

  const TarjetaPerfil({
    super.key,
    required this.perfil,
    required this.onTap,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tarjeta principal
        Positioned.fill(
          child: ScalePulse(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppTema.radiusGrande,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(AppTema.espaciadoMedio),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: AppTema.sombraAvatar,
                    ),
                    child: ClipRRect(
                      borderRadius: AppTema.radiusCirculo,
                      child: Image.asset(
                        perfil.avatar,
                        width: AppTema.avatarGrande,
                        height: AppTema.avatarGrande,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTema.espaciadoMedio),
                  Text(
                    perfil.nombre,
                    style: AppTema.textoGrande.copyWith(color: AppTema.azulOscuro),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTema.espaciadoSmall),
                  Text(
                    "⭐ ${perfil.puntuacionTotal} pts",
                    style: AppTema.textoPuntos,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Botón eliminar — esquina superior izquierda
        Positioned(
          top: 8,
          left: 8,
          child: GestureDetector(
            onTap: () => _confirmarEliminar(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTema.rojo,
                borderRadius: AppTema.radiusMedio,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppTema.radiusGrande),
        insetPadding: const EdgeInsets.symmetric(horizontal: 200, vertical: 200),
        child: Padding(
          padding: const EdgeInsets.all(AppTema.espaciadoGrande),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_rounded, color: AppTema.rojo, size: 48),
              const SizedBox(height: AppTema.espaciadoMedio),
              Text(
                "¿Eliminar a ${perfil.nombre}?",
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTema.azulOscuro,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTema.espaciadoSmall),
              const Text(
                "Se borrarán todos sus datos",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTema.espaciadoGrande),
              Row(
                children: [
                  Expanded(
                    child: ScalePulse(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: AppTema.decoracionBotonNaranja,
                        child: const Text(
                          "Cancelar",
                          style: AppTema.textoBoton,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTema.espaciadoSmall),
                  Expanded(
                    child: ScalePulse(
                      onTap: () {
                        Navigator.pop(dialogContext);
                        onEliminar();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: AppTema.decoracionBotonRojo,
                        child: const Text(
                          "Eliminar",
                          style: AppTema.textoBoton,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}