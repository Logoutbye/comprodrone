import 'package:com_pro_drone/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';
import 'add_order_screen.dart';

class OrderListScreen extends StatelessWidget {
  final OrderService orderService = OrderService(); // Instanciar el servicio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddOrderScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Lista de Pedidos', style: TextStyle(fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Center(
            child: StreamBuilder<List<Order>>(
              stream:
                  orderService.getAllOrders(), // Obtener pedidos en tiempo real
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator()); // Estado de carga
                }

                if (snapshot.hasError) {
                  return Center(
                      child:
                          Text('Error: ${snapshot.error}')); // Estado de error
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 400.0),
                    child: Center(
                      child: Text(
                        'No se encontraron pedidos',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ); // Estado vacío
                }

                // Si tenemos datos, mostrarlos en un DataTable
                List<Order> orders = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Manejar desbordamiento
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DataTable(
                        border:
                            TableBorder.all(color: Colors.grey[300]!, width: 1),
                        columns: [
                          DataColumn(
                              label: Text('ID', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Fecha', style: _tableHeaderStyle())),
                          DataColumn(
                              label:
                                  Text('Cliente', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Correo Electrónico',
                                  style: _tableHeaderStyle())),
                          DataColumn(
                              label:
                                  Text('Ciudad', style: _tableHeaderStyle())),
                          DataColumn(
                              label:
                                  Text('Teléfono', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Necesidad',
                                  style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Observaciones',
                                  style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Seguimiento',
                                  style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Presupuesto',
                                  style: _tableHeaderStyle())),
                          DataColumn(
                              label:
                                  Text('Acciones', style: _tableHeaderStyle())),
                        ],
                        rows: orders.map((order) {
                          return DataRow(cells: [
                            DataCell(Text(order.id)),
                            DataCell(Text(order.date)),
                            DataCell(Text(order.client)),
                            DataCell(Text(order.email)),
                            DataCell(Text(order.city)),
                            DataCell(Text(order.phone)),
                            DataCell(Text(order.need)),
                            DataCell(Text(order.remarks)),
                            DataCell(Text(order.followUp)),
                            DataCell(Text(order.budget)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      _showEditDialog(context, order);
                                    },
                                    tooltip: 'Editar Pedido',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      _confirmDelete(context, order.id);
                                    },
                                    tooltip: 'Eliminar Pedido',
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Método para mostrar el cuadro de diálogo de edición
  void _showEditDialog(BuildContext context, Order order) {
    final TextEditingController dateController =
        TextEditingController(text: order.date);
    final TextEditingController clientController =
        TextEditingController(text: order.client);
    final TextEditingController emailController =
        TextEditingController(text: order.email);
    final TextEditingController phoneController =
        TextEditingController(text: order.phone);
    final TextEditingController cityController =
        TextEditingController(text: order.city);
    final TextEditingController needController =
        TextEditingController(text: order.need);
    final TextEditingController remarksController =
        TextEditingController(text: order.remarks);
    final TextEditingController followUpController =
        TextEditingController(text: order.followUp);
    final TextEditingController budgetController =
        TextEditingController(text: order.budget);

    // Función para manejar la selección de fecha
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateFormat('dd-MM-yyyy').parse(order.date),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Pedido'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    hintText: 'Seleccionar fecha',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                ),
                _buildTextField(clientController, 'Cliente', Icons.person),
                _buildTextField(
                    emailController, 'Correo Electrónico', Icons.email),
                _buildTextField(phoneController, 'Teléfono', Icons.phone),
                _buildTextField(cityController, 'Ciudad', Icons.location_city),
                _buildTextField(needController, 'Necesidad', Icons.list),
                _buildTextField(
                    remarksController, 'Observaciones', Icons.comment),
                _buildTextField(
                    followUpController, 'Seguimiento', Icons.follow_the_signs),
                _buildTextField(budgetController, 'Presupuesto', Icons.money),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Actualizar la información del pedido
                Order updatedOrder = Order(
                  id: order.id,
                  date: dateController.text,
                  client: clientController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  city: cityController.text,
                  need: needController.text,
                  budget: budgetController.text,
                  followUp: followUpController.text,
                  remarks: remarksController.text,
                );

                await orderService.updateOrder(order.id, updatedOrder);
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  // Método para confirmar eliminación
  Future<void> _confirmDelete(BuildContext context, String orderId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await orderService.deleteOrder(orderId); // Eliminar pedido
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Método para construir un campo de texto con icono
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Método para estilizar los encabezados de la tabla
  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,
      fontSize: 16,
    );
  }
}
