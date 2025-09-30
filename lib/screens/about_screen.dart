import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'catalog_screen.dart';
import 'login_screen.dart';

class DarkAboutStyle {
  static const Color primaryColor = Color(0xFF9b59b6);
  static const Color secondaryColor = Color(0xFF6c3483);
  static const Color backgroundColor = Color(0xFF1E1E2C);
  static const Color textColor = Colors.white70;

  static AppBar customAppBar(VoidCallback onLogout, VoidCallback goCatalog) {
    return AppBar(
      title: const Text(
        "Sobre Nosotros",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: goCatalog,
          child: const Text(
            "Catálogo de Productos",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: onLogout,
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: "Cerrar sesión",
        ),
      ],
    );
  }
}

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final AuthService _authService = AuthService();
  String usuario = "A nuestra aplicación"; // por defecto

  @override
  void initState() {
    super.initState();
    _loadUsuario();
  }

  Future<void> _loadUsuario() async {
    // Aquí podrías parsear username desde token si quieres
    final token = await _authService.getToken();
    if (token != null && token.isNotEmpty) {
      setState(() {
        usuario = "A nuestra aplicación"; // O el username real si lo tienes en el token
      });
    }
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _goCatalog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CatalogScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkAboutStyle.backgroundColor,
      appBar: DarkAboutStyle.customAppBar(_logout, _goCatalog),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "¡Bienvenido, $usuario! ",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Somos una empresa dedicada a ofrecer los mejores productos "
                  "para nuestros clientes, garantizando calidad, confianza y un servicio "
                  "excelente. \n\nNuestra misión es facilitar la vida de las personas "
                  "con soluciones accesibles y modernas.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
