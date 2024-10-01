import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/contract_service.dart';
import '../models/contract_model.dart';

class ContractHistoryScreen extends StatelessWidget {
  final ContractService contractService = ContractService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Historial de Contratos', style: TextStyle(fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Contract>>(
              stream: contractService.getAllContracts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No se encontraron contratos',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                List<Contract> contracts = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Número de Contrato')),
                        DataColumn(label: Text('Fecha')),
                        DataColumn(label: Text('Comprador')),
                        DataColumn(label: Text('Correo del Comprador')),
                        DataColumn(label: Text('Ciudad del Comprador')),
                        DataColumn(label: Text('Vendedor')),
                        DataColumn(label: Text('Correo del Vendedor')),
                        DataColumn(label: Text('Modelo del Drone')),
                        DataColumn(label: Text('Precio')),
                        DataColumn(label: Text('Comisión')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: contracts.map((contract) {
                        return DataRow(cells: [
                          DataCell(Text(contract.contractNumber)),
                          DataCell(Text(DateFormat('dd-MM-yyyy').format(contract.createdAt))),
                          DataCell(Text(contract.buyerName)),
                          DataCell(Text(contract.buyerEmail)),
                          DataCell(Text(contract.buyerCity)),
                          DataCell(Text(contract.sellerName)),
                          DataCell(Text(contract.sellerEmail)),
                          DataCell(Text(contract.droneModel)),
                          DataCell(Text(contract.price)),
                          DataCell(Text(contract.commission)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () {
                                    _confirmDelete(context, contract.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
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

  Future<void> _confirmDelete(BuildContext context, String contractId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este contrato?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ContractService().deleteContract(contractId);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
