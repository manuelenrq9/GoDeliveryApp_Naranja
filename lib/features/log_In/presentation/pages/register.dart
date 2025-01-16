import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/RegisterSuccessScreen.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/login.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _region;
  String? _emailErrorMessage;
  String _selectedCountryCode = '+1';

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<String?> _getApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_url'); // Obtén el token almacenado
  }

  // Método para realizar la validación y enviar los datos
  void _register() async {
    final apiUrl = await _getApi();
    setState(() {
      _emailErrorMessage = null;
    });
    if (apiUrl != 'https://orangeteam-deliverybackend-production.up.railway.app') {
      _validateEmail(_emailController.text);
    }
    if (_formKey.currentState?.validate() ?? false) {
      if (_emailErrorMessage != null &&
          apiUrl ==
              'https://orangeteam-deliverybackend-production.up.railway.app') {
        // Si hay un error de correo, no permitir el registro
        return;
      }
      print('3');
      // Continuar con el proceso de registro
      final email = _emailController.text;
      print('4');
      try {
        print('5');
        if (apiUrl ==
            'https://orangeteam-deliverybackend-production.up.railway.app') {
          final emailAvailable = await isEmailAvailable(email);

          if (!emailAvailable) {
            setState(() {
              _emailErrorMessage = 'El correo electrónico ya está registrado.';
            });
            return;
          }
        }
        Map<String, String> newUser = {};
        if (apiUrl ==
            'https://orangeteam-deliverybackend-production.up.railway.app') {
          newUser = {
            'name': _nameController.text,
            'email': email,
            'password': _passwordController.text,
            'phone': _phoneController.text,
            'type': 'CLIENT',
          };
        }
        if (apiUrl ==
            'https://godelybackgreen.up.railway.app/api') {
          newUser = {
            'name': _nameController.text,
            'email': email,
            'password': _passwordController.text,
            'phone': _phoneController.text,
            'role': 'CLIENT',
          };
        }
         if (apiUrl == 'https://amarillo-backend-production.up.railway.app'){
          newUser = {
            'name': _nameController.text,
            'email': email,
            'password': _passwordController.text,
            'phone': _phoneController.text,
            "image": ""
          };
        }
        final response = await http.post(
          Uri.parse('$apiUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newUser),
        );
        print('HOLA  $apiUrl/auth/register');
        print(response.statusCode);
        print('URL');
        print(json.encode(newUser));
        if (response.statusCode == 201) {
          showLoadingScreen(context,
              destination: const RegisterSuccessScreen());
        } else {
          setState(() {
            _emailErrorMessage = 'Error al crear cuenta. Intenta nuevamente.';
          });
        }
      } catch (e) {
        setState(() {
          _emailErrorMessage =
              'Ocurrió un error. Por favor verifica tu conexión.';
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> isEmailAvailable(String email) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://orangeteam-deliverybackend-production.up.railway.app/User/byEmail/$email'),
      );

      if (response.statusCode == 500) {
        // El servidor responde 500 si el correo no está registrado
        return true;
      } else if (response.statusCode == 200) {
        // El servidor responde 200 si el correo ya está registrado
        return false;
      } else {
        throw Exception('Error al verificar el correo electrónico');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  Future<void> _validateEmail(String email) async {
    final apiUrl = await _getApi();

    if (email.isNotEmpty &&
        RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email) &&
        apiUrl ==
            'https://orangeteam-deliverybackend-production.up.railway.app') {
      final emailAvailable = await isEmailAvailable(email);
      setState(() {
        _emailErrorMessage =
            emailAvailable ? null : 'El correo electrónico ya está registrado.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/LogoLetrasGoDely.png',
                  width: 350,
                  height: 50,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ingresa Tus Datos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Nombre de Usuario',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu nombre';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Correo Electrónico',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: _emailErrorMessage == null
                              ? Colors.grey
                              : Colors.red,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      errorText:
                          _emailErrorMessage, // Muestra el mensaje de error
                    ),
                    onChanged: (value) {
                      _validateEmail(value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo.';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                          .hasMatch(value)) {
                        return 'Correo no válido';
                      }
                      if (_emailErrorMessage != null) {
                        return _emailErrorMessage;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
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
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Confirmar Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor confirma tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Selecciona tu región',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.public),
                    ),
                    items: <String>[
                      'América del Norte',
                      'América Central',
                      'América del Sur',
                      'Europa',
                      'Asia',
                      'África',
                      'Oceanía',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _region = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona una región';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: _selectedCountryCode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: <String>[
                            '+1', // USA
                            '+52', // Mexico
                            '+91', // India
                            '+44', // UK
                            '+81', // Japan
                            '+58', // Venezuela
                          ].map<DropdownMenuItem<String>>((String value) {
                            String flagUrl;
                            switch (value) {
                              case '+1':
                                flagUrl =
                                    'https://flagcdn.com/w320/us.png'; // USA
                                break;
                              case '+52':
                                flagUrl =
                                    'https://flagcdn.com/w320/mx.png'; // Mexico
                                break;
                              case '+91':
                                flagUrl =
                                    'https://flagcdn.com/w320/in.png'; // India
                                break;
                              case '+44':
                                flagUrl =
                                    'https://flagcdn.com/w320/gb.png'; // UK
                                break;
                              case '+81':
                                flagUrl =
                                    'https://flagcdn.com/w320/jp.png'; // Japan
                                break;
                              case '+58':
                                flagUrl =
                                    'https://flagcdn.com/w320/ve.png'; // Venezuela
                                break;
                              default:
                                flagUrl =
                                    'https://flagcdn.com/w320/default.png'; // Default flag
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Image.network(
                                    flagUrl,
                                    width: 15,
                                    height: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCountryCode = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor selecciona un prefijo';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: 'Teléfono',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu teléfono';
                            }
                            if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return 'Teléfono no válido';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: 'Fecha de Nacimiento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFFFF7000),
                                onPrimary: Color.fromARGB(255, 15, 15, 15),
                                surface: Color.fromARGB(255, 255, 255, 255),
                                onSurface: Colors.black,
                              ),
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu fecha de nacimiento';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isLoading
                        ? ElevatedButton(
                            key: const ValueKey('loading'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {},
                            child: const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : ElevatedButton(
                            key: const ValueKey('login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7000),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _register,
                            child: const Text(
                              'Crear Cuenta',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    showLoadingScreen(context,
                        destination: const LoginScreen());
                  },
                  child: const Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(color: Color(0xFFFF7000)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
