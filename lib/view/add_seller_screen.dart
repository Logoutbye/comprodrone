import 'package:flutter/material.dart';
import '../models/seller_model.dart';
import '../services/seller_services.dart'; // Actualiza la ruta al servicio SellerService

class AddSellerScreen extends StatefulWidget {
  @override
  _AddSellerScreenState createState() => _AddSellerScreenState();
}

class _AddSellerScreenState extends State<AddSellerScreen> {
  final _formKey = GlobalKey<FormState>();

  // FocusNodes para manejar las transiciones entre los campos de texto
  final FocusNode _sellerNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _typeOfSellerFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _whatsappNoFocus = FocusNode();

  // Variables para almacenar los datos del formulario
  String? _sellerName,
      _email,
      _phone,
      _city,
      _typeOfSeller,
      _address,
      _whatsappNo;

  // Servicio de vendedores para manejar la adición de datos del vendedor
  final SellerService sellerService = SellerService();

  // Función para enviar el formulario
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Seller newSeller = Seller(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Utilizar milisegundos desde el Epoch para ID
        sellerName: _sellerName!,
        email: _email!,
        phone: _phone!,
        city: _city!,
        typeOfSeller: _typeOfSeller!,
        address: _address!,
        whatsappNo:
            _whatsappNo ?? '', // Valor por defecto vacío si no se proporciona
      );
      sellerService.addSeller(newSeller); // Agregar vendedor a la base de datos
      Navigator.pop(context); // Volver después de agregar
    }
  }

  // Eliminar focus nodes para liberar memoria
  @override
  void dispose() {
    _sellerNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _cityFocus.dispose();
    _typeOfSellerFocus.dispose();
    _addressFocus.dispose();
    _whatsappNoFocus.dispose();
    super.dispose();
  }

  // Construir los campos del formulario con visuales mejorados y transiciones de enfoque
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Agregar Vendedor'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de Nombre del Vendedor
              _buildTextFormField(
                label: 'Nombre del Vendedor',
                icon: Icons.person,
                focusNode: _sellerNameFocus,
                onSaved: (value) => _sellerName = value,
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa el nombre del vendedor' : null,
                nextFocusNode: _emailFocus,
              ),

              SizedBox(height: 16),

              // Campo de Correo
              _buildTextFormField(
                label: 'Correo',
                icon: Icons.email,
                focusNode: _emailFocus,
                onSaved: (value) => _email = value,
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa un correo' : null,
                nextFocusNode: _phoneFocus,
              ),

              SizedBox(height: 16),

              // Campo de Teléfono
              _buildTextFormField(
                label: 'Teléfono',
                icon: Icons.phone,
                focusNode: _phoneFocus,
                onSaved: (value) => _phone = value,
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa un número de teléfono' : null,
                nextFocusNode: _cityFocus,
              ),

              SizedBox(height: 16),

              // Campo de Ciudad
              _buildTextFormField(
                label: 'Ciudad',
                icon: Icons.location_city,
                focusNode: _cityFocus,
                onSaved: (value) => _city = value,
                validator: (value) => value!.isEmpty ? 'Ingresa una ciudad' : null,
                nextFocusNode: _typeOfSellerFocus,
              ),

              SizedBox(height: 16),

              // Campo de Tipo de Vendedor
              _buildTextFormField(
                label: 'Tipo de Vendedor',
                icon: Icons.store,
                focusNode: _typeOfSellerFocus,
                onSaved: (value) => _typeOfSeller = value,
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa el tipo de vendedor' : null,
                nextFocusNode: _addressFocus,
              ),

              SizedBox(height: 16),

              // Campo de Dirección
              _buildTextFormField(
                label: 'Dirección',
                icon: Icons.home,
                focusNode: _addressFocus,
                onSaved: (value) => _address = value,
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa una dirección' : null,
                nextFocusNode: _whatsappNoFocus,
              ),

              SizedBox(height: 16),

              // Campo de WhatsApp No
              _buildTextFormField(
                label: 'WhatsApp No',
                icon: Icons.chat,
                focusNode: _whatsappNoFocus,
                onSaved: (value) => _whatsappNo = value,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _submitForm(); // Enviar formulario cuando este campo esté hecho
                },
                validator: (String? value) {},
              ),

              SizedBox(height: 32),

              // Botón de Enviar
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Agregar Vendedor', style: TextStyle(fontSize: 18)),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método auxiliar para construir cada campo del formulario
  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required FocusNode focusNode,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    FocusNode? nextFocusNode,
    TextInputAction textInputAction = TextInputAction.next,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return TextFormField(
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : textInputAction,
      onFieldSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context)
              .requestFocus(nextFocusNode); // Pasar al siguiente campo
        } else if (onFieldSubmitted != null) {
          onFieldSubmitted(_); // Enviar el formulario si es el último campo
        }
      },
    );
  }
}
