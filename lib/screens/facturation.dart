import 'package:flutter/material.dart';
import 'facture_item.dart';
import 'facture_form.dart';
import '../adapters/dio_adapter.dart';
import '../models/facture.dart';

class Facturation extends StatefulWidget {
  const Facturation({super.key});

  @override
  State<Facturation> createState() => _FacturationState();
}

class _FacturationState extends State<Facturation> {
  List<Facture> _factures = [];
  bool _hasLoaded = false;
  final DioAdapter _dioAdapter = DioAdapter();

  @override
  void initState() {
    super.initState();
    _getFactures();
  }

  Future<void> _getFactures() async {
    dynamic response = await _dioAdapter.getRequest(
        'https://firestore.googleapis.com/v1/projects/proyect-desfc/databases/(default)/documents/facturas');

    if (response != null && response['documents'] != null) {
      List<dynamic> documents = response['documents'];
      _factures = documents.map((doc) => Facture.fromJson(doc)).toList();

      setState(() {
        _hasLoaded = true;
      });
    }
  }

  Widget _renderFactureList() {
    if (!_hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_factures.isEmpty) {
      return const Center(child: Text("No hay facturas disponibles."));
    }

    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _factures.length,
        itemBuilder: (context, index) {
          return FactureItem(facture: _factures[index]);
        });
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
        title: const Text("Facturación", style: TextStyle(color: Colors.white)),
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
      body: _renderFactureList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FactureForm()),
          );

          if (result == true) {
            _getFactures();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
