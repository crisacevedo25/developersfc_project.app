import 'package:flutter/material.dart';
import 'dart:async';

import '../models/product.dart';
import '../adapters/dio_adapter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<Product> _productsState;
  bool _hasLoaded = false;

  List<Product> _products = [];
  final DioAdapter _dioAdapter = DioAdapter();

  @override
  void initState() {
    super.initState();
    _setProducts(null);
  }

  Future<void> _setProducts(ProductType? pType) async {
    List<Product> p;
    setState(() {
      _hasLoaded = false;
    });
    if (pType != null) {
      p = _products.where((pdt) => pdt.category == pType).toList();
    } else {
      dynamic response = await _dioAdapter.getRequest(
          "https://firestore.googleapis.com/v1/projects/proyect-desfc/databases/(default)/documents/productos");
      List<dynamic> documents = response["documents"];
      _products = documents.map((doc) => Product.fromJson(doc)).toList();
      p = _products;
    }

    setState(() {
      _productsState = p;
      _hasLoaded = true;
    });
  }

  List<Widget> productsListTile() {
    List<Widget> pWidgetTile = [];
    for (final p in _productsState) {
      pWidgetTile.add(_ProductTile(product: p));
    }
    return pWidgetTile;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoaded) return _SearchLoading();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Búsqueda"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  _setProducts(ProductType.GALLETAS);
                },
                child: const Text(
                  "Galletas",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _setProducts(ProductType.DULCES);
                },
                child: const Text(
                  "Dulces",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _setProducts(ProductType.CHURROS);
                },
                child: const Text(
                  "Churros",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: ListView(
            children: [...productsListTile()],
          )),
        ],
      ),
    );
  }
}

class _SearchLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Búsqueda"),
        ),
        body: Center(child: CircularProgressIndicator()));
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;

  const _ProductTile({required this.product});

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
                  image: NetworkImage(product.image),
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
                    product.nombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    "Compra: L${product.preciocomp}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "Venta: L${product.preciovent}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
