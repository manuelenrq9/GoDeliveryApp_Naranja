import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/data/cancel_order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/pages/order_history_screen.dart';

class CancelOrderDialog extends StatelessWidget {

  final Order order;

   const CancelOrderDialog({
    Key? key,
    required this.order, // Parámetro en el constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('CANCELAR ORDEN'),
            SizedBox(height: 10),
            Text('¿Estas seguro de cancelar la orden?'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Regresar'),
                  onPressed: () {
                    // Add your logic here for what happens when Continue is pressed
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>OrderHistoryScreen()));
                  },
                  style: TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 207, 204, 204) ),
                ),
                SizedBox(width: 5,),
                TextButton(
                  child: Text('Cancelar Orden'),
                  onPressed: () async {
                    // Add your logic here for what happens when Continue is pressed
                    await cancelOrder(context, order.id);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>OrderHistoryScreen()));
                  },
                  style: TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 207, 204, 204) ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
