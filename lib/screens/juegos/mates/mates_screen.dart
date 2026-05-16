import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_aprender_jugando/models/juego_mates.dart';
import 'package:proyecto_aprender_jugando/models/mates_state.dart';
import 'package:proyecto_aprender_jugando/providers/estadisticas_provider.dart';
import 'package:proyecto_aprender_jugando/providers/juego_provider.dart';
import 'package:proyecto_aprender_jugando/providers/perfil_provider.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/contador_juego.dart';
import 'package:proyecto_aprender_jugando/widgets/common/marco_juego.dart';
import 'package:proyecto_aprender_jugando/widgets/common/pantalla_felicitacion.dart';

const int kTotalRondas = 5;

class MatesScreen extends StatefulWidget {
  const MatesScreen({super.key});

  @override
  State<MatesScreen> createState() => _MatesScreenState();
}

class _MatesScreenState extends State<MatesScreen> {
  late MatesState _estado;
  int _aciertosTotal = 0;
  int _erroresTotal = 0;

  @override
  void initState() {
    super.initState();
    _reiniciar();
  }

  void _reiniciar() {
    setState(() {
      _estado = MatesState.inicial(totalRondas: kTotalRondas);
      _aciertosTotal = 0;
      _erroresTotal = 0;
    });
  }

  void _onNumeroTocado(int numero) {
    if (_estado.numeroYaUsado(numero)) return;
    setState(() {
      if (_estado.numeroSeleccionado == numero) {
        _estado.numeroSeleccionado = null;
      } else {
        _estado.numeroSeleccionado = numero;
      }
    });
  }

  void _onHuecoTocado(int indiceOp) {
    if (_estado.numeroSeleccionado == null) return;
    setState(() {
      _estado.rondaActual[indiceOp].respuestaColocada = null;
      _estado.colocarEnOperacion(indiceOp, _estado.numeroSeleccionado!);
    });
    _comprobarRonda();
  }

  void _onNumeroDragSoltado(int indiceOp, int numero) {
    if (_estado.numeroYaUsado(numero)) return;
    setState(() {
      _estado.rondaActual[indiceOp].respuestaColocada = null;
      _estado.colocarEnOperacion(indiceOp, numero);
    });
    _comprobarRonda();
  }

