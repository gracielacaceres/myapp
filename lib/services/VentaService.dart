import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/venta.dart';

class VentaService {
  final String baseUrl = 'https://fe9b-200-60-18-106.ngrok-free.app/ventas';

  // Obtener todas las ventas
  Future<List<Venta>> listarVentas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((venta) => Venta.fromJson(venta)).toList();
    } else {
      throw Exception('Error al cargar las ventas');
    }
  }

  // Obtener ventas activas
  Future<List<Venta>> listarVentasActivas() async {
    final response = await http.get(Uri.parse('$baseUrl/activos'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((venta) => Venta.fromJson(venta)).toList();
    } else {
      throw Exception('Error al cargar las ventas activas');
    }
  }

  // Obtener ventas inactivas
  Future<List<Venta>> listarVentasInactivas() async {
    final response = await http.get(Uri.parse('$baseUrl/inactivos'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((venta) => Venta.fromJson(venta)).toList();
    } else {
      throw Exception('Error al cargar las ventas inactivas');
    }
  }

  // Obtener una venta específica por ID
  Future<Venta> obtenerVenta(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Venta.fromJson(json.decode(response.body));
    } else {
      throw Exception('Venta no encontrada');
    }
  }

  // Crear una nueva venta
  Future<Venta> guardarVenta(Venta venta) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(venta.toJson()),
    );
    if (response.statusCode == 201) {
      return Venta.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear venta');
    }
  }

  // Actualizar una venta
  Future<Venta> actualizarVenta(int id, Venta venta) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(venta.toJson()),
    );
    if (response.statusCode == 200) {
      return Venta.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar venta');
    }
  }

  // Eliminar una venta
  Future<void> eliminarVenta(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar venta');
    }
  }

  // Restaurar una venta
  Future<Venta> restaurarVenta(int id) async {
    final response = await http.put(Uri.parse('$baseUrl/recuperar/$id'));
    if (response.statusCode == 200) {
      return Venta.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al restaurar venta');
    }
  }
}
