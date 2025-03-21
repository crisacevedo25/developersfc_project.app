import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final bool isEditing;

  const ProductForm({super.key, this.product, this.isEditing = false});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _compraController;
  late TextEditingController _ventaController;
  late TextEditingController _cantidadController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nombreController =
        TextEditingController(text: widget.product?.nombre ?? "");
    _compraController = TextEditingController(
        text: widget.product?.preciocomp.toString() ?? "0");
    _ventaController = TextEditingController(
        text: widget.product?.preciovent.toString() ?? "0");
    _cantidadController =
        TextEditingController(text: widget.product?.cant.toString() ?? "0");
    _categoryController =
        TextEditingController(text: widget.product?.category.toString() ?? "0");
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _compraController.dispose();
    _ventaController.dispose();
    _cantidadController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "nombre": _nombreController.text,
        "preciocomp": int.parse(_compraController.text),
        "preciovent": int.parse(_ventaController.text),
        "cant": int.parse(_cantidadController.text),
        "category": int.parse(_categoryController.text),
      };

      if (widget.isEditing) {
        await FirebaseFirestore.instance
            .collection("productos")
            .doc(widget.product!.id)
            .update(data);
      } else {
        await FirebaseFirestore.instance.collection("productos").add(data);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.isEditing ? "Editar Producto" : "Nuevo Producto"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  "Nombre del producto", "Ej: Oreo", _nombreController),
              const SizedBox(height: 10),
              _buildTextField("Precio de compra", "Ej: 500", _compraController,
                  isNumeric: true),
              const SizedBox(height: 10),
              _buildTextField("Precio de venta", "Ej: 700", _ventaController,
                  isNumeric: true),
              const SizedBox(height: 10),
              _buildTextField(
                  "Cantidad disponible", "Ej: 10", _cantidadController,
                  isNumeric: true),
              const SizedBox(height: 10),
              _buildTextField("Categoría", "Ingrese el valor correspondiente",
                  _categoryController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                    widget.isEditing ? "Guardar Cambios" : "Agregar Producto"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Este campo es obligatorio'
              : null,
        ),
      ],
    );
  }
}
