import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/paymentmethod/presentation/pages/CreditDebitScreen.dart';
import 'package:godeliveryapp_naranja/features/paymentmethod/presentation/pages/MobilePaymentScreen.dart';
import 'package:godeliveryapp_naranja/features/paymentmethod/presentation/pages/ZellementScreen.dart';
import 'package:godeliveryapp_naranja/features/paymentmethod/presentation/widgets/PaymentMethodCard.dart';

class ProcessOrderScreen extends StatefulWidget {
  @override
  _ProcessOrderScreenState createState() => _ProcessOrderScreenState();
}

class _ProcessOrderScreenState extends State<ProcessOrderScreen> {
  bool _isProcessing = false;

  void _confirmOrder() async {
    setState(() {
      _isProcessing = true;
    });

    // Simula el procesamiento de la orden
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    // Aquí puedes agregar la lógica para procesar la orden final
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Orden confirmada con éxito'),
        backgroundColor: Colors.green, // Color de fondo verde
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Procesar Orden',
            style: TextStyle(
              color: Color.fromARGB(255, 175, 91, 7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 175, 91, 7), // Color del icono de back
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen de la orden
            Card(
              color: Colors.white, // Color de fondo blanco
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 10,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen del Pedido',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 175, 91, 7),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Producto A
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://res.cloudinary.com/walmart-labs/image/upload/d_default.jpg/w_960,dpr_auto,f_auto,q_auto:best/gr/images/product-images/img_large/00003746602342l.jpg', // URL de la imagen del producto A
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: const Text('chocolate amargo lindt'),
                      subtitle: const Text('Cantidad: 2'),
                      trailing: const Text(
                        '\$20.00',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Producto B
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQcjHLspxubA3NbVRQaMxhj9w47cLiEgR1ww&s', // URL de la imagen del producto B
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: const Text('Sopa Maruchan de Pollo'),
                      subtitle: const Text('Cantidad: 1'),
                      trailing: const Text(
                        '\$15.00',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Total: \$35.00',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Selección de método de pago
            const Text(
              'Selecciona un Método de Pago',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 175, 91, 7),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                PaymentMethodCard(
                  icon: Icons.credit_card,
                  title: 'Tarjeta de Crédito/Débito',
                  description: 'Paga con tu tarjeta de manera segura.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreditDebitScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                PaymentMethodCard(
                  icon: Icons.phone_android,
                  title: 'Pago Móvil',
                  description:
                      'Realiza el pago a través de tu dispositivo móvil.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MobilePaymentScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                PaymentMethodCard(
                  icon: Icons.attach_money,
                  title: 'zelle',
                  description: 'Paga con Zelle de manera segura y eficiente.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PagoConZelleScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF7000),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isProcessing ? null : _confirmOrder,
                    child: _isProcessing
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Confirmar Orden',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF7000)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isProcessing
                        ? null
                        : () {
                            // Cancelar y regresar
                            Navigator.pop(context);
                          },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                          fontSize: 16, color: Color.fromARGB(255, 175, 91, 7)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
