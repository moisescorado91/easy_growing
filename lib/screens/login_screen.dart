import 'package:flutter/material.dart';
import 'package:easy_growing/services/usuario_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_growing/models/usuario.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final UsuarioService _usuarioService = UsuarioService();

  final Color _primaryColor = const Color(0xFF295773);      
  final Color _lightBackground = const Color(0xFFCBD7E4);   
  final Color _secondaryColor = const Color(0xFFF3EBF3);  
  final Color _darkAccent = const Color(0xFF295D7D); 
  final Color _successColor = const Color(0xFF7AAC6C);

  void _iniciarSesion() async {
    final username = _usuarioController.text;
    final password = _contrasenaController.text;

    final usuario = await _usuarioService.validarUsuario(username, password);

    if (usuario != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('usuarioId', usuario.id!);

      Navigator.pushReplacementNamed(context, '/gastos');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Usuario o contraseña incorrectos'),
          backgroundColor: _darkAccent,
        ),
      );
    }
  }

  String? _validarContrasena(String contrasena) {
    if (contrasena.isEmpty) return 'Ingresa tu contraseña';
    if (contrasena.length < 8) return 'Debe tener al menos 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(contrasena))
      return 'Debe tener una mayúscula';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(contrasena)) {
      return 'Debe tener un carácter especial';
    }
    return null;
  }

  void _mostrarRegistroDialog() {
    final _nuevoUsuarioController = TextEditingController();
    final _nuevoContrasenaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _lightBackground,
          title: Text('Registrar nuevo usuario', style: TextStyle(color: _primaryColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nuevoUsuarioController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  labelStyle: TextStyle(color: _primaryColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _primaryColor),
                  ),
                ),
              ),
              TextField(
                controller: _nuevoContrasenaController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: _primaryColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _primaryColor),
                  ),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(color: _primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _successColor,
              ),
              onPressed: () async {
                final nuevoUsuario = _nuevoUsuarioController.text.trim();
                final nuevaContrasena = _nuevoContrasenaController.text.trim();

                if (nuevoUsuario.isEmpty || nuevaContrasena.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Todos los campos son obligatorios'),
                      backgroundColor: _darkAccent,
                    ),
                  );
                  return;
                }

                final error = _validarContrasena(nuevaContrasena);
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: _darkAccent,
                    ),
                  );
                  return;
                }

                final nuevo = Usuario(
                  usuario: nuevoUsuario,
                  password: nuevaContrasena,
                );

                final id = await _usuarioService.agregarUsuario(nuevo);

                if (id > 0) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setInt('usuarioId', id);

                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/gastos');
                  }
                } else {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Error al registrar usuario'),
                        backgroundColor: _darkAccent,
                      ),
                    );
                  }
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBackground,
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/easy.png', height: 250, width: 150),
            const SizedBox(height: 50),
            TextField(
              controller: _usuarioController,
              decoration: InputDecoration(
                labelText: 'Usuario',
                labelStyle: TextStyle(color: _primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _primaryColor),
                ),
              ),
            ),
            TextField(
              controller: _contrasenaController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: _primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _primaryColor),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _iniciarSesion,
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _mostrarRegistroDialog,
              child: Text(
                'Registrarme',
                style: TextStyle(
                  color: _darkAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}