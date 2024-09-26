import 'package:com_pro_drone/services/buyer_services.dart';
import 'package:com_pro_drone/services/seller_services.dart';
import 'package:com_pro_drone/view/add_drone.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/buyer_model.dart';
import '../models/drone_model.dart';
import '../models/seller_model.dart';
import '../services/drone_services.dart';

class DroneListScreen extends StatefulWidget {
  const DroneListScreen({super.key});

  @override
  _DroneListScreenState createState() => _DroneListScreenState();
}

class _DroneListScreenState extends State<DroneListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DroneService droneService = DroneService();
  final SellerService sellerService = SellerService();
  final BuyerService buyerService = BuyerService();

  List<Buyer> buyers = [];
  List<Seller> sellers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchNames(); // Fetch buyers and sellers
  }

  Future<void> _fetchNames() async {
    buyerService.getAllBuyers().listen((buyerList) {
      setState(() {
        buyers = buyerList;
      });
    });

    sellerService.getAllSellers().listen((sellerList) {
      setState(() {
        sellers = sellerList;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Drone List'),
        bottom: TabBar(
          labelStyle: TextStyle(color: Colors.white),
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Active Drones',
            ),
            Tab(text: 'Non-Active Drones'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Drone',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDroneScreen(),
                  ));
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDroneList(true), // Active Drones
          _buildDroneList(false), // Non-Active Drones
        ],
      ),
    );
  }

  Widget _buildDroneList(bool isActive) {
    return StreamBuilder<List<Drone>>(
      stream: droneService.getAllDrones(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No drones available.'));
        }

        final drones =
            snapshot.data!.where((drone) => drone.status == isActive).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(color: Colors.grey[300]!),
            columns: [
              DataColumn(label: Text('Drone ID', style: _tableHeaderStyle())),
              DataColumn(label: Text('Brand', style: _tableHeaderStyle())),
              DataColumn(label: Text('Model', style: _tableHeaderStyle())),
              DataColumn(label: Text('Status', style: _tableHeaderStyle())),
              DataColumn(label: Text('Web Price', style: _tableHeaderStyle())),
              DataColumn(
                  label: Text('Customer Price', style: _tableHeaderStyle())),
              DataColumn(label: Text('Commission', style: _tableHeaderStyle())),
              DataColumn(label: Text('Follow Up', style: _tableHeaderStyle())),
              DataColumn(label: Text('Sold Date', style: _tableHeaderStyle())),
              DataColumn(label: Text('Actions', style: _tableHeaderStyle())),
            ],
            rows: drones.map((drone) {
              return DataRow(cells: [
                DataCell(Text(drone.dId)),
                DataCell(Text(drone.brand)),
                DataCell(Text(drone.model)),
                DataCell(Text(drone.status ? 'Active' : 'Non-Active')),
                DataCell(Text(drone.webPrice.toString())),
                DataCell(Text(drone.customerPrice.toString())),
                DataCell(Text(drone.commision)),
                DataCell(Text(drone.followUp)),
                DataCell(Text(
                    drone.soldDate?.toLocal().toString().split(' ')[0] ?? '')),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          _showUpdateDialog(context, drone); // Update dialog
                        },
                        tooltip: 'Edit Drone',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _confirmDelete(context, drone.dId);
                        },
                        tooltip: 'Delete Drone',
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }

  // Method to confirm drone deletion
  void _confirmDelete(BuildContext context, String droneId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this drone?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                droneService.deleteDrone(droneId); // Call delete method
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Method to show drone update dialog
  void _showUpdateDialog(BuildContext context, Drone drone) {
    final TextEditingController brandController =
        TextEditingController(text: drone.brand);
    final TextEditingController modelController =
        TextEditingController(text: drone.model);
    final TextEditingController webPriceController =
        TextEditingController(text: drone.webPrice.toString());
    final TextEditingController customerPriceController =
        TextEditingController(text: drone.customerPrice.toString());
    final TextEditingController commissionController =
        TextEditingController(text: drone.commision);
    final TextEditingController followUpController =
        TextEditingController(text: drone.followUp);
    final TextEditingController soldDateController = TextEditingController(
      text: drone.soldDate != null
          ? DateFormat('yyyy-MM-dd').format(drone.soldDate!)
          : '',
    );

    ValueNotifier<String?> selectedSellerId = ValueNotifier<String?>(drone.sId);
    ValueNotifier<String?> selectedBuyerId = ValueNotifier<String?>(drone.bId);
    ValueNotifier<bool> isActive = ValueNotifier<bool>(drone.status);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Drone'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(brandController, 'Brand'),
                _buildTextField(modelController, 'Model'),
                _buildTextField(webPriceController, 'Web Price',
                    keyboardType: TextInputType.number),
                _buildTextField(customerPriceController, 'Customer Price',
                    keyboardType: TextInputType.number),
                _buildTextField(commissionController, 'Commission'),
                _buildTextField(followUpController, 'Follow Up'),
                _buildDropdownButton(
                  context,
                  'Select Seller',
                  selectedSellerId,
                  sellers.map<DropdownMenuItem<String>>((Seller seller) {
                    return DropdownMenuItem<String>(
                      value: seller.id,
                      child: Text(seller.sellerName),
                    );
                  }).toList(),
                ),
                _buildDropdownButton(
                  context,
                  'Select Buyer',
                  selectedBuyerId,
                  buyers.map<DropdownMenuItem<String>>((Buyer buyer) {
                    return DropdownMenuItem<String>(
                      value: buyer.id,
                      child: Text(buyer.buyer),
                    );
                  }).toList(),
                ),
                _buildDateField(soldDateController, context, 'Sold Date'),
                ValueListenableBuilder<bool>(
                  valueListenable: isActive,
                  builder: (context, value, child) {
                    return CheckboxListTile(
                      title: Text('Is Active?'),
                      value: value,
                      onChanged: (newValue) {
                        isActive.value = newValue ?? false;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Drone updatedDrone = Drone(
                  dId: drone.dId,
                  bId: selectedBuyerId.value!,
                  sId: selectedSellerId.value!,
                  brand: brandController.text,
                  model: modelController.text,
                  serialNumber: drone.serialNumber, // Unchanged serial number
                  webPrice: webPriceController.text,
                  customerPrice: customerPriceController.text,
                  commision: commissionController.text,
                  followUp: followUpController.text,
                  status: isActive.value, // Updated status
                  soldDate: soldDateController.text.isNotEmpty
                      ? DateTime.tryParse(soldDateController.text)
                      : null,
                  contractNo: drone.contractNo,
                );
                droneService.updateDrone(drone.dId, updatedDrone);
                Navigator.of(context).pop(); // Close dialog after updating
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Helper to build a text field
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Helper to build a date field
  Widget _buildDateField(TextEditingController controller, BuildContext context,
      String labelText) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
      ),
    );
  }

  // Helper to build a dropdown button
  Widget _buildDropdownButton(BuildContext context, String hint,
      ValueNotifier<String?> selectedId, List<DropdownMenuItem<String>> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ValueListenableBuilder<String?>(
        valueListenable: selectedId,
        builder: (context, value, child) {
          return DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: Text(hint),
            onChanged: (newValue) {
              selectedId.value = newValue;
            },
            items: items,
          );
        },
      ),
    );
  }

  // Helper method for table headers
  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.black54,
    );
  }
}
