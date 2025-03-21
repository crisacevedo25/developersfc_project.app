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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String userData = await _localStorage.getUser();
    final Map<String, dynamic> userDataMap = jsonDecode(userData);

    Map<String, dynamic>? firestoreData =
        await _db.getUserData(userDataMap["uid"]);

    if (firestoreData != null) {
      setState(() {
        _userData = firestoreData;
        usernameController.text = _userData!["username"];
        nameController.text = _userData!["fullname"];
        emailController.text = _userData!["email"];

        _userData!["docId"] = firestoreData["docId"];
      });
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
    if (_userData != null && _userData!["docId"] != null) {
      String docId = _userData!["docId"];

      print("Actualizando usuario con document ID: $docId");

      _userData!["username"] = usernameController.text;
      _userData!["fullname"] = nameController.text;
      _userData!["email"] = emailController.text;

      await _db.updateUserData(docId, _userData!);
      await _localStorage.setUser(jsonEncode(_userData));

      setState(() {
        isEditing = false;
      });
    } else {
      print("Error: No se encontró el ID del documento del usuario.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Perfil", style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _userData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: usernameController,
                    enabled: isEditing,
                    decoration: const InputDecoration(labelText: "Username"),
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
                          child: const Text(
                            "Guardar cambios",
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _toggleEditing,
                          child: const Text(
                            "Editar",
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _logOut(context),
                    child: const Text(
                      "Cerrar sesión",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
