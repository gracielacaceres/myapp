import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // Guardar el ID y rol del usuario en local
  Future<void> saveUserSession(int id, String rol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', id);
    await prefs.setString('userRole', rol);
  }

  // Obtener el ID del usuario
  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Obtener el rol del usuario
  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }

  // Cerrar sesión (eliminar datos)
  Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
