import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:proyecto_aprender_jugando/models/puzzle_state.dart';
import 'package:proyecto_aprender_jugando/services/api_service.dart';
import 'package:proyecto_aprender_jugando/widgets/common/marco_juego.dart';
import 'package:proyecto_aprender_jugando/widgets/puzzle/tablero_principal.dart';
import 'package:proyecto_aprender_jugando/widgets/puzzle/tablero_secundario.dart';

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
  final int gridSize = 3;
  Uint8List? imagenFondo;

  @override
  void initState() {
    super.initState();
    _cargarJuego();
  }

  Future<void> _cargarJuego() async {
    setState(() => cargando = true);
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

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MarcoJuego(
      titulo: "Puzzle",
      onSalir: () => Navigator.pop(context),
      onReiniciar: _cargarJuego,
      child: puzzleState!.finalizado
          ? _pantallaFelicitacion()
          : Row(
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
          const SizedBox(width: 16),
          TableroSecundario(
            piezas: piezas!,
            puzzleState: puzzleState!,
            onTapPieza: _onTapPieza,
            onDragPieza: _onDragPieza,
            onDragIniciado: _onDragIniciado,
          ),
        ],
      ),
    );
  }

  Widget _pantallaFelicitacion() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "¡FELICIDADES!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "¡Has completado el puzzle!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _cargarJuego,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB300),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Text(
              "¡Otro puzzle!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
  }

  void _onDragIniciado(int? valorPieza) {
    setState(() {
      puzzleState!.piezaSeleccionada = valorPieza;
    });
  }
}