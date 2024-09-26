import 'package:flutter/material.dart';
import '../models/drone_model.dart';
import '../models/buyer_model.dart'; // Import Buyer model
import '../models/seller_model.dart'; // Import Seller model
import '../services/drone_services.dart'; // Ensure correct path to your DroneService
import '../services/buyer_services.dart'; // Ensure correct path to your BuyerService
import '../services/seller_services.dart'; // Ensure correct path to your SellerService

class AddDroneScreen extends StatefulWidget {
  @override
  _AddDroneScreenState createState() => _AddDroneScreenState();
}

class _AddDroneScreenState extends State<AddDroneScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _sId; // Seller ID
  String? _bId; // Buyer ID
  String? _brand, _model, _serialNumber;
  bool _status = false; // Status is now a boolean
  String? _webPrice, _customerPrice;
  String? _commission, _followUp, _contractNo;

  final DroneService droneService = DroneService();
  final BuyerService buyerService = BuyerService();
  final SellerService sellerService = SellerService();

  // FocusNodes for input fields
  final FocusNode _brandFocusNode = FocusNode();
  final FocusNode _modelFocusNode = FocusNode();
  final FocusNode _serialNumberFocusNode = FocusNode();
  final FocusNode _webPriceFocusNode = FocusNode();
  final FocusNode _customerPriceFocusNode = FocusNode();
  final FocusNode _commissionFocusNode = FocusNode();
  final FocusNode _followUpFocusNode = FocusNode();
  final FocusNode _contractNoFocusNode = FocusNode();

  // Selected buyer and seller IDs for the dropdown
  String? _selectedBuyerId;
  String? _selectedSellerId;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_sId == null || _bId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Please select both Buyer and Seller')),
        );
        return; // Exit if required fields are missing
      }

      // Generate Drone ID using current timestamp
      String droneId = DateTime.now().millisecondsSinceEpoch.toString();

      Drone newDrone = Drone(
        dId: droneId, // Use generated ID
        sId: _sId!, // Seller ID
        bId: _bId!, // Buyer ID
        brand: _brand!,
        status: _status,
        model: _model!,
        serialNumber: _serialNumber!,
        webPrice: _webPrice!,
        customerPrice: _customerPrice!,
        commision: _commission!,
        followUp: _followUp ?? '', // Default to empty string if not provided
        soldDate: null, // Set soldDate to null initially
        contractNo:
            _contractNo ?? '', // Default to empty string if not provided
      );

      // Add drone to the database
      droneService.addDrone(newDrone);

      Navigator.pop(context); // Go back after adding the drone
    }
  }

  @override
  void dispose() {
    // Dispose FocusNodes
    _brandFocusNode.dispose();
    _modelFocusNode.dispose();
    _serialNumberFocusNode.dispose();
    _webPriceFocusNode.dispose();
    _customerPriceFocusNode.dispose();
    _commissionFocusNode.dispose();
    _followUpFocusNode.dispose();
    _contractNoFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Add Drone'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // StreamBuilder for selecting Buyer
              StreamBuilder<List<Buyer>>(
                stream: buyerService.getAllBuyers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Populate buyers dropdown
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Buyer',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: _selectedBuyerId,
                    items: snapshot.data!.map((buyer) {
                      return DropdownMenuItem<String>(
                        value: buyer.id,
                        child: Text(buyer.buyer), // Display buyer name
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBuyerId = value; // Set selected buyer ID
                        _bId = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a buyer' : null,
                  );
                },
              ),
              SizedBox(height: 20),

              // StreamBuilder for selecting Seller
              StreamBuilder<List<Seller>>(
                stream: sellerService.getAllSellers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Populate sellers dropdown
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Seller',
                      prefixIcon: Icon(Icons.store_mall_directory),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: _selectedSellerId,
                    items: snapshot.data!.map((seller) {
                      return DropdownMenuItem<String>(
                        value: seller.id,
                        child: Text(seller.sellerName), // Display seller name
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSellerId = value; // Set selected seller ID
                        _sId = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a seller' : null,
                  );
                },
              ),
              SizedBox(height: 20),

              // Input fields with icons and focus
              _buildTextFormField(
                label: 'Brand',
                icon: Icons.flight,
                focusNode: _brandFocusNode,
                validator: (value) => value!.isEmpty ? 'Enter brand' : null,
                onSaved: (value) => _brand = value,
                nextFocusNode: _modelFocusNode,
              ),
              _buildTextFormField(
                label: 'Model',
                icon: Icons.airplanemode_active,
                focusNode: _modelFocusNode,
                validator: (value) => value!.isEmpty ? 'Enter model' : null,
                onSaved: (value) => _model = value,
                nextFocusNode: _serialNumberFocusNode,
              ),
              _buildTextFormField(
                label: 'Serial Number',
                icon: Icons.confirmation_number,
                focusNode: _serialNumberFocusNode,
                validator: (value) =>
                    value!.isEmpty ? 'Enter serial number' : null,
                onSaved: (value) => _serialNumber = value,
                nextFocusNode: _webPriceFocusNode,
              ),
              _buildTextFormField(
                label: 'Website Price',
                icon: Icons.monetization_on,
                focusNode: _webPriceFocusNode,
                validator: (value) => value!.isEmpty ? 'Enter web price' : null,
                onSaved: (value) => _webPrice = value!,
                keyboardType: TextInputType.number,
                nextFocusNode: _customerPriceFocusNode,
              ),
              _buildTextFormField(
                label: 'Customer Price',
                icon: Icons.attach_money,
                focusNode: _customerPriceFocusNode,
                validator: (value) =>
                    value!.isEmpty ? 'Enter customer price' : null,
                onSaved: (value) => _customerPrice = value!,
                keyboardType: TextInputType.number,
                nextFocusNode: _commissionFocusNode,
              ),
              _buildTextFormField(
                label: 'Commission',
                icon: Icons.money,
                focusNode: _commissionFocusNode,
                validator: (value) =>
                    value!.isEmpty ? 'Enter commission' : null,
                onSaved: (value) => _commission = value,
                nextFocusNode: _followUpFocusNode,
              ),
              _buildTextFormField(
                label: 'Follow Up',
                icon: Icons.follow_the_signs,
                focusNode: _followUpFocusNode,
                onSaved: (value) => _followUp = value,
                nextFocusNode: _contractNoFocusNode,
                validator: (String? value) {},
              ),
              _buildTextFormField(
                label: 'Contract Number',
                icon: Icons.note,
                focusNode: _contractNoFocusNode,
                onSaved: (value) => _contractNo = value,
                validator: (String? value) {},
              ),
              SizedBox(height: 20),

              // Checkbox for status
              CheckboxListTile(
                title: Text('Is Drone Active'),
                value: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Add Drone', style: TextStyle(fontSize: 18)),
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

  // Helper to build text form fields with icons
  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required FocusNode focusNode,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
    FocusNode? nextFocusNode,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        focusNode: focusNode,
        keyboardType: keyboardType,
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
            nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        onFieldSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}
