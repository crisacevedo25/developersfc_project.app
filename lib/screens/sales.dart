import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalesRegister extends StatelessWidget {
  const SalesRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Registro Ventas",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset('assets/img/Logo1.jpg', fit: BoxFit.contain),
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("facturas").get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<String, Map<String, double>> groupedData = {};
          double totalInvertido = 0;
          double totalVendido = 0;

          for (var doc in snapshot.data!.docs) {
            var data = doc.data() as Map<String, dynamic>;
            String description = data['description'];
            double total = (data['total'] as num).toDouble();
            int category = data['category'];

            if (!groupedData.containsKey(description)) {
              groupedData[description] = {"invertido": 0, "vendido": 0};
            }

            if (category == 0) {
              groupedData[description]!['invertido'] =
                  (groupedData[description]!['invertido'] ?? 0) + total;
              totalInvertido += total;
            } else if (category == 1) {
              groupedData[description]!['vendido'] =
                  (groupedData[description]!['vendido'] ?? 0) + total;
              totalVendido += total;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text("Ganancias",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            "\$${(totalVendido - totalInvertido).toStringAsFixed(2)}",
                            style: TextStyle(
                              color: (totalVendido - totalInvertido) >= 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(height: 40, width: 1, color: Colors.black38),
                      Column(
                        children: [
                          const Text("Total Invertido",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("\$${totalInvertido.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(height: 40, width: 1, color: Colors.black38),
                      Column(
                        children: [
                          const Text("Total Vendido",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("\$${totalVendido.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...groupedData.entries.map((entry) {
                  double invertido = entry.value['invertido'] ?? 0;
                  double vendido = entry.value['vendido'] ?? 0;
                  return _buildProductCard(
                      entry.key, invertido, vendido, vendido - invertido);
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
      String name, double invertido, double vendido, double ganancia) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("Total Invertido: \$${invertido.toStringAsFixed(2)}"),
                  Text("Total Vendido: \$${vendido.toStringAsFixed(2)}"),
                  Text(
                    ganancia >= 0
                        ? "Ganancias: +\$${ganancia.toStringAsFixed(2)}"
                        : "Pérdidas: -\$${(-ganancia).toStringAsFixed(2)}",
                    style: TextStyle(
                      color: ganancia >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
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
