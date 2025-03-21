import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/facture.dart';

class FactureItem extends StatefulWidget {
  final Facture facture;
  const FactureItem({super.key, required this.facture});

  @override
  State<FactureItem> createState() => _FactureItemState();
}

class _FactureItemState extends State<FactureItem> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void _deleteFacture() async {
    await _db.collection("facturas").doc(widget.facture.id).delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.facture.description,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categoría: ${widget.facture.category == FactureType.Compra ? 'Compra' : 'Venta'}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  "Cant: ${widget.facture.cant}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Total: L${widget.facture.total}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: _deleteFacture,
                icon: const Icon(Icons.delete, color: Colors.red, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
