import 'package:flutter/material.dart';

class DeliveryTime extends StatefulWidget {
  @override
  _DeliveryTimeState createState() => _DeliveryTimeState();
}

class _DeliveryTimeState extends State<DeliveryTime> {
  String _deliveryTime = 'Entrega a las 15:00 pm'; // Estado inicial de la hora

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 36, 36, 36)
            : Colors.white,
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
          // Indicador de hora de entrega
          Flexible(
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Color(0xFFFF7000),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _deliveryTime,
                    overflow:
                        TextOverflow.ellipsis, // Texto con puntos suspensivos
                    maxLines: 1, // Limita el texto a una línea
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Botón de cambiar hora
          TextButton(
            onPressed: () {
              _editDeliveryTime(context);
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

  void _editDeliveryTime(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Editar la hora de entrega',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Entrega a:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      // Configurar hora inicial a las 6:00 PM
                      TimeOfDay initialTime =
                          const TimeOfDay(hour: 18, minute: 0);

                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: const Color(0xFFFF7000),
                              buttonTheme: const ButtonThemeData(
                                textTheme: ButtonTextTheme.primary,
                              ),
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFFFF7000),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (selectedTime != null) {
                        String period =
                            selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
                        setState(() {
                          _deliveryTime =
                              'Entrega a las ${selectedTime.format(context)} $period';
                        });
                        Navigator.of(context).pop(); // Cierra el diálogo actual
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Seleccionar hora',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
          ],
        );
      },
    );
  }
}
