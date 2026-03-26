import 'package:proyecto_aprender_jugando/models/juego.dart';

class JuegoPuzzle extends Juego {
  final int gridSize;
  final String url;

  JuegoPuzzle({
    required super.id,
    required super.nombre,
    required super.descripcion,
    required super.icono,
    required this.url,
    this.gridSize = 3,
  });

}