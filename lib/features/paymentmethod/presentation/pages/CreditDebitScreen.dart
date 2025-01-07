import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreditDebitScreen extends StatefulWidget {
  const CreditDebitScreen({super.key});

  @override
  _CreditDebitScreenState createState() => _CreditDebitScreenState();
}

class _CreditDebitScreenState extends State<CreditDebitScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBank;
  String? _selectedCardType; // Variable para almacenar el tipo de tarjeta
  String? _expirationDate;
  bool _saveCard = false;
  final List<String> _banks = [
    'Santander',
    'BBVA',
    'Azteca',
    'HSBC',
    'Scotiabank',
    'Banesco',
    'Mercantil',
    'BCV',
    'Banco De Venezuela'
  ];

  // Imágenes para los tipos de tarjeta
  final Map<String, String> _cardImages = {
    'Crédito':
        'https://static.wixstatic.com/media/85e2bf_7b77c4a0cde043f2a35bcf96f7ddfbd6~mv2.png/v1/fill/w_500,h_178,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Metodos%20de%20Pago.png',
    'Débito':
        'https://static.wixstatic.com/media/85e2bf_7b77c4a0cde043f2a35bcf96f7ddfbd6~mv2.png/v1/fill/w_500,h_178,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Metodos%20de%20Pago.png',
  };

  final Map<String, String> _bankImages = {
    'Santander':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuFNxu2YgCD8Fk9fFFW0awvMRf7ODPUfiGHtY47CxNjaz-hl8xsznxWk9MDIefIyO0bjE&usqp=CAU',
    'BBVA':
        'https://play-lh.googleusercontent.com/oraD6oZpIkoQ3ZAv3uOM-yggF5_8RIHB5QFcx__WccT2vr8uA9ffQmX95ExdMZuBzf8',
    'Azteca':
        'https://uvn-brightspot.s3.amazonaws.com/assets/vixes/pictures/picture-21529-1555339487.png',
    'HSBC':
        'https://1000logos.net/wp-content/uploads/2017/02/Colors-HSBC-Logo.jpg',
    'Scotiabank':
        'https://play-lh.googleusercontent.com/nU5R6xW3ge8zcnu6Rem25EjZjSxfjN607ra8sv4S_R12w06L41GisPHBZr75r_LcjXU=w240-h480-rw',
    'Banesco':
        'https://w7.pngwing.com/pngs/687/42/png-transparent-banesco-bank-mercantil-banco-banco-de-venezuela-finance-bank-payment-sphere-apk.png',
    'Mercantil':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPO9WeCmbCoaq0rKwYEGAnClJqfSTDSGEZ4Q&s',
    'BCV':
        'https://w7.pngwing.com/pngs/534/624/png-transparent-central-bank-of-venezuela-venezuelan-bolivar-bank-emblem-label-logo-thumbnail.png',
    'Banco De Venezuela':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWJUxYjB0jTxCPeLHVt0esGh9hUmUq-KW_AQ&s'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Pago con Tarjeta',
          style: TextStyle(
            color: Color.fromARGB(255, 175, 91, 7),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 175, 91, 7),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Información de Pago',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7000),
                ),
              ),
              const SizedBox(height: 20),
