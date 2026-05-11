import 'dart:math';

enum EstadoCarta { oculta, volteada, emparejada }

class ParejasState {
  List<String> imagenCelda;
  List<EstadoCarta> estado;
  int? cartaSeleccionada;
  int? cartaComprobar;
  bool finalizado;
  int intentos;

  ParejasState({
    required this.imagenCelda,
    required this.estado,
    this.cartaSeleccionada,
    this.cartaComprobar,
    this.finalizado = false,
    this.intentos = 0,
  });

  factory ParejasState.inicial(List<String> todasLasImagenes) {
    // Seleccionar 8 imágenes aleatorias del pool y duplicarlas
    final shuffled = List<String>.from(todasLasImagenes)..shuffle(Random());
    final seleccionadas = shuffled.take(6).toList();
    final parejas = [...seleccionadas, ...seleccionadas]..shuffle(Random());

    return ParejasState(
      imagenCelda: parejas,
      estado: List.filled(12, EstadoCarta.oculta),
    );
  }

  void seleccionarCasilla(int posicion) {
    if (estado[posicion] == EstadoCarta.emparejada ||
        estado[posicion] == EstadoCarta.volteada) return;

    if (cartaSeleccionada == null) {
      cartaSeleccionada = posicion;
      estado[posicion] = EstadoCarta.volteada;
    } else {
      cartaComprobar = posicion;
      estado[posicion] = EstadoCarta.volteada;
      intentos++;
    }
  }

  void comprobarCartas() {
    if (cartaSeleccionada == null || cartaComprobar == null) return;

    if (imagenCelda[cartaSeleccionada!] == imagenCelda[cartaComprobar!]) {
      estado[cartaSeleccionada!] = EstadoCarta.emparejada;
      estado[cartaComprobar!] = EstadoCarta.emparejada;
      _comprobarFinalizado();
    } else {
      estado[cartaSeleccionada!] = EstadoCarta.oculta;
      estado[cartaComprobar!] = EstadoCarta.oculta;
    }

    cartaSeleccionada = null;
    cartaComprobar = null;
  }

  void _comprobarFinalizado() {
    finalizado = estado.every((e) => e == EstadoCarta.emparejada);
  }
}