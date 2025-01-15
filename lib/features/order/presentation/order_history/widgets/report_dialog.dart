import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/pages/order_history_screen.dart';

class ReportDialog extends StatelessWidget {

  const ReportDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reporte enviado'),
            SizedBox(height: 10),
            Text('Tu reporte ha sido enviado para su revisión.'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Continuar'),
                  onPressed: () {
                    // Add your logic here for what happens when Continue is pressed
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>OrderHistoryScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
