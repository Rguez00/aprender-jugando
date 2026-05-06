import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/juego_parejas.dart';
import '../../../models/parejas_state.dart';
import '../../../providers/perfil_provider.dart';
import '../../../utils/tema.dart';
import '../../../widgets/common/marco_juego.dart';
import '../../../widgets/common/scale_pulse.dart';
import '../../../widgets/parejas/carta_widget.dart';
import 'package:proyecto_aprender_jugando/models/estadisticas.dart';
import 'package:proyecto_aprender_jugando/models/juego.dart';
import 'package:proyecto_aprender_jugando/providers/estadisticas_provider.dart';
import 'package:proyecto_aprender_jugando/providers/juego_provider.dart';

// Pool completo de imágenes
const List<String> _kPoolImagenes = [
  'assets/images/arbol.png',
  'assets/images/calabaza.png',
  'assets/images/cerdo.png',
  'assets/images/cesta.png',
  'assets/images/coche.png',
  'assets/images/flor.png',
  'assets/images/fresa.png',
  'assets/images/mundo.png',
  'assets/images/oso.png',
  'assets/images/pajaro.png',
  'assets/images/poyo.png',
  'assets/images/zanahoria.png',
];

class ParejasScreen extends StatefulWidget {
  const ParejasScreen({super.key});

  @override
  State<ParejasScreen> createState() => _ParejasScreenState();
}

class _ParejasScreenState extends State<ParejasScreen> {
  late ParejasState _estado;
  bool _bloqueado = false; // evita tocar cartas durante el delay

  @override
  void initState() {
    super.initState();
    _estado = ParejasState.inicial(_kPoolImagenes);
  }

