import 'package:flutter/material.dart';
import '../services/UsuarioService.dart';
import '../models/usuario.dart';
import 'UserDetailScreen.dart';
import 'UserCreateScreen.dart';
import 'HomeScreen.dart'; // Asegúrate de importar HomeScreen

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<Usuario>> futureUsuarios;
  final UsuarioService usuarioService = UsuarioService();
  String filter = 'todos'; // Estado del filtro actual

  @override
  void initState() {
    super.initState();
    futureUsuarios = usuarioService
        .listarUsuarios(); // Cargar todos los usuarios por defecto
  }

  void _filterUsers(String type) {
    setState(() {
      filter = type; // Actualizar el filtro actual
      if (type == 'activos') {
        futureUsuarios = usuarioService.listarUsuariosActivos();
      } else if (type == 'inactivos') {
        futureUsuarios = usuarioService.listarUsuariosInactivos();
      } else {
        futureUsuarios =
            usuarioService.listarUsuarios(); // Cargar todos los usuarios
      }
    });
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Usuario'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este usuario?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                try {
                  await usuarioService.eliminarUsuario(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario eliminado')));
                  _filterUsers(
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
          title: const Text('Restaurar Usuario'),
          content:
              const Text('¿Estás seguro de que deseas restaurar este usuario?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Restaurar'),
              onPressed: () async {
                try {
                  await usuarioService.recuperarCuenta(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario restaurado')));
                  _filterUsers('inactivos');
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
        title: const Text('Usuarios'),
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
              // Navegar a la pantalla de citas
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserCreateScreen()),
              );
            },
            tooltip: 'Ir a Gestión de Citas',
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
                  onPressed: () => _filterUsers('todos'),
                  child: const Text('Todos'),
                ),
                ElevatedButton(
                  onPressed: () => _filterUsers('activos'),
                  child: const Text('Activos'),
                ),
                ElevatedButton(
                  onPressed: () => _filterUsers('inactivos'),
                  child: const Text('Inactivos'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Usuario>>(
              future: futureUsuarios,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final usuarios = snapshot.data!;
                  return ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = usuarios[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            '${usuario.nombre} ${usuario.apellido}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(usuario.email ?? '',
                              style: const TextStyle(color: Colors.grey)),
                          trailing: usuario.activo == 0
                              ? IconButton(
                                  icon: const Icon(Icons.restore,
                                      color: Colors.green),
                                  tooltip: 'Restaurar',
                                  onPressed: () => _showRestoreConfirmation(
                                      usuario.idUsuario!),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  tooltip: 'Eliminar',
                                  onPressed: () => _showDeleteConfirmation(
                                      usuario.idUsuario!),
                                ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserDetailScreen(usuario: usuario),
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
              builder: (context) => UserCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
