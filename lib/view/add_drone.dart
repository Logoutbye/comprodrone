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
  final FocusNode _statusFocusNode = FocusNode();
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

      // Check for null values
      if (_sId == null ||
          _bId == null ||
          _brand == null ||
          _model == null ||
          _serialNumber == null ||
          _webPrice == null ||
          _customerPrice == null ||
          _commission == null) {
        // Handle error
        print(
            '::: drone ading :sId: $_sId, bId: $_bId, brand: $_brand, model: $_model, serialNumber: $_serialNumber, webPrice: $_webPrice, customerPrice: $_customerPrice, commission: $_commission');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Please fill all required fields')),
        );
        return; // Exit the method early
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
        soldDate: null, // Set soldDate to null
        contractNo:
            _contractNo ?? '', // Default to empty string if not provided
      );

      // Add drone to the database
      droneService.addDrone(newDrone);
      print(
          '::: drone added :sId: $_sId, bId: $_bId, brand: $_brand, model: $_model, serialNumber: $_serialNumber, webPrice: $_webPrice, customerPrice: $_customerPrice, commission: $_commission');

      Navigator.pop(context); // Go back after adding
    }
  }

  @override
  void dispose() {
    // Dispose FocusNodes
    _brandFocusNode.dispose();
    _statusFocusNode.dispose();
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
      appBar: AppBar(title: Text('Add Drone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // StreamBuilder for selecting Buyer
              StreamBuilder<List<Buyer>>(
                stream: buyerService
                    .getAllBuyers(), // Ensure this method returns a Stream<List<Buyer>>
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Loading state
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Error state
                  }

                  // Populate buyers dropdown
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Select Buyer'),
                    value: _selectedBuyerId,
                    items: snapshot.data!.map((buyer) {
                      return DropdownMenuItem<String>(
                        value: buyer.id,
                        child: Text(buyer.buyer), // Display buyer name
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBuyerId = value; // Set the selected buyer ID
                        _bId = value; // Store the selected buyer ID
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Select a buyer' : null,
                  );
                },
              ),
              SizedBox(height: 20),

              // StreamBuilder for selecting Seller
              StreamBuilder<List<Seller>>(
                stream: sellerService
                    .getAllSellers(), // Ensure this method returns a Stream<List<Seller>>
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Loading state
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Error state
                  }

                  // Populate sellers dropdown
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Select Seller'),
                    value: _selectedSellerId,
                    items: snapshot.data!.map((seller) {
                      return DropdownMenuItem<String>(
                        value: seller.id,
                        child: Text(seller.sellerName), // Display seller name
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSellerId = value; // Set the selected seller ID
                        _sId = value; // Store the selected seller ID
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Select a seller' : null,
                  );
                },
              ),
              SizedBox(height: 20),

              // Input fields with FocusNode
              TextFormField(
                focusNode: _brandFocusNode,
                decoration: InputDecoration(labelText: 'Brand'),
                validator: (value) => value!.isEmpty ? 'Enter brand' : null,
                onSaved: (value) => _brand = value,
                textInputAction: TextInputAction.next, // Move to the next field
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_modelFocusNode);
                },
              ),
              TextFormField(
                focusNode: _modelFocusNode,
                decoration: InputDecoration(labelText: 'Model'),
                validator: (value) => value!.isEmpty ? 'Enter model' : null,
                onSaved: (value) => _model = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_serialNumberFocusNode);
                },
              ),
              TextFormField(
                focusNode: _serialNumberFocusNode,
                decoration: InputDecoration(labelText: 'Serial Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter serial number' : null,
                onSaved: (value) => _serialNumber = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_webPriceFocusNode);
                },
              ),
              TextFormField(
                focusNode: _webPriceFocusNode,
                decoration: InputDecoration(labelText: 'Website Price'),
                validator: (value) => value!.isEmpty ? 'Enter web price' : null,
                keyboardType: TextInputType.number,
                onSaved: (value) => _webPrice = value!,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_customerPriceFocusNode);
                },
              ),
              TextFormField(
                focusNode: _customerPriceFocusNode,
                decoration: InputDecoration(labelText: 'Customer Price'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter customer price' : null,
                keyboardType: TextInputType.number,
                onSaved: (value) => _customerPrice = value!,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_commissionFocusNode);
                },
              ),
              TextFormField(
                focusNode: _commissionFocusNode,
                decoration: InputDecoration(labelText: 'Commission'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter commission' : null,
                onSaved: (value) => _commission = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_followUpFocusNode);
                },
              ),
              TextFormField(
                focusNode: _followUpFocusNode,
                decoration: InputDecoration(labelText: 'Follow Up'),
                onSaved: (value) => _followUp = value,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_contractNoFocusNode);
                },
              ),
              TextFormField(
                focusNode: _contractNoFocusNode,
                decoration: InputDecoration(labelText: 'Contract Number'),
                onSaved: (value) => _contractNo = value,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _submitForm(); // Submit the form when done
                },
              ),
              SizedBox(height: 20),
              // Checkbox for status
              CheckboxListTile(
                title: Text('Is Drone Active'),
                value: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value ?? false; // Ensure it's not null
                  });
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Drone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
