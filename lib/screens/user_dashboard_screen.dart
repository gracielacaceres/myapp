import 'package:flutter/material.dart';
import '../utils/session_manager.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Cliente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await SessionManager().clearSession();
              Navigator.pushReplacementNamed(
                  context, '/login'); // Regresa a login
            },
          ),
        ],
      ),
      body: const Center(child: Text('Bienvenido al Dashboard del Cliente')),
    );
  }
}
