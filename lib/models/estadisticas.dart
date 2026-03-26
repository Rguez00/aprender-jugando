class Estadisticas {
  final String idPerfil;
  final String idJuego;
  final int puntuacion;
  final int aciertos;
  final int errores;
  final DateTime fecha;

  Estadisticas({
    required this.idPerfil,
    required this.idJuego,
    required this.puntuacion,
    required this.aciertos,
    required this.errores,
    required this.fecha,
  });

  Map<String, dynamic> toJson() {
    return {
      "idPerfil": idPerfil,
      "idJuego": idJuego,
      "puntuacion": puntuacion,
      "aciertos": aciertos,
      "errores": errores,
      "fecha": fecha.toIso8601String(),
    };
  }

  factory Estadisticas.fromJson(Map<String, dynamic> json) {
    return Estadisticas(
        idPerfil: json["idPerfil"],
        idJuego: json["idJuego"],
        puntuacion: json["puntuacion"],
        aciertos: json["aciertos"],
        errores: json["errores"],
        fecha: DateTime.parse(json["fecha"]),
    );
  }


}