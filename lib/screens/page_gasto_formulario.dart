import 'package:flutter/material.dart';
import 'package:easy_growing/models/gasto.dart';
import 'package:easy_growing/services/gasto_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgregarGastoScreen extends StatefulWidget {
  final Gasto? gasto;

  const AgregarGastoScreen({
    super.key,
    this.gasto,
  });

  @override
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

  // Paleta de colores
  final Color _primaryColor = const Color(0xFF295773);
  final Color _lightBackground = const Color(0xFFCBD7E4);
  final Color _secondaryColor = const Color(0xFFF3EBF3);
  final Color _darkAccent = const Color(0xFF295D7D);
  final Color _successColor = const Color(0xFF7AAC6C);

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              onSurface: _darkAccent,
            ),
          ),
          child: child!,
        );
      },
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
      final prefs = await SharedPreferences.getInstance();
      int? usuarioId = prefs.getInt('usuarioId');

      if (isEdit) {
        final nuevoGasto = Gasto(
          id: idGasto,
          descripcion: descripcion,
          categoria: _categoriaSeleccionada,
          monto: monto,
          fecha: _fechaSeleccionada.toString().split(' ')[0],
          idUsuario: usuarioId!,
        );

        await _gastoService.editarGasto(nuevoGasto);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gasto actualizado: ${nuevoGasto.descripcion} - \$${monto.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: _successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        final nuevoGasto = Gasto(
          descripcion: descripcion,
          categoria: _categoriaSeleccionada,
          monto: monto,
          fecha: _fechaSeleccionada.toString().split(' ')[0],
          idUsuario: usuarioId!,
        );
        
        await _gastoService.agregarGasto(nuevoGasto);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gasto agregado: ${nuevoGasto.descripcion} - \$${monto.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: _successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBackground,
      appBar: AppBar(
        title: Text(isEdit ? 'Editar gasto' : 'Agregar gasto'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: _secondaryColor,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: _descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      labelStyle: TextStyle(color: _primaryColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _montoController,
                    decoration: InputDecoration(
                      labelText: 'Monto',
                      labelStyle: TextStyle(color: _primaryColor),
                      prefixText: '\$ ',
                      prefixStyle: TextStyle(color: _primaryColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      final monto = double.tryParse(value ?? '');
                      if (monto == null || monto <= 0) {
                        return 'Ingrese un monto válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _categoriaSeleccionada,
                    items: _categorias
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat, style: TextStyle(color: _darkAccent)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _categoriaSeleccionada = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      labelStyle: TextStyle(color: _primaryColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor),
                      ),
                    ),
                    dropdownColor: _secondaryColor,
                    style: TextStyle(color: _darkAccent),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Fecha: ${_fechaSeleccionada.toString().split(' ')[0]}',
                          style: TextStyle(color: _darkAccent, fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: _seleccionarFecha,
                        child: Text(
                          'Cambiar fecha',
                          style: TextStyle(color: _primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _guardarGasto,
                    child: Text(
                      isEdit ? 'Actualizar Gasto' : 'Guardar Gasto',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
