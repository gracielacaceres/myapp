import 'package:flutter/material.dart';
import '../models/venta.dart';
import '../services/VentaService.dart';

class VentaCreateScreen extends StatefulWidget {
  const VentaCreateScreen({super.key});

  @override
  _VentaCreateScreenState createState() => _VentaCreateScreenState();
}

class _VentaCreateScreenState extends State<VentaCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final VentaService ventaService = VentaService();

  late TextEditingController _montoTotalController;
  late TextEditingController _usuarioController;
  late TextEditingController _fechaController;

  @override
  void initState() {
    super.initState();
    _montoTotalController = TextEditingController();
    _usuarioController = TextEditingController();
    _fechaController = TextEditingController();
  }

  @override
  void dispose() {
    _montoTotalController.dispose();
    _usuarioController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  void _createVenta() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Convertir el texto de la fecha a DateTime
        DateTime fechaVenta = DateTime.parse(_fechaController.text);

        final venta = Venta(
          idVenta: 0, // Asumimos que el ID será generado automáticamente
          idUsuario: int.parse(_usuarioController.text),
          fechaVenta: fechaVenta, // Usamos el DateTime convertido
          montoTotal: double.parse(_montoTotalController.text),
        );

        await ventaService.guardarVenta(venta);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Venta creada exitosamente')),
        );
        Navigator.pop(context); // Regresar a la pantalla anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Venta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icono de flecha hacia atrás
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
          tooltip: 'Volver a la lista de ventas',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usuarioController,
                decoration: const InputDecoration(labelText: 'ID del Usuario'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el ID del usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(
                    labelText: 'Fecha de la Venta (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la fecha de la venta';
                  }
                  // Puedes agregar más validación de formato si es necesario
                  try {
                    DateTime.parse(value);
                  } catch (e) {
                    return 'Formato de fecha no válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _montoTotalController,
                decoration: const InputDecoration(labelText: 'Monto Total'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el monto total';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createVenta,
                child: const Text('Crear Venta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
