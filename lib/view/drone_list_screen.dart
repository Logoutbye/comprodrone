import 'package:com_pro_drone/services/buyer_services.dart';
import 'package:com_pro_drone/services/seller_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/buyer_model.dart';
import '../models/drone_model.dart';
import '../models/seller_model.dart';
import '../services/drone_services.dart';

class DroneListScreen extends StatefulWidget {
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
        title: Text('Drone List'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Active Drones'),
            Tab(text: 'Non-Active Drones'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddOrUpdateDialog(context, null); // Call add dialog
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
                          _showAddOrUpdateDialog(
                              context, drone); // Update dialog
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

  // Add/Update Dialog
  void _showAddOrUpdateDialog(BuildContext context, Drone? drone) {
    final bool isUpdate = drone != null; // Check if it's an update or add

    final TextEditingController brandController =
        TextEditingController(text: isUpdate ? drone!.brand : '');
    final TextEditingController modelController =
        TextEditingController(text: isUpdate ? drone.model : '');
    final TextEditingController webPriceController =
        TextEditingController(text: isUpdate ? drone.webPrice.toString() : '');
    final TextEditingController customerPriceController = TextEditingController(
        text: isUpdate ? drone.customerPrice.toString() : '');
    final TextEditingController commissionController =
        TextEditingController(text: isUpdate ? drone.commision : '');
    final TextEditingController followUpController =
        TextEditingController(text: isUpdate ? drone.followUp : '');
    final TextEditingController soldDateController = TextEditingController(
      text: isUpdate && drone.soldDate != null
          ? DateFormat('yyyy-MM-dd').format(drone.soldDate!)
          : '',
    );

    String? selectedSellerId = isUpdate ? drone!.sId : null;
    String? selectedBuyerId = isUpdate ? drone.bId : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUpdate ? 'Update Drone' : 'Add Drone'),
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
                // Dropdown for selecting Seller
                DropdownButton<String>(
                  value: selectedSellerId,
                  hint: Text('Select Seller'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSellerId = newValue;
                    });
                  },
                  items: sellers.map<DropdownMenuItem<String>>((Seller seller) {
                    return DropdownMenuItem<String>(
                      value: seller.id,
                      child: Text(seller.sellerName),
                    );
                  }).toList(),
                ),
                // Dropdown for selecting Buyer
                DropdownButton<String>(
                  value: selectedBuyerId,
                  hint: Text('Select Buyer'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBuyerId = newValue;
                    });
                  },
                  items: buyers.map<DropdownMenuItem<String>>((Buyer buyer) {
                    return DropdownMenuItem<String>(
                      value: buyer.id,
                      child: Text(buyer.buyer),
                    );
                  }).toList(),
                ),
                // Sold Date (only show in update)
                if (isUpdate)
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
                Drone updatedDrone = Drone(
                    dId: isUpdate
                        ? drone!.dId
                        : '', // Drone ID in case of update
                    bId: selectedBuyerId!,
                    sId: selectedSellerId!,
                    brand: brandController.text,
                    model: modelController.text,
                    serialNumber: isUpdate ? drone!.serialNumber : '',
                    webPrice: double.tryParse(webPriceController.text) ?? 0.0,
                    customerPrice:
                        double.tryParse(customerPriceController.text) ?? 0.0,
                    commision: commissionController.text,
                    followUp: followUpController.text,
                    status: isUpdate
                        ? drone!.status
                        : true, // Default status as true for add
                    soldDate: isUpdate && soldDateController.text.isNotEmpty
                        ? DateTime.tryParse(soldDateController.text)
                        : null,
                    contractNo: drone!.contractNo);

                if (isUpdate) {
                  droneService.updateDrone(
                      drone.dId, updatedDrone); // Update drone
                } else {
                  droneService.addDrone(updatedDrone); // Add new drone
                }

                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(isUpdate ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }
}
