import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/register.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';
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
  String _selectedApi = 'https://orangeteam-deliverybackend-production.up.railway.app';

  @override
  void initState() {
    super.initState();
    _loadApiUrl();
  }

  void _loadApiUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedApiUrl = prefs.getString('api_url');
    if (storedApiUrl != null) {
      setState(() {
        _selectedApi = storedApiUrl;
      });
    } else {
      _setApiUrl(
          _selectedApi); // Solo establece la URL si no estaba guardada previamente
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
          Uri.parse('$_selectedApi/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(loginData),
        );

        if (response.statusCode == 201) {
          // Si la respuesta es exitosa, guardar el token
          final responseBody = json.decode(response.body);
          final token = responseBody['token'];
          final userId = responseBody['user']['id'];

          // Almacenar el token en shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString('user_id', userId);

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
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.orange),
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  void _setApiUrl(String apiUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_url', apiUrl);
    setState(() {
      _selectedApi = apiUrl;
    });
    await CartScreen.clearCartStatic(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Center(
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
                            showLoadingScreen(context,
                                destination: const RegisterScreen());
                          },
                          child: const Text('¿No tienes cuenta? Regístrate',
                              style: TextStyle(color: Color(0xFFFF7000))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 25,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.wifi, color: Colors.orange, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Selecciona la API',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _apiOption(
                              'Naranja',
                              'https://orangeteam-deliverybackend-production.up.railway.app',
                              Colors.orange,
                              'orangeteam'),
                          _apiOption(
                              'Amarillo',
                              'https://amarillo-backend-production.up.railway.app',
                              Color(0xFFFFD700),
                              'amarillo'),
                          _apiOption(
                              'Verde',
                              'https://verde-backend-production.up.railway.app',
                              Colors.green,
                              'verde'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _apiOption(String title, String url, Color color, String key) {
    return ListTile(
      leading: Icon(Icons.circle, color: color),
      title: Text('${title}'),
      trailing: _selectedApi.contains(key)
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              padding: EdgeInsets.all(6),
              child: Icon(Icons.check, color: color, size: 30),
            )
          : null,
      onTap: () {
        _setApiUrl(url);
        Navigator.pop(context);
      },
    );
  }
}
