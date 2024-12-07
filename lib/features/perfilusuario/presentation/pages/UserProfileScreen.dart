import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/login.dart';
import 'package:godeliveryapp_naranja/features/perfilusuario/data/user.dart';
import 'package:godeliveryapp_naranja/features/perfilusuario/presentation/pages/edit_user_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatelessWidget {
  Future<String?> _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  @override
  Widget build(BuildContext context) {
    final user = User(
      profileImageUrl:
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '04265191055',
      password: 'password',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(
            color: Color.fromARGB(255, 175, 91, 7),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 175, 91, 7),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Foto de perfil
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user.profileImageUrl),
              ),
              const SizedBox(height: 16),

              // Nombre del usuario
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              // Información adicional en tarjetas
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.phone, color: Color(0xFFFF7000)),
                  title: const Text('Teléfono'),
                  subtitle: Text(user.phone),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.mail, color: Color(0xFFFF7000)),
                  title: const Text('Correo Electrónico'),
                  subtitle: Text(user.email),
                ),
              ),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.lock, color: Color(0xFFFF7000)),
                  title: const Text('Contraseña'),
                  subtitle: Text('......'),
                ),
              ),

              const SizedBox(height: 16),

              // Botones de Editar y Cerrar Sesión alineados horizontalmente
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditUserProfileScreen(user: user),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF7000),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Acción para cerrar sesión
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, color: Color(0xFFFF7000)),
                    label: const Text('Cerrar Sesión'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFFFF7000),
                      side: const BorderSide(color: Color(0xFFFF7000)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
