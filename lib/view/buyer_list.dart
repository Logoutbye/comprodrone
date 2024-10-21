import 'package:com_pro_drone/models/buyer_model.dart';
import 'package:com_pro_drone/view/add_buyer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importar para formateo de fecha
import '../services/buyer_services.dart';

class BuyerListScreen extends StatelessWidget {
  final BuyerService buyerService = BuyerService(); // Instanciar el servicio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBuyerScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent, // Actualizar el color del botón
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Lista de Compradores', style: TextStyle(fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Actualizar el color de la AppBar
        elevation: 0,
      ),
      body: Column(
        children: [
          Center(
            child: StreamBuilder<List<Buyer>>(
              stream:
                  buyerService.getAllBuyers(), // Obtener compradores en tiempo real
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator()); // Estado de carga
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}')); // Estado de error
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No se encontraron compradores',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ); // Estado vacío
                }

                // Si tenemos datos, los mostramos en un DataTable
                List<Buyer> buyers = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Manejar desbordamiento para muchas columnas
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DataTable(
                        border: TableBorder.all(
                            color: Colors.grey[300]!,
                            width: 1), // Agregar borde a la tabla
                        columns: [
                          DataColumn(
                              label: Text('ID', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Fecha', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Nombre', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Correo', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Ciudad', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Teléfono', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Requisitos',
                                  style: _tableHeaderStyle())),
                          DataColumn(
                              label:
                                  Text('Observaciones', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Seguimiento',
                                  style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Notas', style: _tableHeaderStyle())),
                          DataColumn(
                              label:
                                  Text('Presupuesto', style: _tableHeaderStyle())),
                          DataColumn(
                              label:
                                  Text('Acciones', style: _tableHeaderStyle())),
                        ],
                        rows: buyers.map((buyer) {
                          return DataRow(cells: [
                            DataCell(Text(buyer.id)),
                            DataCell(Text(buyer.date)),
                            DataCell(Text(buyer.buyer)),
                            DataCell(Text(buyer.email)),
                            DataCell(Text(buyer.city)),
                            DataCell(Text(buyer.phone)),
                            DataCell(Text(buyer.requirements)),
                            DataCell(Text(buyer.remarks)), // Mostrar observaciones
                            DataCell(Text(buyer.followUp)), // Mostrar seguimiento
                            DataCell(Text(buyer.notes)), // Mostrar notas
                            DataCell(Text(buyer.budget)), // Mostrar presupuesto
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      _showEditDialog(
                                          context, buyer); // Mostrar diálogo de edición
                                    },
                                    tooltip: 'Editar Comprador',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      _confirmDelete(context,
                                          buyer.id); // Mostrar confirmación de eliminación
                                    },
                                    tooltip: 'Eliminar Comprador',
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

  // Método para mostrar el diálogo de edición
  void _showEditDialog(BuildContext context, Buyer buyer) {
    final TextEditingController dateController =
        TextEditingController(text: buyer.date);
    final TextEditingController nameController =
        TextEditingController(text: buyer.buyer);
    final TextEditingController emailController =
        TextEditingController(text: buyer.email);
    final TextEditingController phoneController =
        TextEditingController(text: buyer.phone);
    final TextEditingController cityController =
        TextEditingController(text: buyer.city);
    final TextEditingController requirementsController =
        TextEditingController(text: buyer.requirements);
    final TextEditingController remarksController =
        TextEditingController(text: buyer.remarks);
    final TextEditingController followUpController =
        TextEditingController(text: buyer.followUp);
    final TextEditingController notesController =
        TextEditingController(text: buyer.notes);
    final TextEditingController budgetController =
        TextEditingController(text: buyer.budget);

    // Función para manejar la selección de fecha
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateFormat('dd-MM-yyyy')
            .parse(buyer.date), // Usar la fecha actual como inicial
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        dateController.text =
            DateFormat('dd-MM-yyyy').format(picked); // Formatear la fecha
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Comprador'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  readOnly: true, // Hacer este campo solo lectura
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    hintText: 'Seleccionar fecha',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context), // Abrir selector de fecha
                    ),
                  ),
                ),
                _buildTextField(nameController, 'Nombre', Icons.person),
                _buildTextField(emailController, 'Correo', Icons.email),
                _buildTextField(phoneController, 'Teléfono', Icons.phone),
                _buildTextField(cityController, 'Ciudad', Icons.location_city),
                _buildTextField(
                    requirementsController, 'Requisitos', Icons.list),
                _buildTextField(remarksController, 'Observaciones', Icons.comment),
                _buildTextField(
                    followUpController, 'Seguimiento', Icons.follow_the_signs),
                _buildTextField(notesController, 'Notas', Icons.note),
                _buildTextField(budgetController, 'Presupuesto', Icons.attach_money),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Actualizar la información del comprador
                Buyer updatedBuyer = Buyer(
                  id: buyer.id, // Mantener el mismo ID
                  date: dateController.text, // Actualizar fecha
                  buyer: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  city: cityController.text,
                  requirements: requirementsController.text, // Agregar requisitos
                  remarks: remarksController.text, // Agregar observaciones
                  followUp: followUpController.text, // Agregar seguimiento
                  notes: notesController.text, // Agregar notas
                  budget: budgetController.text,
                );

                await buyerService.updateBuyer(
                    buyer.id, updatedBuyer); // Actualizar comprador
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  // Método para construir campo de texto con ícono
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

  // Método para mostrar un cuadro de confirmación antes de eliminar
  Future<void> _confirmDelete(BuildContext context, String buyerId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar a este comprador?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await buyerService.deleteBuyer(buyerId); // Eliminar comprador
                Navigator.of(context).pop(); // Cerrar el diálogo
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

  // Método para definir el estilo del encabezado de la tabla
  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,
      fontSize: 16,
    );
  }
}
