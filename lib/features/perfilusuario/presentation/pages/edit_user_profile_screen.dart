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
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  // Estados para alternar visibilidad de las contraseñas
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    // Inicialización de los controladores con datos del usuario
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    passwordController = TextEditingController(text: widget.user.password);
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Liberar recursos al destruir el widget
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildConfirmPasswordField(),
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

  // Campo de texto para la contraseña
  // Campo de texto para la contraseña
  Widget _buildPasswordField() {
    return _buildTextField(
      controller: passwordController,
      label: 'Contraseña',
      icon: Icons.lock,
      obscureText: !_isPasswordVisible, // Alterna visibilidad
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: const Color(0xFFFF7000), // Color naranja
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible; // Cambia el estado
          });
        },
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La contraseña no puede estar vacía';
        } else if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }

// Campo de texto para confirmar la contraseña
  Widget _buildConfirmPasswordField() {
    return _buildTextField(
      controller: confirmPasswordController,
      label: 'Confirmar Contraseña',
      icon: Icons.lock_outline,
      obscureText: !_isConfirmPasswordVisible, // Alterna visibilidad
      suffixIcon: IconButton(
        icon: Icon(
          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: const Color(0xFFFF7000), // Color naranja
        ),
        onPressed: () {
          setState(() {
            _isConfirmPasswordVisible =
                !_isConfirmPasswordVisible; // Cambia el estado
          });
        },
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor confirma tu contraseña';
        } else if (value != passwordController.text) {
          return 'Las contraseñas no coinciden';
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
            password: passwordController.text, // Nueva contraseña
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
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText, // Configura si el texto se oculta
      validator: validator,
      style: const TextStyle(color: Colors.black), // Texto negro
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey), // Etiqueta gris
        prefixIcon: Icon(icon, color: const Color(0xFFFF7000)), // Ícono naranja
        suffixIcon: suffixIcon, // Icono adicional (como el ojo)
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
