import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

/*
Este archivo contiene la clase ProductoService que maneja todas 
las interacciones con la API REST para realizar operaciones CRUD sobre los productos.
*/
class ProductoService {
  /*
  Clase ProductoService:
  Propiedad baseUrl:
  URL base de la API para las operaciones de productos.
  */
  final String baseUrl =
      'https://fe9b-200-60-18-106.ngrok-free.app/api/productos';

  // Obtener lista de todos los productos
  Future<List<Producto>> listarProductos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((producto) => Producto.fromJson(producto))
          .toList();
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  // Obtener lista de productos activos
  Future<List<Producto>> listarProductosActivos() async {
    final response = await http.get(Uri.parse('$baseUrl/activos'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((producto) => Producto.fromJson(producto))
          .toList();
    } else {
      throw Exception('Error al cargar los productos activos');
    }
  }

  // Obtener lista de productos inactivos
  Future<List<Producto>> listarProductosInactivos() async {
    final response = await http.get(Uri.parse('$baseUrl/inactivos'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((producto) => Producto.fromJson(producto))
          .toList();
    } else {
      throw Exception('Error al cargar los productos inactivos');
    }
  }

  // Obtener un producto por ID
  Future<Producto> obtenerProducto(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Producto no encontrado');
    }
  }

  // Crear un nuevo producto
  Future<Producto> guardarProducto(Producto producto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(producto.toJson()),
    );
    if (response.statusCode == 201) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear producto');
    }
  }

  // Actualizar un producto
  Future<Producto> actualizarProducto(int id, Producto producto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(producto.toJson()),
    );
    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar producto');
    }
  }

  // Eliminar un producto
  Future<void> eliminarProducto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar producto');
    }
  }

  // Restaurar un producto
  Future<Producto> recuperarProducto(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/recuperar/$id'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al restaurar producto');
    }
  }

  restaurarProducto(int id) {}

  // Método restaurarProducto vacío, el cual puede ser eliminado si no se utiliza
  //void restaurarProducto(int id) {}  // Lo he comentado porque está vacío y no es necesario en la implementación actual
}
