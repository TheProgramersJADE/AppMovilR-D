import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/user_service.dart';

class DarkRegisterStyle {
  static final Color primaryColor = const Color(0xFF9b59b6); // morado oscuro
  static final Color secondaryColor = const Color(0xFF6c3483); // morado secundario
  static final Color bubbleColor = const Color(0xFF2A2A3D); // contenedor
  static final Color inputBackground = const Color(0xFF3A3A4D);
  static final Color inputText = Colors.white;
  static final Color errorColor = const Color(0xFFe74c3c);
  static final Color buttonText = Colors.white;

  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
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
      overlayColor: WidgetStateProperty.all(color2.withOpacity(0.7)),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _correoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();

  int _selectedRole = 3; // Cliente por defecto
  String? errorMessage;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final usuario = Usuario(
      correoElectronico: _correoController.text,
      direccion: _direccionController.text,
      nombreCompleto: _nombreController.text,
      password: _passwordController.text,
      telefono: _telefonoController.text,
      username: _usernameController.text,
      idRol: _selectedRole,
      status: 1,
    );

    final success = await _userService.crearUsuario(usuario);

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: DarkRegisterStyle.bubbleColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("¡Registro exitoso!",
              style: TextStyle(color: DarkRegisterStyle.primaryColor, fontWeight: FontWeight.bold)),
          content: const Text(
            "Usuario registrado correctamente.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text("OK", style: TextStyle(color: DarkRegisterStyle.primaryColor)),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        errorMessage = "Error al registrar usuario";
      });
    }
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
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: DarkRegisterStyle.bubbleColor.withOpacity(0.95),
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
                      "Registro de Usuario",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: DarkRegisterStyle.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nombreController,
                      decoration: DarkRegisterStyle.inputDecoration("Nombre completo"),
                      style: TextStyle(color: DarkRegisterStyle.inputText),
                      validator: (v) => v!.isEmpty ? "Ingresa el nombre" : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _correoController,
                      decoration: DarkRegisterStyle.inputDecoration("Correo electrónico"),
                      style: TextStyle(color: DarkRegisterStyle.inputText),
                      validator: (v) => v!.isEmpty ? "Ingresa el correo" : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _telefonoController,
                      decoration: DarkRegisterStyle.inputDecoration("Teléfono"),
                      style: TextStyle(color: DarkRegisterStyle.inputText),
                      validator: (v) => v!.isEmpty ? "Ingresa el teléfono" : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _direccionController,
                      decoration: DarkRegisterStyle.inputDecoration("Dirección"),
                      style: TextStyle(color: DarkRegisterStyle.inputText),
                      validator: (v) => v!.isEmpty ? "Ingresa la dirección" : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _usernameController,
                      decoration: DarkRegisterStyle.inputDecoration("Usuario"),
                      style: TextStyle(color: DarkRegisterStyle.inputText),
                      validator: (v) => v!.isEmpty ? "Ingresa el usuario" : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: DarkRegisterStyle.inputDecoration("Contraseña"),
                      style: TextStyle(color: DarkRegisterStyle.inputText),
                      validator: (v) => v!.isEmpty ? "Ingresa la contraseña" : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      value: _selectedRole,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text("Administrador")),
                        DropdownMenuItem(value: 3, child: Text("Cliente")),
                      ],
                      decoration: DarkRegisterStyle.inputDecoration("Rol"),
                      dropdownColor: DarkRegisterStyle.bubbleColor,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedRole = value);
                      },
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _register,
                      style: DarkRegisterStyle.gradientButton(
                        DarkRegisterStyle.primaryColor,
                        DarkRegisterStyle.secondaryColor,
                      ),
                      child: const Center(child: Text("Registrar")),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: DarkRegisterStyle.errorColor,
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











// import 'package:flutter/material.dart';
// import '../models/usuario.dart';
// import '../services/user_service.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _userService = UserService();

//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _correoController = TextEditingController();
//   final _nombreController = TextEditingController();
//   final _telefonoController = TextEditingController();
//   final _direccionController = TextEditingController();

//   int _selectedRole = 3; // Cliente por defecto
//   String? errorMessage;

//   void _register() async {
//     if (!_formKey.currentState!.validate()) return;

//     final usuario = Usuario(
//       correoElectronico: _correoController.text,
//       direccion: _direccionController.text,
//       nombreCompleto: _nombreController.text,
//       password: _passwordController.text,
//       telefono: _telefonoController.text,
//       username: _usernameController.text,
//       idRol: _selectedRole,
//       status: 1,
//     );

//     final success = await _userService.crearUsuario(usuario);

//     if (success) {
//       // Mostrar alerta de registro exitoso
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("¡Registro exitoso!"),
//           content: const Text("Usuario registrado correctamente."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Cierra la alerta
//                 Navigator.pushReplacementNamed(
//                   context,
//                   '/login',
//                 ); // Va al login
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//     } else {
//       setState(() {
//         errorMessage = "Error al registrar usuario";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Registro")),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _nombreController,
//                     decoration: const InputDecoration(
//                       labelText: "Nombre completo",
//                     ),
//                     validator: (v) => v!.isEmpty ? "Ingresa el nombre" : null,
//                   ),
//                   TextFormField(
//                     controller: _correoController,
//                     decoration: const InputDecoration(
//                       labelText: "Correo electrónico",
//                     ),
//                     validator: (v) => v!.isEmpty ? "Ingresa el correo" : null,
//                   ),
//                   TextFormField(
//                     controller: _telefonoController,
//                     decoration: const InputDecoration(labelText: "Teléfono"),
//                     validator: (v) => v!.isEmpty ? "Ingresa el teléfono" : null,
//                   ),
//                   TextFormField(
//                     controller: _direccionController,
//                     decoration: const InputDecoration(labelText: "Dirección"),
//                     validator: (v) =>
//                         v!.isEmpty ? "Ingresa la dirección" : null,
//                   ),
//                   TextFormField(
//                     controller: _usernameController,
//                     decoration: const InputDecoration(labelText: "Usuario"),
//                     validator: (v) => v!.isEmpty ? "Ingresa el usuario" : null,
//                   ),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(labelText: "Contraseña"),
//                     validator: (v) =>
//                         v!.isEmpty ? "Ingresa la contraseña" : null,
//                   ),
//                   const SizedBox(height: 20),
//                   DropdownButtonFormField<int>(
//                     value: _selectedRole,
//                     items: const [
//                       DropdownMenuItem(value: 1, child: Text("Administrador")),
//                       DropdownMenuItem(value: 3, child: Text("Cliente")),
//                     ],
//                     decoration: const InputDecoration(labelText: "Rol"),
//                     onChanged: (value) {
//                       if (value != null) setState(() => _selectedRole = value);
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _register,
//                     child: const Text("Registrar"),
//                   ),
//                   if (errorMessage != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10),
//                       child: Text(
//                         errorMessage!,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
