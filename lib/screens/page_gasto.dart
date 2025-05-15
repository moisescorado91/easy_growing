import 'package:easy_growing/screens/goal_screen.dart';
import 'package:easy_growing/screens/screen_grafic.dart';
import 'package:easy_growing/screens/screen_perfil.dart';
import 'package:easy_growing/services/goal_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_growing/screens/page_gasto_formulario.dart';
import 'package:easy_growing/services/gasto_service.dart';
import 'package:easy_growing/models/gasto.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GastoService _gastoService = GastoService();
  final GoalService _goalService = GoalService();

  List<Gasto> _gastos = [];

  @override
  void initState() {
    super.initState();
    _cargarGastos();
  }

  Future<void> _cargarGastos() async {
    final gastos = await _gastoService.obtenerGastos();
    print(gastos);

    setState(() {
      _gastos = gastos;
    });
  }

  Future<void> _confirmarEliminacion(int id) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmación'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar este gasto?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  _eliminarGasto(id);
                  Navigator.of(context).pop();
                },
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  Future<void> _eliminarGasto(int id) async {
    await _gastoService.eliminarGasto(id);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Gasto eliminado')));
    _cargarGastos();
  }

  void _editarGasto(Gasto gasto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AgregarGastoScreen(gasto: gasto)),
    );
    _cargarGastos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.jpg', height: 40),
        ),
        title: const Text('Mis Gastos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            tooltip: 'Salir',
          ),
        ],
      ),
      body:
          _gastos.isEmpty
              ? const Center(child: Text("No hay gastos registrados."))
              : ListView.builder(
                itemCount: _gastos.length,
                itemBuilder: (context, index) {
                  final gasto = _gastos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(gasto.descripcion),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${gasto.id} ${gasto.categoria} • ${gasto.fecha}',
                          ),
                          Text(
                            '\$${gasto.monto.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editarGasto(gasto),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _confirmarEliminacion(gasto.id!),
                          ),
                        ],
                      ),
                      onLongPress: () => _confirmarEliminacion(gasto.id!),
                    ),
                  );
                },
              ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.star_outline),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GoalScreen(goalService: _goalService),
                  ),
                );
              },
              tooltip: 'Metas',
            ),

            // se quito esto los requerimientos solicitan informacion basada en otro tipo de boton
            // IconButton(
            //   icon: const Icon(Icons.add),
            //   onPressed: () async {
            //     await Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => const AgregarGastoScreen()),
            //     );
            //     _cargarGastos();
            //   },
            //   tooltip: 'Agregar',
            // ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScreenGrafic(gastoService: _gastoService),
                  ),
                );
              },
              tooltip: 'Gráficos',
            ),
            IconButton(
              icon: const Icon(Icons.person), // icono de perfil
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ScreenPerfil()),
                );
              },
              tooltip: 'Perfil',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarGastoScreen()),
          );
          _cargarGastos();
        },
        tooltip: 'Agregar Gasto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
