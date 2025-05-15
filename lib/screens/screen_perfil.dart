import 'package:flutter/material.dart';
import 'package:easy_growing/models/usuario.dart';
import 'package:easy_growing/services/usuario_service.dart';

class ScreenPerfil extends StatelessWidget {
  final UsuarioService usuarioService = UsuarioService();

  ScreenPerfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Usuario?>(
        future: usuarioService.obtenerPerfil(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No se encontró perfil de usuario'),
            );
          }

          final usuario = snapshot.data!;

          print(usuario);

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/images/logo.jpg',
                    ), 
                  ),
                ),
                const SizedBox(height: 20),
                Text('Nombre:', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  usuario.usuario ?? 'Sin nombre',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 15),
                Text('Id:', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  usuario.id?.toString() ?? 'Sin ID',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 15),
                Text(
                  'Teléfono:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '+503 0000-0000',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}