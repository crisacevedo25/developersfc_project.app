import 'package:flutter/material.dart';
import 'bottom_navbar.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Image.asset(
              'assets/img/Logo1.jpg',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _MenuItem(
                  icon: Icons.grid_view,
                  label: "Inventario",
                  onTap: () => _navigateToPage(context, 1),
                ),
                _MenuItem(
                  icon: Icons.receipt,
                  label: "Facturación",
                  onTap: () => _navigateToPage(context, 2),
                ),
                _MenuItem(
                  icon: Icons.assignment,
                  label: "Registro",
                  onTap: () => _navigateToPage(context, 3),
                ),
                _MenuItem(
                  icon: Icons.person,
                  label: "Perfil",
                  onTap: () => _navigateToPage(context, 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyBottomNavigationBar(initialIndex: index)),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSingle;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.isSingle = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.redAccent),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
