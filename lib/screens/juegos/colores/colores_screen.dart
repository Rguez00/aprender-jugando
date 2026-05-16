import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_aprender_jugando/models/colores_state.dart';
import 'package:proyecto_aprender_jugando/models/juego_colores.dart';
import 'package:proyecto_aprender_jugando/providers/estadisticas_provider.dart';
import 'package:proyecto_aprender_jugando/providers/juego_provider.dart';
import 'package:proyecto_aprender_jugando/providers/perfil_provider.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/contador_juego.dart';
import 'package:proyecto_aprender_jugando/widgets/common/marco_juego.dart';
import 'package:proyecto_aprender_jugando/widgets/common/pantalla_felicitacion.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';

const int kPreguntasColores = 10;

class ColoresScreen extends StatefulWidget {
  const ColoresScreen({super.key});

  @override
  State<ColoresScreen> createState() => _ColoresScreenState();
}

class _ColoresScreenState extends State<ColoresScreen> {
  late ColoresState _estado;

  @override
  void initState() {
    super.initState();
    _reiniciar();
  }

  void _reiniciar() {
    setState(() {
      _estado = ColoresState.inicial(totalPreguntas: kPreguntasColores);
    });
  }

  void _onOpcionTocada(int indiceOpcion) {
    if (_estado.respondida) return;

    setState(() => _estado.responder(indiceOpcion));

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() => _estado.siguiente());
      if (_estado.finalizado) _onJuegoCompletado();
    });
  }

  int _calcularPuntos() => _estado.aciertos * 10;

  void _onJuegoCompletado() {
    final perfilProvider = context.read<PerfilProvider>();
    final juegoProvider = context.read<JuegoProvider>();
    final estadisticasProvider = context.read<EstadisticasProvider>();

    if (perfilProvider.perfilActivo == null) return;

    perfilProvider.actualizarPuntos(_calcularPuntos());

    juegoProvider.iniciarJuego(JuegoColores());
    for (var i = 0; i < _estado.aciertos; i++) juegoProvider.registrarAcierto();
    for (var i = 0; i < _estado.errores; i++) juegoProvider.registrarErrores();

    final estadistica = juegoProvider.finalizarJuego(
      perfilProvider.perfilActivo!.id,
    );
    estadisticasProvider.guardarEstadisticas(estadistica);
  }

  @override
  Widget build(BuildContext context) {
    return MarcoJuego(
      titulo: 'Colores',
      onSalir: () => Navigator.pop(context),
      onReiniciar: _reiniciar,
      cabeceraExtra: ContadorJuego(
        texto: '🎨 ${_estado.indiceActual + 1} / $kPreguntasColores',
      ),
      child: _estado.finalizado
          ? PantallaFelicitacion(
        subtitulo: '¡Has completado todos los colores!',
        infoPuntos:
        '${_estado.aciertos} aciertos  •  Puntos: ${_calcularPuntos()}',
        onJugarDeNuevo: _reiniciar,
      )
          : _buildJuego(),
    );
  }

  Widget _buildJuego() {
    final pregunta = _estado.preguntaActual;
    final esVerColor = pregunta.tipo == TipoPregunta.verColorElegirNombre;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: esVerColor
                ? _buildRectanguloColor(pregunta.colorCorrecto)
                : _buildNombrePregunta(pregunta.colorCorrecto),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          flex: 2,
          child: Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(
                pregunta.opciones.length,
                    (i) => esVerColor
                    ? _buildOpcionNombre(i, pregunta)
                    : _buildOpcionColor(i, pregunta),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRectanguloColor(ColorInfo info) {
    return Container(
      width: 280,
      height: 200,
      decoration: BoxDecoration(
        color: info.color,
        borderRadius: AppTema.radiusGrande,
        boxShadow: [
          BoxShadow(
            color: info.color.withOpacity(0.5),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 3,
        ),
      ),
    );
  }

  Widget _buildNombrePregunta(ColorInfo info) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '¿Cuál es el...?',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                  color: Colors.black38,
                  blurRadius: 4,
                  offset: Offset(1, 1)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: AppTema.radiusGrande,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            info.castellano.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOpcionNombre(int i, PreguntaColor pregunta) {
    final opcion = pregunta.opciones[i];
    final respondida = _estado.respondida;
    final seleccionada = _estado.indiceOpcionSeleccionada == i;
    final esCorrecta = _estado.esCorrecta(i);

    Color fondo;
    Color borde;
    Color textoColor;

    if (!respondida) {
      fondo = Colors.white.withOpacity(0.92);
      borde = Colors.white.withOpacity(0.5);
      textoColor = AppTema.azulOscuro;
    } else if (esCorrecta) {
      fondo = const Color(0xFFE2EFDA);
      borde = AppTema.verde;
      textoColor = AppTema.verde;
    } else if (seleccionada) {
      fondo = const Color(0xFFFFE7E7);
      borde = AppTema.rojo;
      textoColor = AppTema.rojo;
    } else {
      fondo = Colors.white.withOpacity(0.3);
      borde = Colors.white.withOpacity(0.2);
      textoColor = Colors.white.withOpacity(0.4);
    }

    return ScalePulse(
      onTap: () => _onOpcionTocada(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 200,
        height: 80,
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: AppTema.radiusMedio,
          border: Border.all(color: borde, width: 2.5),
          boxShadow: respondida
              ? null
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            opcion.castellano.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: textoColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOpcionColor(int i, PreguntaColor pregunta) {
    final opcion = pregunta.opciones[i];
    final respondida = _estado.respondida;
    final seleccionada = _estado.indiceOpcionSeleccionada == i;
    final esCorrecta = _estado.esCorrecta(i);

    double bordeWidth = 3;
    Color bordeColor = Colors.white.withOpacity(0.4);

    if (respondida) {
      if (esCorrecta) {
        bordeColor = AppTema.verde;
        bordeWidth = 5;
      } else if (seleccionada) {
        bordeColor = AppTema.rojo;
        bordeWidth = 5;
      } else {
        bordeColor = Colors.white.withOpacity(0.15);
      }
    }

    return ScalePulse(
      onTap: () => _onOpcionTocada(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 160,
        height: 100,
        decoration: BoxDecoration(
          color: opcion.color,
          borderRadius: AppTema.radiusMedio,
          border: Border.all(color: bordeColor, width: bordeWidth),
          boxShadow: [
            BoxShadow(
              color: opcion.color.withOpacity(respondida ? 0.2 : 0.5),
              blurRadius: respondida ? 4 : 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: respondida && esCorrecta
            ? const Center(
          child: Icon(Icons.check_circle_rounded,
              color: Colors.white, size: 40),
        )
            : respondida && seleccionada
            ? const Center(
          child: Icon(Icons.cancel_rounded,
              color: Colors.white, size: 40),
        )
            : null,
      ),
    );
  }
}