import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/facture.dart';

class FactureForm extends StatefulWidget {
  final Facture? facture;
  final bool isEditing;

  const FactureForm({super.key, this.facture, this.isEditing = false});

  @override
  State<FactureForm> createState() => _FactureFormState();
}

class _FactureFormState extends State<FactureForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _totalController;
  late TextEditingController _cantController;
  FactureType _selectedCategory = FactureType.Compra;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.facture?.description ?? "");
    _totalController =
        TextEditingController(text: widget.facture?.total.toString() ?? "0");
    _cantController =
        TextEditingController(text: widget.facture?.cant.toString() ?? "0");
    _selectedCategory = widget.facture?.category ?? FactureType.Compra;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _totalController.dispose();
    _cantController.dispose();
    super.dispose();
  }

  Future<void> _saveFacture() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "description": _descriptionController.text,
        "category": _selectedCategory.index,
        "total": double.parse(_totalController.text),
        "cant": int.parse(_cantController.text),
      };

      if (widget.isEditing) {
        await FirebaseFirestore.instance
            .collection("facturas")
            .doc(widget.facture!.id)
            .update(data);
      } else {
        await FirebaseFirestore.instance.collection("facturas").add(data);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.isEditing ? "Editar Factura" : "Nueva Factura"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Descripción", "Ingresa la descripción",
                  _descriptionController),
              const SizedBox(height: 10),
              DropdownButtonFormField<FactureType>(
                value: _selectedCategory,
                decoration: _inputDecoration("Categoría"),
                items: FactureType.values.map((FactureType type) {
                  return DropdownMenuItem<FactureType>(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildTextField("Total", "0", _totalController, isNumber: true),
              const SizedBox(height: 10),
              _buildTextField("Cantidad", "0", _cantController, isNumber: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFacture,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50)),
                child: Text(
                    widget.isEditing ? "Guardar Cambios" : "Agregar Factura"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: _inputDecoration(hint),
          validator: (value) => value == null || value.isEmpty
              ? 'Este campo es obligatorio'
              : null,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[300],
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    );
  }
}
