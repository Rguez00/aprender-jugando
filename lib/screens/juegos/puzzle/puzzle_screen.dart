import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:proyecto_aprender_jugando/models/puzzle_state.dart';
import 'package:proyecto_aprender_jugando/services/api_service.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';
import 'package:proyecto_aprender_jugando/widgets/common/marco_juego.dart';
import 'package:proyecto_aprender_jugando/widgets/common/scale_pulse.dart';
import 'package:proyecto_aprender_jugando/widgets/puzzle/tablero_principal.dart';
import 'package:proyecto_aprender_jugando/widgets/puzzle/tablero_secundario.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_aprender_jugando/models/juego_puzzle.dart';
import 'package:proyecto_aprender_jugando/providers/estadisticas_provider.dart';
import 'package:proyecto_aprender_jugando/providers/juego_provider.dart';
import 'package:proyecto_aprender_jugando/providers/perfil_provider.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final ApiService apiService = ApiService();
  PuzzleState? puzzleState;
  List<Uint8List>? piezas;
  bool cargando = true;
  bool _juegoGuardado = false; // evita guardar estadísticas más de una vez
  final int gridSize = 3;
  Uint8List? imagenFondo;

  @override
  void initState() {
    super.initState();
    _cargarJuego();
  }

  Future<void> _cargarJuego() async {
    setState(() {
      cargando = true;
      _juegoGuardado = false;
    });
    final String url = await apiService.obtenerImagenUrlPuzzle();
    final Uint8List imagen = await apiService.obtenerImagenBytes(url);
    final Uint8List imagenCuadrada = apiService.hacerCuadrada(imagen);
    List<Uint8List> listaPiezas = apiService.dividirImagen(imagenCuadrada, gridSize);
    setState(() {
      piezas = listaPiezas;
      puzzleState = PuzzleState.inicial(gridSize);
      cargando = false;
      imagenFondo = imagenCuadrada;
    });
  }

  void _onJuegoCompletado() {
    if (_juegoGuardado) return; // evitar llamadas duplicadas
    _juegoGuardado = true;

    final perfilProvider = context.read<PerfilProvider>();
    final juegoProvider = context.read<JuegoProvider>();
    final estadisticasProvider = context.read<EstadisticasProvider>();

    if (perfilProvider.perfilActivo == null) return;

    perfilProvider.actualizarPuntos(50);

    juegoProvider.iniciarJuego(JuegoPuzzle(
      id: 'puzzle',
      nombre: 'Puzzle',
      descripcion: 'Completa el puzzle con las piezas',
      icono: 'assets/images/logo_puzzle.png',
      url: '',
    ));
    juegoProvider.registrarAcierto();

    final estadistica = juegoProvider.finalizarJuego(
      perfilProvider.perfilActivo!.id,
    );
    estadisticasProvider.guardarEstadisticas(estadistica);
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                'assets/images/fondo_juegos.png',
                fit: BoxFit.cover,
              ),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    "Cargando puzzle...",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(1, 1)),
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

    final Widget tableros = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TableroPrincipal(
          imagen: imagenFondo!,
          puzzleState: puzzleState!,
          piezas: piezas!,
          onTapCelda: _onTapCelda,
          onDragPieza: _onDragPieza,
          onDragIniciado: _onDragIniciado,
        ),
        TableroSecundario(
          piezas: piezas!,
          puzzleState: puzzleState!,
          onTapPieza: _onTapPieza,
          onDragPieza: _onDragPieza,
          onDragIniciado: _onDragIniciado,
        ),
      ],
    );

    return MarcoJuego(
      titulo: "Puzzle",
      onSalir: () => Navigator.pop(context),
      onReiniciar: _cargarJuego,
      child: puzzleState!.finalizado
          ? Stack(
        children: [
          tableros,
          Container(
            padding: const EdgeInsets.only(left: 600),
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
                        Shadow(
                            color: Colors.black45,
                            blurRadius: 8,
                            offset: Offset(2, 2)),
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
                        Shadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(1, 1)),
                      ],
                    ),
                    children: [
                      TextSpan(text: '¡', style: TextStyle(color: Colors.orange[700])),
                      TextSpan(text: 'H', style: TextStyle(color: Colors.red[400])),
                      TextSpan(text: 'a', style: TextStyle(color: Colors.orange[600])),
                      TextSpan(text: 's', style: TextStyle(color: Colors.yellow[600])),
                      TextSpan(text: ' c', style: TextStyle(color: Colors.green[400])),
                      TextSpan(text: 'o', style: TextStyle(color: Colors.blue[300])),
                      TextSpan(text: 'm', style: TextStyle(color: Colors.purple[300])),
                      TextSpan(text: 'p', style: TextStyle(color: Colors.red[400])),
                      TextSpan(text: 'l', style: TextStyle(color: Colors.orange[600])),
                      TextSpan(text: 'e', style: TextStyle(color: Colors.yellow[600])),
                      TextSpan(text: 't', style: TextStyle(color: Colors.green[400])),
                      TextSpan(text: 'a', style: TextStyle(color: Colors.blue[300])),
                      TextSpan(text: 'd', style: TextStyle(color: Colors.purple[300])),
                      TextSpan(text: 'o', style: TextStyle(color: Colors.red[400])),
                      TextSpan(text: ' e', style: TextStyle(color: Colors.orange[600])),
                      TextSpan(text: 'l', style: TextStyle(color: Colors.yellow[600])),
                      TextSpan(text: ' p', style: TextStyle(color: Colors.green[400])),
                      TextSpan(text: 'u', style: TextStyle(color: Colors.blue[300])),
                      TextSpan(text: 'z', style: TextStyle(color: Colors.purple[300])),
                      TextSpan(text: 'z', style: TextStyle(color: Colors.red[400])),
                      TextSpan(text: 'l', style: TextStyle(color: Colors.orange[600])),
                      TextSpan(text: 'e', style: TextStyle(color: Colors.yellow[600])),
                      TextSpan(text: '!', style: TextStyle(color: Colors.green[400])),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ScalePulse(
                  onTap: _cargarJuego,
                  child: Image.asset(
                    'assets/images/jugar_de_nuevo_redondo.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          : tableros,
    );
  }

  void _onTapCelda(int index) {
    setState(() {
      if (puzzleState!.piezaSeleccionada != null) {
        puzzleState!.colocarPieza(index);
      } else if (puzzleState!.piezaCelda[index] != null) {
        puzzleState!.moverPiezaPrincipal(index);
      }
    });
    if (puzzleState!.finalizado) _onJuegoCompletado();
  }

  void _onTapPieza(int index) {
    setState(() {
      puzzleState!.seleccionarPiezaSecundario(index);
    });
  }

  void _onDragPieza(int valorPieza, int indiceCeldaDestino) {
    setState(() {
      if (puzzleState!.listaPiezas.contains(valorPieza)) {
        puzzleState!.piezaSeleccionada = valorPieza;
        puzzleState!.piezaVieneDePrincipal = false;
        puzzleState!.colocarPieza(indiceCeldaDestino);
      } else {
        final indiceOrigen = puzzleState!.piezaCelda.indexOf(valorPieza);
        if (indiceOrigen != -1) {
          puzzleState!.piezaSeleccionada = valorPieza;
          puzzleState!.piezaVieneDePrincipal = true;
          puzzleState!.indicePiezaPrincipal = indiceOrigen;
          puzzleState!.colocarPieza(indiceCeldaDestino);
        }
      }
    });
    if (puzzleState!.finalizado) _onJuegoCompletado();
  }

  void _onDragIniciado(int? valorPieza) {
    setState(() {
      puzzleState!.piezaSeleccionada = valorPieza;
    });
  }
}