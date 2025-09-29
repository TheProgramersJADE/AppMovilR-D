import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/user_service.dart';

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
      // Mostrar alerta de registro exitoso
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("¡Registro exitoso!"),
          content: const Text("Usuario registrado correctamente."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra la alerta
                Navigator.pushReplacementNamed(context, '/login'); // Va al login
              },
              child: const Text("OK"),
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
      appBar: AppBar(title: const Text("Registro")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: "Nombre completo"),
                    validator: (v) => v!.isEmpty ? "Ingresa el nombre" : null,
                  ),
                  TextFormField(
                    controller: _correoController,
                    decoration: const InputDecoration(labelText: "Correo electrónico"),
                    validator: (v) => v!.isEmpty ? "Ingresa el correo" : null,
                  ),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(labelText: "Teléfono"),
                    validator: (v) => v!.isEmpty ? "Ingresa el teléfono" : null,
                  ),
                  TextFormField(
                    controller: _direccionController,
                    decoration: const InputDecoration(labelText: "Dirección"),
                    validator: (v) => v!.isEmpty ? "Ingresa la dirección" : null,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: "Usuario"),
                    validator: (v) => v!.isEmpty ? "Ingresa el usuario" : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Contraseña"),
                    validator: (v) => v!.isEmpty ? "Ingresa la contraseña" : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    value: _selectedRole,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Administrador")),
                      DropdownMenuItem(value: 3, child: Text("Cliente")),
                    ],
                    decoration: const InputDecoration(labelText: "Rol"),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedRole = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text("Registrar"),
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
      ),
    );
  }
}







//import 'package:flutter/material.dart';
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

//   String? errorMessage;
//   String? successMessage;


// void _register() async {
//   if (!_formKey.currentState!.validate()) return;

//   final usuario = Usuario(
//     correoElectronico: _correoController.text,
//     direccion: _direccionController.text,
//     nombreCompleto: _nombreController.text,
//     password: _passwordController.text,
//     telefono: _telefonoController.text,
//     username: _usernameController.text,
//     idRol: 1,
//     status: 1,
//   );

//   final success = await _userService.crearUsuario(usuario);

//   if (success) {
//     // Si se registró bien, redirige al login automáticamente
//     Navigator.pushReplacementNamed(context, '/login');
//   } else {
//     setState(() {
//       errorMessage = "Error al registrar usuario";
//       successMessage = null;
//     });
//   }
// }



// //   void _register() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     final usuario = Usuario(
// //       correoElectronico: _correoController.text,
// //       direccion: _direccionController.text,
// //       nombreCompleto: _nombreController.text,
// //       password: _passwordController.text,
// //       telefono: _telefonoController.text,
// //       username: _usernameController.text,
// //       idRol: 1,
// //       status: 1,
// //     );

// // final success = await _userService.crearUsuario(usuario);

// //     setState(() {
// //       if (success) {
// //         successMessage = "Usuario registrado con éxito";
// //         errorMessage = null;
// //       } else {
// //         errorMessage = "Error al registrar usuario";
// //         successMessage = null;
// //       }
// //     });
// //   }

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
//                   if (successMessage != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10),
//                       child: Text(
//                         successMessage!,
//                         style: const TextStyle(color: Colors.green),
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
