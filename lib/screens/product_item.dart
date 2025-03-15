import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductItem extends StatefulWidget {
  Product product;
  ProductItem({super.key, required this.product});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Alineación centrada
          children: [
            // Imagen del producto más grande y rectangular
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(widget.product.image),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) =>
                      const AssetImage('assets/placeholder.png'),
                ),
              ),
              child: widget.product.image.isEmpty
                  ? const Icon(Icons.attach_money,
                      color: Colors.white, size: 40)
                  : null,
            ),
            const SizedBox(width: 10),
            // Columna con la información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Alinea al centro verticalmente
                children: [
                  Text(
                    widget.product.nombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    "Compra: \$${widget.product.preciocomp}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "Venta: \$${widget.product.preciovent}", // Suponiendo un 20% más para venta
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "Cant: ${widget.product.cant}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (widget.product.cant == 0)
                    const Text(
                      "AGOTADO",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            // Botón de editar
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centrar los botones
              children: [
                IconButton(
                  onPressed: () => print("Editar producto"),
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () => print("Eliminar producto"),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
