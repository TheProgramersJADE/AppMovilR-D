import 'package:flutter/material.dart';
import 'package:myapp/screens/about_screen.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import '../models/user_session.dart';

class DarkLoginStyle {
  static final Color primaryColor = const Color(0xFF9b59b6); // morado oscuro
  static final Color secondaryColor = const Color(
    0xFF6c3483,
  ); // morado secundario
  static final Color bubbleColor = const Color(0xFF2A2A3D); // contenedor
  static final Color inputBackground = const Color(0xFF3A3A4D);
  static final Color inputText = Colors.white;
  static final Color errorColor = const Color(0xFFe74c3c); // rojo alerta
  static final Color buttonText = Colors.white;

  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  static ButtonStyle gradientButton(Color color1, Color color2) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      elevation: 6,
      shadowColor: Colors.black54,
      backgroundColor: color1,
      foregroundColor: buttonText,
    ).copyWith(
      overlayColor: WidgetStateProperty.all(
        color2.withOpacity(0.7),
      ), // hover effect
    );
  }
}

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
        MaterialPageRoute(builder: (_) => const AboutScreen()),
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
      body: Container(
        // Fondo degradado
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E2C), Color(0xFF2C003E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: DarkLoginStyle.bubbleColor.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "R&D Bodega Pro",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: DarkLoginStyle.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: DarkLoginStyle.inputDecoration("Usuario"),
                      style: TextStyle(color: DarkLoginStyle.inputText),
                      validator: (v) => v!.isEmpty ? "Ingresa usuario" : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: DarkLoginStyle.inputDecoration("Contraseña"),
                      style: TextStyle(color: DarkLoginStyle.inputText),
                      validator: (v) =>
                          v!.isEmpty ? "Ingresa contraseña" : null,
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _login,
                      style: DarkLoginStyle.gradientButton(
                        DarkLoginStyle.primaryColor,
                        DarkLoginStyle.secondaryColor,
                      ),
                      child: const Center(child: Text("Entrar")),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _goToRegister,
                      style: DarkLoginStyle.gradientButton(
                        DarkLoginStyle.secondaryColor,
                        DarkLoginStyle.primaryColor,
                      ),
                      child: const Center(child: Text("Registrarse")),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: DarkLoginStyle.errorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}