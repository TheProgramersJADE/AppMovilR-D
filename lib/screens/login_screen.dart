import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'catalog_screen.dart';
import 'register_screen.dart';
import '../models/user_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? errorMessage;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final userSession = UserSession(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    final token = await _authService.login(userSession);

    if (token != null && token.isNotEmpty) {
      await _authService.setToken(token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CatalogScreen()),
      );
    } else {
      setState(() {
        errorMessage = "Credenciales incorrectas";
      });
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: "Usuario"),
                  validator: (v) => v!.isEmpty ? "Ingresa usuario" : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Contraseña"),
                  validator: (v) => v!.isEmpty ? "Ingresa contraseña" : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _login, child: const Text("Entrar")),
                TextButton(
                  onPressed: _goToRegister,
                  child: const Text("Registrarse"),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
