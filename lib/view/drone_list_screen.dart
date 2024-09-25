import 'package:flutter/material.dart';
import '../models/drone_model.dart';
import '../services/drone_services.dart'; // Ensure the correct path to your DroneService
import 'add_drone.dart';

class DroneListScreen extends StatefulWidget {
  @override
  _DroneListScreenState createState() => _DroneListScreenState();
}

class _DroneListScreenState extends State<DroneListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController; // Declare a TabController
  final DroneService droneService = DroneService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Initialize TabController with 2 tabs
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
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
            Tab(text: 'Active Drones'), // Tab for active drones
            Tab(text: 'Non-Active Drones'), // Tab for non-active drones
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDroneScreen()),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDroneList(true), // Show active drones
          _buildDroneList(false), // Show non-active drones
        ],
      ),
    );
  }

  Widget _buildDroneList(bool isActive) {
    return StreamBuilder<List<Drone>>(
      stream: droneService.getAllDrones(), // Ensure this method returns a Stream<List<Drone>>
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

        final drones = snapshot.data!.where((drone) => drone.status == isActive).toList(); // Filter drones by status

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
                DataCell(Text(drone.soldDate.toString())), // Format as needed
                DataCell(
                  Row(
                    children: [
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
}
