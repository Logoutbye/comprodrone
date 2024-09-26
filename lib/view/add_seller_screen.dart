import 'package:flutter/material.dart';
import '../models/seller_model.dart';
import '../services/seller_services.dart'; // Update the path to your SellerService

class AddSellerScreen extends StatefulWidget {
  @override
  _AddSellerScreenState createState() => _AddSellerScreenState();
}

class _AddSellerScreenState extends State<AddSellerScreen> {
  final _formKey = GlobalKey<FormState>();

  // FocusNodes for managing focus transitions between text fields
  final FocusNode _sellerNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _typeOfSellerFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _whatsappNoFocus = FocusNode();

  // Variables to store the form data
  String? _sellerName,
      _email,
      _phone,
      _city,
      _typeOfSeller,
      _address,
      _whatsappNo;

  // Seller service to handle saving seller data
  final SellerService sellerService = SellerService();

  // Form submission function
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Seller newSeller = Seller(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Use milliseconds since epoch for ID
        sellerName: _sellerName!,
        email: _email!,
        phone: _phone!,
        city: _city!,
        typeOfSeller: _typeOfSeller!,
        address: _address!,
        whatsappNo:
            _whatsappNo ?? '', // Default to empty string if not provided
      );
      sellerService.addSeller(newSeller); // Add seller to the database
      Navigator.pop(context); // Go back after adding
    }
  }

  // Dispose focus nodes to free up memory
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

  // Build the form fields with improved visuals and focus transitions
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Add Seller'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Seller Name Field
              _buildTextFormField(
                label: 'Seller Name',
                icon: Icons.person,
                focusNode: _sellerNameFocus,
                onSaved: (value) => _sellerName = value,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a seller name' : null,
                nextFocusNode: _emailFocus,
              ),

              SizedBox(height: 16),

              // Email Field
              _buildTextFormField(
                label: 'Email',
                icon: Icons.email,
                focusNode: _emailFocus,
                onSaved: (value) => _email = value,
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                nextFocusNode: _phoneFocus,
              ),

              SizedBox(height: 16),

              // Phone Field
              _buildTextFormField(
                label: 'Phone',
                icon: Icons.phone,
                focusNode: _phoneFocus,
                onSaved: (value) => _phone = value,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a phone number' : null,
                nextFocusNode: _cityFocus,
              ),

              SizedBox(height: 16),

              // City Field
              _buildTextFormField(
                label: 'City',
                icon: Icons.location_city,
                focusNode: _cityFocus,
                onSaved: (value) => _city = value,
                validator: (value) => value!.isEmpty ? 'Enter a city' : null,
                nextFocusNode: _typeOfSellerFocus,
              ),

              SizedBox(height: 16),

              // Type of Seller Field
              _buildTextFormField(
                label: 'Type of Seller',
                icon: Icons.store,
                focusNode: _typeOfSellerFocus,
                onSaved: (value) => _typeOfSeller = value,
                validator: (value) =>
                    value!.isEmpty ? 'Enter the type of seller' : null,
                nextFocusNode: _addressFocus,
              ),

              SizedBox(height: 16),

              // Address Field
              _buildTextFormField(
                label: 'Address',
                icon: Icons.home,
                focusNode: _addressFocus,
                onSaved: (value) => _address = value,
                validator: (value) =>
                    value!.isEmpty ? 'Enter an address' : null,
                nextFocusNode: _whatsappNoFocus,
              ),

              SizedBox(height: 16),

              // WhatsApp No Field
              _buildTextFormField(
                label: 'WhatsApp No',
                icon: Icons.chat,
                focusNode: _whatsappNoFocus,
                onSaved: (value) => _whatsappNo = value,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _submitForm(); // Submit form when this field is done
                },
                validator: (String? value) {},
              ),

              SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Add Seller', style: TextStyle(fontSize: 18)),
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

  // Helper method to build each form field
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
              .requestFocus(nextFocusNode); // Move to the next field
        } else if (onFieldSubmitted != null) {
          onFieldSubmitted(_); // Submit the form if this is the last field
        }
      },
    );
  }
}
