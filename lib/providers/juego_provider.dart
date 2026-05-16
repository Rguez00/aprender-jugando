import 'package:flutter/cupertino.dart';

import '../models/estadisticas.dart';
import '../models/juego.dart';

class JuegoProvider extends ChangeNotifier{
  Juego? _juegoActual;
  int _puntuacion = 0;
  int _aciertos = 0;
  int _errores = 0;

  Juego? get juegoActual => _juegoActual;
  int get puntuacion => _puntuacion;
  int get aciertos => _aciertos;
  int get errores => _errores;


  void iniciarJuego(Juego juego) {
      _juegoActual = juego;
      _puntuacion = 0;
      _aciertos = 0;
      _errores = 0;
      notifyListeners();
  }

  void registrarAcierto() {
    _aciertos++;
    notifyListeners();
  }

  void registrarErrores() {
    _errores++;
    notifyListeners();
  }

  Estadisticas finalizarJuego(String idPerfil) {
    return Estadisticas(
        idPerfil: idPerfil,
        idJuego: _juegoActual!.id,
        puntuacion: puntuacion,
        aciertos: aciertos,
        errores: errores,
        fecha: DateTime.now()
    );
  }

}