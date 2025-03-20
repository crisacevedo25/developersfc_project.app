import 'package:flutter/material.dart';
import 'home.dart';
import 'inventory.dart';
import 'facturation.dart';
import 'sales.dart';
import 'profile.dart';

class MyTabController extends StatefulWidget {
  const MyTabController({super.key});

  @override
  State<MyTabController> createState() => _MyTabController();
}

class _MyTabController extends State<MyTabController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.home), text: "Inicio"),
              Tab(icon: Icon(Icons.grid_view), text: "Inventario"),
              Tab(icon: Icon(Icons.receipt), text: "Facturacion"),
              Tab(icon: Icon(Icons.assignment), text: "Registro"),
              Tab(icon: Icon(Icons.person), text: "Profile"),
            ]),
            automaticallyImplyLeading: false,
          ),
          body: TabBarView(children: [
            MainMenu(),
            Inventory(),
            Facturation(),
            SalesRegister(),
            Profile()
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("=========================================> Click on add");
            },
            child: Icon(Icons.add),
          ),
        ));
  }
}
