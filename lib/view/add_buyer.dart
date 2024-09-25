import 'package:com_pro_drone/models/buyer_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../services/buyer_services.dart';

class AddBuyerScreen extends StatefulWidget {
  @override
  _AddBuyerScreenState createState() => _AddBuyerScreenState();
}

class _AddBuyerScreenState extends State<AddBuyerScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _buyerName, _email, _phone, _city, _budget;
  String? _requirements, _remarks, _followUp, _notes;
  String _selectedDate = ''; // Store the selected date
  final BuyerService buyerService = BuyerService();

  // Function to handle date picking
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedDate = DateFormat('dd-MM-yyyy').format(picked); // Format the date
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Buyer newBuyer = Buyer(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Use milliseconds since epoch for ID
        date: _selectedDate.isNotEmpty ? _selectedDate : DateFormat('dd-MM-yyyy').format(DateTime.now()), // Use selected date or current date
        buyer: _buyerName!,
        email: _email!,
        phone: _phone!,
        city: _city!,
        requirements: _requirements ?? 'None', // Default if empty
        remarks: _remarks ?? 'None', // Default if empty
        followUp: _followUp ?? 'None', // Default if empty
        notes: _notes ?? 'None', // Default if empty
        budget: _budget!,
      );
      buyerService.addBuyer(newBuyer); // Add buyer to Firestore
      Navigator.pop(context); // Go back after adding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Buyer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Buyer Name'),
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                onSaved: (value) => _buyerName = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) => value!.isEmpty ? 'Enter a phone' : null,
                onSaved: (value) => _phone = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) => value!.isEmpty ? 'Enter a city' : null,
                onSaved: (value) => _city = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Budget'),
                validator: (value) => value!.isEmpty ? 'Enter a budget' : null,
                onSaved: (value) => _budget = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Requirements'),
                onSaved: (value) => _requirements = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Remarks'),
                onSaved: (value) => _remarks = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Follow Up'),
                onSaved: (value) => _followUp = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                onSaved: (value) => _notes = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Select date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                controller: TextEditingController(text: _selectedDate), // Display selected date
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Buyer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
