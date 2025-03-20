import 'dart:convert';
import 'package:flutter/material.dart';
import '../adapters/local_storage.dart';
import '../adapters/db.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final LocalStorage _localStorage = LocalStorage();
  final Db _db = Db();
  Map<String, dynamic>? _userData;
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      String? userData = await _localStorage.getUser();
      if (userData != null) {
        final Map<String, dynamic> userDataMap = jsonDecode(userData);

        setState(() {
          _userData = userDataMap;
          nameController.text = _userData?["fullname"] ?? "Desconocido";
          emailController.text = _userData?["email"] ?? "No disponible";
        });
      }
    } catch (e) {
      print("Error al obtener los datos del usuario: $e");
    }
  }

  Future<void> _logOut(BuildContext context) async {
    await _localStorage.clearAll();
    Navigator.pushReplacementNamed(context, 'init');
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _saveChanges() async {
    if (_userData != null) {
      _userData!["fullname"] = nameController.text;
      _userData!["email"] = emailController.text;

      await _db.updateUserData(_userData!["uid"], _userData!);
      await _localStorage.setUser(jsonEncode(_userData));

      setState(() {
        isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _userData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    /*child: _userData?["profilePicture"] != null &&
                            _userData?["profilePicture"].toString().isNotEmpty
                        ? Image.network(
                            _userData!["profilePicture"],
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.person, size: 100.0),*/
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: nameController,
                    enabled: isEditing,
                    decoration: const InputDecoration(labelText: "Nombre"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    enabled: isEditing,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  const SizedBox(height: 20),
                  isEditing
                      ? ElevatedButton(
                          onPressed: _saveChanges,
                          child: const Text("Guardar cambios"),
                        )
                      : ElevatedButton(
                          onPressed: _toggleEditing,
                          child: const Text("Editar"),
                        ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _logOut(context),
                    child: const Text("Cerrar sesión"),
                  ),
                ],
              ),
      ),
    );
  }
}
