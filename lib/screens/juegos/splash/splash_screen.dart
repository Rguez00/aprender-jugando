import 'package:flutter/material.dart';

import '../../home/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    _navegar();
  }

  Future<void> _navegar() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return; // ← añadir esta línea
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset("assets/images/splash_screen.png",
        fit: BoxFit.cover,
        ),
      ),
    );
  }
}
