import 'package:flutter/material.dart';
import '../services/catalog_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final CatalogService _catalogService = CatalogService();
  final AuthService _authService = AuthService();
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  void _loadCatalog() async {
    setState(() {
      isLoading = true;
    });

    final data = await _catalogService.getProducts();

    setState(() {
      products = data;
      isLoading = false;
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text("No hay productos disponibles"))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return ProductCard(product: p);
                  },
                ),
    );
  }
}

/// ===============================
/// Widget ProductCard
/// ===============================
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final String nombre = product['nombre'] ?? 'Sin nombre';
    final double precio = (product['precio_venta'] ?? 0).toDouble();
    final int stock = (product['stock_actual'] ?? 0).toInt();
    final String? imagenUrl = product['imagen_url'];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: imagenUrl != null && imagenUrl.isNotEmpty
            ? Image.network(
                "https://api-gateway-nodejs-ryd-miih.onrender.com$imagenUrl",
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
        title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Precio: \$${precio.toStringAsFixed(2)}\nStock: $stock"),
      ),
    );
  }
}
