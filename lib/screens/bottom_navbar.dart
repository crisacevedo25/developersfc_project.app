import 'package:flutter/material.dart';
import 'home.dart';
import 'inventory.dart';
import 'facturation.dart';
import 'sales.dart';
import 'profile.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBar();
}

class _MyBottomNavigationBar extends State<MyBottomNavigationBar> {
  // state
  int _selectedItem = 0;

  // widges
  final List<Widget> _screens = [
    MainMenu(),
    Home(),
    Facturation(),
    SalesRegister(),
    Profile()
  ];

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
              icon: Icon(Icons.search, color: Colors.redAccent))
        ],
      ),
      body: _screens[_selectedItem],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.redAccent), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view, color: Colors.redAccent),
              label: 'Inventario'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt, color: Colors.redAccent),
              label: 'Facturacion'),
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
