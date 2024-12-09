import 'package:flutter/material.dart';
import 'UserListScreen.dart'; // Importar la pantalla de la lista de usuarios
import 'ProductListScreen.dart'; // Importar la pantalla de la lista de productos
import 'VentaListScreen.dart'; // Importar la pantalla de la lista de ventas

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserListScreen()),
              );
            },
            child: const Text('Lista de Usuarios'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProductoListScreen()),
              );
            },
            child: const Text('Lista de Productos'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const VentaListScreen()), // Pantalla de ventas
              );
            },
            child: const Text('Lista de Ventas'),
          ),
        ],
      ),
    );
  }
}