  void _comprobarRonda() {
    if (!_estado.rondaCompleta) return;

    for (final op in _estado.rondaActual) {
      if (op.correcta) {
        _aciertosTotal++;
      } else {
        _erroresTotal++;
      }
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _estado.siguienteRonda());
      if (_estado.finalizado) _onJuegoCompletado();
    });
  }

  int _calcularPuntos() => _aciertosTotal * 10;

  void _onJuegoCompletado() {
    final perfilProvider = context.read<PerfilProvider>();
    final juegoProvider = context.read<JuegoProvider>();
    final estadisticasProvider = context.read<EstadisticasProvider>();

    if (perfilProvider.perfilActivo == null) return;

    perfilProvider.actualizarPuntos(_calcularPuntos());

    juegoProvider.iniciarJuego(JuegoMates());
    for (var i = 0; i < _aciertosTotal; i++) juegoProvider.registrarAcierto();
    for (var i = 0; i < _erroresTotal; i++) juegoProvider.registrarErrores();

    final estadistica = juegoProvider.finalizarJuego(
      perfilProvider.perfilActivo!.id,
    );
    estadisticasProvider.guardarEstadisticas(estadistica);
  }

  @override
  Widget build(BuildContext context) {
    return MarcoJuego(
      titulo: 'Números',
      onSalir: () => Navigator.pop(context),
      onReiniciar: _reiniciar,
      cabeceraExtra: ContadorJuego(
        texto: '🔢 Ronda ${_estado.indiceRonda + 1} / $kTotalRondas',
      ),
      child: _estado.finalizado
          ? PantallaFelicitacion(
        subtitulo: '¡Has completado todos los números!',
        infoPuntos:
        '$_aciertosTotal aciertos  •  Puntos: ${_calcularPuntos()}',
        onJugarDeNuevo: _reiniciar,
      )
          : _buildJuego(),
    );
  }

  Widget _buildJuego() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _estado.rondaActual.length,
                  (i) => _buildOperacion(i),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 1,
          child: Center(
            child: Wrap(
              spacing: 16,
              alignment: WrapAlignment.center,
              children: _estado.resultadosMezclados.map((numero) {
                final usado = _estado.numeroYaUsado(numero);
                final seleccionado = _estado.numeroSeleccionado == numero;
                return _buildNumeroDisponible(numero, usado, seleccionado);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimbolo(String simbolo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        simbolo,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 50,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          shadows: [
            Shadow(
                color: Colors.black26, blurRadius: 4, offset: Offset(1, 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildOperacion(int indiceOp) {
    final op = _estado.rondaActual[indiceOp];
    final colorGrupo1 = kColoresGrupo[indiceOp * 2 % kColoresGrupo.length];
    final colorGrupo2 =
    kColoresGrupo[(indiceOp * 2 + 1) % kColoresGrupo.length];

    Color? fondoHueco;
    Color? bordeHueco;

    if (op.resuelta) {
      fondoHueco =
      op.correcta ? const Color(0xFFE2EFDA) : const Color(0xFFFFE7E7);
      bordeHueco = op.correcta ? AppTema.verde : AppTema.rojo;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── FILA IMÁGENES ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildFilaImagenes(op.numero1, op.imagenNumero1, colorGrupo1),
              _buildSimbolo(op.simbolo),
              _buildFilaImagenes(op.numero2, op.imagenNumero2, colorGrupo2),
            ],
          ),
          const SizedBox(height: 6),
          // ── FILA NÚMEROS ───────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNumeroOperacion('${op.numero1}'),
              _buildSimbolo(op.simbolo),
              _buildNumeroOperacion('${op.numero2}'),
              _buildSimbolo('='),
              DragTarget<int>(
                onWillAcceptWithDetails: (d) =>
                !_estado.numeroYaUsado(d.data) ||
                    _estado.rondaActual[indiceOp].respuestaColocada == d.data,
                onAcceptWithDetails: (d) =>
                    _onNumeroDragSoltado(indiceOp, d.data),
                builder: (context, candidatos, _) {
                  final destacado = candidatos.isNotEmpty;
                  return GestureDetector(
                    onTap: () => _onHuecoTocado(indiceOp),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      height: 70,
                      decoration: BoxDecoration(
                        color: destacado
                            ? Colors.yellow.withValues(alpha:0.4)
                            : fondoHueco ?? Colors.black.withValues(alpha:0.15),
                        borderRadius: AppTema.radiusMedio,
                        border: Border.all(
                          color: destacado
                              ? Colors.yellow
                              : bordeHueco ?? Colors.black.withValues(alpha:0.4),
                          width: destacado ? 3 : 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          op.resuelta ? '${op.respuestaColocada}' : '?',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: op.resuelta
                                ? (op.correcta ? AppTema.verde : AppTema.rojo)
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilaImagenes(int numero, String imagen, Color color) {
    return Wrap(
      spacing: 2,
      children: List.generate(
        numero,
            (_) => Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(3),
          child: Image.asset(imagen, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildNumeroOperacion(String texto) {
    return Container(
      width: 70,
      height: 70,
      alignment: Alignment.center,
      child: Text(
        texto,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 50,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          shadows: [
            Shadow(
                color: Colors.black26, blurRadius: 3, offset: Offset(1, 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildNumeroDisponible(int numero, bool usado, bool seleccionado) {
    return Draggable<int>(
      data: numero,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.2,
          child: _buildChipNumero(numero, false, false),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildChipNumero(numero, false, false),
      ),
      child: GestureDetector(
        onTap: () => _onNumeroTocado(numero),
        child: _buildChipNumero(numero, usado, seleccionado),
      ),
    );
  }

  Widget _buildChipNumero(int numero, bool usado, bool seleccionado) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: usado
            ? Colors.white.withValues(alpha:0.15)
            : seleccionado
            ? AppTema.dorado
            : Colors.white.withValues(alpha:0.9),
        borderRadius: AppTema.radiusMedio,
        border: Border.all(
          color:
          seleccionado ? AppTema.naranja : Colors.white.withValues(alpha:0.5),
          width: seleccionado ? 3 : 2,
        ),
        boxShadow: usado
            ? null
            : [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$numero',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: usado ? Colors.white.withValues(alpha:0.3) : AppTema.azulOscuro,
          ),
        ),
      ),
    );
  }
}