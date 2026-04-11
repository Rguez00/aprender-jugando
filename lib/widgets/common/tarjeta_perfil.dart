import 'package:flutter/material.dart';
import 'package:proyecto_aprender_jugando/models/perfil.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';

class TarjetaPerfil extends StatelessWidget {
  final Perfil perfil;
  final VoidCallback onTap;

  const TarjetaPerfil({
    super.key,
    required this.perfil,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScalePulse(
      onTap: onTap,
      child: Container(
        decoration: AppTema.decoracionTarjeta,
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
              style: AppTema.textoGrande,
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
    );
  }
}