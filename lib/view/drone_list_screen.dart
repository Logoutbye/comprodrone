import 'package:com_pro_drone/services/buyer_services.dart';
import 'package:com_pro_drone/services/seller_services.dart';
import 'package:com_pro_drone/view/add_drone.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formateo de fechas
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
    _fetchNames(); // Obtener compradores y vendedores
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
        title: const Text('Lista de Drones'),
        bottom: TabBar(
          labelStyle: TextStyle(color: Colors.white),
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Drones Activos',
            ),
            Tab(text: 'Drones No Activos'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Agregar Drone',
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
          _buildDroneList(true), // Drones Activos
          _buildDroneList(false), // Drones No Activos
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
          return Center(child: Text('No hay drones disponibles.'));
        }

        final drones =
            snapshot.data!.where((drone) => drone.status == isActive).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(color: Colors.grey[300]!),
            columns: [
              DataColumn(label: Text('ID del Drone', style: _tableHeaderStyle())),
              DataColumn(label: Text('Marca', style: _tableHeaderStyle())),
              DataColumn(label: Text('Modelo', style: _tableHeaderStyle())),
              DataColumn(label: Text('Estado', style: _tableHeaderStyle())),
              DataColumn(label: Text('Precio Web', style: _tableHeaderStyle())),
              DataColumn(
                  label: Text('Precio al Cliente', style: _tableHeaderStyle())),
              DataColumn(label: Text('Comisión', style: _tableHeaderStyle())),
              DataColumn(label: Text('Seguimiento', style: _tableHeaderStyle())),
              DataColumn(label: Text('Fecha de Venta', style: _tableHeaderStyle())),
              DataColumn(label: Text('Acciones', style: _tableHeaderStyle())),
            ],
            rows: drones.map((drone) {
              return DataRow(cells: [
                DataCell(Text(drone.dId)),
                DataCell(Text(drone.brand)),
                DataCell(Text(drone.model)),
                DataCell(Text(drone.status ? 'Activo' : 'No Activo')),
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
                          _showUpdateDialog(context, drone); // Dialogo para actualizar
                        },
                        tooltip: 'Editar Drone',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _confirmDelete(context, drone.dId);
                        },
                        tooltip: 'Eliminar Drone',
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

  // Método para confirmar eliminación del drone
  void _confirmDelete(BuildContext context, String droneId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este drone?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                droneService.deleteDrone(droneId); // Llamar método de eliminación
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Método para mostrar diálogo de actualización de drone
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
          title: Text('Actualizar Drone'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(brandController, 'Marca'),
                _buildTextField(modelController, 'Modelo'),
                _buildTextField(webPriceController, 'Precio Web',
                    keyboardType: TextInputType.number),
                _buildTextField(customerPriceController, 'Precio al Cliente',
                    keyboardType: TextInputType.number),
                _buildTextField(commissionController, 'Comisión'),
                _buildTextField(followUpController, 'Seguimiento'),
                _buildDropdownButton(
                  context,
                  'Seleccionar Vendedor',
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
                  'Seleccionar Comprador',
                  selectedBuyerId,
                  buyers.map<DropdownMenuItem<String>>((Buyer buyer) {
                    return DropdownMenuItem<String>(
                      value: buyer.id,
                      child: Text(buyer.buyer),
                    );
                  }).toList(),
                ),
                _buildDateField(soldDateController, context, 'Fecha de Venta'),
                ValueListenableBuilder<bool>(
                  valueListenable: isActive,
                  builder: (context, value, child) {
                    return CheckboxListTile(
                      title: Text('¿Activo?'),
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
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Drone updatedDrone = Drone(
                  dId: drone.dId,
                  bId: selectedBuyerId.value!,
                  sId: selectedSellerId.value!,
                  brand: brandController.text,
                  model: modelController.text,
                  serialNumber: drone.serialNumber, // Número de serie sin cambios
                  webPrice: webPriceController.text,
                  customerPrice: customerPriceController.text,
                  commision: commissionController.text,
                  followUp: followUpController.text,
                  status: isActive.value, // Estado actualizado
                  soldDate: soldDateController.text.isNotEmpty
                      ? DateTime.tryParse(soldDateController.text)
                      : null,
                  contractNo: drone.contractNo,
                );
                droneService.updateDrone(drone.dId, updatedDrone);
                Navigator.of(context).pop(); // Cerrar diálogo después de actualizar
              },
              child: Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  // Helper para construir un campo de texto
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

  // Helper para construir un campo de fecha
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

  // Helper para construir un botón de lista desplegable
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

  // Método helper para encabezados de tabla
  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.black54,
    );
  }
}
