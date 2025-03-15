import 'package:flutter/material.dart';

class Facturation extends StatefulWidget {
  const Facturation({super.key});

  @override
  State<Facturation> createState() => _FacturationState();
}

class _FacturationState extends State<Facturation> {
  bool isCompraSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Facturación", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
                child: Text("Logo", style: TextStyle(color: Colors.white))),
          ),
        ),
      ),
      body: Column(
        children: [
          // Toggle de Compra/Venta
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isCompraSelected = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCompraSelected ? Colors.black : Colors.white,
                      foregroundColor:
                          isCompraSelected ? Colors.white : Colors.black,
                    ),
                    child: const Text("Compra"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isCompraSelected = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isCompraSelected ? Colors.black : Colors.white,
                      foregroundColor:
                          !isCompraSelected ? Colors.white : Colors.black,
                    ),
                    child: const Text("Venta"),
                  ),
                ),
              ],
            ),
          ),
          // Lista de productos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Descripción aquí",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text("Cant: 20",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const Text("\$00.00",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete,
                                color: Colors.black, size: 30),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
