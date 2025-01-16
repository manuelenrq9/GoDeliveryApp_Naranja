import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobilePaymentScreen extends StatefulWidget {
  final String monto;
  final String currency;

  MobilePaymentScreen({
    Key? key,
    required this.monto,
    required this.currency,
  }) : super(key: key);

  @override
  _MobilePaymentScreenState createState() => _MobilePaymentScreenState();
}

class _MobilePaymentScreenState extends State<MobilePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
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
  String? _selectedBank;

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

  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _idFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _idController.dispose();
    _phoneFocusNode.dispose();
    _idFocusNode.dispose();
    super.dispose();
  }

  void _showProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7000)),
              ),
              SizedBox(height: 20),
              Text(
                'Procesando pago...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      _showSuccessDialog(context);
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copiado al portapapeles: $text',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 212, 212, 212),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Pago Móvil',
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
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos de pago móvil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 175, 91, 7),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCardWithCopy('0105 - Mercantil', Icons.copy),
                    const SizedBox(height: 10),
                    _buildInfoCardWithCopy('J-000667616', Icons.copy),
                    const SizedBox(height: 10),
                    _buildInfoCardWithCopy('0414-2374667', Icons.copy),
                    const SizedBox(height: 10),
                    _buildInfoCardWithCopy('${widget.currency} ${widget.monto}', Icons.copy),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ingrese los datos del pago móvil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 175, 91, 7),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Expanded(
                  //   flex: 2,
                  //   child: DropdownButtonFormField<String>(
                  //     decoration: InputDecoration(
                  //       labelText: 'Prefijo',
                  //       labelStyle: const TextStyle(
                  //           color: Color.fromARGB(255, 0, 0, 0)),
                  //       filled: true,
                  //       fillColor: Colors.white,
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide:
                  //             const BorderSide(color: Color(0xFFFF7000)),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //     dropdownColor: Colors.white,
                  //     items: [
                  //       '+58',
                  //       '+1',
                  //       '+44',
                  //       '+49',
                  //       '+34',
                  //       '+39',
                  //       '+81',
                  //       '+86',
                  //       '+91'
                  //     ].map((String prefix) {
                  //       return DropdownMenuItem<String>(
                  //         value: prefix,
                  //         child: Text(prefix),
                  //       );
                  //     }).toList(),
                  //     onChanged: (value) {
                  //       // Handle prefix change if needed
                  //     },
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Seleccione';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
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
                  ),
                ],
              ),
              const SizedBox(height: 15),
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
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Prefijo',
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
                        '+58',
                        '+1',
                        '+44',
                        '+49',
                        '+34',
                        '+39',
                        '+81',
                        '+86',
                        '+91'
                      ].map((String prefix) {
                        return DropdownMenuItem<String>(
                          value: prefix,
                          child: Text(prefix),
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
                      focusNode: _idFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Número de telefono',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0)),
                        hintText: '4265634985',
                        prefixIcon: Icon(
                          Icons.phone,
                          color: _idFocusNode.hasFocus
                              ? Color(0xFFFF7000)
                              : const Color.fromARGB(255, 0, 0, 0),
                        ),
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
                          return 'Por favor ingrese el número de telefono';
                        }
                        if (value.length < 10) {
                          return ' Por favor debe tener 10 dígitos';
                        }
                        return null;
                      },
                      onTap: () {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _showProcessingDialog(context);
                        Future.delayed(const Duration(seconds: 3), () {
                          Navigator.pop(
                              context); // Cierra el diálogo de procesamiento
                          _showSuccessDialog(
                              context); // Muestra el mensaje de éxito
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7000),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.orangeAccent,
                      elevation: 5,
                    ),
                    child: const Text(
                      'Realizar pago',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCardWithCopy(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: Icon(icon, color: const Color(0xFFFF7000)),
          onPressed: () => _copyToClipboard(title),
        ),
      ),
    );
  }
}

void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // No se puede cerrar tocando fuera del cuadro
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Color(0xFFFF7000),
              size: 50,
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Pago Móvil Realizado Exitosamente!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF7000),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'El pago se ha procesado correctamente. Detalles del pago: \n\n'
              'Banco: Mercantil\nReferencia: 0105 - Mercantil\nMonto: \$35',
              style: TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el cuadro de diálogo
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF7000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    },
  );
}
