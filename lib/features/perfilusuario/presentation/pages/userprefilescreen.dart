import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Mi Perfil ',
            style: TextStyle(
              color: Color.fromARGB(255, 175, 91, 7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 175, 91, 7), // Color del icono de volver
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Información básica del usuario
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        'https://pymstatic.com/5844/conversions/personas-emocionales-wide_webp.webp',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Maria Silva',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 3, 3, 3),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'maria.Silva23@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Botones adicionales (Perfil, Carrito, Contacto)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xFFFF7000)),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(Icons.person,
                                  size: 30, color: Color(0xFFFF7000)),
                            ),
                            const Text('Mi Cuenta'),
                          ],
                        ),
                        Column(
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xFFFF7000)),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(Icons.shopping_bag_sharp,
                                  size: 30, color: Color(0xFFFF7000)),
                            ),
                            const Text('Mis Compras'),
                          ],
                        ),
                        Column(
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xFFFF7000)),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(Icons.contact_mail,
                                  size: 30, color: Color(0xFFFF7000)),
                            ),
                            const Text('Contacto'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Opciones del perfil
                    ListTile(
                      leading:
                          const Icon(Icons.history, color: Color(0xFFFF7000)),
                      title: const Text('Historial de Pedidos'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.location_on,
                          color: Color(0xFFFF7000)),
                      title: const Text('Direcciones de Envío'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.payment, color: Color(0xFFFF7000)),
                      title: const Text('Métodos de Pago'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.notifications,
                          color: Color(0xFFFF7000)),
                      title: const Text(
                        'Notificaciones',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.settings, color: Color(0xFFFF7000)),
                      title: const Text('Configuración'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.card_giftcard,
                          color: Color(0xFFFF7000)),
                      title: const Text('Mis Cupones'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.favorite, color: Color(0xFFFF7000)),
                      title: const Text('Mis Favoritos'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.lock, color: Color(0xFFFF7000)),
                      title: const Text('Cambiar Contraseña'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Acción para cambiar la contraseña
                      },
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
          // Botones en la parte inferior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF7000), // Color del botón
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    'Editar Perfil',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color(0xFFFF7000)), // Color del borde del botón
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(Icons.logout,
                      color: Color(0xFFFF7000)), // Color del icono
                  label: const Text(
                    'Cerrar Sesión',
                    style:
                        TextStyle(color: Color(0xFFFF7000)), // Color del texto
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
