import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ApiService {
  // Gateways
  final String baseUrl = "https://api-gateway-nodejs-ryd-miih.onrender.com/ApiAutenticacion";
  final String adminUrl = "https://api-gateway-nodejs-ryd-miih.onrender.com/ApiAdministracion";

  // LOGIN → retorna token JWT
  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      String token = response.body.replaceAll('"', '');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      return token;
    } else if (response.statusCode == 401) {
      throw Exception('Usuario o contraseña incorrectos');
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  // REGISTRO → ahora requiere token
  Future<User> register(String name, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) throw Exception('Debes iniciar sesión primero para registrar');

    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar usuario: ${response.statusCode}');
    }
  }

  // LISTA DE USUARIOS → requiere token JWT
  Future<List<User>> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('No autorizado. Inicia sesión primero.');
    }

    final response = await http.get(
      Uri.parse('$adminUrl/users'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Error al obtener usuarios: ${response.statusCode}');
    }
  }
}
