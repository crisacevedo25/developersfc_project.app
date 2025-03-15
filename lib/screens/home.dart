import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "Logo",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          // Botones en grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2, // Reduce el tamaño de los cuadros
              children: const [
                _MenuItem(icon: Icons.grid_view, label: "Inventario"),
                _MenuItem(icon: Icons.receipt, label: "Facturación"),
                _MenuItem(icon: Icons.search, label: "Búsqueda"),
                _MenuItem(icon: Icons.assignment, label: "Registro"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Botón de perfil centrado
          const _MenuItem(icon: Icons.person, label: "Perfil", isSingle: true),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSingle;

  const _MenuItem(
      {super.key,
      required this.icon,
      required this.label,
      this.isSingle = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isSingle ? 80 : 120, // Reducir el tamaño de los cuadros
      height: isSingle ? 80 : 120,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.purple, size: 30),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
