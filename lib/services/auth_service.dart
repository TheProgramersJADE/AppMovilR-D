import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_session.dart';
import 'storage_service.dart'; // 👈 Importa StorageService

class AuthService {
  final String _baseUrl = "https://api-gateway-nodejs-ryd-miih.onrender.com/ApiAutenticacion/";
  final StorageService _storage = StorageService(); // 👈 Usamos StorageService
  String? _token;

  Future<String?> login(UserSession user) async {
    final url = Uri.parse("$_baseUrl/api/users/login");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': user.username,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body) as String;
      _token = token;
      await setToken(token); // 👈 guardamos token
      return token;
    }
    return null;
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _storage.write('token', token);
  }

  Future<String?> getToken() async {
    if (_token != null) return _token;
    _token = await _storage.read('token');
    return _token;
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete('token');
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}




// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user_session.dart';

// class AuthService {
//   final String _baseUrl = "https://api-gateway-nodejs-ryd-miih.onrender.com/ApiAutenticacion/";
//   String? _token;

//   // Login
//   Future<String?> login(UserSession user) async {
//     final url = Uri.parse("$_baseUrl/api/users/login");
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(user.toJson()),
//     );

//     if (response.statusCode == 200) {
//       final token = jsonDecode(response.body) as String;
//       _token = token;
//       await setToken(token); // guardar token en shared_preferences
//       return token;
//     } else {
//       print("Error en login: ${response.statusCode} - ${response.body}");
//     }
//     return null;
//   }

//   // Guardar token
//   Future<void> setToken(String token) async {
//     _token = token;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', token);
//   }

//   // Obtener token
//   Future<String?> getToken() async {
//     if (_token != null) return _token;
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     return _token;
//   }

//   // Logout
//   Future<void> logout() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//   }

//   // Verificar si autenticado
//   Future<bool> isAuthenticated() async {
//     final token = await getToken();
//     return token != null && token.isNotEmpty;
//   }
// }