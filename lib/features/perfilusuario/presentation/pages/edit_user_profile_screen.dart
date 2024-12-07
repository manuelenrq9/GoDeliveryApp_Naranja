import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/perfilusuario/data/user.dart';

class EditUserProfileScreen extends StatefulWidget {
  final User user;

  EditUserProfileScreen({required this.user});

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // Llave para el formulario

  // Controladores de texto
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    // Inicialización de los controladores con datos del usuario
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    // Liberar recursos al destruir el widget
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            color: Color.fromARGB(255, 175, 91, 7),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 175, 91, 7),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campos de texto para la edición del perfil
              _buildNameField(),
              const SizedBox(height: 16),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPhoneField(),
              const SizedBox(height: 32),

              // Botón de guardar cambios
              Center(child: _buildSaveButton(context)),
            ],
          ),
        ),
      ),
    );
  }

  // === Widgets Modularizados ===

  // Campo de texto para el nombre
  Widget _buildNameField() {
    return _buildTextField(
      controller: nameController,
      label: 'Nombre',
      icon: Icons.person,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El nombre no puede estar vacío';
        }
        return null;
      },
    );
  }

  // Campo de texto para el correo electrónico
  Widget _buildEmailField() {
    return _buildTextField(
      controller: emailController,
      label: 'Correo Electrónico',
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El correo no puede estar vacío';
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Ingresa un correo válido';
        }
        return null;
      },
    );
  }

  // Campo de texto para el teléfono
  Widget _buildPhoneField() {
    return _buildTextField(
      controller: phoneController,
      label: 'Teléfono',
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El teléfono no puede estar vacío';
        } else if (!RegExp(r'^\d+$').hasMatch(value)) {
          return 'El teléfono debe contener solo números';
        }
        return null;
      },
    );
  }

  // Botón para guardar cambios
  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Crear un objeto de usuario actualizado
          final updatedUser = User(
            name: nameController.text,
            email: emailController.text,
            profileImageUrl: widget.user.profileImageUrl,
            phone: phoneController.text,
            password: widget.user.password,
          );

          // Volver a la pantalla anterior con el usuario actualizado
          Navigator.pop(context, updatedUser);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF7000),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Guardar Cambios',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // === Método Genérico para Campos de Texto ===
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.black), // Texto negro
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 12, 12, 12)), // Etiqueta gris
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF7000), width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
