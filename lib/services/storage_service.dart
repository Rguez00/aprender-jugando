import 'package:proyecto_aprender_jugando/providers/estadisticas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/estadisticas.dart';
import '../models/perfil.dart';
import 'dart:convert';

class StorageService {

  Future<List<Perfil>> cargarPerfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString("perfiles");
    if (data == null) return [];
    final List<dynamic> lista = jsonDecode(data);
    return lista.map((item) => Perfil.fromJson(item)).toList();
  }

  Future<void> guardarPerfiles(List<Perfil> perfiles) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = perfiles.map((perfil) => perfil.toJson()).toList();
    final String data = jsonEncode(lista);
    await prefs.setString("perfiles", data);
  }

  Future<void> actualizarPerfiles(Perfil perfilActualizado) async {
    final lista = await cargarPerfiles();
    final index = lista.indexWhere((perfil) => perfil.id == perfilActualizado.id);
    if (index != -1) lista[index] = perfilActualizado;
    await guardarPerfiles(lista);
  }

  Future<void> eliminarPerfiles(String id) async {
    final lista = await cargarPerfiles();
    lista.removeWhere((perfil) => perfil.id == id);
    await guardarPerfiles(lista);
  }

  Future<void> guardarEstadisticas(Estadisticas estadistica) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(estadistica.idPerfil);
    List<dynamic> lista = data != null ? jsonDecode(data) : [];
    lista.add(estadistica.toJson());
    await prefs.setString(estadistica.idPerfil, jsonEncode(lista));
  }

  Future<List<Estadisticas>> cargarEstadisticas(String idPerfil) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(idPerfil);
    if (data == null) return [];
    final List<dynamic> lista = jsonDecode(data);
    return lista.map((item) => Estadisticas.fromJson(item)).toList();
  }
}
