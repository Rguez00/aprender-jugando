// tablero_secundario.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:proyecto_aprender_jugando/models/puzzle_state.dart';
import 'package:proyecto_aprender_jugando/widgets/common/responsive_grid.dart';

class TableroSecundario extends StatelessWidget {
  final List<Uint8List> piezas;
  final PuzzleState puzzleState;
  final Function(int) onTapPieza;
  final Function(int, int) onDragPieza;
  final Function(int?) onDragIniciado;

  const TableroSecundario({
    super.key,
    required this.piezas,
    required this.puzzleState,
    required this.onTapPieza,
    required this.onDragPieza,
    required this.onDragIniciado,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double size = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;

          return Center(
            child: Container(
              width: size,
              height: size,
              child: ResponsiveGrid(
                columns: 3,
                rows: 3,
                size: size,
                itemBuilder: (index) {
                  if (index >= puzzleState.listaPiezas.length) {
                    return Container();
                  }
                  final pieza = puzzleState.listaPiezas[index];
                  return Draggable<int>(
                    data: pieza,
                    onDragStarted: () => onDragIniciado(pieza),
                    feedback: SizedBox(
                      width: size / 3,
                      height: size / 3,
                      child: Image.memory(piezas[pieza], fit: BoxFit.cover),
                    ),
                    childWhenDragging: Container(),
                    child: GestureDetector(
                      onTap: () => onTapPieza(index),
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          border: Border.all(
                            color: pieza == puzzleState.piezaSeleccionada
                                ? Colors.orange
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: Image.memory(piezas[pieza], fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}