// import 'package:flutter/material.dart';
// import 'package:godeliveryapp_naranja/core/loading_screen.dart';
// import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/RegisterSuccessScreen.dart';
// import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/login.dart';
// import 'package:intl/intl.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   //Controlador para el campo de fecha nacimiento
//   final TextEditingController _dateController = TextEditingController();

//   @override
//   void dispose() {
//     _dateController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'images/LogoLetrasGoDely.png',
//                 width: 350,
//                 height: 50,
//               ),
//               const SizedBox(height: 16),

//               const Text(
//                 'Ingresa Tus Datos',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child:
//                     //Campo Usuario
//                     TextField(
//                         decoration: InputDecoration(
//                   hintText: 'Nombre de Usuario',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   prefixIcon: const Icon(Icons.person),
//                 )),
//               ),
//               const SizedBox(height: 10),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child:
//                     //Campo Correo Electronico
//                     TextField(
//                         decoration: InputDecoration(
//                   hintText: 'Correo Electronico',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   prefixIcon: const Icon(Icons.email),
//                 )),
//               ),
//               const SizedBox(height: 10),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: TextFormField(
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     hintText: 'Contraseña',
//                     prefixIcon: const Icon(Icons.lock),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Campo Confirmar Contraseña
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: TextFormField(
//                   obscureText: !_isConfirmPasswordVisible,
//                   decoration: InputDecoration(
//                     hintText: 'Confirmar Contraseña',
//                     prefixIcon: const Icon(Icons.lock),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isConfirmPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isConfirmPasswordVisible =
//                               !_isConfirmPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     hintText: 'Selecciona tu región',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     prefixIcon: const Icon(Icons.public),
//                   ),
//                   items: <String>[
//                     'América del Norte',
//                     'América Central',
//                     'América del Sur',
//                     'Europa',
//                     'Asia',
//                     'África',
//                     'Oceanía',
//                   ].map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     // Handle change here
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Campo Prefijo y Teléfono
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   children: [
//                     Flexible(
//                       flex: 3,
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Prefijo',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           prefixIcon: const Icon(Icons.phone),
//                         ),
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Por favor ingrese el prefijo';
//                           }
//                           if (!RegExp(r'^\+\d+$').hasMatch(value)) {
//                             return 'Ingrese un prefijo válido (e.g., +1)';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Flexible(
//                       flex: 5,
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Teléfono',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Por favor ingrese el teléfono';
//                           }
//                           if (!RegExp(r'^\d+$').hasMatch(value)) {
//                             return 'Ingrese un teléfono válido';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Campo Fecha de Nacimiento
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: TextField(
//                   controller: _dateController,
//                   decoration: InputDecoration(
//                     hintText: 'Fecha de Nacimiento',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     prefixIcon: const Icon(Icons.calendar_today),
//                   ),
//                   readOnly: true,
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                       builder: (BuildContext context, Widget? child) {
//                         return Theme(
//                           data: ThemeData.light().copyWith(
//                             colorScheme: const ColorScheme.light(
//                               primary: Color(0xFFFF7000), // Color naranja
//                               onPrimary: Color.fromARGB(255, 15, 15,
//                                   15), // Color del texto en el botón
//                               surface: Color.fromARGB(255, 255, 255,
//                                   255), // Color de fondo del calendario
//                               onSurface: Colors
//                                   .black, // Color del texto en el calendario
//                             ),
//                             dialogBackgroundColor: Colors.white,
//                           ),
//                           child: child!,
//                         );
//                       },
//                     );
//                     if (pickedDate != null) {
//                       String formattedDate =
//                           DateFormat('dd/MM/yyyy').format(pickedDate);
//                       setState(() {
//                         _dateController.text = formattedDate;
//                       });
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(
//                         0xFFFF7000), // Color de fondo del botón (#FF7000)
//                     minimumSize:
//                         const Size(double.infinity, 50), // Tamaño del botón
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(10), // Bordes redondeados
//                     ),
//                   ),
//                   onPressed: () {
//                     showLoadingScreen(context,
//                         destination: const RegisterSuccessScreen());
//                   },
//                   child: const Text(
//                     'Crear Cuenta',
//                     style: TextStyle(
//                       color: Colors.white, // Color del texto blanco
//                       fontWeight: FontWeight.bold, // Letras en negrita
//                       fontSize: 16, // Tamaño del texto
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Texto de ir al Login
//               TextButton(
//                 onPressed: () {
//                   showLoadingScreen(context, destination: const LoginScreen());
//                 },
//                 child: const Text(
//                   '¿Ya tienes cuenta? Inicia sesión',
//                   style: TextStyle(color: Color(0xFFFF7000)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/RegisterSuccessScreen.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/login.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controlador para el campo de fecha nacimiento
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _region;
  
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



  // Método para realizar la validación y enviar los datos
 // Método para realizar la validación y enviar los datos
  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Si la validación es correcta, enviar los datos
      final newUser = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'phone': _phoneController.text,
        'type': 'CLIENT', // Tipo siempre es CLIENT
      };

      try {
        final response = await http.post(
          Uri.parse('https://orangeteam-deliverybackend-production.up.railway.app/auth/register'),
          headers: {'accept': '*/*', 'Content-Type': 'application/json'},
          body: json.encode(newUser),
        );

        if (response.statusCode == 201) {
          // Si la respuesta es exitosa, redirige a la pantalla de éxito
          showLoadingScreen(context, destination: const RegisterSuccessScreen());
        } else {
          _showErrorDialog('Error al crear cuenta. Intenta nuevamente.\n${response.body}');
        }
      } catch (e) {
        _showErrorDialog('Ocurrió un error. Por favor verifica tu conexión.\n$e');
      }
    }
  }

  // Método para mostrar el diálogo de error
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,  // Aquí se agrega el formulario
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

                // Campo Nombre de Usuario
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

                // Campo Correo Electronico
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Correo Electronico',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
                        return 'Correo no válido';
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
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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

                // Campo Confirmar Contraseña
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
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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

                // Campo Región
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

                // Campo Teléfono
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                const SizedBox(height: 10),

                // Campo Fecha de Nacimiento
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
                                primary: Color(0xFFFF7000), // Color naranja
                                onPrimary: Color.fromARGB(255, 15, 15,
                                    15), // Color del texto en el botón
                                surface: Color.fromARGB(255, 255, 255,
                                    255), // Color de fondo del calendario
                                onSurface: Colors
                                    .black, // Color del texto en el calendario
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

                // Botón de Crear Cuenta
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
                    onPressed: _register, // Llamamos la función de registro
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
                const SizedBox(height: 10),

                // Texto de ir al Login
                TextButton(
                  onPressed: () {
                    showLoadingScreen(context, destination: const LoginScreen());
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
