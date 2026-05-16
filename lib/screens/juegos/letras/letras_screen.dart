import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_aprender_jugando/models/juego_letras.dart';
import 'package:proyecto_aprender_jugando/models/letras_state.dart';
import 'package:proyecto_aprender_jugando/models/palabra_model.dart';
import 'package:proyecto_aprender_jugando/providers/estadisticas_provider.dart';
import 'package:proyecto_aprender_jugando/providers/juego_provider.dart';
import 'package:proyecto_aprender_jugando/providers/perfil_provider.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/contador_juego.dart';
import 'package:proyecto_aprender_jugando/widgets/common/marco_juego.dart';
import 'package:proyecto_aprender_jugando/widgets/common/pantalla_felicitacion.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';
import 'package:proyecto_aprender_jugando/widgets/letras/bloque_letra.dart';
import 'package:proyecto_aprender_jugando/widgets/letras/hueco_letra.dart';

const int kPalabrasPorPartida = 5;

class LetrasScreen extends StatefulWidget {
  const LetrasScreen({super.key});

  @override
  State<LetrasScreen> createState() => _LetrasScreenState();
}

class _LetrasScreenState extends State<LetrasScreen> {
  late List<PalabraModel> _palabrasPartida;
  late LetrasState _estadoActual;
  int _indicePalabra = 0;
  int _puntosTotal = 0;
  bool _comprobando = false;
  bool _palabraCorrecta = false;
  List<bool> _hucosCorrectos = [];

  @override
  void initState() {
    super.initState();
    _iniciarPartida();
  }

  void _iniciarPartida() {
    final shuffled = List<PalabraModel>.from(kPoolPalabras)..shuffle(Random());
    _palabrasPartida = shuffled.take(kPalabrasPorPartida).toList();
    _indicePalabra = 0;
    _puntosTotal = 0;
    _cargarPalabra();
  }

  void _cargarPalabra() {
    setState(() {
      _estadoActual = LetrasState.dePalabra(_palabrasPartida[_indicePalabra]);
      _comprobando = false;
      _palabraCorrecta = false;
      _hucosCorrectos = List.filled(
          _palabrasPartida[_indicePalabra].palabra.length, true);
    });
  }

  void _onLetraTocada(String letra, int indice) {
    if (_comprobando) return;
    if (!_estadoActual.completo) {
      setState(() => _estadoActual.colocarLetra(letra));
      if (_estadoActual.completo) _comprobarPalabra();
    }
  }

  void _onBorrar() {
    if (_comprobando) return;
    setState(() {
      _estadoActual.borrarUltima();
      _hucosCorrectos = List.filled(
          _estadoActual.palabra.palabra.length, true);
    });
  }

