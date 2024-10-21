import 'package:flutter/material.dart';
import '../models/supplier_model.dart';
import '../services/supplier_services.dart';

class AddSupplierScreen extends StatefulWidget {
  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form variables for each field
  String? _supplierName, _contactDetails, _cliente, _empresa, _contacto, _email, _telefono, _ciudad, _paginaWeb, _observaciones;

  final SupplierService supplierService = SupplierService();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Supplier newSupplier = Supplier(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _supplierName!,
        contactDetails: _contactDetails!,
        cliente: _cliente ?? '',
        empresa: _empresa ?? '',
        contacto: _contacto ?? '',
        email: _email ?? '',
        telefono: _telefono ?? '',
        ciudad: _ciudad ?? '',
        paginaWeb: _paginaWeb ?? '',
        observaciones: _observaciones ?? '',
      );

      bool success = await supplierService.addSupplier(newSupplier);
      if (success) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Agregar Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(label: 'Nombre del Proveedor', onSaved: (value) => _supplierName = value, validator: (value) => value!.isEmpty ? 'Ingresa el nombre del proveedor' : null),
              SizedBox(height: 16),
              _buildTextFormField(label: 'Detalles de Contacto', onSaved: (value) => _contactDetails = value, validator: (value) => value!.isEmpty ? 'Ingresa los detalles de contacto' : null),
              SizedBox(height: 16),
              _buildTextFormField(label: 'Cliente', onSaved: (value) => _cliente = value),
              SizedBox(height: 16),
              _buildTextFormField(label: 'Empresa', onSaved: (value) => _empresa = value),
              SizedBox(height: 16),
              _buildTextFormField(label: 'Contacto', onSaved: (value) => _contacto = value),
              SizedBox(height: 16),
              _buildTextFormField(label: 'Correo electrónico', onSaved: (value) => _email = value),
              SizedBox(height: 16),
              _buildTextFormField(label: 'Teléfono', onSaved: (value) => _telefono = value),
              SizedBox(height: 16),
              _buildTextFormField(label: 'Ciudad', onSaved: (value) => _ciudad = value),
              SizedBox(height: 16),
              _buildTextFormField(label: 'Página web', onSaved: (value) => _paginaWeb = value),
              SizedBox(height: 16),
              _buildTextFormField(label: 'Observaciones', onSaved: (value) => _observaciones = value),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Agregar Proveedor', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
