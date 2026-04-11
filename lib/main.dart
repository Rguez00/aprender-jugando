import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_aprender_jugando/providers/estadisticas_provider.dart';
import 'package:proyecto_aprender_jugando/providers/juego_provider.dart';
import 'package:proyecto_aprender_jugando/providers/perfil_provider.dart';
import 'package:proyecto_aprender_jugando/screens/juegos/puzzle/puzzle_screen.dart';
import 'package:proyecto_aprender_jugando/screens/splash/splash_screen.dart';
import 'package:proyecto_aprender_jugando/utils/tema.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PerfilProvider()),
        ChangeNotifierProvider(create: (_) => JuegoProvider()),
        ChangeNotifierProvider(create: (_) => EstadisticasProvider()),
      ],
      child: MaterialApp(
        theme: AppTema.themeData,
        title: 'Aprender Jugando',
        home: const SplashScreen(),
      ),
    );
  }
}

