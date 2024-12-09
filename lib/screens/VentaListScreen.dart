import 'package:flutter/material.dart';
import '../services/VentaService.dart';
import '../models/venta.dart';
import 'VentaDetailScreen.dart';
import 'VentaCreateScreen.dart';
import 'HomeScreen.dart';

class VentaListScreen extends StatefulWidget {
  const VentaListScreen({super.key});

  @override
  _VentaListScreenState createState() => _VentaListScreenState();
}

class _VentaListScreenState extends State<VentaListScreen> {
  late Future<List<Venta>> futureVentas;
  final VentaService ventaService = VentaService();
  String filter = 'todos'; // Estado del filtro actual

  @override
  void initState() {
    super.initState();
    futureVentas =
        ventaService.listarVentas(); // Cargar todas las ventas por defecto
  }

  void _filterVentas(String type) {
    setState(() {
      filter = type; // Actualizar el filtro actual
      if (type == 'activos') {
        futureVentas = ventaService.listarVentasActivas();
      } else if (type == 'inactivos') {
        futureVentas = ventaService.listarVentasInactivas();
      } else {
        futureVentas = ventaService.listarVentas(); // Cargar todas las ventas
      }
    });
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Venta'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta venta?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                try {
                  await ventaService.eliminarVenta(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Venta eliminada')));
                  _filterVentas(
                      filter); // Actualizar la lista según el filtro actual
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showRestoreConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restaurar Venta'),
          content:
              const Text('¿Estás seguro de que deseas restaurar esta venta?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Restaurar'),
              onPressed: () async {
                try {
                  await ventaService.restaurarVenta(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Venta restaurada')));
                  _filterVentas(
                      'inactivos'); // Mostrar las ventas inactivas después de restaurar
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icono de flecha hacia atrás
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const HomeScreen()), // Redirige a HomeScreen
            );
          },
          tooltip: 'Volver al menú principal',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today), // Icono de calendario
            onPressed: () {
              // Navegar a la pantalla de crear venta
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VentaCreateScreen()),
              );
            },
            tooltip: 'Ir a Gestión de Ventas',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _filterVentas('todos'),
                  child: const Text('Todas'),
                ),
                ElevatedButton(
                  onPressed: () => _filterVentas('activos'),
                  child: const Text('Activas'),
                ),
                ElevatedButton(
                  onPressed: () => _filterVentas('inactivos'),
                  child: const Text('Inactivas'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Venta>>(
              future: futureVentas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final ventas = snapshot.data!;
                  return ListView.builder(
                    itemCount: ventas.length,
                    itemBuilder: (context, index) {
                      final venta = ventas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            'Venta #${venta.idVenta}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Monto Total: \$${venta.montoTotal}',
                              style: const TextStyle(color: Colors.grey)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Eliminar',
                            onPressed: () =>
                                _showDeleteConfirmation(venta.idVenta),
                          ),
                          onTap: () {
                            // Se pasa el idVenta correctamente a la pantalla de detalle
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VentaDetailScreen(
                                    idVenta: venta.idVenta), // Paso del idVenta
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VentaCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
