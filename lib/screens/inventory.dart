import 'package:flutter/material.dart';
import 'product_item.dart';
import '../adapters/dio_adapter.dart';
import '../models/product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> _products = [];
  bool _hasLoaded = false;

  // instancia de dio
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
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
        children: _renderProduct(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("=========================================> Click on add");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
