import 'package:flutter/cupertino.dart';
import 'package:proyecto_aprender_jugando/services/storage_service.dart';

import '../models/perfil.dart';

class PerfilProvider extends ChangeNotifier {
  List<Perfil> _perfiles = [];
  Perfil? _perfilActivo;
  final StorageService stService = StorageService();

  List<Perfil> get perfiles => _perfiles;

  Perfil? get perfilActivo => _perfilActivo;

  PerfilProvider() {
    cargarPerfiles();
  }

  Future<void> cargarPerfiles() async {
    _perfiles = await stService.cargarPerfiles();
    notifyListeners();
  }

  void seleccionarPerfil(Perfil perfil) {
    _perfilActivo = perfil;
    notifyListeners();
  }

  void agregarPerfil(Perfil perfil) {
    if (_perfiles.length < 3) {
      _perfiles.add(perfil);
      stService.guardarPerfiles(_perfiles);
      notifyListeners();
    } else {
      throw Exception("Máximo 3 perfiles");
    }
  }

  Future<void> eliminarPerfil(Perfil perfil) async {
    await stService.eliminarPerfiles(perfil.id);
    _perfiles.removeWhere((p) => p.id == perfil.id);
    notifyListeners();
  }

  Future<void> actualizarPuntos(int puntos) async {
    if (_perfilActivo != null) {
      _perfilActivo!.puntuacionTotal += puntos;
      await stService.actualizarPerfiles(_perfilActivo!);
      notifyListeners();
    }
  }
}