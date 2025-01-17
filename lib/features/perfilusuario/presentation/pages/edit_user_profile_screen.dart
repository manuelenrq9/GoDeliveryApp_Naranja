import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/sidebar/presentation/custom_drawer.dart';
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

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  late User _user;
  bool _isPasswordVisible = false;
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Token y datos de usuario
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('Token obtenido: $token'); // Bandera de token
    return token;
  }

  Future<String?> _getApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_url'); // Obtén el token almacenado
  }

  // Obtener datos de usuario desde el backend
  Future<User?> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('user_id');
    print('UserID: $userID'); // Bandera para verificar el userID
    if (userID == null) return null;
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Datos de usuario: $data');
        return User.fromJson(data);
      } else {
        print('Error en la respuesta de la API: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Actualizar datos del usuario
  Future<void> _updateUserData() async {
    final apiUrl = await _getApi();
    try {
      final token = await _getToken();
      if (token == null) {
        print('No hay token de autenticación');
        throw Exception('No hay token de autenticación');
      }
      final response = await http.patch(
        Uri.parse(
          '$apiUrl/user/update/${_user.id}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'image': _imageController.text,
          if(_passwordController.text != '')...{'password': _passwordController.text}
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado con éxito')),
        );
        // Aquí recargamos los datos después de la actualización
        setState(() {
          _user = User(
            id: _user.id,
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            profileImageUrl: _imageController.text,
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar perfil')),
        );
      }
    } catch (e) {
      print('Error al actualizar perfil: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
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
          _imageController.text = _user.profileImageUrl;

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
                  _buildPasswordTextField(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateUserData,
                    child: const Text('Actualizar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF7000),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
      drawer: CustomDrawer(),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
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
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
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
    );
  }
}
