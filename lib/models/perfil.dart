class Perfil {
  final String id;
  final String nombre;
  final String avatar;
  int puntuacionTotal;

  Perfil({
    required this.id,
    required this.nombre,
    required this.avatar,
    this.puntuacionTotal = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "avatar": avatar,
      "puntuacionTotal": puntuacionTotal,
    };
  }

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
        id: json["id"],
        nombre: json["nombre"],
        avatar: json["avatar"],
        puntuacionTotal: json["puntuacionTotal"],
    );
  }
}
