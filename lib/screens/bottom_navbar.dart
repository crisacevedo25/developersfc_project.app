import 'package:flutter/material.dart';
import 'home.dart';
import 'inventory.dart';
import 'facturation.dart';
import 'sales.dart';
import 'profile.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int initialIndex; // Recibe el índice de la pantalla

  const MyBottomNavigationBar({super.key, this.initialIndex = 0});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late int _selectedItem;

  // Lista de pantallas
  final List<Widget> _screens = [
    MainMenu(), // Índice 0 (Home)
    Inventory(), // Índice 1 (Inventario)
    Facturation(), // Índice 2 (Facturación)
    SalesRegister(), // Índice 3 (Registro)
    Profile(), // Índice 4 (Perfil)
  ];

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialIndex; // Asigna el índice recibido
  }

  void _selectedScreen(int newSelectedItem) {
    setState(() {
      _selectedItem = newSelectedItem;
    });
  }

  void _navigateToSearch(BuildContext context) {
    Navigator.pushNamed(context, 'search');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tab app"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              _navigateToSearch(context);
            },
            icon: const Icon(Icons.search, color: Colors.redAccent),
          )
        ],
      ),
      body: _screens[_selectedItem], // Muestra la pantalla seleccionada
      bottomNavigationBar: _selectedItem == 0
          ? null // Ocultar NavBar si está en Home
          : BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home, color: Colors.redAccent),
                    label: 'Inicio'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view, color: Colors.redAccent),
                    label: 'Inventario'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.receipt, color: Colors.redAccent),
                    label: 'Facturación'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.assignment, color: Colors.redAccent),
                    label: 'Registro'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person, color: Colors.redAccent),
                    label: 'Perfil')
              ],
              currentIndex: _selectedItem,
              selectedItemColor: Colors.black,
              onTap: _selectedScreen,
            ),
    );
  }
}
