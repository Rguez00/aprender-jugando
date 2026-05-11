import 'package:proyecto_aprender_jugando/models/juego.dart';

class JuegoLetras extends Juego {
  JuegoLetras() : super(
    id: 'letras',
    nombre: 'Letras',
    descripcion: 'Forma palabras colocando las letras en orden',
    icono: 'assets/images/logo_letras.png',
  );
}