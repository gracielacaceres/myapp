import 'package:flutter/material.dart';
import '../models/venta.dart';
import '../services/VentaService.dart';

class VentaDetailScreen extends StatefulWidget {
  final int idVenta;

  const VentaDetailScreen({super.key, required this.idVenta});

  @override
  _VentaDetailScreenState createState() => _VentaDetailScreenState();
}

class _VentaDetailScreenState extends State<VentaDetailScreen> {
  late Venta _venta;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchVentaDetails();
  }

  void _fetchVentaDetails() async {
    try {
      final venta = await VentaService().obtenerVenta(widget.idVenta);
      setState(() {
        _venta = venta;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Venta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icono de flecha hacia atrás
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
          tooltip: 'Volver a la lista de ventas',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Cargando datos
          : _hasError
              ? const Center(child: Text('Error al cargar los detalles de la venta.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID Venta: ${_venta.idVenta}', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text('ID Usuario: ${_venta.idUsuario}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 10),
                      Text('Fecha Venta: ${_venta.fechaVenta.toLocal().toString().split(' ')[0]}',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 10),
                      Text('Monto Total: \$${_venta.montoTotal.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
    );
  }
}
