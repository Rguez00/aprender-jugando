import 'package:proyecto_aprender_jugando/models/juego.dart';

class JuegoMates extends Juego{
final int min;
final int max;

  JuegoMates({
    required super.id,
    required super.nombre,
    required super.descripcion,
    required super.icono,
    this.min = 0,
    this.max = 20,
  });
}