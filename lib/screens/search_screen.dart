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
  // states
  late List<Product> _productsState;
  bool _hasLoaded = false;
  // values

  List<Product> _products = [];
  final DioAdapter _dioAdapter = DioAdapter();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setProduts(null);
  }

  Future<void> _setProduts(ProductType? pType) async {
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
      pWidgetTile.add(Divider(
        height: 0,
      ));
    }
    return pWidgetTile;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoaded) return _SearchLoading();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Item"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _setProduts(ProductType.GALLETAS);
                  },
                  child: const Text("Galletas")),
              ElevatedButton(
                  onPressed: () {
                    _setProduts(ProductType.DULCES);
                  },
                  child: const Text("Dulces")),
              ElevatedButton(
                  onPressed: () {
                    _setProduts(ProductType.CHURROS);
                  },
                  child: const Text("Churros")),
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

// stateless widget

class _SearchLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search Item"),
        ),
        body: Center(child: CircularProgressIndicator()));
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        product.image,
        width: 80,
        height: 200,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
      title: Row(
        children: [
          Text(product.nombre),
          SizedBox(
            width: 5,
          ),
          Text(
            "\$ ${product.preciovent}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: IconButton(
          onPressed: () {
            print("Delete item");
          },
          icon: Icon(Icons.shopping_basket)),
    );
  }
}
