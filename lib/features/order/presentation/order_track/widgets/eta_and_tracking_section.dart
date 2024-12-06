import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/widgets/map_placeholder.dart';
// Importa MapScreen

import 'tracking_step.dart';

class ETAAndTrackingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ETA: 15 minutes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFFFF7000),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const TrackingStep(
                    label: "Pedido realizado",
                    time: "2:30 PM, 27 Jun 2020",
                    isActive: true,
                  ),
                  const Divider(),
                  const TrackingStep(
                    label: "Artículos procesados",
                    time: "Embolsado en almacén a las 2:40 PM",
                    isActive: true,
                  ),
                  const Divider(),
                  const TrackingStep(
                    label: "Delivering",
                    time: "Tu orden está en camino",
                    isActive: true,
                  ),
                  const SizedBox(height: 16),

                  // Aquí llamas al MapScreen
                  Container(
                    width: double.infinity,
                    height: 350, // Altura del mapa
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MapScreen(), // Llamas la clase MapScreen
                  ),
                  const Divider(),
                  const TrackingStep(
                    label: "Compras entregadas",
                    time: "Esperada a las 3:05 PM, 27 Jun 2020",
                    isActive: false,
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
