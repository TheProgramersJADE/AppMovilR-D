import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class CatalogService {
  final String _baseUrl = "https://api-gateway-nodejs-ryd-miih.onrender.com/ApiAdministracion/";
  final AuthService _authService = AuthService();

  Future<List<dynamic>> getProducts() async {
    final url = Uri.parse("$_baseUrl/api/catalogo");
    final token = await _authService.getToken();

    final response = await http.get(
      url,
      headers: token != null
          ? {'Authorization': 'Bearer $token'}
          : {},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      print("Error al obtener catálogo: ${response.statusCode}");
      print(response.body);
      return [];
    }
  }
}
