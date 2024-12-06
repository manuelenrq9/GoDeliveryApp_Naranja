import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/loading_screen.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/ForgotPasswordScreen.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:godeliveryapp_naranja/features/log_In/presentation/pages/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:
                    //Campo Correo/Usuario
                    TextField(
                  decoration: InputDecoration(
                    hintText: 'Email/Usuario',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //Campo Contraseña
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  obscureText:
                      !_isPasswordVisible, // Controla la visibilidad de la contraseña
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    prefixIcon:
                        const Icon(Icons.lock), // Candado a la izquierda
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Ícono de ojo a la derecha
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xFFFF7000), // Color de fondo del botón (#FF7000)
                    minimumSize:
                        const Size(double.infinity, 50), // Tamaño del botón
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Bordes redondeados
                    ),
                  ),
                  onPressed: () {
                    showLoadingScreen(context, destination: const MainMenu());
                  },
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      color: Colors.white, // Color del texto blanco
                      fontWeight: FontWeight.bold, // Letras en negrita
                      fontSize: 16, // Tamaño del texto
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),

              //Texto Olvide mi contraseña
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    showLoadingScreen(context,
                        destination: ForgotPasswordScreen());
                  },
                  child: const Text(
                    'Olvidé mi contraseña',
                    style: TextStyle(color: Color(0xFFFF7000)),
                  ),
                ),
              ),

              //Texto Registrarme
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    showLoadingScreen(context,
                        destination: const RegisterScreen());
                  },
                  child: const Text(       
                  '¿No tienes cuenta? Regístrate',
                  style: TextStyle(color: Color(0xFFFF7000)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
