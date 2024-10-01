import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importar para formateo de fecha
import '../services/buyer_services.dart';
import '../models/buyer_model.dart';

class AddBuyerScreen extends StatefulWidget {
  @override
  _AddBuyerScreenState createState() => _AddBuyerScreenState();
}

class _AddBuyerScreenState extends State<AddBuyerScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _buyerName, _email, _phone, _city, _budget;
  String? _requirements, _remarks, _followUp, _notes;
  String _selectedDate = ''; // Almacenar la fecha seleccionada
  final BuyerService buyerService = BuyerService();

  // FocusNodes para cada campo de texto
  FocusNode _buyerNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _budgetFocusNode = FocusNode();
  FocusNode _requirementsFocusNode = FocusNode();
  FocusNode _remarksFocusNode = FocusNode();
  FocusNode _followUpFocusNode = FocusNode();
  FocusNode _notesFocusNode = FocusNode();

  // Función para manejar la selección de fecha
Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate =
            DateFormat('dd-MM-yyyy').format(picked); // Formatear la fecha
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Buyer newBuyer = Buyer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: _selectedDate.isNotEmpty
            ? _selectedDate
            : DateFormat('dd-MM-yyyy')
                .format(DateTime.now()), // Usar la fecha seleccionada o la actual
        buyer: _buyerName!,
        email: _email!,
        phone: _phone!,
        city: _city!,
        requirements: _requirements ?? 'Ninguno',
        remarks: _remarks ?? 'Ninguno',
        followUp: _followUp ?? 'Ninguno',
        notes: _notes ?? 'Ninguno',
        budget: _budget!,
      );
      buyerService.addBuyer(newBuyer); // Agregar comprador a la base de datos
      Navigator.pop(context); // Volver después de agregar
    }
  }

  @override
  void dispose() {
    // Eliminar todos los FocusNodes
    _buyerNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _cityFocusNode.dispose();
    _budgetFocusNode.dispose();
    _requirementsFocusNode.dispose();
    _remarksFocusNode.dispose();
    _followUpFocusNode.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Comprador')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600, // Limitar el ancho máximo
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Campo de Nombre del Comprador
                  TextFormField(
                    focusNode: _buyerNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Comprador',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Ingresa un nombre' : null,
                    onSaved: (value) => _buyerName = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo de Correo
                  TextFormField(
                    focusNode: _emailFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Ingresa un correo' : null,
                    onSaved: (value) => _email = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_phoneFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo de Teléfono
                  TextFormField(
                    focusNode: _phoneFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Ingresa un número de teléfono' : null,
                    onSaved: (value) => _phone = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_cityFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo de Ciudad
                  TextFormField(
                    focusNode: _cityFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Ciudad',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Ingresa una ciudad' : null,
                    onSaved: (value) => _city = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_budgetFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo de Presupuesto
                  TextFormField(
                    focusNode: _budgetFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Presupuesto',
                      prefixIcon: Icon(Icons.money),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Ingresa un presupuesto' : null,
                    onSaved: (value) => _budget = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_requirementsFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo de Requisitos
                  TextFormField(
                    focusNode: _requirementsFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Requisitos',
                      prefixIcon: Icon(Icons.list_alt),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _requirements = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_remarksFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo de Observaciones
                  TextFormField(
                    focusNode: _remarksFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Observaciones',
                      prefixIcon: Icon(Icons.comment),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _remarks = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_followUpFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo de Seguimiento
                  TextFormField(
                    focusNode: _followUpFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Seguimiento',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _followUp = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_notesFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo de Notas
                  TextFormField(
                    focusNode: _notesFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Notas',
                      prefixIcon: Icon(Icons.note_add),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _notes = value,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _submitForm();
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo de Fecha con Selector de Calendario
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      hintText: 'Seleccionar fecha',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(
                        text: _selectedDate), // Mostrar fecha seleccionada
                  ),
                  SizedBox(height: 30),

                  // Botón de Agregar Comprador
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Agregar Comprador'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
