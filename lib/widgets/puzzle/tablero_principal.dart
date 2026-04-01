// tablero_principal.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:proyecto_aprender_jugando/models/puzzle_state.dart';
import 'package:proyecto_aprender_jugando/widgets/common/responsive_grid.dart';

class TableroPrincipal extends StatelessWidget {
  final Uint8List imagen;
  final PuzzleState puzzleState;
  final List<Uint8List> piezas;
  final Function(int) onTapCelda;
  final Function(int, int) onDragPieza;
  final Function(int?) onDragIniciado;

  const TableroPrincipal({
    super.key,
    required this.imagen,
    required this.puzzleState,
    required this.piezas,
    required this.onTapCelda,
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(imagen),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
              ),
              child: ResponsiveGrid(
                columns: 3,
                rows: 3,
                size: size,
                itemBuilder: (index) {
                  final pieza = puzzleState.piezaCelda[index];
                  return DragTarget<int>(
                    onAcceptWithDetails: (details) {
                      onDragPieza(details.data, index);
                    },
                    builder: (context, candidateData, rejectedData) {
                      // Efecto visual cuando una pieza está encima de la celda
                      final hayPiezaEncima = candidateData.isNotEmpty;
                      return Draggable<int>(
                        data: pieza,
                        onDragStarted: () => onDragIniciado(pieza),
                        feedback: pieza != null
                            ? SizedBox(
                          width: size / 3,
                          height: size / 3,
                          child: Image.memory(
                            piezas[pieza],
                            fit: BoxFit.cover,
                          ),
                        )
                            : const SizedBox.shrink(),
                        childWhenDragging: Container(),
                        child: GestureDetector(
                          onTap: () => onTapCelda(index),
                          child: Container(
                            foregroundDecoration: BoxDecoration(
                              border: Border.all(
                                color: hayPiezaEncima
                                    ? Colors.green
                                    : pieza != null &&
                                    pieza ==
                                        puzzleState.piezaSeleccionada
                                    ? Colors.orange
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: pieza != null
                                ? Image.memory(piezas[pieza],
                                fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                      );
                    },
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