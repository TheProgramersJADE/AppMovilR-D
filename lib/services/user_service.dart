import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UserService {
  final String _baseUrl =
      "https://api-gateway-nodejs-ryd-miih.onrender.com/ApiAutenticacion/";

  Future<bool> crearUsuario(Usuario usuario) async {
    final url = Uri.parse("$_baseUrl/api/users/");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error al registrar usuario: ${response.statusCode}");
      print(response.body);
      return false;
    }
  }
}
