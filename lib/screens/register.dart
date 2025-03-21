import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../adapters/dio_adapter.dart';
import '../adapters/local_storage.dart';
import '../adapters/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final LocalStorage _localStorage = LocalStorage();
  final _formKey = GlobalKey<FormState>();
  final _user = User(username: '', fullname: '', email: '', password: '');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        dynamic authResponse = await Auth.createUserWithEmailAndPassword(
            _user.email, _user.password);
        _user.setUid(authResponse.user.uid);
        dynamic response = await DioAdapter().postRequest(
            'https://firestore.googleapis.com/v1/projects/proyect-desfc/databases/(default)/documents/users',
            _user.toFirestoreRestMap());
        User newUser = User.fromMap(response);
        await _localStorage.setUser(newUser.toStringMap());
        _displaySnackbar(context, 'Usuario registrado con éxito');
      } catch (e) {
        _displaySnackbar(context, 'Error registrando usuario');
      }
    }
  }

  void _displaySnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    Navigator.pushReplacementNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Crear usuario"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, 'init'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _animation,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField("Ingresa tu nombre", "Tu nombre",
                    (value) => _user.fullname = value!),
                const SizedBox(height: 10),
                _buildTextField("Crea tu usuario", "Username",
                    (value) => _user.username = value!),
                const SizedBox(height: 10),
                _buildTextField("Ingresa tu email", "Tuemail@correo.com",
                    (value) => _user.email = value!),
                const SizedBox(height: 10),
                _buildTextField("Crea una contraseña", "******",
                    (value) => _user.password = value!,
                    isPassword: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _onSubmit(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50)),
                  child: const Text("Registrarme"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String?) onSaved,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Este campo es obligatorio'
              : null,
          onSaved: onSaved,
        ),
      ],
    );
  }
}
