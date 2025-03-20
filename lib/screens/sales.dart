import 'package:flutter/material.dart';

class SalesRegister extends StatelessWidget {
  const SalesRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Registro Ventas",
            style: TextStyle(color: Colors.white)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Sección de ganancias/pérdidas
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
                    children: const [
                      Text(
                        "Ganancias",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$0.00",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.black38,
                  ),
                  Column(
                    children: const [
                      Text(
                        "Pérdidas",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$0.00",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tarjetas de productos
            _buildProductCard("Nombre Prod", 0, 0, 0),
            _buildProductCard("Nombre Prod", 0, 0, -0),
          ],
        ),
      ),
    );
  }

  // Widget para cada tarjeta de producto
  Widget _buildProductCard(
      String name, double invertido, double vendido, double ganancia) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(Icons.attach_money, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text("Tot Invertido: \$${invertido.toStringAsFixed(2)}"),
                  Text("Tot Vendido: \$${vendido.toStringAsFixed(2)}"),
                  Text(
                    ganancia >= 0
                        ? "Ganancias: +\$${ganancia.toStringAsFixed(2)}"
                        : "Pérdidas: -\$${(-ganancia).toStringAsFixed(2)}",
                    style: TextStyle(
                        color: ganancia >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold),
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
