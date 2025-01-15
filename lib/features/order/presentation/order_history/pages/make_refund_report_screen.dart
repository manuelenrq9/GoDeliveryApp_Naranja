import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/data/make_order_report.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/widgets/report_dialog.dart';

class MakeRefundReportScreen extends StatefulWidget {
  final Order order;
  const MakeRefundReportScreen({super.key, required this.order});

  @override
  State<MakeRefundReportScreen> createState() => _MakeRefundReportScreenState();
}

class _MakeRefundReportScreenState extends State<MakeRefundReportScreen> {
   final TextEditingController _reportController 
   = TextEditingController(); // Controlador para el TextField
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Reporte',
          style: TextStyle(
            color: Color.fromARGB(255, 175, 91, 7),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 175, 91, 7)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 37,),
            Padding(
              padding: const EdgeInsets.only(right:13, left:13),
              child: Text(
                'Por favor escriba un justificativo para su solicitud de reembolso ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 22,),
            Padding(
              padding: const EdgeInsets.only(left:30, right: 30),
              child: TextField(
                controller: _reportController, // Asigna el controlador al TextField
                minLines: 15, // Número mínimo de líneas
                maxLines: null, // Permite que el campo de texto se expanda indefinidamente
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 22,),
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
  onPressed: () async {
    await makeOrderReport(widget.order.id, _reportController.text);
    showDialog(
      context: context, // Use the context from the build method
      builder: (BuildContext context) {
        return ReportDialog();
      },
    );
  },
  child: const Text(
    'Enviar reporte',
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  ),
),

                    ),
          ],
        ) ,
      ),
    );
  }
}