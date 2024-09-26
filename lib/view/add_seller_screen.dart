import 'package:flutter/material.dart';
import '../models/seller_model.dart';
import '../services/seller_services.dart'; // Update the path to your SellerService

class AddSellerScreen extends StatefulWidget {
  @override
  _AddSellerScreenState createState() => _AddSellerScreenState();
}

class _AddSellerScreenState extends State<AddSellerScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _sellerNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _typeOfSellerFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _whatsappNoFocus = FocusNode();

  String? _sellerName, _email, _phone, _city, _typeOfSeller, _address, _whatsappNo;

  final SellerService sellerService = SellerService();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Seller newSeller = Seller(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Use milliseconds since epoch for ID
        sellerName: _sellerName!,
        email: _email!,
        phone: _phone!,
        city: _city!,
        typeOfSeller: _typeOfSeller!,
        address: _address!,
        whatsappNo: _whatsappNo ?? '', // Default to empty string if not provided
      );
      sellerService.addSeller(newSeller); // Add seller to the database
      Navigator.pop(context); // Go back after adding
    }
  }

  @override
  void dispose() {
    // Dispose of focus nodes to free up resources
    _sellerNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _cityFocus.dispose();
    _typeOfSellerFocus.dispose();
    _addressFocus.dispose();
    _whatsappNoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Seller')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                focusNode: _sellerNameFocus,
                decoration: InputDecoration(labelText: 'Seller Name'),
                validator: (value) => value!.isEmpty ? 'Enter a seller name' : null,
                onSaved: (value) => _sellerName = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocus);
                },
              ),
              TextFormField(
                focusNode: _emailFocus,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                onSaved: (value) => _email = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_phoneFocus);
                },
              ),
              TextFormField(
                focusNode: _phoneFocus,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) => value!.isEmpty ? 'Enter a phone number' : null,
                onSaved: (value) => _phone = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_cityFocus);
                },
              ),
              TextFormField(
                focusNode: _cityFocus,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) => value!.isEmpty ? 'Enter a city' : null,
                onSaved: (value) => _city = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_typeOfSellerFocus);
                },
              ),
              TextFormField(
                focusNode: _typeOfSellerFocus,
                decoration: InputDecoration(labelText: 'Type of Seller'),
                validator: (value) => value!.isEmpty ? 'Enter type of seller' : null,
                onSaved: (value) => _typeOfSeller = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_addressFocus);
                },
              ),
              TextFormField(
                focusNode: _addressFocus,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Enter an address' : null,
                onSaved: (value) => _address = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_whatsappNoFocus);
                },
              ),
              TextFormField(
                focusNode: _whatsappNoFocus,
                decoration: InputDecoration(labelText: 'WhatsApp No'),
                onSaved: (value) => _whatsappNo = value,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _submitForm(); // Submit the form when the user is done
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Seller'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
