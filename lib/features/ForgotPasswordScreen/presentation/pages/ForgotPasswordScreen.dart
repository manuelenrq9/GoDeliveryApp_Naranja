import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/ForgotPasswordScreen/presentation/pages/recoveryPasswordMessague.dart'; // Asegúrate de importar correctamente el mensaje

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Usamos un controlador de formulario para validar
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Olvidé mi Contraseña",
          style: TextStyle(
            color: Color.fromARGB(255, 175, 91, 7),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 175, 91, 7), // Cambia el color aquí
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.lock_outline,
                  size: 100,
                  color: Color(0xFFFF7000),
                ),
                const SizedBox(height: 20),
                Text(
                  "Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey, // Asignamos la clave del formulario
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un correo electrónico';
                          }
                          // Validación simple de correo electrónico
                          String pattern =
                              r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\b';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value)) {
                            return 'Por favor ingresa un correo electrónico válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Llamamos a la validación antes de hacer cualquier acción
                          if (_formKey.currentState!.validate()) {
                            // Si la validación es correcta, se navega a la siguiente pantalla
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecoverypasswordmessagueScreen(),
                              ),
                            );
                          } else {
                            // Si no es válido, mostramos un mensaje de error
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Por favor ingresa un correo válido')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7000),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Enviar Enlace de Recuperación",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
