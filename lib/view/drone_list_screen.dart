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
        title: const Text('Drone List'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active Drones'),
            Tab(text: 'Non-Active Drones'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
          _buildDroneList(true),
          _buildDroneList(false),
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
            border: TableBorder.all(),
            columns: [
              DataColumn(label: Text('Drone ID')),
              DataColumn(label: Text('Brand')),
              DataColumn(label: Text('Model')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Web Price')),
              DataColumn(label: Text('Customer Price')),
              DataColumn(label: Text('Commission')),
              DataColumn(label: Text('Follow Up')),
              DataColumn(label: Text('Sold Date')),
              DataColumn(label: Text('Actions')),
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
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showUpdateDialog(context, drone); // Update dialog
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _confirmDelete(context, drone.dId);
                        },
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
            TextButton(
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

  void _showUpdateDialog(BuildContext context, Drone drone) {
    // Initialize controllers with existing drone data
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

    // For dropdowns
    ValueNotifier<String?> selectedSellerId = ValueNotifier<String?>(drone.sId);
    ValueNotifier<String?> selectedBuyerId = ValueNotifier<String?>(drone.bId);

    // Status of the drone (active or not) using ValueNotifier
    ValueNotifier<bool> isActive = ValueNotifier<bool>(drone.status);

    // Show dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Drone'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: brandController,
                  decoration: InputDecoration(labelText: 'Brand'),
                ),
                TextField(
                  controller: modelController,
                  decoration: InputDecoration(labelText: 'Model'),
                ),
                TextField(
                  controller: webPriceController,
                  decoration: InputDecoration(labelText: 'Web Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: customerPriceController,
                  decoration: InputDecoration(labelText: 'Customer Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: commissionController,
                  decoration: InputDecoration(labelText: 'Commission'),
                ),
                TextField(
                  controller: followUpController,
                  decoration: InputDecoration(labelText: 'Follow Up'),
                ),
                // ValueListenableBuilder for Seller Dropdown
                ValueListenableBuilder<String?>(
                  valueListenable: selectedSellerId,
                  builder: (context, value, child) {
                    return DropdownButton<String>(
                      value: value,
                      hint: Text('Select Seller'),
                      onChanged: (String? newValue) {
                        selectedSellerId.value = newValue;
                      },
                      items: sellers
                          .map<DropdownMenuItem<String>>((Seller seller) {
                        return DropdownMenuItem<String>(
                          value: seller.id,
                          child: Text(seller.sellerName),
                        );
                      }).toList(),
                    );
                  },
                ),
                // ValueListenableBuilder for Buyer Dropdown
                ValueListenableBuilder<String?>(
                  valueListenable: selectedBuyerId,
                  builder: (context, value, child) {
                    return DropdownButton<String>(
                      value: value,
                      hint: Text('Select Buyer'),
                      onChanged: (String? newValue) {
                        selectedBuyerId.value = newValue;
                      },
                      items:
                          buyers.map<DropdownMenuItem<String>>((Buyer buyer) {
                        return DropdownMenuItem<String>(
                          value: buyer.id,
                          child: Text(buyer.buyer),
                        );
                      }).toList(),
                    );
                  },
                ),
                // Sold Date
                TextField(
                  controller: soldDateController,
                  decoration:
                      InputDecoration(labelText: 'Sold Date (YYYY-MM-DD)'),
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      soldDateController.text =
                          DateFormat('yyyy-MM-dd').format(picked);
                    }
                  },
                ),
                // ValueListenableBuilder for Status Checkbox
                ValueListenableBuilder<bool>(
                  valueListenable: isActive,
                  builder: (context, value, child) {
                    return CheckboxListTile(
                      title: Text('Is Active?'),
                      value: value,
                      onChanged: (bool? newValue) {
                        isActive.value =
                            newValue ?? false; // Default to false if null
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
            TextButton(
              onPressed: () {
                // Update the drone details
                Drone updatedDrone = Drone(
                  dId: drone.dId, // Keep the same drone ID
                  bId: selectedBuyerId.value!,
                  sId: selectedSellerId.value!,
                  brand: brandController.text,
                  model: modelController.text,
                  serialNumber:
                      drone.serialNumber, // Serial number remains unchanged
                  webPrice: webPriceController.text,
                  customerPrice: customerPriceController.text,
                  commision: commissionController.text,
                  followUp: followUpController.text,
                  status:
                      isActive.value, // Update the status from ValueNotifier
                  soldDate: soldDateController.text.isNotEmpty
                      ? DateTime.tryParse(soldDateController.text)
                      : null, // Parse the date if provided
                  contractNo: drone.contractNo, // Keep the same contract number
                );

                // Call the update service
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
}
