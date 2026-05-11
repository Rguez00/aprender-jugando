class PalabraModel {
  final String palabra;
  final String imagen;

  const PalabraModel({
    required this.palabra,
    required this.imagen,
  });
}

const List<PalabraModel> kPoolPalabras = [
  PalabraModel(palabra: 'ARBOL',     imagen: 'assets/images/arbol.png'),
  PalabraModel(palabra: 'CERDO',     imagen: 'assets/images/cerdo.png'),
  PalabraModel(palabra: 'CESTA',     imagen: 'assets/images/cesta.png'),
  PalabraModel(palabra: 'COCHE',     imagen: 'assets/images/coche.png'),
  PalabraModel(palabra: 'FLOR',      imagen: 'assets/images/flor.png'),
  PalabraModel(palabra: 'FRESA',     imagen: 'assets/images/fresa.png'),
  PalabraModel(palabra: 'MUNDO',     imagen: 'assets/images/mundo.png'),
  PalabraModel(palabra: 'OSO',       imagen: 'assets/images/oso.png'),
  PalabraModel(palabra: 'PAJARO',    imagen: 'assets/images/pajaro.png'),
  PalabraModel(palabra: 'ZANAHORIA', imagen: 'assets/images/zanahoria.png'),
  PalabraModel(palabra: 'CALABAZA',  imagen: 'assets/images/calabaza.png'),
  PalabraModel(palabra: 'POYO',      imagen: 'assets/images/poyo.png'),
];