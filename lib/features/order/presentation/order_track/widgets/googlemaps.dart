import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen2 extends StatefulWidget {
  const MapScreen2({super.key});

  @override
  State<MapScreen2> createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(10.3574598,-66.9660037); // San Francisco
  Location _locationService = Location();
  LatLng? _userLocation;
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};  // ✅ Set actualizado para contener solo 1 marcador por tipo
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _goToUserLocation();  
  }

  // ✅ Optimizado para mantener solo un marcador de ubicación
  Future<void> _goToUserLocation() async {
    if (_isLoadingLocation) return; 
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
      }

      var permission = await _locationService.requestPermission();
      if (permission != PermissionStatus.granted) return;

      var locationData = await _locationService.getLocation();

      // ✅ Eliminar marcador anterior antes de añadir uno nuevo
      _markers.removeWhere((marker) => marker.markerId == const MarkerId('userLocation'));

      setState(() {
        _userLocation = LatLng(locationData.latitude!, locationData.longitude!);
        _markers.add(Marker(
          markerId: const MarkerId('userLocation'),
          position: _userLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      });

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_userLocation!, 16.0),
      );
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  // ✅ Selección de un solo punto en el mapa con un solo marcador
  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLocation = position;
      // ✅ Eliminar marcador anterior antes de añadir uno nuevo
      _markers.removeWhere((marker) => marker.markerId == const MarkerId('selectedLocation'));

      _markers.add(Marker(
        markerId: const MarkerId('selectedLocation'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    });
    mapController.animateCamera(CameraUpdate.newLatLng(position));
    _showSelectedLocationDialog(position);
  }

  // ✅ Mostrar un diálogo con la ubicación seleccionada
  void _showSelectedLocationDialog(LatLng position) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubicación Seleccionada'),
        content: Text('Latitud: ${position.latitude}, Longitud: ${position.longitude}'),
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
      appBar: AppBar(title: const Text('Maps')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
            markers: _markers,
            onTap: _onMapTapped,  // ✅ Solo un marcador
          ),
          // if (_isLoadingLocation) 
          //   const Center(child: CircularProgressIndicator(color: Colors.orange)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToUserLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
