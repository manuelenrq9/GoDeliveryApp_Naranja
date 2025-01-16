import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/currencyConverter.dart';
import 'package:godeliveryapp_naranja/features/menu/presentation/pages/main_menu.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencySettingsScreen extends StatefulWidget {
  @override
  _CurrencySettingsScreenState createState() => _CurrencySettingsScreenState();
}

class _CurrencySettingsScreenState extends State<CurrencySettingsScreen> {
  final converter = CurrencyConverter();
  final LocalAuthentication _localAuth = LocalAuthentication();
  final currencies = [
    {'code': 'USD', 'symbol': '\$', 'example': '10.00 USD'},
    {'code': 'VES', 'symbol': 'Bs.', 'example': '10.00 Bs.'},
    {'code': 'EUR', 'symbol': '€', 'example': '10.00 EUR'},
  ];

  bool isBiometricEnabled = false; // Estado del interruptor
  String? tokenBiometric; // Token biométrico almacenado

  @override
  void initState() {
    super.initState();
    _loadBiometricSettings();
  }

  /// Cargar la configuración biométrica al iniciar la pantalla
  Future<void> _loadBiometricSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('tokenBiometric');
    final userId = await _getUserId();
    final userIdBiometric = await _getUserIdBiometric();
    setState(() {
      tokenBiometric = token;
      isBiometricEnabled = token != null && userId == userIdBiometric; // Habilitar si el token existe
    });
  }

  /// Guardar el token biométrico en SharedPreferences
  Future<void> _saveBiometricToken(String? token, String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    final pref = await SharedPreferences.getInstance();
    if (token != null && userId != null) {
      await prefs.setString('tokenBiometric', token);
      await pref.setString('user_id_biometric', userId);
    } else {
      await prefs.remove('tokenBiometric');
    }
  }

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id'); // Obtén el token almacenado
  }

  Future<String?> _getUserIdBiometric() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id_biometric'); // Obtén el token almacenado
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Obtén el token almacenado
  }

  /// Registrar huella dactilar
  Future<void> _authenticateAndSaveToken() async {
    try {
      // Verificar si el dispositivo admite autenticación biométrica
      bool canAuthenticate = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        _showMessage('El dispositivo no admite autenticación biométrica.');
        return;
      }

      // Solicitar autenticación biométrica
      bool authenticated = await _localAuth.authenticate(
        localizedReason:
            'Por favor, verifica tu identidad con tu huella dactilar.',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated) {
        final token = await _getToken();
        final userId = await _getUserId();
        if (token != null) {
          setState(() {
            tokenBiometric = token;
            isBiometricEnabled = true; // Habilitar la funcionalidad
          });
          await _saveBiometricToken(token, userId);
          _showMessage('Autenticación exitosa.');
        } else {
          _showMessage('No se encontró un token válido.');
        }
      } else {
        _showMessage('Autenticación fallida.');
      }
    } catch (e) {
      _showMessage('Error durante la autenticación: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Configuración de moneda',
            style: TextStyle(color: Color.fromARGB(255, 175, 91, 7)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 175, 91, 7)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainMenu()),
              (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                'Selecciona tu moneda preferida:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9027),
                ),
              ),
              const SizedBox(height: 16),

              // Lista de monedas
              Column(
                children: List.generate(
                  currencies.length,
                  (index) {
                    final currency = currencies[index];
                    final isSelected =
                        converter.selectedCurrency == currency['code'];

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              converter.setCurrency(currency['code']!);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Has seleccionado ${currency['code']} (${currency['symbol']}).',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(16),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainMenu()),
                              (route) => false,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.orange[100]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.grey[300]!,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currency['code']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.orange[800]
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${currency['symbol']} - Ejemplo: ${currency['example']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isSelected
                                            ? Colors.orange[600]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                AnimatedScale(
                                  scale: isSelected ? 1.2 : 1.0,
                                  duration: const Duration(milliseconds: 500),
                                  child: isSelected
                                      ? const Icon(Icons.check_circle,
                                          color: Colors.orange)
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Sección de huella dactilar
              Text(
                'Habilitar inicio de sesión con huella dactilar:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9027),
                ),
              ),
              const SizedBox(height: 16),

              // Switch para habilitar huella dactilar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isBiometricEnabled
                        ? 'Huella dactilar habilitada'
                        : 'Habilitar huella dactilar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[800],
                    ),
                  ),
                  Switch(
                    value: isBiometricEnabled,
                    activeColor: Colors.orange,
                    onChanged: (value) async {
                      if (value) {
                        await _authenticateAndSaveToken();
                      } else {
                        setState(() {
                          tokenBiometric = null;
                          isBiometricEnabled = false;
                        });
                        await _saveBiometricToken(null, null);
                        _showMessage('Autenticación biométrica deshabilitada.');
                      }
                    },
                  ),
                ],
              ),

              // // Botón de registrar huella
              // Center(
              //   child: ElevatedButton.icon(
              //     onPressed: isBiometricEnabled
              //         ? () {
              //             // Acción para registrar huella
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               SnackBar(
              //                 content: Row(
              //                   children: [
              //                     const Icon(
              //                       Icons.check_circle,
              //                       color: Colors.white,
              //                     ),
              //                     const SizedBox(width: 8),
              //                     Expanded(
              //                       child: Text(
              //                         'Tu huella dactilar se ha registrado exitosamente. Ahora puedes iniciar sesión con huella dactilar.',
              //                         style: TextStyle(color: Colors.white),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 backgroundColor: Colors.green,
              //                 behavior: SnackBarBehavior.floating,
              //                 margin: const EdgeInsets.all(16),
              //                 duration: const Duration(seconds: 4),
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //               ),
              //             );
              //           }
              //         : null, // Botón deshabilitado si el switch está apagado
              //     icon: const Icon(Icons.fingerprint),
              //     label: const Text('Registrar huella'),
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 24.0, vertical: 12.0),
              //       backgroundColor: isBiometricEnabled
              //           ? Colors.orange
              //           : Colors.grey, // Cambia color según estado
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8.0),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
