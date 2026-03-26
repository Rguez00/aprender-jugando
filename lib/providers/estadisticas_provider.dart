import 'package:flutter/material.dart';

import '../models/estadisticas.dart';
import '../services/storage_service.dart';

class EstadisticasProvider extends ChangeNotifier{
  List<Estadisticas> _historial = [];
  List<Estadisticas> get historial => _historial;
  final StorageService stService = StorageService();

  Future<void> guardarEstadisticas(Estadisticas estadistica) async {
    _historial.add(estadistica);
    await stService.guardarEstadisticas(estadistica);
    notifyListeners();
  }

  Future<void> cargarHistorial(String idPerfil) async {
    _historial = await stService.cargarEstadisticas(idPerfil);
    notifyListeners();
  }



}