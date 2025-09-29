import 'package:flutter/material.dart';
import '../services/catalog_service.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final CatalogService _catalogService = CatalogService();
  late Future<List<dynamic>> _catalogoFuture;

  @override
  void initState() {
    super.initState();
    _catalogoFuture = _catalogService.getCatalogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de productos'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _catalogoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos disponibles'));
          }

          final catalogo = snapshot.data!;
          return ListView.builder(
            itemCount: catalogo.length,
            itemBuilder: (context, index) {
              final producto = catalogo[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(producto['nombre'] ?? 'Sin nombre'),
                  subtitle: Text(producto['descripcion'] ?? ''),
                  trailing: Text('Precio: \$${producto['precio'] ?? ''}'),
                  onTap: () {
                    // Aquí podrías ir al detalle del producto
                    Navigator.pushNamed(
                      context,
                      '/catalogo-detalle',
                      arguments: producto['id'],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
