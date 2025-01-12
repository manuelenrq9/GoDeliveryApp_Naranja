import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DeliveryDate extends StatefulWidget {
  final Order order;
  DeliveryDate({Key? key, required this.order}) : super(key: key);

  @override
  _DeliveryDateState createState() => _DeliveryDateState();
}

class _DeliveryDateState extends State<DeliveryDate> {
  String createdDate = '';
  String deliveredDate = '';
  String _deliveryDate = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES').then((_) {
      setState(() {
        createdDate = formatDate(widget.order.createdDate);
        deliveredDate = formatDate(widget.order.receivedDate);
        _deliveryDate = deliveredDate;
      });
    });
  }

  String formatDate(DateTime dateTime) {
    // Format the DateTime object into the desired format in Spanish
    return DateFormat('EEE dd MMM yyyy', 'es_ES').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Indicador de fecha de entrega
          Flexible(
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFFFF7000),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _deliveryDate,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Botón de cambiar fecha
          TextButton(
            onPressed: () {
              _editDeliveryDate(context);
            },
            child: const Icon(
              Icons.edit,
              color: Color(0xFFCD5B06),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 30),
            ),
          ),
        ],
      ),
    );
  }

  void _editDeliveryDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime minDate = today;
    final DateTime maxDate =
        today.add(const Duration(days: 7)); // Una semana después

    final DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Editar la fecha de entrega:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Entrega:',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: today,
                          firstDate: minDate,
                          lastDate: maxDate,
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFFFF7000),
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                                dialogBackgroundColor: Colors.white,
                                textTheme: TextTheme(
                                  headlineSmall: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  bodyLarge: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (date != null) {
                          Navigator.of(context).pop(date);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Seleccionar día'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cerrar',
              ),
            ),
          ],
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _deliveryDate = formatDate(pickedDate);
      });
    }
  }
}
