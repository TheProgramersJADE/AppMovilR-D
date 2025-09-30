import 'package:flutter/material.dart';
import 'package:myapp/screens/login_screen.dart';
import '../services/catalog_service.dart';
import '../services/auth_service.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final CatalogService _catalogService = CatalogService();
  final AuthService _authService = AuthService();
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  void _loadCatalog() async {
    final data = await _catalogService.getProducts();
    setState(() {
      products = data;
    });
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catálogo"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final producto = products[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: producto['imagen_url'] != null
                        ? Image.network(
                            "https://api-gateway-node-ryd-mii.onrender.com${producto['imagen_url']}",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                alignment: Alignment.center,
                                child: const Text(
                                  "Imagen no encontrada",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const Text(
                              "Imagen de producto no ingresada",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                    title: Text(producto['nombre'] ?? 'Sin nombre'),
                    subtitle: Text(
                      "Precio: ${producto['precio_venta'] ?? '0'}\nStock: ${producto['stock_actual'] ?? '0'}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}












// import 'package:flutter/material.dart';

// class ProductCard extends StatelessWidget {
//   final Map<String, dynamic> product;

//   const ProductCard({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     final String nombre = product['nombre'] ?? 'Sin nombre';
//     final double precio = (product['precio_venta'] ?? 0).toDouble();
//     final int stock = (product['stock_actual'] ?? 0).toInt();
//     final String? imagenUrl = product['imagen_url'];

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       child: ListTile(
//         leading: imagenUrl != null
//             ? Image.network(
//                 "https://api-gateway-nodejs-ryd-miih.onrender.com$imagenUrl",
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//               )
//             : Container(
//                 width: 50,
//                 height: 50,
//                 color: Colors.grey[300],
//                 alignment: Alignment.center,
//                 child: const Text(
//                   "Imagen de producto no ingresada",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 10),
//                 ),
//               ),
//         title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Precio: \$${precio.toStringAsFixed(2)}"),
//             Text("Stock: $stock"),
//           ],
//         ),
//       ),
//     );
//   }
// }







// import 'package:flutter/material.dart';

// class ProductCard extends StatelessWidget {
//   final Map<String, dynamic> product;

//   const ProductCard({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     final String nombre = product['nombre'] ?? 'Sin nombre';
//     final double precio = (product['precio_venta'] ?? 0).toDouble();
//     final int stock = (product['stock_actual'] ?? 0).toInt();
//     final String? imagenUrl = product['imagen_url'];

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       child: ListTile(
//         leading: imagenUrl != null
//             ? Image.network(
//                 "https://api-gateway-nodejs-ryd-miih.onrender.com$imagenUrl",
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//               )
//             : Container(
//                 width: 50,
//                 height: 50,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.image_not_supported),
//               ),
//         title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Precio: \$${precio.toStringAsFixed(2)}"),
//             Text("Stock: $stock"),
//           ],
//         ),
//       ),
//     );
//   }
// }