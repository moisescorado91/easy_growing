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
      appBar: AppBar(title: Text(widget.title)),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 200, 
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/logo.jpg",
                  ), 
                  fit: BoxFit.cover,
                ),
              ),
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color:
                      Colors
                          .black45, 
                ),
                child: Text(
                  'Menú',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Gastos'),
              onTap: () {
                Navigator.pop(context); 
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Redirigir a gastos")));
                Navigator.pushReplacementNamed(context, '/gastos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart),
              title: const Text('Gráfico'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Redirigir a gráfico")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
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
