import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        title: Text(product['nombre'] ?? 'Sin nombre'),
        subtitle: Text("Precio: ${product['precio'] ?? '0'}"),
        trailing: Text("Stock: ${product['stock'] ?? '0'}"),
      ),
    );
  }
}
