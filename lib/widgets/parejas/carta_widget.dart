import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/parejas_state.dart';

class CartaWidget extends StatefulWidget {
  final EstadoCarta estado;
  final String imagen;

  const CartaWidget({
    required this.estado,
    required this.imagen,
    super.key,
  });

  @override
  State<CartaWidget> createState() => _CartaWidgetState();
}

class _CartaWidgetState extends State<CartaWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animacion;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animacion = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CartaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.estado == EstadoCarta.oculta) {
      // Siempre volver al reverso al reiniciar
      _controller.reverse();
    } else if (widget.estado == EstadoCarta.volteada ||
        widget.estado == EstadoCarta.emparejada) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animacion,
      builder: (context, child) {
        final angulo = _animacion.value;
        final mostrarFrente = angulo > pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspectiva 3D
            ..rotateY(angulo),
          child: mostrarFrente
              ? Transform(
            // Corrige el efecto espejo al pasar de 90° a 180°
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(pi),
            child: _frente(),
          )
              : _reverso(),
        );
      },
    );
  }

  Widget _frente() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.15),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        widget.imagen,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _reverso() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.15),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Image.asset(
        'assets/images/logo_estrella.png',
        fit: BoxFit.contain,  // ocupa todo el padding
      ),
    );
  }
}