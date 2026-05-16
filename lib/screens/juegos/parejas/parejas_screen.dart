import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_aprender_jugando/models/juego_parejas.dart';
import 'package:proyecto_aprender_jugando/models/parejas_state.dart';
import 'package:proyecto_aprender_jugando/providers/estadisticas_provider.dart';
import 'package:proyecto_aprender_jugando/providers/juego_provider.dart';
import 'package:proyecto_aprender_jugando/providers/perfil_provider.dart';
import 'package:proyecto_aprender_jugando/utils/constantes.dart';
import 'package:proyecto_aprender_jugando/widgets/common/contador_juego.dart';
import 'package:proyecto_aprender_jugando/widgets/common/marco_juego.dart';
import 'package:proyecto_aprender_jugando/widgets/common/pantalla_felicitacion.dart';
import 'package:proyecto_aprender_jugando/widgets/parejas/carta_widget.dart';

class ParejasScreen extends StatefulWidget {
  const ParejasScreen({super.key});

  @override
  State<ParejasScreen> createState() => _ParejasScreenState();
}

class _ParejasScreenState extends State<ParejasScreen> {
  late ParejasState _estado;
  bool _bloqueado = false;

  @override
  void initState() {
    super.initState();
    _reiniciar();
  }

  void _onCartaTocada(int indice) {
    if (_bloqueado) return;
    if (_estado.estado[indice] == EstadoCarta.emparejada) return;
    if (_estado.estado[indice] == EstadoCarta.volteada) return;
    if (_estado.cartaSeleccionada != null &&
        _estado.cartaComprobar != null) return;

    setState(() {
      _estado.seleccionarCasilla(indice);
    });

    if (_estado.cartaComprobar != null) {
      _bloqueado = true;
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        setState(() {
          _estado.comprobarCartas();
          _bloqueado = false;
        });
        if (_estado.finalizado) _onJuegoCompletado();
      });
    }
  }

  void _onJuegoCompletado() {
    final perfilProvider = context.read<PerfilProvider>();
    final juegoProvider = context.read<JuegoProvider>();
    final estadisticasProvider = context.read<EstadisticasProvider>();

    if (perfilProvider.perfilActivo == null) return;

    final puntos = _calcularPuntos();
    final errores = (_estado.intentos - 6).clamp(0, 999);

    perfilProvider.actualizarPuntos(puntos);

    juegoProvider.iniciarJuego(JuegoParejas());
    for (var i = 0; i < 6; i++) juegoProvider.registrarAcierto();
    for (var i = 0; i < errores; i++) juegoProvider.registrarErrores();

    final estadistica = juegoProvider.finalizarJuego(
      perfilProvider.perfilActivo!.id,
    );
    estadisticasProvider.guardarEstadisticas(estadistica);
  }

  int _calcularPuntos() {
    const base = 100;
    final extra = (_estado.intentos - 6).clamp(0, 999);
    return (base - extra * 5).clamp(10, base);
  }

  void _reiniciar() {
    setState(() {
      _estado = ParejasState.inicial(kImagenesObjetos);
      _bloqueado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final puntos = _calcularPuntos();
    return MarcoJuego(
      titulo: 'Parejas',
      onSalir: () => Navigator.pop(context),
      onReiniciar: _reiniciar,
      cabeceraExtra: ContadorJuego(
        texto: '🎯 Intentos: ${_estado.intentos}',
      ),
      child: _estado.finalizado
          ? PantallaFelicitacion(
        subtitulo: '¡Has encontrado todas las parejas!',
        infoPuntos: 'Intentos: ${_estado.intentos}  •  Puntos: $puntos',
        onJugarDeNuevo: _reiniciar,
      )
          : _buildTablero(),
    );
  }

  Widget _buildTablero() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final anchoMaximo = constraints.maxWidth;
        final altoMaximo = constraints.maxHeight;

        final celdaPorAncho = (anchoMaximo - 8 * 3) / 4;
        final celdaPorAlto = (altoMaximo - 8 * 2) / 3;
        final celdaSize =
        celdaPorAncho < celdaPorAlto ? celdaPorAncho : celdaPorAlto;

        final gridAncho = celdaSize * 4 + 8 * 3;
        final gridAlto = celdaSize * 3 + 8 * 2;

        return Center(
          child: SizedBox(
            width: gridAncho,
            height: gridAlto,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, indice) {
                return GestureDetector(
                  onTap: () => _onCartaTocada(indice),
                  child: CartaWidget(
                    estado: _estado.estado[indice],
                    imagen: _estado.imagenCelda[indice],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}