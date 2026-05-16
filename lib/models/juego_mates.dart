import 'package:proyecto_aprender_jugando/models/juego.dart';

class JuegoMates extends Juego {
  JuegoMates() : super(
    id: 'mates',
    nombre: 'Números',
    descripcion: 'Sumas y restas del 1 al 10',
    icono: 'assets/images/logo_mates.png',
  );
}