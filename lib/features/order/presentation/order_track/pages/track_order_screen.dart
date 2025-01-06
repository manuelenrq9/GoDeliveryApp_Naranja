import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/widgets/courier_info_section.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/widgets/delivery_info_section.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/widgets/eta_and_tracking_section.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/widgets/order_details_section.dart';

class TrackOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size; // Obtener el tamaño de la pantalla

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Seguimiento del pedido",
          style: TextStyle(
            color: Color.fromARGB(255, 175, 91, 7),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 175, 91, 7)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DeliveryInfoSection(size: size),
              // const Divider(),
              // CourierInfoSection(),
              // const Divider(),
              // OrderDetailsSection(),
              // const SizedBox(height: 16),
              ETAAndTrackingSection(),
            ],
          ),
        ),
      ),
    );
  }
}
