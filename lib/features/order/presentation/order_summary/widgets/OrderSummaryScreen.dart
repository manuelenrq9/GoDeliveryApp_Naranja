import 'dart:convert';  
import 'package:godeliveryapp_naranja/features/order/data/make_reorder.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderReport.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/pages/make_order_report_screen.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/widgets/distanceDelivery.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/widgets/eta_and_tracking_section.dart';
import 'package:godeliveryapp_naranja/features/shopping_cart/presentation/pages/cart_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/dataID.services.dart';
import 'package:godeliveryapp_naranja/features/combo/data/combo_fetchID.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderPayment.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/order_header.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/pages/order_summary.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/product_tile.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/reorder_button.dart';
import 'package:godeliveryapp_naranja/core/navbar.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_track/pages/order_direction.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderSummaryScreen extends StatefulWidget {
  final Order order;

  const OrderSummaryScreen({super.key, required this.order});
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  int _selectedIndex = 3;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _deliveryDate;
  double? _selectedLatitude;
  double? _selectedLongitude;
  String? _selectedAddress;
  double? _distanceInKm;
    bool _isMapVisible = false; 

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime lastDate = today.add(const Duration(days: 7));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm - dd/MM/yy');
    return formatter.format(dateTime);
  }

  List<Map<String, String>> _getStatusDates(Order order) {
    final Map<String, DateTime> statusDates = {
      'CREATED': order.createdDate,
      'BEING PROCESSED': order.beignProcessedDate,
      'SHIPPED': order.shippedDate,
      'DELIVERED': order.receivedDate,
      'CANCELLED': order.cancelledDate,
    };

    final List<String> statusOrder = [
      'CREATED',
      'BEING PROCESSED',
      'SHIPPED',
      'DELIVERED'
    ];

    List<Map<String, String>> datesToShow = [];

    if (order.status == 'CANCELLED') {
      datesToShow = [
        {
          'Estado': 'CREATED',
          'Fecha': statusDates['CREATED'] != null
              ? formatDateTime(statusDates['CREATED']!)
              : 'N/A'
        },
        {
          'Estado': 'CANCELLED',
          'Fecha': statusDates['CANCELLED'] != null
              ? formatDateTime(statusDates['CANCELLED']!)
              : 'N/A'
        },
      ];
    } else {
      for (String status in statusOrder) {
        datesToShow.add({
          'Estado': status,
          'Fecha': statusDates[status] != null
              ? formatDateTime(statusDates[status]!)
              : 'N/A',
        });
        if (status == order.status) break;
      }
    }

    return datesToShow;
  }

  Widget _buildStatusDates(Order order) {
    List<Map<String, String>> statusDates = _getStatusDates(order);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statusDates.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Check circular antes del estado
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrange, // Color del círculo
                ),
                child: const Icon(
                  Icons.check, // Ícono del check
                  color: Colors.white, // Color del ícono
                  size: 16,
                ),
              ),
              const SizedBox(width: 10), // Espaciado entre el check y el texto
              Expanded(
                child: Text(
                  entry['Estado'] ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                entry['Fecha'] ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CartCombo> combos = widget.order.combos;
    List<OrderPayment> payment = widget.order.paymentMethod;
    String paymentMethod = '';
    payment.forEach((payment) {
      paymentMethod = payment.paymentMethod;
    });
    String formatedId = widget.order.id.length > 8
        ? widget.order.id.substring(0, 8)
        : widget.order.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resumen del Pedido',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        foregroundColor: Color.fromARGB(255, 175, 91, 7),
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderHeader(orderNumber: formatedId, status: widget.order.status),
            const Divider(thickness: 1, height: 32),
            const Text(
              'Estados del Pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatusDates(widget.order),
            const Divider(thickness: 1, height: 32),            
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isMapVisible = !_isMapVisible;
                  });
                },
                child: Text(_isMapVisible ? 'Ocultar Mapa' : 'Mostrar Ubicación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Mapa expandible
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isMapVisible
                  ? Container(
                      height: 300, // Altura del mapa expandido
                      child: DeliveryTrackingScreen(
                        deliveryDestination: LatLng(widget.order.latitude, widget.order.longitude),
                        orderStatus: widget.order.status,
                      ),
                    )
                  : const SizedBox.shrink(), // Espacio vacío si está oculto
            ),
            const Divider(thickness: 1, height: 32),
            const Text(
              'Productos en tu pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Widget>>(
              future: _buildProductList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Column(children: snapshot.data!);
                } else {
                  return const Text('No products available');
                }
              },
            ),
            const SizedBox(height: 16),
            OrderSummary(order: widget.order),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.credit_card,
              text: 'Método de pago: ${paymentMethod}',
            ),
            const Divider(thickness: 1, height: 32),
            _buildDeliveryScheduler(),
            if (widget.order.status == 'CANCELLED' || widget.order.status == 'DELIVERED') ...[
              const Text(
                'Detalles del Reporte',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildOrderReport(widget.order.report),
            ],
            if (widget.order.status == 'CREATED' ||
                widget.order.status == 'BEING PROCESSED') ...[
              const Text(
                'Modificar ubicación de entrega',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Ubicación actual: \n${(_selectedAddress != null && _selectedAddress!.isNotEmpty) ? _selectedAddress : widget.order.address}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _selectLocation,
                    icon: const Icon(Icons.location_on),
                    label: const Text('Seleccionar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
            if (widget.order.status == 'CREATED' ||
                widget.order.status == 'BEING PROCESSED') ...[  Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _updateOrder();
                  },
                  child: const Text('Actualizar Información'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Fondo naranja
                    foregroundColor: Colors.white, // Texto blanco
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ),],
            if (widget.order.status == 'DELIVERED') ...[  Center(
                child: ElevatedButton(
                  onPressed: () async {
                      MakeReorder logic = MakeReorder(widget.order);
                      await logic.execute();
                      Navigator.push(context, MaterialPageRoute(
                        builder:(context) => CartScreen(),));
                  },
                  child: const Text('ReOrdenar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Fondo naranja
                    foregroundColor: Colors.white, // Texto blanco
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ),],
            if (widget.order.status == 'CANCELLED') ...[  Center(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => MakeOrderReportScreen(order:widget.order),
                                ),
                    );
                  },
                  child: const Text('Reportar Orden'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Fondo naranja
                    foregroundColor: Colors.white, // Texto blanco
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ),],
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }

Widget _buildOrderReport(List<OrderReport> reports) {
  if (reports.isEmpty) {
    return const Text(
      'No hay reportes disponibles para esta orden.',
      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: reports.map((report) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Descripción: ${report.description}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Fecha: ${formatDateTime(report.reportDate)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}


Future<String?> _getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token'); // Obtén el token almacenado
}

  Future<void> _updateOrder() async {
  // Crear un mapa con los datos que cambiaron
  final Map<String, dynamic> updatedData = {};

  if (_deliveryDate != null) {
    final formattedDate = _formatDateForDatabase(_deliveryDate!);
    updatedData['receivedDate'] = formattedDate;
  }

  if (_selectedLatitude != null && _selectedLongitude != null) {
    updatedData['latitude'] = _selectedLatitude;
    updatedData['longitude'] = _selectedLongitude;
    updatedData['address'] = _selectedAddress;
  }

  // Si no hay cambios, mostrar mensaje y salir
  if (updatedData.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No hay cambios para actualizar.')),
    );
    return;
  }

  // Llamar al backend para actualizar los datos
  try {
    final token = await _getToken(); // Reutilizamos la función para obtener el token
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final response = await http.patch(
      Uri.parse(
          'https://orangeteam-deliverybackend-production.up.railway.app/order/update/${widget.order.id}'),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Información actualizada exitosamente.')),
      );
    } else {
      print('Error al actualizar la información: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: ${response.statusCode}'),
        ),
      );
    }
  } catch (e) {
    print('Error al actualizar la información: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al actualizar la información.')),
    );
  }
}


  Future<void> _selectLocation() async {
    if (widget.order.status == 'CREATED' ||
        widget.order.status == 'BEING PROCESSED') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LocationPickerScreen(),
        ),
      );

      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          _selectedLatitude = result['latitud'];
          _selectedLongitude = result['longitud'];
          _selectedAddress = result['direccion'];
          _distanceInKm = result['km'];
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('La ubicación no puede ser modificada en este estado.')),
      );
    }
  }

  Widget _buildDeliveryScheduler() {
    if (widget.order.status == 'CREATED' ||
        widget.order.status == 'BEING PROCESSED') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Programar fecha de entrega',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  _deliveryDate != null
                      ? 'Fecha seleccionada: \n${formatDateTime(_deliveryDate!)}'
                      : 'No se ha seleccionado una fecha.',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () => _selectDeliveryDate(context),
                child: const Text(
                  'Seleccionar',
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ],
          ),
          const Divider(thickness: 1, height: 32),
        ],
      );
    } else {
      return const SizedBox.shrink(); // No mostrar nada si no aplica
    }
  }

  String _formatDateForDatabase(DateTime date) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss").format(date);
  }

  /// Muestra un selector de fecha y hora
  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime lastDate = today.add(const Duration(days: 7));

    // Seleccionar fecha
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ?? today,
      firstDate: today,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Seleccionar hora
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.deepOrange,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _deliveryDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });

        // Lógica para actualizar la base de datos con la fecha seleccionada
        final formattedDate = _formatDateForDatabase(_deliveryDate!);
      }
    }
  }

  Widget _buildSection({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepOrange, size: 24),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Future<List<Widget>> _buildProductList() async {
    List<CartProduct> products = widget.order.products;
    List<CartCombo> combos = widget.order.combos;

    List<Product> productList = [];
    try {
      for (var product in products) {
        var id = product.id;
        var productObject = await fetchEntityById<Product>(id, 'product/one/',
            (json) => Product.fromJson(json)); // Await the asynchronous call
        productList
            .add(productObject); //    Add the product object to the productList
      }
    } catch (e) {
      print('Error fetching productos: \$e');
    }

    List<Combo> comboList = [];
    try {
      for (var cartCombo in combos) {
        Combo combo = await fetchComboById(cartCombo.id);
        comboList.add(combo);
      }
    } catch (e) {
      print('Error fetching combos: \$e');
    }

    return List<Widget>.generate(productList.length + comboList.length,
        (index) {
      if (index < productList.length) {
        final product = productList[index];
        final quantity = products[index].quantity;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ProductTile(
            name: product.name,
            presentation: '${product.weight}${product.measurement}',
            price: '$quantity',
            imageUrl: product.image.isNotEmpty ? product.image.first : '',
          ),
        );
      } else {
        final comboIndex = index - productList.length;
        final combo = comboList[comboIndex];
        final quantityCombo = combos[comboIndex].quantity;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ProductTile(
            name: combo.name,
            presentation: '${combo.weight}${combo.measurement}',
            price: '$quantityCombo',
            imageUrl: combo.comboImage.isNotEmpty ? combo.comboImage.first : '',
          ),
        );
      }
    });
  }

  void _showReorderConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Pedido realizado',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            '¡Tu pedido se ha realizado con éxito! Pronto recibirás la confirmación de entrega.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.deepOrange, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
