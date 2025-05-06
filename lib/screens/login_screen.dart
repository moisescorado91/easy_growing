import 'package:flutter/material.dart';
import 'package:easy_growing/services/usuario_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final UsuarioService _usuarioService = UsuarioService();

  void _iniciarSesion() async {
    final username = _usuarioController.text;
    final password = _contrasenaController.text;

    print(username);
    print(password);

    // Llamamos al servicio para validar las credenciales
    final usuario = await _usuarioService.validarUsuario(username, password);

    if (usuario != null) {
      // Si el usuario es válido, redirigimos a la pantalla de gastos
      Navigator.pushReplacementNamed(context, '/gastos');
    } else {
      // Si el usuario no es válido, mostramos un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', height: 250, width: 150),
            const SizedBox(height: 50), // Espacio debajo del logo
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _contrasenaController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _iniciarSesion,
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
