import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/UsuarioService.dart';
import '../utils/session_manager.dart';
import 'UserListScreen.dart'; // Admin view
import 'user_dashboard_screen.dart'; // Client view

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UsuarioService usuarioService = UsuarioService();

  void _login() async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      final usuario = await usuarioService.login(
          email, password); // Implementa login en el servicio
      if (usuario != null) {
        // Guardar la sesión
        await SessionManager()
            .saveUserSession(usuario.idUsuario!, usuario.rol!);

        // Redirigir según el rol
        if (usuario.rol == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserListScreen()),
          );
        } else if (usuario.rol == 'cliente') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserDashboardScreen()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
