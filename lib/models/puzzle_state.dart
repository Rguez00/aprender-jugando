class PuzzleState {
  List<int?> piezaCelda;
  List<int> listaPiezas;
  int? piezaSeleccionada;
  bool finalizado;
  bool piezaVieneDePrincipal;
  int? indicePiezaPrincipal;

  PuzzleState({
    required this.piezaCelda,
    required this.listaPiezas,
    required this.piezaSeleccionada,
    this.finalizado = false,
    this.piezaVieneDePrincipal = false,
    this.indicePiezaPrincipal,
  });

  PuzzleState.inicial(int gridSize)
      : piezaCelda = List.filled(gridSize * gridSize, null),
        listaPiezas = List.generate(gridSize * gridSize, (i) => i)..shuffle(),
        piezaSeleccionada = null,
        finalizado = false,
        piezaVieneDePrincipal = false,
        indicePiezaPrincipal = null;

  void seleccionarPiezaSecundario(int index) {
    piezaSeleccionada = listaPiezas[index];
    piezaVieneDePrincipal = false;
    indicePiezaPrincipal = null;
  }

  void colocarPieza(int index) {
    if (piezaVieneDePrincipal && indicePiezaPrincipal != null) {
      piezaCelda[indicePiezaPrincipal!] = null;
    }
    if (piezaCelda[index] == null) {
      piezaCelda[index] = piezaSeleccionada;
    } else {
      listaPiezas.add(piezaCelda[index]!);
      piezaCelda[index] = piezaSeleccionada;
    }
    if (!piezaVieneDePrincipal) {
      listaPiezas.remove(piezaSeleccionada);
    }
    piezaSeleccionada = null;
    piezaVieneDePrincipal = false;
    indicePiezaPrincipal = null;
    puzzleCompleto();
  }

  void moverPiezaPrincipal(int index) {
    if (piezaCelda[index] != null) {
      piezaSeleccionada = piezaCelda[index];
      piezaVieneDePrincipal = true;
      indicePiezaPrincipal = index;
    }
  }

  void devolverPieza() {
    piezaSeleccionada = null;
    piezaVieneDePrincipal = false;
    indicePiezaPrincipal = null;
  }

  void puzzleCompleto() {
    for (int i = 0; i < piezaCelda.length; i++) {
      if (piezaCelda[i] != i) {
        finalizado = false;
        return;
      }
    }
    finalizado = true;
  }
}