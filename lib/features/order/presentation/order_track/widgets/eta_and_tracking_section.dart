import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/widgets/distanceDelivery.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ETAAndTrackingSection extends StatelessWidget {
  final double latitude; // Recibe latitud
  final double longitude; // Recibe longitud
  final String status; // Recibe status de la orden

  const ETAAndTrackingSection({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 600, // Altura del mapa
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DeliveryTrackingScreen(
                      deliveryDestination: LatLng(latitude, longitude), // Propagar LatLng
                      orderStatus: status, // Propagar Status
                    ), // Llamas la clase MapScreen
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
