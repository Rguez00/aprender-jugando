import 'dart:math';
import 'package:flutter/material.dart';

class ColorInfo {
  final String castellano;
  final String ingles;
  final Color color;
  final Color colorTexto; // para que el texto sea legible sobre el color

  const ColorInfo({
    required this.castellano,
    required this.ingles,
    required this.color,
    required this.colorTexto,
  });
}

const List<ColorInfo> kColoresDisponibles = [
  ColorInfo(castellano: 'Rojo',     ingles: 'Red',    color: Color(0xFFE53935), colorTexto: Colors.white),
  ColorInfo(castellano: 'Azul',     ingles: 'Blue',   color: Color(0xFF1E88E5), colorTexto: Colors.white),
  ColorInfo(castellano: 'Verde',    ingles: 'Green',  color: Color(0xFF43A047), colorTexto: Colors.white),
  ColorInfo(castellano: 'Amarillo', ingles: 'Yellow', color: Color(0xFFFFD600), colorTexto: Colors.black),
  ColorInfo(castellano: 'Naranja',  ingles: 'Orange', color: Color(0xFFFF6D00), colorTexto: Colors.white),
  ColorInfo(castellano: 'Morado',   ingles: 'Purple', color: Color(0xFF8E24AA), colorTexto: Colors.white),
  ColorInfo(castellano: 'Rosa',     ingles: 'Pink',   color: Color(0xFFE91E63), colorTexto: Colors.white),
  ColorInfo(castellano: 'Marrón',   ingles: 'Brown',  color: Color(0xFF6D4C41), colorTexto: Colors.white),
  ColorInfo(castellano: 'Negro',    ingles: 'Black',  color: Color(0xFF212121), colorTexto: Colors.white),
  ColorInfo(castellano: 'Blanco',   ingles: 'White',  color: Color(0xFFFAFAFA), colorTexto: Colors.black),
];

enum TipoPregunta { verColorElegirNombre, verNombreElegirColor }

class PreguntaColor {
  final ColorInfo colorCorrecto;
  final List<ColorInfo> opciones; // 4 opciones barajadas
  final TipoPregunta tipo;

  const PreguntaColor({
    required this.colorCorrecto,
    required this.opciones,
    required this.tipo,
  });
}

class ColoresState {
  final List<PreguntaColor> preguntas;
  int indiceActual;
  int? indiceOpcionSeleccionada;
  int aciertos;
  int errores;

  ColoresState({
    required this.preguntas,
    this.indiceActual = 0,
    this.indiceOpcionSeleccionada,
    this.aciertos = 0,
    this.errores = 0,
  });

  factory ColoresState.inicial({int totalPreguntas = 10}) {
    final rng = Random();
    final coloresBarajados = List<ColorInfo>.from(kColoresDisponibles)
      ..shuffle(rng);

    // Mitad tipo A, mitad tipo B, mezcladas
    final tipos = [
      ...List.filled(totalPreguntas ~/ 2, TipoPregunta.verColorElegirNombre),
      ...List.filled(totalPreguntas ~/ 2, TipoPregunta.verNombreElegirColor),
    ]..shuffle(rng);

    final preguntas = <PreguntaColor>[];

    for (int i = 0; i < totalPreguntas; i++) {
      final correcto = coloresBarajados[i % coloresBarajados.length];

      // 3 distractores distintos al correcto
      final distractores = List<ColorInfo>.from(kColoresDisponibles)
        ..removeWhere((c) => c.castellano == correcto.castellano)
        ..shuffle(rng);

      final opciones = [correcto, ...distractores.take(3)]..shuffle(rng);

      preguntas.add(PreguntaColor(
        colorCorrecto: correcto,
        opciones: opciones,
        tipo: tipos[i],
      ));
    }

    return ColoresState(preguntas: preguntas);
  }

  PreguntaColor get preguntaActual => preguntas[indiceActual];

  bool get respondida => indiceOpcionSeleccionada != null;

  bool get finalizado => indiceActual >= preguntas.length;

  bool esCorrecta(int indiceOpcion) =>
      preguntaActual.opciones[indiceOpcion].castellano ==
          preguntaActual.colorCorrecto.castellano;

  void responder(int indiceOpcion) {
    indiceOpcionSeleccionada = indiceOpcion;
    if (esCorrecta(indiceOpcion)) {
      aciertos++;
    } else {
      errores++;
    }
  }

  void siguiente() {
    indiceActual++;
    indiceOpcionSeleccionada = null;
  }
}