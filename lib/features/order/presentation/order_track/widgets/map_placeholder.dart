import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Location location = Location();
  List<LatLng> trail = [];
  List<Marker> markers = [];
  LatLng currentLocation = LatLng(10.4806, -66.9036);
  final MapController mapController = MapController();
  bool isDarkMode = false;

  final String lightMapStyle =
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  final String darkMapStyle =
      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';

  late String currentMapStyle;

  @override
  void initState() {
    super.initState();
    currentMapStyle = lightMapStyle;
    _initLocation();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Mantener la ubicación actual sin mover el mapa automáticamente
    location.onLocationChanged.listen((LocationData locData) {
      setState(() {
        currentLocation = LatLng(locData.latitude!, locData.longitude!);
        trail.add(currentLocation);
      });
    });
  }

  double calculateTotalDistance(List<LatLng> trail) {
    double totalDistance = 0.0;
    for (int i = 0; i < trail.length - 1; i++) {
      totalDistance += Distance().as(
        LengthUnit.Meter,
        trail[i],
        trail[i + 1],
      );
    }
    return totalDistance;
  }

  void simulateMovement(LatLng targetLocation) {
    const int steps = 100; // Número de pasos para el movimiento
    final double stepLat =
        (targetLocation.latitude - currentLocation.latitude) / steps;
    final double stepLng =
        (targetLocation.longitude - currentLocation.longitude) / steps;

    for (int i = 0; i <= steps; i++) {
      Future.delayed(Duration(milliseconds: 50 * i), () {
        setState(() {
          currentLocation = LatLng(
            currentLocation.latitude + stepLat,
            currentLocation.longitude + stepLng,
          );
          trail.add(
              currentLocation); // Añadir a la ruta para que se dibuje la línea
          mapController.move(
              currentLocation, 16.0); // Mover el mapa hacia la nueva ubicación
        });
      });
    }
  }

  Widget buildCustomFab(
      {required IconData icon, required VoidCallback onPressed}) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: const Color.fromARGB(255, 255, 255, 255), // Fondo naranja
      shape: const CircleBorder(),
      elevation: 4.0,
      padding: const EdgeInsets.all(15.0),
      child: Icon(
        icon,
        color: Color(0xFFFF7000), // Ícono en blanco
        size: 18.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentLocation,
              initialZoom: 16.0,
              onTap: (_, LatLng latLng) {
                setState(() {
                  trail.add(latLng); // Añadir punto a la ruta
                  markers.add(
                    Marker(
                      point: latLng, // El punto donde el usuario hizo clic
                      child: const Icon(
                        Icons.circle,
                        size: 20.0,
                        color: Color.fromARGB(255, 252, 90, 26),
                      ),
                    ),
                  );
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: currentMapStyle,
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: trail,
                    strokeWidth: 4.0,
                    color: Color(0xFFFF7000),
                  ),
                ],
              ),
              MarkerLayer(
                markers: markers,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentLocation, // Ubicación actual
                    child: const Icon(
                      Icons.location_on,
                      size: 40.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white.withOpacity(0.8),
              child: Text(
                'Distancia: ${calculateTotalDistance(trail).toStringAsFixed(2)} m',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildCustomFab(
            icon: Icons.my_location,
            onPressed: () {
              mapController.move(
                  currentLocation, 16.0); // Mover el mapa a la ubicación actual
            },
          ),
          SizedBox(height: 10),
          buildCustomFab(
            icon: Icons.clear,
            onPressed: () {
              setState(() {
                trail.clear();
                markers.clear();
              });
            },
          ),
          SizedBox(height: 10),
          buildCustomFab(
            icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
                currentMapStyle = isDarkMode ? darkMapStyle : lightMapStyle;
              });
            },
          ),
          SizedBox(height: 10),
          buildCustomFab(
            icon: Icons.directions_run,
            onPressed: () {
              if (markers.isNotEmpty) {
                // Simula el movimiento hacia el último marcador que el usuario ha puesto
                simulateMovement(markers.last.point);
              }
            },
          ),
        ],
      ),
    );
  }
}
