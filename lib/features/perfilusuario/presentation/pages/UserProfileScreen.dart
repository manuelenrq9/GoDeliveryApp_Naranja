import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConfiguracion.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/login.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/perfilusuario/presentation/pages/edit_user_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImageUrl: json['image'] ??
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  late User _user;
  bool _isPasswordVisible = false; // Estado para alternar visibilidad

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String?> _getApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_url'); // Obtén el token almacenado
  }

  Future<User?> _getUserData() async {
    String? userID = await _getUserID();

    if (userID == null) {
      return null;
    }
    final apiUrl = await _getApi();
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No hay token de autenticación');

      final response = await http.get(
        Uri.parse('$apiUrl/user/one/$userID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String?> _getUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF7000)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelStyle: const TextStyle(
            color: Colors.black, // Etiqueta negra cuando se enfoca
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Perfil de Usuario',
            style: TextStyle(
              color: Color.fromARGB(255, 175, 91, 7),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 175, 91, 7)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainMenu()),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFFFF7000)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CurrencySettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<User?>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                  child: Text('No se encontraron datos de usuario.'));
            }

            _user = snapshot.data!;
            _nameController.text = _user.name;
            _phoneController.text = _user.phone;
            _emailController.text = _user.email;
            // _passwordController.text = _user.password;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(_user.profileImageUrl),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_nameController, 'Nombre', Icons.person),
                    const SizedBox(height: 16),
                    _buildTextField(
                        _emailController, 'Correo Electrónico', Icons.email),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Teléfono', Icons.phone),
                    const SizedBox(height: 16),
                    // _buildPasswordTextField(),
                    const SizedBox(height: 16),

                    const SizedBox(
                        height: 20), // Espacio entre botones y formulario
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final userId = await _getUserID();
                            if (userId == null) {
                              throw Exception('No hay usuario ID');
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.edit, color: Colors.white),
                              const SizedBox(width: 8),
                              const Text('Editar'),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF7000),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
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
                          icon: const Icon(Icons.logout,
                              color: Color(0xFFFF7000)),
                          label: const Text('Cerrar Sesión'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFFFF7000),
                            side: const BorderSide(color: Color(0xFFFF7000)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false}) {
    return Material(
      elevation: 5.0,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black), // Texto negro
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Color(0xFFFF7000)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF7000)),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Material(
      elevation: 5.0,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(8.0),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: 'Contraseña',
          prefixIcon: const Icon(Icons.lock, color: Color(0xFFFF7000)),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFFFF7000),
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFF7000)),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
