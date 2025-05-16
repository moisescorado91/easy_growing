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

  // Paleta de colores
  final Color _primaryColor = const Color(0xFF295773);
  final Color _lightBackground = const Color(0xFFCBD7E4);
  final Color _secondaryColor = const Color(0xFFF3EBF3);
  final Color _darkAccent = const Color(0xFF295D7D);
  final Color _successColor = const Color(0xFF7AAC6C);
  final Color _errorColor = const Color(0xFFD32F2F);

  List<Gasto> _gastos = [];

  @override
  void initState() {
    super.initState();
    _cargarGastos();
  }

  Future<void> _cargarGastos() async {
    final gastos = await _gastoService.obtenerGastos();
    setState(() {
      _gastos = gastos;
    });
  }

  Future<void> _confirmarEliminacion(int id) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: _secondaryColor,
            title: Text('Confirmación', style: TextStyle(color: _primaryColor)),
            content: Text(
              '¿Estás seguro de que quieres eliminar este gasto?',
              style: TextStyle(color: _darkAccent),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar', style: TextStyle(color: _primaryColor)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _errorColor,
                  foregroundColor: Colors.white,
                ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Gasto eliminado',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
      backgroundColor: _lightBackground,
      // backgroundColor: _lightBackground,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/easy.png', height: 120),
        ),
        title: const Text(
          'Mis Gastos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            tooltip: 'Salir',
          ),
        ],
      ),
      body:
          _gastos.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.money_off, size: 50, color: _darkAccent),
                    const SizedBox(height: 16),
                    Text(
                      "No hay gastos registrados",
                      style: TextStyle(fontSize: 18, color: _darkAccent),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: _gastos.length,
                itemBuilder: (context, index) {
                  final gasto = _gastos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    color: _secondaryColor,
                    elevation: 1,
                    child: ListTile(
                      title: Text(
                        gasto.descripcion,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _darkAccent,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${gasto.categoria} • ${gasto.fecha}',
                            style: TextStyle(
                              color: _darkAccent.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '\$${gasto.monto.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: _primaryColor),
                            onPressed: () => _editarGasto(gasto),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: _errorColor),
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
        height: 70,
        color: _primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.star_outline, size: 30),
              color: Colors.white,
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
            IconButton(
              icon: const Icon(Icons.bar_chart, size: 30),
              color: Colors.white,
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
              icon: const Icon(Icons.person, size: 30),
              color: Colors.white,
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
        backgroundColor: _successColor,
        foregroundColor: Colors.white,
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
