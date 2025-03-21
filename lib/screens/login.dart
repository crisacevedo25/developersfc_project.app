import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import '../adapters/local_storage.dart';
import '../adapters/dio_adapter.dart';
import '../adapters/http_adapter.dart';
import '../adapters/auth.dart';
import '../adapters/db.dart';
import '../models/user.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  bool _hasLoaded = false;
  late String _email;
  late String _password;
  String _error = '';

  LocalStorage _localStorage = LocalStorage();
  DioAdapter _dioAdapter = DioAdapter();
  HttpAdapter _httpAdapter = HttpAdapter();
  Db _db = Db();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _validateLogin(context);
    super.initState();
  }

  Future<void> _validateLogin(BuildContext context) async {
    bool isAuthenticated = await _localStorage.getLoginStatus();
    setState(() {
      _hasLoaded = true;
    });
    if (isAuthenticated) {
      Navigator.pushNamed(context, 'home');
    }
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        dynamic response =
            await Auth.signInWithEmailAndPassword(_email, _password);
        if (response == null || response.user == null) {
          setState(() {
            _error = 'Contraseña o correo inválido';
          });
          return;
        }

        Map<String, dynamic>? userData =
            await _db.getUserData(response.user.uid);
        if (userData == null) {
          setState(() {
            _error = 'Usuario no encontrado';
          });
          return;
        }
        User user = User.fromFirebaseMap(userData);
        await _localStorage.setUser(user.toStringMap());
        setState(() {
          _error = '';
        });
        await _localStorage.setLoginStatus(true);
        _goToAppController(context);
      } catch (e) {
        setState(() {
          _error = 'Ocurrió un error inesperado';
        });
      }
    }
  }

  void _goToAppController(BuildContext context) {
    Navigator.pushNamed(context, 'home');
  }

  void _goToRegister(BuildContext context) {
    Navigator.pushNamed(context, 'register');
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoaded) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child:
                      Image.asset('assets/img/Logo1.jpg', fit: BoxFit.contain),
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Correo",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese un correo válido';
                            }
                            if (!value.contains('@')) {
                              return 'Por favor ingrese un correo válido';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value!,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese una contraseña';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe contener al menos 6 caracteres';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value!,
                        ),
                        if (_error.isNotEmpty) ...[
                          SizedBox(height: 10),
                          Text(_error, style: TextStyle(color: Colors.red)),
                        ],
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text("Iniciar sesión"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => _goToRegister(context),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
                child: const Text(
                  "Registrarse",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
