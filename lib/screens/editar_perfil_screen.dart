import 'package:flutter/material.dart';
import 'package:easy_growing/models/usuario.dart';
import 'package:easy_growing/services/usuario_service.dart';

class EditarPerfilScreen extends StatefulWidget {
  final Usuario usuario;

  const EditarPerfilScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final UsuarioService _usuarioService = UsuarioService();


  final Color _primaryColor = const Color(0xFF295773);
  final Color _lightBackground = const Color(0xFFCBD7E4);
  final Color _secondaryColor = const Color(0xFFF3EBF3);
  final Color _darkAccent = const Color(0xFF295D7D);
  final Color _successColor = const Color(0xFF7AAC6C);

  late TextEditingController _usuarioController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usuarioController = TextEditingController(text: widget.usuario.usuario);
    _passwordController = TextEditingController(text: widget.usuario.password);
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      final actualizado = Usuario(
        id: widget.usuario.id,
        usuario: _usuarioController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _usuarioService.actualizarUsuario(actualizado);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Perfil actualizado correctamente'),
            backgroundColor: _successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBackground,
      appBar: AppBar(
        title: const Text('Editar Perfil', 
                style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            color: _secondaryColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: _lightBackground,
                      child: Icon(Icons.person, size: 40, color: _primaryColor),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _usuarioController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de usuario',
                        labelStyle: TextStyle(color: _primaryColor),
                        prefixIcon: Icon(Icons.person, color: _primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: _primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: _primaryColor, width: 2),
                        ),
                      ),
                      style: TextStyle(color: _darkAccent),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese un nombre' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: _primaryColor),
                        prefixIcon: Icon(Icons.lock, color: _primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: _primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: _primaryColor, width: 2),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(color: _darkAccent),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingrese una contraseña'
                          : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _guardarCambios,
                      child: const Text(
                        'GUARDAR CAMBIOS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: _darkAccent,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}