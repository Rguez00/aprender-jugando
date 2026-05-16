import 'package:flutter/material.dart';

class TextoArcoiris extends StatelessWidget {
  final String texto;
  final double fontSize;

  static const List<Color> _colores = [
    Color(0xFFE65100), // naranja oscuro
    Color(0xFFE53935), // rojo
    Color(0xFFFF6F00), // naranja
    Color(0xFFFDD835), // amarillo
    Color(0xFF43A047), // verde
    Color(0xFF1E88E5), // azul
    Color(0xFF8E24AA), // morado
  ];

  const TextoArcoiris({
    super.key,
    required this.texto,
    this.fontSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    final chars = texto.split('');
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          shadows: const [
            Shadow(
              color: Colors.black45,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        children: chars.asMap().entries.map((e) {
          return TextSpan(
            text: e.value,
            style: TextStyle(
              color: _colores[e.key % _colores.length],
            ),
          );
        }).toList(),
      ),
    );
  }
}