import 'dart:math';
import 'dart:ui';

const Map<int, String> kImagenPorNumero = {
  1: 'assets/images/arbol.png',
  2: 'assets/images/calabaza.png',
  3: 'assets/images/cerdo.png',
  4: 'assets/images/cesta.png',
  5: 'assets/images/coche.png',
  6: 'assets/images/flor.png',
  7: 'assets/images/fresa.png',
  8: 'assets/images/mundo.png',
  9: 'assets/images/oso.png',
  10: 'assets/images/pajaro.png',
};

// Colores para distinguir el grupo 1 y grupo 2 de cada operación
const List<Color> kColoresGrupo = [
  Color(0xFF4CAF50), // verde
  Color(0xFFFF9800), // naranja
  Color(0xFF2196F3), // azul
  Color(0xFFE91E63), // rosa
];

class Operacion {
  final int numero1;
  final int numero2;
  final bool esSuma;
  int? respuestaColocada;

  Operacion({
    required this.numero1,
    required this.numero2,
    required this.esSuma,
    this.respuestaColocada,
  });

  int get resultado => esSuma ? numero1 + numero2 : numero1 - numero2;
  String get simbolo => esSuma ? '+' : '-';
  bool get resuelta => respuestaColocada != null;
  bool get correcta => respuestaColocada == resultado;

  String get imagenNumero1 => kImagenPorNumero[numero1]!;
  String get imagenNumero2 => kImagenPorNumero[numero2]!;
}

class MatesState {
  final List<List<Operacion>> rondas; // cada ronda tiene 2 operaciones
  int indiceRonda;
  List<int> resultadosMezclados; // los 4 resultados de la ronda barajados
  int? numeroSeleccionado; // para la mecánica de pulsar primero

  MatesState({
    required this.rondas,
    this.indiceRonda = 0,
    required this.resultadosMezclados,
    this.numeroSeleccionado,
  });

  factory MatesState.inicial({int totalRondas = 5}) {
    final rng = Random();
    final rondas = <List<Operacion>>[];

    for (int r = 0; r < totalRondas; r++) {
      final operaciones = <Operacion>[];
      final usados = <int>{}; // evitar resultados duplicados en la misma ronda

      while (operaciones.length < 2) {
        final esSuma = rng.nextBool();
        int n1, n2, resultado;

        if (esSuma) {
          n1 = rng.nextInt(9) + 1; // 1-9
          n2 = rng.nextInt(10 - n1) + 1; // n2 tal que n1+n2 <= 10
          resultado = n1 + n2;
        } else {
          n1 = rng.nextInt(8) + 3; // 3-10
          n2 = rng.nextInt(n1 - 1) + 1; // 1 a n1-1
          resultado = n1 - n2;
        }

        if (!usados.contains(resultado) && resultado >= 1 && resultado <= 10) {
          usados.add(resultado);
          operaciones.add(Operacion(numero1: n1, numero2: n2, esSuma: esSuma));
        }
      }
      rondas.add(operaciones);
    }

    return MatesState(
      rondas: rondas,
      resultadosMezclados: _generarMezclados(rondas[0], Random()),
    );
  }

  static List<int> _generarMezclados(List<Operacion> operaciones, Random rng) {
    final correctos = operaciones.map((o) => o.resultado).toList();
    final Set<int> distSet = {};
    while (distSet.length < 2) {
      int d = correctos[0] + rng.nextInt(5) - 2;
      if (!correctos.contains(d) && d >= 1 && d <= 10) distSet.add(d);
    }
    return [...correctos, ...distSet]..shuffle(rng);
  }

  List<Operacion> get rondaActual => rondas[indiceRonda];

  bool get rondaCompleta => rondaActual.every((o) => o.resuelta);

  bool get finalizado => indiceRonda >= rondas.length;

  void siguienteRonda() {
    indiceRonda++;
    if (!finalizado) {
      resultadosMezclados = _generarMezclados(rondas[indiceRonda], Random());
    }
    numeroSeleccionado = null;
    // Limpiar respuestas de la ronda anterior por si se reinicia
    for (final op in rondas[indiceRonda <= 0 ? 0 : indiceRonda - 1]) {
      op.respuestaColocada = null;
    }
  }

  bool numeroYaUsado(int numero) {
    return rondaActual.any((o) => o.respuestaColocada == numero);
  }

  void colocarEnOperacion(int indiceOp, int numero) {
    rondaActual[indiceOp].respuestaColocada = numero;
    numeroSeleccionado = null;
  }
}