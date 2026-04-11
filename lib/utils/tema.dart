import 'package:flutter/material.dart';

class AppTema {
  // ══════════════════════════════════════
  // COLORES BASE
  // ══════════════════════════════════════
  static const Color azulOscuro = Color(0xFF1A237E);
  static const Color azulMedio = Color(0xFF283593);
  static const Color azulClaro = Color(0xFF3949AB);
  static const Color naranja = Color(0xFFFFB300);
  static const Color naranjaOscuro = Color(0xFFFF8F00);
  static const Color verde = Color(0xFF43A047);
  static const Color rojo = Color(0xFFE53935);
  static const Color blanco = Color(0xFFFFFFFF);
  static const Color blancoSuave = Color(0xFFF5F5F5);
  static const Color grisClaro = Color(0xFFEEEEEE);
  static const Color dorado = Color(0xFFFFD700);

  // ══════════════════════════════════════
  // GRADIENTES
  // ══════════════════════════════════════
  static const LinearGradient gradienteFondo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [azulOscuro, azulMedio, azulClaro],
  );

  static const LinearGradient gradienteNaranja = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [naranja, naranjaOscuro],
  );

  static const LinearGradient gradienteVerde = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
  );

  static const LinearGradient gradienteRojo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE53935), Color(0xFFC62828)],
  );

  static const LinearGradient gradienteDorado = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [dorado, naranja],
  );

  static const LinearGradient gradienteTarjeta = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF3949AB), Color(0xFF1A237E)],
  );

  // ══════════════════════════════════════
  // SOMBRAS
  // ══════════════════════════════════════
  static List<BoxShadow> sombraCard = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> sombraBoton = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> sombraAvatar = [
    BoxShadow(
      color: naranja.withOpacity(0.5),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // ══════════════════════════════════════
  // BORDES REDONDEADOS
  // ══════════════════════════════════════
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMedio = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusGrande = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusCirculo = BorderRadius.all(Radius.circular(100));

  // ══════════════════════════════════════
  // TIPOGRAFÍA
  // ══════════════════════════════════════
  static const String fuente = 'Nunito';

  static const TextStyle titulo = TextStyle(
    fontFamily: fuente,
    fontSize: 36,
    fontWeight: FontWeight.w900,
    color: blanco,
    letterSpacing: 1.5,
    shadows: [
      Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(2, 2)),
    ],
  );

  static const TextStyle subtitulo = TextStyle(
    fontFamily: fuente,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: blanco,
    letterSpacing: 1.0,
  );

  static const TextStyle textoGrande = TextStyle(
    fontFamily: fuente,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: blanco,
  );

  static const TextStyle textoNormal = TextStyle(
    fontFamily: fuente,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: blanco,
  );

  static const TextStyle textoSmall = TextStyle(
    fontFamily: fuente,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: blanco,
  );

  static const TextStyle textoPuntos = TextStyle(
    fontFamily: fuente,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: dorado,
    shadows: [
      Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1)),
    ],
  );

  static const TextStyle textoBoton = TextStyle(
    fontFamily: fuente,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: blanco,
    letterSpacing: 1.0,
  );

  // ══════════════════════════════════════
  // DECORACIONES DE CONTENEDORES
  // ══════════════════════════════════════
  static BoxDecoration decoracionFondo = const BoxDecoration(
    gradient: gradienteFondo,
  );

  static BoxDecoration decoracionTarjeta = BoxDecoration(
    gradient: gradienteTarjeta,
    borderRadius: radiusGrande,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration decoracionBotonNaranja = BoxDecoration(
    gradient: gradienteNaranja,
    borderRadius: radiusMedio,
    boxShadow: [
      BoxShadow(
        color: naranja.withOpacity(0.4),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration decoracionBotonVerde = BoxDecoration(
    gradient: gradienteVerde,
    borderRadius: radiusMedio,
    boxShadow: [
      BoxShadow(
        color: verde.withOpacity(0.4),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration decoracionBotonRojo = BoxDecoration(
    gradient: gradienteRojo,
    borderRadius: radiusMedio,
    boxShadow: [
      BoxShadow(
        color: rojo.withOpacity(0.4),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration decoracionMarcoJuego = BoxDecoration(
    gradient: gradienteFondo,
    borderRadius: radiusGrande,
    border: Border.all(
      color: naranja.withOpacity(0.5),
      width: 2,
    ),
  );

  // ══════════════════════════════════════
  // ESPACIADOS
  // ══════════════════════════════════════
  static const double espaciadoSmall = 8;
  static const double espaciadoMedio = 16;
  static const double espaciadoGrande = 24;
  static const double espaciadoExtraGrande = 48;

  // ══════════════════════════════════════
  // TAMAÑOS
  // ══════════════════════════════════════
  static const double avatarSmall = 48;
  static const double avatarMedio = 80;
  static const double avatarGrande = 120;
  static const double iconoSmall = 24;
  static const double iconoMedio = 36;
  static const double iconoGrande = 48;
  static const double altoBoton = 56;
  static const double anchoBoton = 200;

  // ══════════════════════════════════════
  // THEME DATA (para MaterialApp)
  // ══════════════════════════════════════
  static ThemeData get themeData => ThemeData(
    fontFamily: fuente,
    colorScheme: ColorScheme.fromSeed(
      seedColor: azulOscuro,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: azulOscuro,
    cardTheme: CardThemeData(
      color: azulMedio,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: naranja,
        foregroundColor: blanco,
        textStyle: textoBoton,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
    ),
  );
}