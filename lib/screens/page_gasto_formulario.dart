import 'package:flutter/material.dart';
import 'package:easy_growing/models/gasto.dart';
import 'package:easy_growing/services/gasto_service.dart';

class AgregarGastoScreen extends StatefulWidget {
  final Gasto? gasto; // Añadimos este parámetro

  const AgregarGastoScreen({
    super.key,
    this.gasto,
  }); // Constructor con gasto opcional

  @override
  // ignore: library_private_types_in_public_api
  _AgregarGastoScreenState createState() => _AgregarGastoScreenState();
}

class _AgregarGastoScreenState extends State<AgregarGastoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  String _categoriaSeleccionada = 'Alimentación';
  DateTime _fechaSeleccionada = DateTime.now();
  late bool isEdit = false;
  int? idGasto;
  final List<String> _categorias = [
    'Alimentación',
    'Transporte',
    'Servicios',
    'Entretenimiento',
    'Otros',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.gasto != null) {
      // Si estamos editando un gasto, inicializamos los campos con los valores existentes
      idGasto = widget.gasto!.id;
      _descripcionController.text = widget.gasto!.descripcion;
      _montoController.text = widget.gasto!.monto.toString();
      _categoriaSeleccionada = widget.gasto!.categoria;
      _fechaSeleccionada = DateTime.parse(widget.gasto!.fecha);

      isEdit = widget.gasto != null;
    }
  }

  final GastoService _gastoService = GastoService();

  Future<void> _seleccionarFecha() async {
    final DateTime? nuevaFecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (nuevaFecha != null) {
      setState(() {
        _fechaSeleccionada = nuevaFecha;
      });
    }
  }

  void _guardarGasto() async {
    if (_formKey.currentState!.validate()) {
      final descripcion = _descripcionController.text;
      final monto = double.tryParse(_montoController.text) ?? 0;

      // Si estamos editando, usamos editarGasto(), de lo contrario usamos agregarGasto()
      if (isEdit) {
        final nuevoGasto = Gasto(
          id: idGasto,
          descripcion: descripcion,
          categoria: _categoriaSeleccionada,
          monto: monto,
          fecha: _fechaSeleccionada.toString().split(' ')[0],
        );

        await _gastoService.editarGasto(nuevoGasto); // Edita el gasto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gasto actualizado: ${nuevoGasto.descripcion} - \$${monto.toStringAsFixed(2)}',
            ),
          ),
        );
      } else {
        final nuevoGasto = Gasto(
          descripcion: descripcion,
          categoria: _categoriaSeleccionada,
          monto: monto,
          fecha: _fechaSeleccionada.toString().split(' ')[0],
        );
        // Si es nuevo gasto, usamos agregar
        await _gastoService.agregarGasto(nuevoGasto); // Agrega el nuevo gasto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gasto agregado: ${nuevoGasto.descripcion} - \$${monto.toStringAsFixed(2)}',
            ),
          ),
        );
      }

      Navigator.pop(
        context,
      ); // Cierra la pantalla después de agregar o editar el gasto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar gasto' : 'Agregar gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              TextFormField(
                controller: _montoController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  final monto = double.tryParse(value ?? '');
                  if (monto == null || monto <= 0) {
                    return 'Ingrese un monto válido';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                items:
                    _categorias
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaSeleccionada = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Fecha: ${_fechaSeleccionada.toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: _seleccionarFecha,
                    child: const Text('Seleccionar fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardarGasto,
                child: Text(isEdit ? 'Actualizar Gasto' : 'Guardar Gasto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
