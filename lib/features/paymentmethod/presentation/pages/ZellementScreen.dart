import 'package:flutter/material.dart';

class PagoConZelleScreen extends StatefulWidget {
  @override
  _PagoConZelleScreenState createState() => _PagoConZelleScreenState();
}

class _PagoConZelleScreenState extends State<PagoConZelleScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Lista de prefijos telefónicos
  final List<String> _prefixes = [
    '+1', '+44', '+52', '+34', '+57', '+56',
    '+55', '+58' // Agrega los prefijos que necesites
  ];

  // Prefijo seleccionado
  String? _selectedPrefix = '+1';
  bool _isPrefixSelected =
      false; // Estado para detectar si se seleccionó el prefijo

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
                    // Dropdown para seleccionar el prefijo
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isPrefixSelected
                              ? const Color(
                                  0xFFFF7000) // Naranja cuando está seleccionado
                              : Colors.grey, // Gris cuando no está seleccionado
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedPrefix,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPrefix = newValue;
                            _isPrefixSelected =
                                true; // Cambiar el estado a seleccionado
                          });
                        },
                        underline:
                            Container(), // Quitar el subrayado predeterminado
                        isExpanded: false, // Evitar que el dropdown se expanda
                        items: _prefixes
                            .map<DropdownMenuItem<String>>((String prefix) {
                          return DropdownMenuItem<String>(
                            value: prefix,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(prefix),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Input para el número de teléfono
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Número de telefono',
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          hintText: '4265634985',
                          prefixIcon: const Icon(Icons.phone),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          prefixIconColor: WidgetStateColor.resolveWith(
                              (states) => states.contains(WidgetState.focused)
                                  ? const Color(0xFFFF7000)
                                  : const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un número de teléfono';
                          }
                          if (value.length < 10) {
                            return ' Por favor debe tener al menos 10 dígitos';
                          }
                          return null;
                        },
                      ),
                    ),
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
