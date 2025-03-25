import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductItem extends StatefulWidget {
  Product product;
  ProductItem({super.key, required this.product});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void _editProduct() {
    TextEditingController nameController =
        TextEditingController(text: widget.product.nombre);
    TextEditingController priceCompController =
        TextEditingController(text: widget.product.preciocomp.toString());
    TextEditingController priceVentController =
        TextEditingController(text: widget.product.preciovent.toString());
    TextEditingController quantityController =
        TextEditingController(text: widget.product.cant.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Producto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nombre")),
            TextField(
                controller: priceCompController,
                decoration: const InputDecoration(labelText: "Precio Compra")),
            TextField(
                controller: priceVentController,
                decoration: const InputDecoration(labelText: "Precio Venta")),
            TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: "Cantidad")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _db.collection("productos").doc(widget.product.id).update({
                "nombre": nameController.text,
                "preciocomp": int.tryParse(priceCompController.text),
                "preciovent": int.tryParse(priceVentController.text),
                "cant": int.parse(quantityController.text),
              });
              setState(() {
                widget.product.nombre = nameController.text;
                widget.product.preciocomp = int.parse(priceCompController.text);
                widget.product.preciovent = int.parse(priceVentController.text);
                widget.product.cant = int.parse(quantityController.text);
              });
              Navigator.pop(context);
            },
            child: const Text(
              "Guardar",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteProduct() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Producto"),
        content:
            const Text("¿Estás seguro de que deseas eliminar este producto?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              await _db.collection("productos").doc(widget.product.id).delete();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(widget.product.image),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) =>
                      const AssetImage('assets/placeholder.png'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.product.nombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    "Compra: L${widget.product.preciocomp}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "Venta: L${widget.product.preciovent}",
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _editProduct,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: _deleteProduct,
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
