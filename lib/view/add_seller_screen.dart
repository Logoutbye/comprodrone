import 'package:flutter/material.dart';
import '../models/seller_model.dart';
import '../services/seller_services.dart';

class AddSellerScreen extends StatefulWidget {
  @override
  _AddSellerScreenState createState() => _AddSellerScreenState();
}

class _AddSellerScreenState extends State<AddSellerScreen> {
  final _formKey = GlobalKey<FormState>();

  // FocusNodes for the new fields
  final FocusNode _sellerNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _typeOfSellerFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _whatsappNoFocus = FocusNode();
  final FocusNode _fechaFocus = FocusNode();
  final FocusNode _numeroFocus = FocusNode();
  final FocusNode _clienteFocus = FocusNode();
  final FocusNode _dronAnunciadoFocus = FocusNode();
  final FocusNode _precioWebFocus = FocusNode();
  final FocusNode _precioClienteFocus = FocusNode();
  final FocusNode _comisionFocus = FocusNode();
  final FocusNode _seguimientoFocus = FocusNode();
  final FocusNode _estadoFocus = FocusNode();
  final FocusNode _observacionesFocus = FocusNode();

  // Form field variables
  String? _sellerName,
      _email,
      _phone,
      _city,
      _typeOfSeller,
      _address,
      _whatsappNo;
  String? _fecha,
      _numero,
      _cliente,
      _dronAnunciado,
      _seguimiento,
      _estado,
      _observaciones;
  double? _precioWeb, _precioCliente, _comision;

  final SellerService sellerService = SellerService();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Seller newSeller = Seller(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sellerName: _sellerName ?? '',
        email: _email?? '',
        phone: _phone?? '',
        city: _city?? '',
        typeOfSeller: _typeOfSeller?? '',
        address: _address?? '',
        whatsappNo: _whatsappNo?? '',
        fecha: _fecha?? '',
        numero: _numero?? '',
        cliente: _cliente?? '',
        dronAnunciado: _dronAnunciado?? '',
        precioWeb: _precioWeb?? 0.0,
        precioCliente: _precioCliente?? 0.0,
        comision: _comision?? 0.0,
        seguimiento: _seguimiento?? '',
        estado: _estado?? '',
        observaciones: _observaciones?? '',
      );

      sellerService.addSeller(newSeller);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _sellerNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _cityFocus.dispose();
    _typeOfSellerFocus.dispose();
    _addressFocus.dispose();
    _whatsappNoFocus.dispose();
    _fechaFocus.dispose();
    _numeroFocus.dispose();
    _clienteFocus.dispose();
    _dronAnunciadoFocus.dispose();
    _precioWebFocus.dispose();
    _precioClienteFocus.dispose();
    _comisionFocus.dispose();
    _seguimientoFocus.dispose();
    _estadoFocus.dispose();
    _observacionesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Vendedor'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                  label: 'Nombre del Vendedor',
                  icon: Icons.person,
                  focusNode: _sellerNameFocus,
                  onSaved: (value) => _sellerName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa el nombre' : null,
                  nextFocusNode: _emailFocus),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Correo',
                  icon: Icons.email,
                  focusNode: _emailFocus,
                  onSaved: (value) => _email = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa un correo' : null,
                  nextFocusNode: _phoneFocus),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Teléfono',
                  icon: Icons.phone,
                  focusNode: _phoneFocus,
                  onSaved: (value) => _phone = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa un número' : null,
                  nextFocusNode: _cityFocus),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Ciudad',
                  icon: Icons.location_city,
                  focusNode: _cityFocus,
                  onSaved: (value) => _city = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa una ciudad' : null,
                  nextFocusNode: _typeOfSellerFocus),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Tipo de Vendedor',
                  icon: Icons.store,
                  focusNode: _typeOfSellerFocus,
                  onSaved: (value) => _typeOfSeller = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa el tipo de vendedor' : null,
                  nextFocusNode: _addressFocus),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Dirección',
                  icon: Icons.home,
                  focusNode: _addressFocus,
                  onSaved: (value) => _address = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa una dirección' : null,
                  nextFocusNode: _whatsappNoFocus),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'WhatsApp No',
                  icon: Icons.chat,
                  focusNode: _whatsappNoFocus,
                  onSaved: (value) => _whatsappNo = value),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Fecha',
                  icon: Icons.date_range,
                  focusNode: _fechaFocus,
                  onSaved: (value) => _fecha = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa una fecha' : null,
                  nextFocusNode: _numeroFocus),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Numero',
                  icon: Icons.confirmation_number,
                  focusNode: _numeroFocus,
                  onSaved: (value) => _numero = value),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Cliente',
                  icon: Icons.person_outline,
                  focusNode: _clienteFocus,
                  onSaved: (value) => _cliente = value,
                  nextFocusNode: _dronAnunciadoFocus),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Dron Anunciado',
                  icon: Icons.airplanemode_active,
                  focusNode: _dronAnunciadoFocus,
                  onSaved: (value) => _dronAnunciado = value,
                  nextFocusNode: _precioWebFocus),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Precio Web',
                  icon: Icons.attach_money,
                  focusNode: _precioWebFocus,
                  onSaved: (value) =>
                      _precioWeb = double.tryParse(value ?? '0')),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Precio Cliente',
                  icon: Icons.money,
                  focusNode: _precioClienteFocus,
                  onSaved: (value) =>
                      _precioCliente = double.tryParse(value ?? '0')),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Comisión',
                  icon: Icons.percent,
                  focusNode: _comisionFocus,
                  onSaved: (value) =>
                      _comision = double.tryParse(value ?? '0')),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Seguimiento',
                  icon: Icons.track_changes,
                  focusNode: _seguimientoFocus,
                  onSaved: (value) => _seguimiento = value),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Estado',
                  icon: Icons.flag,
                  focusNode: _estadoFocus,
                  onSaved: (value) => _estado = value),
              SizedBox(height: 16),
              _buildTextFormField(
                  label: 'Observaciones',
                  icon: Icons.notes,
                  focusNode: _observacionesFocus,
                  onSaved: (value) => _observaciones = value),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child:
                      Text('Agregar Vendedor', style: TextStyle(fontSize: 18)),
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
    required IconData icon,
    required FocusNode focusNode,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    FocusNode? nextFocusNode,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return TextFormField(
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      validator: validator,
      onSaved: onSaved,
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : textInputAction,
      onFieldSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
    );
  }
}
