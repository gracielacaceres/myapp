import 'package:flutter/material.dart';
import '../services/ProductoService.dart';
import '../models/producto.dart';
import 'ProductoDetailScreen.dart';
import 'ProductoCreateScreen.dart';
import 'HomeScreen.dart'; // Asegúrate de importar HomeScreen

class ProductoListScreen extends StatefulWidget {
  const ProductoListScreen({super.key});

  @override
  _ProductoListScreenState createState() => _ProductoListScreenState();
}

class _ProductoListScreenState extends State<ProductoListScreen> {
  late Future<List<Producto>> futureProductos;
  final ProductoService productoService = ProductoService();
  String filter = 'todos'; // Estado del filtro actual

  @override
  void initState() {
    super.initState();
    futureProductos = productoService
        .listarProductos(); // Cargar todos los productos por defecto
  }

  void _filterProducts(String type) {
    setState(() {
      filter = type; // Actualizar el filtro actual
      if (type == 'activos') {
        futureProductos = productoService.listarProductosActivos();
      } else if (type == 'inactivos') {
        futureProductos = productoService.listarProductosInactivos();
      } else {
        futureProductos =
            productoService.listarProductos(); // Cargar todos los productos
      }
    });
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este producto?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                try {
                  await productoService.eliminarProducto(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Producto eliminado')));
                  _filterProducts(
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
          title: const Text('Restaurar Producto'),
          content: const Text(
              '¿Estás seguro de que deseas restaurar este producto?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Restaurar'),
              onPressed: () async {
                try {
                  await productoService.restaurarProducto(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Producto restaurado')));
                  _filterProducts(
                      'inactivos'); // Actualizar lista a productos inactivos
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
        title: const Text('Productos'),
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
            icon: const Icon(Icons.add), // Icono de agregar producto
            onPressed: () {
              // Navegar a la pantalla de creación de productos
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductoCreateScreen()),
              );
            },
            tooltip: 'Agregar Producto',
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
                  onPressed: () => _filterProducts('todos'),
                  child: const Text('Todos'),
                ),
                ElevatedButton(
                  onPressed: () => _filterProducts('activos'),
                  child: const Text('Activos'),
                ),
                ElevatedButton(
                  onPressed: () => _filterProducts('inactivos'),
                  child: const Text('Inactivos'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Producto>>(
              future: futureProductos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final productos = snapshot.data!;
                  return ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          leading: Image.network(
                            producto.imagen,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 50);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 50,
                                height: 50,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            },
                          ),
                          title: Text(
                            producto.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '\$${producto.precio}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: producto.estado == 0
                              ? IconButton(
                                  icon: const Icon(Icons.restore,
                                      color: Colors.green),
                                  tooltip: 'Restaurar',
                                  onPressed: () => _showRestoreConfirmation(
                                      producto.idProducto),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  tooltip: 'Eliminar',
                                  onPressed: () => _showDeleteConfirmation(
                                      producto.idProducto),
                                ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(producto: producto),
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
              builder: (context) => ProductoCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