// Selección de banco
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Selecciona tu Banco',
                  labelStyle:
                      const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  prefixIcon: const Icon(Icons.account_balance),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFFF7000)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) =>
                      states.contains(WidgetState.focused)
                          ? const Color(0xFFFF7000)
                          : const Color.fromARGB(255, 0, 0, 0)),
                ),
                dropdownColor:
                    Colors.white, // Fondo blanco para la lista desplegable
                items: _banks.map((bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Row(
                      children: [
                        Image.network(
                          _bankImages[bank]!,
                          width: 30, // Ancho de la imagen
                          height: 30, // Alto de la imagen
                        ),
                        const SizedBox(width: 10),
                        Text(bank),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBank = value;
                    print('Selected bank: $_selectedBank');
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione un banco';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              if (_selectedBank != null)
                Text(
                  'Banco seleccionado: $_selectedBank',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 175, 91, 7),
                  ),
                ),
              const SizedBox(height: 15),
              Divider(height: 20, color: Colors.grey.shade400),
              const SizedBox(height: 15),
              // Selección de tipo de tarjeta (Crédito o Débito) con Radio Buttons
              Text(
                'Selecciona el tipo de tarjeta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 10),
              // Tarjeta de Crédito
              Row(
                children: [
                  Radio<String>(
                    value: 'Crédito',
                    groupValue: _selectedCardType,
                    onChanged: (value) {
                      setState(() {
                        _selectedCardType = value;
                      });
                    },
                    activeColor: _selectedCardType == 'Débito'
                        ? const Color.fromARGB(255, 51, 23, 2)
                        : const Color(0xFFFF7000),
                    // Cambia el color del círculo cuando se selecciona
                  ),
                  const Text('Crédito'),
                  const Spacer(),
                  // Imagen de tarjeta de crédito
                  if (_selectedCardType == 'Crédito')
                    Image.network(
                      _cardImages['Crédito']!,
                      width: 130,
                      height: 65,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Tarjeta de Débito
              Row(
                children: [
                  Radio<String>(
                    value: 'Débito',
                    groupValue: _selectedCardType,
                    onChanged: (value) {
                      setState(() {
                        _selectedCardType = value;
                      });
                    },
                    activeColor: _selectedCardType == 'Crédito'
                        ? const Color.fromARGB(255, 32, 15, 2)
                        : const Color(0xFFFF7000),
                  ),
                  const Text('Débito'),
                  const Spacer(),
                  // Imagen de tarjeta de débito
                  if (_selectedCardType == 'Débito')
                    Image.network(
                      _cardImages['Débito']!,
                      width: 130,
                      height: 65,
                    ),
                ],
              ),
              const SizedBox(height: 15),
              // Campo de número de tarjeta
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Número de Tarjeta',
                  labelStyle:
                      const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  hintText: '1234 5678 9101 1121',
                  prefixIcon: const Icon(Icons.credit_card),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFFF7000)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) =>
                      states.contains(WidgetState.focused)
                          ? const Color(0xFFFF7000)
                          : const Color.fromARGB(255, 0, 0, 0)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el número de la tarjeta';
                  }
                  if (value.length < 16) {
                    return 'El número de tarjeta debe tener al menos 16 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              // Campo de fecha de expiración con selector de Mes/Año
              GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await _selectMonthYear(context);
                  if (selectedDate != null) {
                    setState(() {
                      _expirationDate =
                          DateFormat('MM/yy').format(selectedDate);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Fecha de Expiración (MM/AA)',
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      hintText: 'MM/AA',
                      prefixIcon: const Icon(Icons.calendar_today),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFFF7000)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      prefixIconColor: WidgetStateColor.resolveWith((states) =>
                          states.contains(WidgetState.focused)
                              ? const Color(0xFFFF7000)
                              : const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    validator: (value) {
                      if (_expirationDate == null || _expirationDate!.isEmpty) {
                        return 'Por favor, selecciona la fecha de expiración';
                      }
                      return null;
                    },
                    controller: TextEditingController(text: _expirationDate),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Campo de CVV
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Código de Seguridad (CVV)',
                  labelStyle:
                      const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  hintText: 'Ejemplo: 123',
                  prefixIcon: const Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFFF7000)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) =>
                      states.contains(WidgetState.focused)
                          ? const Color(0xFFFF7000)
                          : const Color.fromARGB(255, 0, 0, 0)),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el código de seguridad';
                  }
                  if (value.length != 3) {
                    return 'El CVV debe tener 3 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              // Guardar tarjeta
              Row(
                children: [
                  Checkbox(
                    value: _saveCard,
                    onChanged: (value) {
                      setState(() {
                        _saveCard = value!;
                      });
                    },
                    activeColor: const Color(
                        0xFFFF7000), // Color naranja cuando se selecciona
                  ),
                  const Text('Guardar tarjeta para futuros pagos'),
                ],
              ),
              const SizedBox(height: 30),
              // Botón de acción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7000),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Dentro del método onPressed del botón Pagar:
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _confirmarPago(context);
                    }
                  },

                  child: const Text(
                    'Pagar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarPago(BuildContext context) {
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

  /// Método para seleccionar mes/año
  Future<DateTime?> _selectMonthYear(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month),
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF7000),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      return DateTime(picked.year, picked.month);
    }
    return null;
  }
}
