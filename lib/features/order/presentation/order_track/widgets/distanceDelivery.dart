import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:latlong2/latlong.dart' as latlong;

class DeliveryTrackingScreen extends StatefulWidget {
  final LatLng deliveryDestination;

  const DeliveryTrackingScreen({super.key, required this.deliveryDestination});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  GoogleMapController? mapController;
  LatLng _deliveryLocation = const LatLng(10.3878430, -66.9599546); // Punto de inicio
  Location _locationService = Location();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _routePoints = [];
  Timer? _deliveryTimer;
  int _currentRouteIndex = 0;
  bool _isDelivering = false;
  double _eta = 0.0; 
  double _speedKmH = 40; // ✅ Velocidad Promedio del Motorizado (40 km/h)
  String googleApiKey = "AIzaSyDN2oEm1jKZK8nxkS7u1YmRE_bWYvuKl6o"; // ✅ Reemplazar con tu clave API válida

  @override
  void initState() {
    super.initState();
    _fetchRouteFromGoogleMaps();
  }

  /// ✅ 1. Obtener la Ruta y Calcular ETA con Google Directions API
  Future<void> _fetchRouteFromGoogleMaps() async {
    try {
      final Dio dio = Dio();
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '${_deliveryLocation.latitude},${_deliveryLocation.longitude}',
          'destination': '${widget.deliveryDestination.latitude},${widget.deliveryDestination.longitude}',
          'key': googleApiKey,
          'mode': 'driving',
        },
      );

      if (response.data['status'] == 'OK') {
        final points = PolylinePoints().decodePolyline(
          response.data['routes'][0]['overview_polyline']['points'],
        );

        setState(() {
          _routePoints = points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          _polylines.add(Polyline(
            polylineId: const PolylineId('deliveryRoute'),
            color: Colors.blue,
            width: 5,
            points: _routePoints,
          ));

          // ✅ Agregar el marcador del destino
          _markers.add(
            Marker(
              markerId: const MarkerId('destination'),
              position: widget.deliveryDestination,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            ),
          );

          // ✅ Calcular ETA basado en Google Directions
          _eta = response.data['routes'][0]['legs'][0]['duration']['value'] / 60; // Minutos
        });

        _startDeliveryAlongRoute();
      } else {
        _showErrorSnackBar("Error al obtener la ruta: ${response.data['status']}");
      }
    } catch (e) {
      _showErrorSnackBar("Error al obtener la ruta: $e");
    }
  }

  /// ✅ 2. Calcular la Distancia Restante entre la Ubicación Actual y el Destino
  double _calculateDistance(LatLng start, LatLng end) {
    final distance = latlong.Distance();
    return distance.as(
        latlong.LengthUnit.Kilometer,
        latlong.LatLng(start.latitude, start.longitude),
        latlong.LatLng(end.latitude, end.longitude));
  }

  /// ✅ 3. Actualizar ETA Basado en Distancia y Velocidad
  void _updateETA() {
    double distanceRemaining = _calculateDistance(
        _deliveryLocation, widget.deliveryDestination);
    
    // ✅ Calcular ETA basado en la distancia y la velocidad
    _eta = (distanceRemaining / _speedKmH) * 60; // Convertido a minutos
  }

  /// ✅ 4. Simular el Movimiento del Motorizado con ETA Dinámico
  void _startDeliveryAlongRoute() {
    _isDelivering = true;
    _deliveryTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentRouteIndex < _routePoints.length) {
        setState(() {
          _deliveryLocation = _routePoints[_currentRouteIndex];
          _currentRouteIndex++;
          _updateETA(); // ✅ Actualizar ETA basado en la distancia real
          _markers.add(
            Marker(
              markerId: const MarkerId('deliveryPerson'),
              position: _deliveryLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          );
        });
        mapController?.animateCamera(CameraUpdate.newLatLng(_deliveryLocation));
      } else {
        timer.cancel();
        _showDeliveryCompletedDialog();
      }
    });
  }

  /// ✅ 5. Mostrar un Mensaje de Error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  /// ✅ 6. Mostrar Alerta al Llegar
  void _showDeliveryCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Entrega Completa'),
        content: const Text('El motorizado ha llegado al destino.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento del Motorizado')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _deliveryLocation, zoom: 12),
        markers: _markers,
        polylines: _polylines,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRouteFromGoogleMaps,
        child: const Icon(Icons.directions_car),
      ),
      // ✅ Mostrar ETA Actualizado en Tiempo Real
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Tiempo Estimado de Llegada: ${_eta.toStringAsFixed(0)} min",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _deliveryTimer?.cancel();
    mapController?.dispose();
    super.dispose();
  }
}
