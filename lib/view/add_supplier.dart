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
    print("Supplier Data: ${newSupplier.toMap()}"); // Debugging the Supplier Data
    bool success = await supplierService.addSupplier(newSupplier);
    if (success) {
      Navigator.pop(context);
    }
  }
}


  @override
  void dispose() {
    // Dispose of focus nodes when the screen is destroyed
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
          'Add Supplier',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600), // Limits the form width
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true, // Ensures the list takes only necessary space
                children: [
                  // Supplier Name Field
                  _buildTextFormField(
                    focusNode: _supplierNameFocusNode,
                    labelText: 'Supplier Name',
                    icon: Icons.store,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a supplier name' : null,
                    onSaved: (value) => _supplierName = value,
                    nextFocusNode: _contactDetailsFocusNode,
                  ),
                  SizedBox(height: 20),

                  // Contact Details Field
                  _buildTextFormField(
                    focusNode: _contactDetailsFocusNode,
                    labelText: 'Contact Details',
                    icon: Icons.contact_phone,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter contact details' : null,
                    onSaved: (value) => _contactDetails = value,
                  ),
                  SizedBox(height: 40),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () async {
                      await _submitForm();
                    },
                    child: Text(
                      'Add Supplier',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  // Helper method to build text form fields
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
          _submitForm(); // Submit form if it's the last field
        }
      },
    );
  }
}
