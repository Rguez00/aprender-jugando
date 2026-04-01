import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_aprender_jugando/utils/api_keys.dart';

class ApiService {

  Future<String> obtenerImagenUrlPuzzle() async {
    String url =
        "https://pixabay.com/api/?key=${ApiKeys.pixabay}&q=animals&safesearch=true&image_type=photo&per_page=10&min_width=600&min_height=600&orientation=square";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final hits = data["hits"] as List;
      final random = Random();
      return hits[random.nextInt(hits.length)]["webformatURL"];
    } else {
      throw Exception("Error al cargar la imagen");
    }
  }

  Future<Uint8List> obtenerImagenBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw Exception("Error al cargar la imagen");
  }

  Uint8List hacerCuadrada(Uint8List imageBytes) {
    final imagen = img.decodeImage(imageBytes);
    if (imagen == null) throw Exception("No se pudo decodificar la imagen");

    final lado = imagen.width < imagen.height ? imagen.width : imagen.height;
    final x = (imagen.width - lado) ~/ 2;
    final y = (imagen.height - lado) ~/ 2;

    final cuadrada = img.copyCrop(imagen, x: x, y: y, width: lado, height: lado);
    return img.encodeJpg(cuadrada);
  }

  List<Uint8List> dividirImagen(Uint8List imageBytes, int gridSize) {
    final imagen = img.decodeImage(imageBytes);
    if (imagen == null) throw Exception("No se pudo decodificar la imagen");

    final anchoPieza = imagen.width ~/ gridSize;
    final altoPieza = imagen.height ~/ gridSize;
    List<Uint8List> piezas = [];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        final pieza = img.copyCrop(
          imagen,
          x: j * anchoPieza,
          y: i * altoPieza,
          width: anchoPieza,
          height: altoPieza,
        );
        piezas.add(img.encodeJpg(pieza));
      }
    }
    return piezas;
  }
}