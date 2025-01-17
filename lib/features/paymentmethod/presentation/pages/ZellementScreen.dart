import 'package:flutter/material.dart';

class PagoConZelleScreen extends StatefulWidget {
  final String monto;
  final String currency;

  const PagoConZelleScreen({
    Key? key,
    required this.monto,
    required this.currency,
  }) : super(key: key);

  @override
  _PagoConZelleScreenState createState() => _PagoConZelleScreenState();
}

class _PagoConZelleScreenState extends State<PagoConZelleScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // FocusNodes para controlar el foco de los campos
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _messageFocusNode = FocusNode();

  // Lista de prefijos telefónicos
  final List<String> _prefixes = [
    '+1',
    '+44',
    '+52',
    '+34',
    '+57',
    '+56',
    '+55',
    '+58',
  ];

  // Prefijo seleccionado
  String? _selectedPrefix = '+1';
  bool _isPrefixSelected = false;

  @override
  void dispose() {
    // Liberar los FocusNodes
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _amountFocusNode.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
                  isDarkMode
                      ? 'https://freepnglogo.com/images/all_img/1707675201zelle-logo-transparent.png'
                      : 'https://i.pinimg.com/736x/2f/1a/d8/2f1ad879c9586a7a6a314d95c4d7430d.jpg',
                  height: 50,
                ),
              ),
              const SizedBox(height: 20),

              // Correo electrónico
              _buildTitleText('Correo electrónico asociado a Zelle'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                decoration: _buildInputDecoration(
                  label: 'Correo electrónico',
                  hintText: 'usuario@correo.com',
                  icon: Icons.email,
                  isDarkMode: isDarkMode,
                  isFocused: _emailFocusNode.hasFocus,
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
              _buildTitleText('Teléfono asociado al Zelle'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildDropdown(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      decoration: _buildInputDecoration(
                        label: 'Número de teléfono',
                        hintText: '4265634985',
                        icon: Icons.phone,
                        isDarkMode: isDarkMode,
                        isFocused: _phoneFocusNode.hasFocus,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un número de teléfono';
                        }
                        if (value.length < 10) {
                          return 'Por favor debe tener al menos 10 dígitos';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Monto de la transacción
              _buildTitleText('Monto de la transacción'),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '\$${widget.currency} ${widget.monto}',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Mensaje opcional
              _buildTitleText('Mensaje opcional'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                focusNode: _messageFocusNode,
                decoration: _buildInputDecoration(
                  hintText: 'Escribe un mensaje para el destinatario',
                  isDarkMode: isDarkMode,
                  isFocused: _messageFocusNode.hasFocus,
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
                      Navigator.pop(context);
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
    );
  }

  Widget _buildTitleText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    IconData? icon,
    bool isDarkMode = false,
    String? label,
    bool isFocused = false,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      hintText: hintText,
      prefixIcon: icon != null
          ? Icon(
              icon,
              color: isFocused ? const Color(0xFFFF7000) : Colors.grey,
            )
          : null,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFF7000)),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isPrefixSelected ? const Color(0xFFFF7000) : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButton<String>(
        value: _selectedPrefix,
        onChanged: (String? newValue) {
          setState(() {
            _selectedPrefix = newValue;
            _isPrefixSelected = true;
          });
        },
        underline: Container(),
        items: _prefixes.map<DropdownMenuItem<String>>((String prefix) {
          return DropdownMenuItem<String>(
            value: prefix,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(prefix),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _confirmarPago(BuildContext context) {
    final email = _emailController.text;

    final message = _messageController.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
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
              'Tu pago de \$${widget.currency} ${widget.monto} ha sido procesado con éxito.',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF6D4C41),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Correo: $email',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF6D4C41),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Mensaje: ${message.isEmpty ? 'Sin mensaje' : message}',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF6D4C41),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed:(){
                Navigator.pop(context);
              },
            child: const Text(
              'Aceptar',
              style: TextStyle(
                color: Color(0xFFFF7000),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
