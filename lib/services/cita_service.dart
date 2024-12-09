import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cita.dart';

class CitaService {
  final String baseUrl =
      'https://fe9b-200-60-18-106.ngrok-free.app/citas'; // Cambia al endpoint de tu API

  // Listar citas
  Future<List<Cita>> listarCitas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((citaJson) => Cita.fromJson(citaJson)).toList();
    } else {
      throw Exception('Error al listar citas');
    }
  }

  // Crear cita
  Future<Cita> crearCita(Cita cita) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cita.toJson()),
    );
    if (response.statusCode == 201) {
      return Cita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear cita');
    }
  }

  // Actualizar cita
  Future<Cita> actualizarCita(int id, Cita cita) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cita.toJson()),
    );
    if (response.statusCode == 200) {
      return Cita.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar cita');
    }
  }
}
