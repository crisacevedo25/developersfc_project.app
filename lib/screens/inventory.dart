import 'package:flutter/material.dart';
import 'product_item.dart';
import 'product_form.dart';
import '../adapters/dio_adapter.dart';
import '../models/product.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<Product> _products = [];
  bool _hasLoaded = false;

  final DioAdapter _dioAdapter = DioAdapter();

  @override
  void initState() {
    _getProducts();
    super.initState();
  }

  Future<void> _getProducts() async {
    dynamic response = await _dioAdapter.getRequest(
        'https://firestore.googleapis.com/v1/projects/proyect-desfc/databases/(default)/documents/productos');
    List<dynamic> documents = response['documents'];
    _products = documents.map((doc) => Product.fromJson(doc)).toList();
    setState(() {
      _hasLoaded = true;
    });
  }

  List<Widget> _renderProduct() {
    return _products.map((p) => ProductItem(product: p)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Inventario", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset(
              'assets/img/Logo1.jpg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
        children: _renderProduct(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(isEditing: false)),
          );

          if (result == true) {
            _getProducts();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
