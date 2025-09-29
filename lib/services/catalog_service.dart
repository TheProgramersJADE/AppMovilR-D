import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CatalogService {
  final _storage = const FlutterSecureStorage();

  final String baseUrl =
      'https://api-gateway-nodejs-ryd-miih.onrender.com/ApiAdministracion/api/catalogo';

  Future<List<dynamic>> getCatalogo() async {
    // Recuperamos token
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // enviamos token
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error al cargar catálogo: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getCatalogoDetalle(int id) async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar detalle del producto');
    }
  }
}
