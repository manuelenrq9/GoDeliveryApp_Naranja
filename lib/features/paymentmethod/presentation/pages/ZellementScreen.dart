import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PagoConZelleScreen extends StatefulWidget {
  @override
  _PagoConZelleScreenState createState() => _PagoConZelleScreenState();
}

class _PagoConZelleScreenState extends State<PagoConZelleScreen> {
  final _emailController = TextEditingController();

  final _amountController = TextEditingController();
  final _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FocusNode _phoneFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFFF7000), // Naranja cuando está enfocado
              width: 2.0,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Zelle',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 175, 91, 7),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 175, 91, 7),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    'https://i.pinimg.com/736x/2f/1a/d8/2f1ad879c9586a7a6a314d95c4d7430d.jpg',
                    height: 50,
                  ),
                ),
                const SizedBox(height: 20),

                // Correo electrónico
                const Text(
                  'Correo electrónico asociado a Zelle',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    labelStyle:
                        const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    hintText: 'usuario@correo.com',
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    prefixIconColor: WidgetStateColor.resolveWith((states) =>
                        states.contains(WidgetState.focused)
                            ? const Color(0xFFFF7000)
                            : const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un correo electrónico';
                    }
                    const emailRegex =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    if (!RegExp(emailRegex).hasMatch(value)) {
                      return 'Por favor ingresa un correo válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Teléfono
                const Text(
                  'Teléfono asociado al Zelle',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: '+58', // Set the default value to '+58'
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFFF7000)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        dropdownColor: Colors.white,
                        items: [
                          {
                            'prefix': '+58',
                            'flag': 'https://flagcdn.com/w320/ve.png'
                          },
                          {
                            'prefix': '+1',
                            'flag': 'https://flagcdn.com/w320/us.png'
                          },
                          {
                            'prefix': '+44',
                            'flag': 'https://flagcdn.com/w320/gb.png'
                          },
                          {
                            'prefix': '+49',
                            'flag': 'https://flagcdn.com/w320/de.png'
                          },
                          {
                            'prefix': '+34',
                            'flag': 'https://flagcdn.com/w320/es.png'
                          },
                          {
                            'prefix': '+39',
                            'flag': 'https://flagcdn.com/w320/it.png'
                          },
                          {
                            'prefix': '+81',
                            'flag': 'https://flagcdn.com/w320/jp.png'
                          },
                          {
                            'prefix': '+86',
                            'flag': 'https://flagcdn.com/w320/cn.png'
                          },
                          {
                            'prefix': '+91',
                            'flag': 'https://flagcdn.com/w320/in.png'
                          }
                        ].map((Map<String, String> prefix) {
                          return DropdownMenuItem<String>(
                            value: prefix['prefix'],
                            child: Row(
                              children: [
                                Image.network(
                                  prefix['flag']!,
                                  width: 18,
                                  height: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(prefix['prefix']!),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          // Handle prefix change if needed
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleccione ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        focusNode: _phoneFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Número de Referencia',
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          hintText: '4265634985',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFFF7000)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el número de referencia';
                          }
                          if (value.length < 10) {
                            return 'Por favor debe tener  10 dígitos';
                          }
                          return null;
                        },
                        onTap: () {
                          setState(() {});
                        },
                      ),
                    ), // Dropdown para seleccionar el prefijo

                    // Input para el número de teléfono
                  ],
                ),
                const SizedBox(height: 20),

                // Monto de la transacción
                const Text(
                  'Monto de la transacción',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    hintText: '\$0.00',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    prefixIconColor: WidgetStateColor.resolveWith((states) =>
                        states.contains(WidgetState.focused)
                            ? const Color(0xFFFF7000)
                            : const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un monto';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingresa un monto válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Mensaje opcional
                const Text(
                  'Mensaje opcional',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje para el destinatario',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 30),

                // Botón confirmar
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _confirmarPago(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7000),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirmar pago con Zelle',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmarPago(BuildContext context) {
    final email = _emailController.text;
    final amount = _amountController.text;
    final message = _messageController.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 24.0,
        title: const Center(
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Color(0xFFFF7000),
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                'Pago realizado',
                style: TextStyle(
                  color: Color(0xFFFF7000),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tu pago de \$${amount} ha sido procesado con éxito.',
              style: const TextStyle(
                color: Color(0xFF6D4C41),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Correo: $email',
              style: const TextStyle(
                color: Color(0xFF6D4C41),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Mensaje: ${message.isEmpty ? "Sin mensaje" : message}',
              style: const TextStyle(
                color: Color(0xFF6D4C41),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pop(context); // Regresa a ProcessOrderScreen
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(
                  color: Color(0xFFFF7000),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
