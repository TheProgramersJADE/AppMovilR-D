import 'package:flutter/material.dart';
import 'package:myapp/screens/about_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/catalog_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final auth = AuthService();
    bool loggedIn = await auth.isAuthenticated();
    if (loggedIn) {
      return const AboutScreen(); // <- si ya hay token, va a About
    } else {
      return const LoginScreen(); // <- si no, Login
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Mientras carga el token
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mi App',
          theme: ThemeData(primarySwatch: Colors.green),
          home: snapshot.data,
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/about': (context) => const AboutScreen(),
            '/catalog': (context) => const CatalogScreen(),
          },
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:myapp/screens/AboutScreen.dart';
// import 'screens/login_screen.dart';
// import 'screens/register_screen.dart';
// import 'screens/catalog_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Mi App',
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: const LoginScreen(),
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/register': (context) => const RegisterScreen(),
//         '/about': (context) => const AboutScreen(),
//         '/catalog': (context) => const CatalogScreen(),

//       },
//     );
//   }
// }
