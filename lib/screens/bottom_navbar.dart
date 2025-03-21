import 'package:flutter/material.dart';
import 'home.dart';
import 'inventory.dart';
import 'facturation.dart';
import 'sales.dart';
import 'profile.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int initialIndex;

  const MyBottomNavigationBar({super.key, this.initialIndex = 0});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late int _selectedItem;

  final List<Widget> _screens = [
    MainMenu(),
    Inventory(),
    Facturation(),
    SalesRegister(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialIndex;
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
      body: _screens[_selectedItem],
      bottomNavigationBar: _selectedItem == 0
          ? null
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
