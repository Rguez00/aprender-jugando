import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_aprender_jugando/providers/perfil_provider.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/animated_background.dart';
import 'package:proyecto_aprender_jugando/widgets/common/fade_in_slide.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';
import 'package:proyecto_aprender_jugando/widgets/common/tarjeta_perfil.dart';

import '../../models/perfil.dart';
import '../menu/menu_screen.dart';

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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInSlide(
                delay: const Duration(milliseconds: 0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 55,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 2)),
                      ],
                    ),
                    children: [
                      TextSpan(text: '¡', style: TextStyle(color: Colors.orange[700])),
                      TextSpan(text: 'V', style: TextStyle(color: Colors.red[400])),
                      TextSpan(text: 'A', style: TextStyle(color: Colors.orange[600])),
                      TextSpan(text: 'M', style: TextStyle(color: Colors.yellow[700])),
                      TextSpan(text: 'O', style: TextStyle(color: Colors.green[500])),
                      TextSpan(text: 'S', style: TextStyle(color: Colors.blue[400])),
                      TextSpan(text: ' A', style: TextStyle(color: Colors.purple[400])),
                      TextSpan(text: ' J', style: TextStyle(color: Colors.red[400])),
                      TextSpan(text: 'U', style: TextStyle(color: Colors.orange[600])),
                      TextSpan(text: 'G', style: TextStyle(color: Colors.yellow[700])),
                      TextSpan(text: 'A', style: TextStyle(color: Colors.green[500])),
                      TextSpan(text: 'R', style: TextStyle(color: Colors.blue[400])),
                      TextSpan(text: '!', style: TextStyle(color: Colors.purple[400])),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTema.espaciadoExtraGrande),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...perfilProvider.perfiles.asMap().entries.map((entry) {
                    final index = entry.key;
                    final perfil = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTema.espaciadoMedio),
                      child: FadeInSlide(
                        delay: Duration(milliseconds: 200 * index),
                        child: SizedBox(
                          width: 220,
                          height: 280,
                          child: TarjetaPerfil(
                            perfil: perfil,
                            onTap: () {
                              perfilProvider.seleccionarPerfil(perfil);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const MenuScreen()),
                              );
                            },
                            onEliminar: () {
                              perfilProvider.eliminarPerfil(perfil);
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                  if (perfilProvider.perfiles.length < 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTema.espaciadoMedio),
                      child: FadeInSlide(
                        delay: Duration(milliseconds: 200 * perfilProvider.perfiles.length),
                        child: ScalePulse(
                          onTap: () => _mostrarDialogoNuevoPerfil(context),
                          child: Container(
                            width: 220,
                            height: 280,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: AppTema.radiusGrande,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle, size: 64, color: AppTema.azulClaro),
                                SizedBox(height: AppTema.espaciadoMedio),
                                Text(
                                  "Añadir perfil",
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTema.azulOscuro,
                                  ),
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
    final provider = Provider.of<PerfilProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setStateDialog) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppTema.radiusGrande),
          insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
          child: Padding(
            padding: const EdgeInsets.all(AppTema.espaciadoGrande),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título multicolor
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1)),
                      ],
                    ),
                    children: [
                      TextSpan(text: 'N', style: TextStyle(color: Colors.red[400])),
                      TextSpan(text: 'u', style: TextStyle(color: Colors.orange[600])),
                      TextSpan(text: 'e', style: TextStyle(color: Colors.yellow[700])),
                      TextSpan(text: 'v', style: TextStyle(color: Colors.green[500])),
                      TextSpan(text: 'o', style: TextStyle(color: Colors.blue[400])),
                      TextSpan(text: ' P', style: TextStyle(color: Colors.purple[400])),
                      TextSpan(text: 'e', style: TextStyle(color: Colors.red[400])),
                      TextSpan(text: 'r', style: TextStyle(color: Colors.orange[600])),
                      TextSpan(text: 'f', style: TextStyle(color: Colors.yellow[700])),
                      TextSpan(text: 'i', style: TextStyle(color: Colors.green[500])),
                      TextSpan(text: 'l', style: TextStyle(color: Colors.blue[400])),
                    ],
                  ),
                ),
                const SizedBox(height: AppTema.espaciadoGrande),
                // Dos columnas
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Columna izquierda — avatares uno al lado del otro
                      // Columna izquierda — avatares
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Elige avatar",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,          // ← más grande
                                fontWeight: FontWeight.bold,  // ← negrita
                                color: AppTema.azulOscuro,    // ← color legible
                              ),
                            ),
                            const SizedBox(height: AppTema.espaciadoMedio),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // ← reparte el espacio
                              children: [
                                "assets/images/avatar01.png",
                                "assets/images/avatar02.png",
                              ].map((avatar) {
                                final seleccionado = avatarSeleccionado == avatar;
                                return GestureDetector(
                                  onTap: () => setStateDialog(() => avatarSeleccionado = avatar),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: seleccionado ? AppTema.naranja : Colors.transparent,
                                        width: 4,
                                      ),
                                      boxShadow: seleccionado ? AppTema.sombraAvatar : [],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: AppTema.radiusCirculo,
                                      child: Image.asset(
                                        avatar,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      // Separador vertical
                      Container(
                        width: 1,
                        color: AppTema.grisClaro,
                        margin: const EdgeInsets.symmetric(
                            horizontal: AppTema.espaciadoMedio),
                      ),
                      // Columna derecha — input y botones
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: nombreController,
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                color: AppTema.azulOscuro,
                              ),
                              decoration: InputDecoration(
                                hintText: "Nombre del niño",
                                hintStyle: const TextStyle(color: Colors.black38),
                                filled: true,
                                fillColor: AppTema.grisClaro,
                                border: OutlineInputBorder(
                                  borderRadius: AppTema.radiusMedio,
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppTema.espaciadoMedio),
                            Row(
                              children: [
                                Expanded(
                                  child: ScalePulse(
                                    onTap: () => Navigator.pop(dialogContext),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: AppTema.decoracionBotonRojo,
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
                                      if (nombreController.text.isNotEmpty) {
                                        provider.agregarPerfil(
                                          Perfil(
                                            id: DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                            nombre: nombreController.text,
                                            avatar: avatarSeleccionado,
                                          ),
                                        );
                                        Navigator.pop(dialogContext);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: AppTema.decoracionBotonNaranja,
                                      child: const Text(
                                        "Crear",
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}