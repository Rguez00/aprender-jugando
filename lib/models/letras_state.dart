import 'dart:math';
import 'package:proyecto_aprender_jugando/models/palabra_model.dart';

class LetrasState {
  final PalabraModel palabra;
  final List<String> letrasDisponibles; // letras barajadas + trampa
  final List<String?> huecos;           // respuesta del usuario
  bool conErrores;

  LetrasState({
    required this.palabra,
    required this.letrasDisponibles,
    required this.huecos,
    this.conErrores = false,
  });

  factory LetrasState.dePalabra(PalabraModel palabraModel) {
    final letras = palabraModel.palabra.split('');

    // Letras trampa: consonantes comunes que no estén ya en la palabra
    const trampa = ['B', 'D', 'G', 'K', 'M', 'N', 'P', 'R', 'S', 'T', 'V', 'X'];
    final disponibles = trampa
        .where((l) => !letras.contains(l))
        .toList()
      ..shuffle(Random());
    final trampaSeleccionada = disponibles.take(3).toList();

    final mezcla = [...letras, ...trampaSeleccionada]..shuffle(Random());

    return LetrasState(
      palabra: palabraModel,
      letrasDisponibles: mezcla,
      huecos: List.filled(letras.length, null),
    );
  }

  // Coloca una letra en el primer hueco libre
  bool colocarLetra(String letra) {
    final indice = huecos.indexOf(null);
    if (indice == -1) return false;
    huecos[indice] = letra;
    return true;
  }

  // Borra la última letra colocada
  void borrarUltima() {
    for (int i = huecos.length - 1; i >= 0; i--) {
      if (huecos[i] != null) {
        huecos[i] = null;
        return;
      }
    }
  }

  bool get completo => huecos.every((h) => h != null);

  bool get correcto {
    final letrasCorrectas = palabra.palabra.split('');
    for (int i = 0; i < letrasCorrectas.length; i++) {
      if (huecos[i] != letrasCorrectas[i]) return false;
    }
    return true;
  }
}