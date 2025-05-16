import 'package:easy_growing/screens/editar_perfil_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_growing/models/usuario.dart';
import 'package:easy_growing/services/usuario_service.dart';

class ScreenPerfil extends StatelessWidget {
  final UsuarioService usuarioService = UsuarioService();

  // Paleta de colores
  final Color _primaryColor = const Color(0xFF295773);
  final Color _lightBackground = const Color(0xFFCBD7E4);
  final Color _secondaryColor = const Color(0xFFF3EBF3);
  final Color _darkAccent = const Color(0xFF295D7D);
  final Color _successColor = const Color(0xFF7AAC6C);

  ScreenPerfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBackground,
      appBar: AppBar(
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Usuario?>(
        future: usuarioService.obtenerPerfil(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: _primaryColor),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: _darkAccent, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 50, color: _darkAccent),
                  const SizedBox(height: 16),
                  Text(
                    'No se encontró perfil de usuario',
                    style: TextStyle(color: _darkAccent, fontSize: 18),
                  ),
                ],
              ),
            );
          }

          final usuario = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: _secondaryColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: _lightBackground,
                              backgroundImage: const AssetImage(
                                'assets/images/cuenta.png',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProfileItem(
                        context,
                        icon: Icons.numbers,
                        label: 'ID de usuario',
                        value: usuario.id?.toString() ?? 'No disponible',
                      ),
                      const SizedBox(height: 30),
                      _buildProfileItem(
                        context,
                        icon: Icons.person,
                        label: 'Nombre de usuario',
                        value: usuario.usuario ?? 'No especificado',
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            print(usuario);
                            final actualizado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => EditarPerfilScreen(usuario: usuario),
                              ),
                            );

                            if (actualizado == true) {
                              // Refrescar el perfil al volver
                              (context as Element).reassemble();
                            }
                          },

                          child: const Text('Editar Perfil'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: _darkAccent),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: _darkAccent.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            value,
            style: TextStyle(
              color: _primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: _lightBackground, thickness: 1),
      ],
    );
  }
}
