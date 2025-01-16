import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

const String googleApiKey =
    "AIzaSyDN2oEm1jKZK8nxkS7u1YmRE_bWYvuKl6o"; // ✅ Reemplaza con tu clave de Google Maps válida

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? mapController;
  LatLng? _selectedLocation;
  String _selectedAddress = "Selecciona una ubicación";
  Set<Marker> _markers = {};
  bool _addressSetBySearch = false;
  LatLng _orderHubLocation = const LatLng(10.481532, -66.863524);
  String _distanceText = "0";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Los servicios de ubicación están deshabilitados.')),
      );
      return;
    }

    // Verificar los permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Permiso de ubicación denegado permanentemente.')),
      );
      return;
    }

    // Si los permisos son correctos, obtener la ubicación actual
    Position position = await Geolocator.getCurrentPosition();
    _updateSelectedLocation(LatLng(position.latitude, position.longitude));
  }

  void _updateSelectedLocation(LatLng position) async {
    setState(() {
      _selectedLocation = position;
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('selectedLocation'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
      if (!_addressSetBySearch) {
        _getAddressFromLatLng(position);
      }
      _addressSetBySearch = false;
    });
    _calculateDistance();
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 14));
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      setState(() {
        _selectedAddress =
            "${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      _selectedAddress = "No se pudo obtener la dirección.";
    }
  }

  Future<void> _searchPlace() async {
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: googleApiKey,
      mode: Mode.overlay,
      language: "es",
      components: [Component(Component.country, "ve")],
      types: [],
      strictbounds: false,
    );

    if (prediction != null) {
      final places = GoogleMapsPlaces(
          apiKey: googleApiKey,
          apiHeaders: await const GoogleApiHeaders().getHeaders());

      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(prediction.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      final fullAddress =
          detail.result.formattedAddress ?? "Dirección no disponible";

      _addressSetBySearch = true;
      _updateSelectedLocation(LatLng(lat, lng));
      setState(() {
        _selectedAddress = fullAddress;
      });
    }
  }

  void _onMapTapped(LatLng position) {
    _updateSelectedLocation(position);
  }

  Future<void> _calculateDistance() async {
    if (_selectedLocation != null) {
      final dio = Dio();
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin':
              '${_orderHubLocation.latitude},${_orderHubLocation.longitude}',
          'destination':
              '${_selectedLocation!.latitude},${_selectedLocation!.longitude}',
          'key': googleApiKey
        },
      );
      if (response.data['status'] == 'OK') {
        setState(() {
          final distanceString =
              response.data['routes'][0]['legs'][0]['distance']['text'];
          _distanceText =
              RegExp(r'\d+(\.\d+)?').stringMatch(distanceString) ?? "0";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Ubicación'),
        leading: IconButton(
          icon: const Icon(Icons.abc),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Buscar Dirección'),
              onPressed: _searchPlace,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Color de fondo naranja
                foregroundColor: Colors.white, // Color del texto y del icono
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical:
                        12.0), // Opcional: Ajuste de los márgenes internos
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(10.4806, -66.9036),
                zoom: 12,
              ),
              markers: _markers,
              onTap: _onMapTapped,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Dirección: $_selectedAddress",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _getCurrentLocation,
            icon: const Icon(Icons.my_location),
            label: const Text('Usar mi ubicación actual'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Color de fondo naranja
              foregroundColor: Colors.white, // Color del texto y del icono
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0), // Opcional: Ajuste de los márgenes internos
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_selectedLocation != null) {
                          Navigator.pop(context, {
                            'latitud': _selectedLocation!.latitude,
                            'longitud': _selectedLocation!.longitude,
                            'direccion': _selectedAddress,
                            'km': double.parse(_distanceText),
                          });
              }
            },
            child: const Text('Confirmar Ubicación'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Fondo naranja
              foregroundColor: Colors.white, // Texto blanco
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 12.0), // Espaciado
            ),
          )
        ],
      ),
    );
  }
}
