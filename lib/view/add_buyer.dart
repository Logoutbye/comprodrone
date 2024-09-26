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

  // Focus nodes for each text field
  FocusNode _buyerNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _budgetFocusNode = FocusNode();
  FocusNode _requirementsFocusNode = FocusNode();
  FocusNode _remarksFocusNode = FocusNode();
  FocusNode _followUpFocusNode = FocusNode();
  FocusNode _notesFocusNode = FocusNode();

  // Function to handle date picking
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
            DateFormat('dd-MM-yyyy').format(picked); // Format the date
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
                .format(DateTime.now()), // Use selected date or current date
        buyer: _buyerName!,
        email: _email!,
        phone: _phone!,
        city: _city!,
        requirements: _requirements ?? 'None',
        remarks: _remarks ?? 'None',
        followUp: _followUp ?? 'None',
        notes: _notes ?? 'None',
        budget: _budget!,
      );
      buyerService.addBuyer(newBuyer); // Add buyer to Firestore
      Navigator.pop(context); // Go back after adding
    }
  }

  @override
  void dispose() {
    // Dispose of all FocusNodes
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
      appBar: AppBar(title: Text('Add Buyer')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600, // Limit the maximum width
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Buyer Name Field
                  TextFormField(
                    focusNode: _buyerNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Buyer Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a name' : null,
                    onSaved: (value) => _buyerName = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    focusNode: _emailFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter an email' : null,
                    onSaved: (value) => _email = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_phoneFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Phone Field
                  TextFormField(
                    focusNode: _phoneFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a phone number' : null,
                    onSaved: (value) => _phone = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_cityFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // City Field
                  TextFormField(
                    focusNode: _cityFocusNode,
                    decoration: InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a city' : null,
                    onSaved: (value) => _city = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_budgetFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Budget Field
                  TextFormField(
                    focusNode: _budgetFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Budget',
                      prefixIcon: Icon(Icons.money),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a budget' : null,
                    onSaved: (value) => _budget = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_requirementsFocusNode);
                    },
                  ),
                  SizedBox(height: 20),

                  // Requirements Field
                  TextFormField(
                    focusNode: _requirementsFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Requirements',
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

                  // Remarks Field
                  TextFormField(
                    focusNode: _remarksFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Remarks',
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

                  // Follow-Up Field
                  TextFormField(
                    focusNode: _followUpFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Follow Up',
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

                  // Notes Field
                  TextFormField(
                    focusNode: _notesFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Notes',
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

                  // Date Field with Calendar Picker
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Select date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(
                        text: _selectedDate), // Display selected date
                  ),
                  SizedBox(height: 30),

                  // Add Buyer Button
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Add Buyer'),
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