  void _comprobarPalabra() {
    setState(() {
      _comprobando = true;
      _palabraCorrecta = _estadoActual.correcto;
      final letrasCorrectas = _estadoActual.palabra.palabra.split('');
      _hucosCorrectos = List.generate(
        letrasCorrectas.length,
            (i) => _estadoActual.huecos[i] == letrasCorrectas[i],
      );
    });

    if (_estadoActual.correcto) {
      final puntos = _estadoActual.conErrores ? 10 : 20;
      _puntosTotal += puntos;

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        if (_indicePalabra < kPalabrasPorPartida - 1) {
          setState(() => _indicePalabra++);
          _cargarPalabra();
        } else {
          _onJuegoCompletado();
        }
      });
    } else {
      setState(() => _estadoActual.conErrores = true);

      Future.delayed(const Duration(milliseconds: 2000), () {
        if (!mounted) return;
        setState(() {
          final letrasCorrectas = _estadoActual.palabra.palabra.split('');
          for (int i = 0; i < _estadoActual.huecos.length; i++) {
            if (_estadoActual.huecos[i] != letrasCorrectas[i]) {
              _estadoActual.huecos[i] = null;
            }
          }
          _comprobando = false;
          _hucosCorrectos = List.filled(
              _estadoActual.palabra.palabra.length, true);
        });
      });
    }
  }

  void _onJuegoCompletado() {
    final perfilProvider = context.read<PerfilProvider>();
    final juegoProvider = context.read<JuegoProvider>();
    final estadisticasProvider = context.read<EstadisticasProvider>();

    if (perfilProvider.perfilActivo == null) return;

    perfilProvider.actualizarPuntos(_puntosTotal);

    juegoProvider.iniciarJuego(JuegoLetras());
    for (var i = 0; i < kPalabrasPorPartida; i++) juegoProvider.registrarAcierto();

    final estadistica = juegoProvider.finalizarJuego(
      perfilProvider.perfilActivo!.id,
    );
    estadisticasProvider.guardarEstadisticas(estadistica);
  }

  void _reiniciar() {
    setState(() => _iniciarPartida());
  }

  bool _letraUsada(int indice) {
    final letra = _estadoActual.letrasDisponibles[indice];
    final vecesEnPalabra = _estadoActual.palabra.palabra
        .split('')
        .where((l) => l == letra)
        .length;
    final vecesEnHuecos = _estadoActual.huecos
        .where((h) => h == letra)
        .length;
    final igualesAnteriores = _estadoActual.letrasDisponibles
        .sublist(0, indice)
        .where((l) => l == letra)
        .length;
    return vecesEnHuecos > igualesAnteriores &&
        igualesAnteriores < vecesEnPalabra;
  }

  @override
  Widget build(BuildContext context) {
    final finalizado = _indicePalabra >= kPalabrasPorPartida - 1 &&
        _palabraCorrecta &&
        _comprobando;

    return MarcoJuego(
      titulo: 'Letras',
      onSalir: () => Navigator.pop(context),
      onReiniciar: _reiniciar,
      cabeceraExtra: ContadorJuego(
        texto: '📝 ${_indicePalabra + 1} / $kPalabrasPorPartida',
      ),
      child: finalizado
          ? PantallaFelicitacion(
        subtitulo: '¡Has completado todas las palabras!',
        infoPuntos: 'Puntos conseguidos: $_puntosTotal',
        onJugarDeNuevo: _reiniciar,
      )
          : _buildJuego(),
    );
  }

  Widget _buildJuego() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // ── IMAGEN ──────────────────────────────────────
        Expanded(
          flex: 5,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.9),
                borderRadius: AppTema.radiusGrande,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final lado = constraints.maxHeight;
                  return SizedBox(
                    width: lado,
                    height: lado,
                    child: Image.asset(
                      _estadoActual.palabra.imagen,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // ── HUECOS + BORRAR ─────────────────────────────
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                children: List.generate(
                  _estadoActual.huecos.length,
                      (i) => HuecoLetra(
                    letra: _estadoActual.huecos[i],
                    esCorrecta: _hucosCorrectos[i],
                    onLetraSoltada:
                    (_comprobando || _estadoActual.huecos[i] != null)
                        ? null
                        : (letra) {
                      setState(() {
                        _estadoActual.huecos[i] = letra;
                      });
                      if (_estadoActual.completo) _comprobarPalabra();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ScalePulse(
                onTap: _onBorrar,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.85),
                    borderRadius: AppTema.radiusMedio,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.backspace_rounded,
                          color: AppTema.rojo, size: 24),
                      SizedBox(width: 6),
                      Text(
                        'Borrar',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTema.rojo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // ── BLOQUES DE LETRAS ───────────────────────────
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List.generate(
            _estadoActual.letrasDisponibles.length,
                (i) => BloqueLetra(
              letra: _estadoActual.letrasDisponibles[i],
              indice: i,
              usada: _letraUsada(i),
              onTap: () =>
                  _onLetraTocada(_estadoActual.letrasDisponibles[i], i),
            ),
          ),
        ),
      ],
    );
  }
}