  void _onCartaTocada(int indice) {
    if (_bloqueado) return;
    if (_estado.estado[indice] == EstadoCarta.emparejada) return;
    if (_estado.estado[indice] == EstadoCarta.volteada) return;
    // Si ya hay dos volteadas sin comprobar, ignorar
    if (_estado.cartaSeleccionada != null &&
        _estado.cartaComprobar != null) return;

    setState(() {
      _estado.seleccionarCasilla(indice);
    });

    // Si ya se voltearon dos cartas, esperar y comprobar
    if (_estado.cartaComprobar != null) {
      _bloqueado = true;
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        setState(() {
          _estado.comprobarCartas();
          _bloqueado = false;
        });
        // Si se completó el juego, sumar puntos
        if (_estado.finalizado) {
          _onJuegoCompletado();
        }
      });
    }
  }

  void _onJuegoCompletado() {
    final perfilProvider = context.read<PerfilProvider>();
    final juegoProvider = context.read<JuegoProvider>();
    final estadisticasProvider = context.read<EstadisticasProvider>();

    if (perfilProvider.perfilActivo == null) return;

    final puntos = _calcularPuntos();
    // Aciertos = 8 parejas encontradas, errores = intentos fallidos
    final errores = (_estado.intentos - 8).clamp(0, 999);

    perfilProvider.actualizarPuntos(puntos);

    juegoProvider.iniciarJuego(JuegoParejas());
    for (var i = 0; i < 8; i++) juegoProvider.registrarAcierto();
    for (var i = 0; i < errores; i++) juegoProvider.registrarErrores();

    final estadistica = juegoProvider.finalizarJuego(
      perfilProvider.perfilActivo!.id,
    );
    estadisticasProvider.guardarEstadisticas(estadistica);
  }

  int _calcularPuntos() {
    // Base 100 puntos, -5 por cada intento extra (mínimo 10)
    const base = 100;
    final extra = (_estado.intentos - 8).clamp(0, 999);
    return (base - extra * 5).clamp(10, base);
  }

  void _reiniciar() {
    setState(() {
      _estado = ParejasState.inicial(_kPoolImagenes);
      _bloqueado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MarcoJuego(
      titulo: 'Parejas',
      onSalir: () => Navigator.pop(context),
      onReiniciar: _reiniciar,
      cabeceraExtra: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTema.dorado,
          borderRadius: AppTema.radiusMedio,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          '🎯 Intentos: ${_estado.intentos}',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppTema.azulOscuro,
          ),
        ),
      ),
      child: _estado.finalizado ? _buildFelicitacion() : _buildTablero(),
    );
  }

  Widget _buildTablero() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 16,
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

  Widget _buildFelicitacion() {
    final puntos = _calcularPuntos();
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 80,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(2, 2)),
                ],
              ),
              children: [
                TextSpan(text: '¡', style: TextStyle(color: Colors.orange[700])),
                TextSpan(text: 'F', style: TextStyle(color: Colors.red[400])),
                TextSpan(text: 'E', style: TextStyle(color: Colors.orange[600])),
                TextSpan(text: 'L', style: TextStyle(color: Colors.yellow[300])),
                TextSpan(text: 'I', style: TextStyle(color: Colors.green[400])),
                TextSpan(text: 'C', style: TextStyle(color: Colors.blue[300])),
                TextSpan(text: 'I', style: TextStyle(color: Colors.purple[300])),
                TextSpan(text: 'D', style: TextStyle(color: Colors.red[400])),
                TextSpan(text: 'A', style: TextStyle(color: Colors.orange[600])),
                TextSpan(text: 'D', style: TextStyle(color: Colors.yellow[300])),
                TextSpan(text: 'E', style: TextStyle(color: Colors.green[400])),
                TextSpan(text: 'S', style: TextStyle(color: Colors.blue[300])),
                TextSpan(text: '!', style: TextStyle(color: Colors.purple[300])),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 40,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(1, 1)),
                ],
              ),
              children: [
                TextSpan(text: '¡', style: TextStyle(color: Colors.orange[700])),
                TextSpan(text: 'H', style: TextStyle(color: Colors.red[400])),
                TextSpan(text: 'a', style: TextStyle(color: Colors.orange[600])),
                TextSpan(text: 's', style: TextStyle(color: Colors.yellow[600])),
                TextSpan(text: ' e', style: TextStyle(color: Colors.green[400])),
                TextSpan(text: 'n', style: TextStyle(color: Colors.blue[300])),
                TextSpan(text: 'c', style: TextStyle(color: Colors.purple[300])),
                TextSpan(text: 'o', style: TextStyle(color: Colors.red[400])),
                TextSpan(text: 'n', style: TextStyle(color: Colors.orange[600])),
                TextSpan(text: 't', style: TextStyle(color: Colors.yellow[600])),
                TextSpan(text: 'r', style: TextStyle(color: Colors.green[400])),
                TextSpan(text: 'a', style: TextStyle(color: Colors.blue[300])),
                TextSpan(text: 'd', style: TextStyle(color: Colors.purple[300])),
                TextSpan(text: 'o', style: TextStyle(color: Colors.red[400])),
                TextSpan(text: ' t', style: TextStyle(color: Colors.orange[600])),
                TextSpan(text: 'o', style: TextStyle(color: Colors.yellow[600])),
                TextSpan(text: 'd', style: TextStyle(color: Colors.green[400])),
                TextSpan(text: 'a', style: TextStyle(color: Colors.blue[300])),
                TextSpan(text: 's', style: TextStyle(color: Colors.purple[300])),
                TextSpan(text: ' l', style: TextStyle(color: Colors.red[400])),
                TextSpan(text: 'a', style: TextStyle(color: Colors.orange[600])),
                TextSpan(text: 's', style: TextStyle(color: Colors.yellow[600])),
                TextSpan(text: ' p', style: TextStyle(color: Colors.green[400])),
                TextSpan(text: 'a', style: TextStyle(color: Colors.blue[300])),
                TextSpan(text: 'r', style: TextStyle(color: Colors.purple[300])),
                TextSpan(text: 'e', style: TextStyle(color: Colors.red[400])),
                TextSpan(text: 'j', style: TextStyle(color: Colors.orange[600])),
                TextSpan(text: 'a', style: TextStyle(color: Colors.yellow[600])),
                TextSpan(text: 's', style: TextStyle(color: Colors.green[400])),
                TextSpan(text: '!', style: TextStyle(color: Colors.blue[300])),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Intentos: ${_estado.intentos}  •  Puntos: $puntos',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 32),
          ScalePulse(
            onTap: _reiniciar,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              decoration: AppTema.decoracionBotonNaranja,
              child: const Text(
                '¡Otra partida!',
                style: AppTema.textoBoton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}