import 'package:com_pro_drone/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/order_model.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _client, _email, _phone, _city, _budget;
  String? _need, _remarks, _followUp;
  String _selectedDate = ''; // Store the selected date
  final OrderService orderService = OrderService();

  // Function to handle date selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('dd-MM-yyyy').format(picked); // Format the selected date
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Order newOrder = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: _selectedDate.isNotEmpty
            ? _selectedDate
            : DateFormat('dd-MM-yyyy').format(DateTime.now()), // Use selected or current date
        client: _client!,
        email: _email!,
        phone: _phone!,
        city: _city!,
        need: _need ?? 'None',
        budget: _budget!,
        followUp: _followUp ?? 'None',
        remarks: _remarks ?? 'None',
      );
      orderService.addOrder(newOrder); // Add order to Firebase
      Navigator.pop(context); // Go back after adding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Client name field
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Cliente', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Ingrese un nombre de cliente' : null,
                onSaved: (value) => _client = value,
              ),
              SizedBox(height: 20),
              // Email field
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Ingrese un correo electrónico' : null,
                onSaved: (value) => _email = value,
              ),
              SizedBox(height: 20),
              // Phone field
              TextFormField(
                decoration: InputDecoration(labelText: 'Teléfono', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Ingrese un número de teléfono' : null,
                onSaved: (value) => _phone = value,
              ),
              SizedBox(height: 20),
              // City field
              TextFormField(
                decoration: InputDecoration(labelText: 'Ciudad', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Ingrese una ciudad' : null,
                onSaved: (value) => _city = value,
              ),
              SizedBox(height: 20),
              // Budget field
              TextFormField(
                decoration: InputDecoration(labelText: 'Presupuesto', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Ingrese un presupuesto' : null,
                onSaved: (value) => _budget = value,
              ),
              SizedBox(height: 20),
              // Need field
              TextFormField(
                decoration: InputDecoration(labelText: 'Necesidad', border: OutlineInputBorder()),
                onSaved: (value) => _need = value,
              ),
              SizedBox(height: 20),
              // Follow-up field
              TextFormField(
                decoration: InputDecoration(labelText: 'Seguimiento', border: OutlineInputBorder()),
                onSaved: (value) => _followUp = value,
              ),
              SizedBox(height: 20),
              // Remarks field
              TextFormField(
                decoration: InputDecoration(labelText: 'Observaciones', border: OutlineInputBorder()),
                onSaved: (value) => _remarks = value,
              ),
              SizedBox(height: 20),
              // Date picker
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
                controller: TextEditingController(text: _selectedDate), // Show selected date
              ),
              SizedBox(height: 30),
              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16)),
                child: Text('Agregar Pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
