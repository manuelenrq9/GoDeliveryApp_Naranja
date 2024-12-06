import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Obtén el token almacenado
  }

  Future<void> fetchAndSaveUserId(String email) async {
  try {
    final token = await _getToken();

      // Si no hay token, puede que quieras manejarlo, como redirigir al login
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }
    // Construir la URL con el correo
    final url = Uri.parse(
      'https://orangeteam-deliverybackend-production.up.railway.app/User/byEmail/${Uri.encodeComponent(email)}',
    );

    // Realizar la solicitud HTTP
    final response = await http.get(url,
        headers: {
          'Authorization':
              'Bearer $token', // Incluimos el token en el encabezado
          'Content-Type': 'application/json',
        },);

    // Verificar la respuesta
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['value'] != null) {
        final userId = responseData['value']['id']; // Extraer el ID del usuario

        // Guardar el ID en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userId);
      
      } else {
        print('No se encontró información del usuario.');
      }
    } else {
      print('Error al obtener el ID del usuario: ${response.body}');
    }
  } catch (e) {
    print('Error al realizar la solicitud para obtener el ID: $e');
  }
}


  // Método para realizar la validación y el login
  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Si la validación es correcta, enviar los datos
      final loginData = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('https://orangeteam-deliverybackend-production.up.railway.app/auth/login'),
          headers: {'accept': '*/*', 'Content-Type': 'application/json'},
          body: json.encode(loginData),
        );

        if (response.statusCode == 201) {
          // Si la respuesta es exitosa, guardar el token
          final responseBody = json.decode(response.body);
          final token = responseBody['response']['token'];

          // Almacenar el token en shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          // Llamar al método para obtener y guardar el ID del usuario
        await fetchAndSaveUserId(_emailController.text);

          // Redirigir a la pantalla principal
          showLoadingScreen(context, destination: const MainMenu());
        } else {
          _showErrorDialog('Error al iniciar sesión. Revisa tus credenciales.');
        }
      } catch (e) {
        _showErrorDialog('Contraseña invalida\n');
      }
    }
  }

  // Mostrar un diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error', style: TextStyle(color: Colors.orange),),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.orange),),
              
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/LogoGoDely.png',
                width: 270,
                height: 270,
              ),
              const SizedBox(height: 16),
              // Formulario de login
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo Correo/Usuario
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email/Usuario',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un correo electrónico';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Campo Contraseña
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Botón de Iniciar sesión
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7000),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _login,
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Otros botones
                    TextButton(
                      onPressed: () {
                        showLoadingScreen(context, destination: const RegisterScreen());
                      },
                      child: const Text('¿No tienes cuenta? Regístrate', style: TextStyle(color: Color(0xFFFF7000))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
