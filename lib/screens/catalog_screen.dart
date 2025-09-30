import 'package:flutter/material.dart';
import '../services/catalog_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class DarkCatalogStyle {
  static const Color primaryColor = Color(0xFF9b59b6); // morado
  static const Color secondaryColor = Color(0xFF6c3483);
  static const Color backgroundColor = Color(0xFF1E1E2C);
  static const Color cardColor = Color(0xFF2A2A3D);
  static const Color textColor = Colors.white70;

  static AppBar customAppBar(VoidCallback onLogout) {
    return AppBar(
      title: const Text(
        "Catálogo Productos",
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
        IconButton(
          onPressed: onLogout,
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: "Cerrar sesión",
        ),
      ],
    );
  }
}

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
    setState(() => isLoading = true);
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
      backgroundColor: DarkCatalogStyle.backgroundColor,
      appBar: DarkCatalogStyle.customAppBar(_logout),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: DarkCatalogStyle.primaryColor,
              ),
            )
          : products.isEmpty
          ? const Center(
              child: Text(
                "No hay productos disponibles",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 👈 4 por fila
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75, // ajusta proporción de la tarjeta
              ),
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
      color: DarkCatalogStyle.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imagenUrl != null && imagenUrl.isNotEmpty
                    ? Image.network(
                        "https://api-gateway-nodejs-ryd-miih.onrender.com$imagenUrl",
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            alignment: Alignment.center,
                            child: const Text(
                              "Imagen no encontrada",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[800],
                        alignment: Alignment.center,
                        child: const Text(
                          "Imagen no ingresada",
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              nombre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              "Precio: \$${precio.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              "Stock: $stock",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}