import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_aprender_jugando/providers/perfil_provider.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/animated_background.dart';
import 'package:proyecto_aprender_jugando/widgets/common/fade_in_slide.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';
import 'package:proyecto_aprender_jugando/widgets/common/tarjeta_perfil.dart';

import '../../models/perfil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PerfilProvider>(context, listen: false).cargarPerfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final perfilProvider = Provider.of<PerfilProvider>(context);

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título
              FadeInSlide(
                delay: const Duration(milliseconds: 0),
                child: Text(
                  "¿Quién está jugando?",
                  style: AppTema.titulo,
                ),
              ),
              const SizedBox(height: AppTema.espaciadoExtraGrande),
              // Tarjetas de perfiles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Perfiles existentes
                  ...perfilProvider.perfiles.asMap().entries.map((entry) {
                    final index = entry.key;
                    final perfil = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTema.espaciadoMedio),
                      child: FadeInSlide(
                        delay: Duration(milliseconds: 200 * index),
                        child: SizedBox(
                          width: 180,
                          height: 220,
                          child: TarjetaPerfil(
                            perfil: perfil,
                            onTap: () {
                              perfilProvider.seleccionarPerfil(perfil);
                              // Navigator.push a MenuScreen cuando esté lista
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                  // Botón añadir perfil
                  if (perfilProvider.perfiles.length < 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTema.espaciadoMedio),
                      child: FadeInSlide(
                        delay: Duration(
                            milliseconds:
                            200 * perfilProvider.perfiles.length),
                        child: ScalePulse(
                          onTap: () => _mostrarDialogoNuevoPerfil(context),
                          child: Container(
                            width: 180,
                            height: 220,
                            decoration: AppTema.decoracionTarjeta,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle,
                                    size: 64, color: AppTema.naranja),
                                SizedBox(height: AppTema.espaciadoMedio),
                                Text(
                                  "Nuevo perfil",
                                  style: AppTema.textoGrande,
                                ),
                              ],
                            ),
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

  void _mostrarDialogoNuevoPerfil(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    String avatarSeleccionado = "assets/images/avatar01.png";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: AppTema.azulMedio,
          shape: RoundedRectangleBorder(borderRadius: AppTema.radiusGrande),
          title: const Text("Nuevo perfil", style: AppTema.subtitulo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selección de avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "assets/images/avatar01.png",
                  "assets/images/avatar02.png",
                ].map((avatar) {
                  final seleccionado = avatarSeleccionado == avatar;
                  return GestureDetector(
                    onTap: () =>
                        setStateDialog(() => avatarSeleccionado = avatar),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: seleccionado
                              ? AppTema.naranja
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: AppTema.radiusCirculo,
                        child: Image.asset(avatar, width: 64, height: 64,
                            fit: BoxFit.cover),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppTema.espaciadoMedio),
              // Campo nombre
              TextField(
                controller: nombreController,
                style: AppTema.textoNormal,
                decoration: InputDecoration(
                  hintText: "Nombre del niño",
                  hintStyle: AppTema.textoNormal
                      .copyWith(color: Colors.white54),
                  filled: true,
                  fillColor: AppTema.azulClaro,
                  border: OutlineInputBorder(
                    borderRadius: AppTema.radiusMedio,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar",
                  style: TextStyle(color: Colors.white54)),
            ),
            ScalePulse(
              onTap: () {
                if (nombreController.text.isNotEmpty) {
                  final provider =
                  Provider.of<PerfilProvider>(context, listen: false);
                  provider.agregarPerfil(
                    Perfil(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      nombre: nombreController.text,
                      avatar: avatarSeleccionado,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: AppTema.decoracionBotonNaranja,
                child: const Text("Crear", style: AppTema.textoBoton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}