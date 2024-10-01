import 'package:flutter/material.dart';
import '../models/supplier_model.dart';
import '../services/supplier_services.dart';

class AddSupplierScreen extends StatefulWidget {
  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _supplierName, _contactDetails;
  final SupplierService supplierService = SupplierService();

  // Focus nodes for each text field
  final FocusNode _supplierNameFocusNode = FocusNode();
  final FocusNode _contactDetailsFocusNode = FocusNode();

  // Submit form to add supplier
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Supplier newSupplier = Supplier(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _supplierName!,
        contactDetails: _contactDetails!,
      );
      print(
          "Datos del Proveedor: ${newSupplier.toMap()}"); // Depuración de datos del proveedor
      bool success = await supplierService.addSupplier(newSupplier);
      if (success) {
        Navigator.pop(context); // Cerrar pantalla en caso de éxito
      }
    }
  }

  @override
  void dispose() {
    // Eliminar los focus nodes cuando la pantalla sea destruida
    _supplierNameFocusNode.dispose();
    _contactDetailsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          'Agregar Proveedor',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600), // Limitar el ancho del formulario
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true, // Asegura que la lista ocupe solo el espacio necesario
                children: [
                  // Campo de Nombre del Proveedor
                  _buildTextFormField(
                    focusNode: _supplierNameFocusNode,
                    labelText: 'Nombre del Proveedor',
                    icon: Icons.store,
                    validator: (value) =>
                        value!.isEmpty ? 'Ingresa un nombre de proveedor' : null,
                    onSaved: (value) => _supplierName = value,
                    nextFocusNode: _contactDetailsFocusNode,
                  ),
                  SizedBox(height: 20),

                  // Campo de Detalles de Contacto
                  _buildTextFormField(
                    focusNode: _contactDetailsFocusNode,
                    labelText: 'Detalles de Contacto',
                    icon: Icons.contact_phone,
                    validator: (value) =>
                        value!.isEmpty ? 'Ingresa los detalles de contacto' : null,
                    onSaved: (value) => _contactDetails = value,
                  ),
                  SizedBox(height: 40),

                  // Botón de Enviar
                  ElevatedButton(
                    onPressed: () async {
                      await _submitForm();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Agregar Proveedor',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Método auxiliar para construir campos de formulario
  Widget _buildTextFormField({
    required FocusNode focusNode,
    required String labelText,
    required IconData icon,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
    FocusNode? nextFocusNode,
  }) {
    return TextFormField(
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        } else {
          _submitForm(); // Enviar formulario si es el último campo
        }
      },
    );
  }
}