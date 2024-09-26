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
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Generate unique ID
        name: _supplierName!,
        contactDetails: _contactDetails!,
      );
      await supplierService
          .addSupplier(newSupplier).then((v)=>
          Navigator.pop(context)
          ); 
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
      appBar: AppBar(title: Text('Add Supplier')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Supplier Name Field
              TextFormField(
                focusNode: _supplierNameFocusNode,
                decoration: InputDecoration(labelText: 'Supplier Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a supplier name' : null,
                onSaved: (value) => _supplierName = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_contactDetailsFocusNode);
                },
              ),
              // Contact Details Field
              TextFormField(
                focusNode: _contactDetailsFocusNode,
                decoration: InputDecoration(labelText: 'Contact Details'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter contact details' : null,
                onSaved: (value) => _contactDetails = value,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) async {
                  await _submitForm(); // Submit the form when done
                },
              ),
              SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  await _submitForm();
                  print(":::::: AIMAMMAMMAMMMA");
                },
                child: Text('Add Supplier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
