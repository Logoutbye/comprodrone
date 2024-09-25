

import 'package:com_pro_drone/models/buyer_model.dart';
import 'package:flutter/material.dart';

import '../services/buyer_services.dart';

class AddBuyerScreen extends StatefulWidget {
  @override
  _AddBuyerScreenState createState() => _AddBuyerScreenState();
}

class _AddBuyerScreenState extends State<AddBuyerScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _buyerName, _email, _phone, _city, _budget;

  final BuyerService buyerService = BuyerService();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Buyer newBuyer = Buyer(
        id: DateTime.now().toString(), // Use a unique ID, e.g., timestamp
        date: DateTime.now().toString(),
        buyer: _buyerName!,
        email: _email!,
        phone: _phone!,
        city: _city!,
        requirements: 'None', // Add other fields as necessary
        remarks: 'None',
        followUp: 'None',
        notes: 'None',
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
                validator: (value) =>
                    value!.isEmpty ? 'Enter an email' : null,
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
