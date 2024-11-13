import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/presentation/interfaces/loading_screen.dart';
import 'package:godeliveryapp_naranja/presentation/interfaces/login.dart';
import 'package:intl/intl.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  //Controlador para el campo de fecha nacimiento
  final TextEditingController _dateController = TextEditingController(); 

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
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
                child:
                    //Campo Usuario
                    TextField(
                        decoration: InputDecoration(
                        hintText: 'Nombre de Usuario',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person),
                )),
              ),
              const SizedBox(height: 10),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:
                    //Campo Correo Electronico
                    TextField(
                        decoration: InputDecoration(
                        hintText: 'Correo Electronico',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.email),
                    )),
              ),
              const SizedBox(height: 10),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
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
                ),
              ),
              const SizedBox(height: 10),

              // Campo Confirmar Contraseña
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
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
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:
                    //Campo Region
                    TextField(
                        decoration: InputDecoration(
                        hintText: 'Región',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.public),
                    )),
              ),
              const SizedBox(height: 10),


              // Campo Código de País | Teléfono
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Prefijo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 5,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Teléfono',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),



              // Campo Fecha de Nacimiento
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
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
                ),
              ),
              const SizedBox(height: 20),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7000), // Color de fondo del botón (#FF7000)
                    minimumSize:
                        const Size(double.infinity, 50), // Tamaño del botón
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Bordes redondeados
                    ),
                  ),
                  onPressed: () {
                    showLoadingScreen(context,destination: const LoginScreen());
                  },
                  child: const Text(
                    'Crear Cuenta',
                    style: TextStyle(
                      color: Colors.white, // Color del texto blanco
                      fontWeight: FontWeight.bold, // Letras en negrita
                      fontSize: 16, // Tamaño del texto
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Texto de ir al Login
              TextButton(
                onPressed: () {
                  showLoadingScreen(context,destination: const LoginScreen());
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
    );
  }
}
