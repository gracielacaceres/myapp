import 'package:flutter/material.dart'; // Proporciona Widgets y temas preferidos de Material Design
import 'screens/UserListScreen.dart'; // Importa la pantalla de lista de los usuarios que será la pantalla principal
import 'screens/user_dashboard_screen.dart'; // Client view
import 'utils/session_manager.dart'; // Maneja la sesión del usuario
import 'screens/login_screen.dart'; // Pantalla de login

void main() {
  runApp(const MyApp()); // Inicia la aplicación ejecutando el widget MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión Barbería',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Configuración de colores
        fontFamily: 'Roboto', // Cambiar a una fuente predeterminada legible
        textTheme: const TextTheme(
          bodyMedium:
              TextStyle(fontSize: 16.0), // Asegura un tamaño de texto estándar
        ),
      ),
      home: FutureBuilder(
        future: _checkSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // Mostrar mientras se carga
            );
          } else if (snapshot.hasData) {
            if (snapshot.data == 'admin') {
              return const UserListScreen(); // Admin
            } else {
              return const UserDashboardScreen(); // Cliente
            }
          } else {
            return const LoginScreen(); // No hay sesión
          }
        },
      ),
    );
  }

  Future<String?> _checkSession() async {
    return await SessionManager()
        .getUserRole(); // Obtiene el rol si está logueado
  }
}
