import 'package:flutter/material.dart';
import '../models/drone_model.dart';
import '../models/buyer_model.dart'; // Importar modelo Buyer
import '../models/seller_model.dart'; // Importar modelo Seller
import '../services/drone_services.dart'; // Asegúrate de usar la ruta correcta para DroneService
import '../services/buyer_services.dart'; // Asegúrate de usar la ruta correcta para BuyerService
import '../services/seller_services.dart'; // Asegúrate de usar la ruta correcta para SellerService

class AddDroneScreen extends StatefulWidget {
  @override
  _AddDroneScreenState createState() => _AddDroneScreenState();
}

class _AddDroneScreenState extends State<AddDroneScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _sId; // ID del vendedor
  String? _bId; // ID del comprador
  String? _brand, _model, _serialNumber;
  bool _status = false; // El estado ahora es un booleano
  String? _webPrice, _customerPrice;
  String? _commission, _followUp, _contractNo;

  final DroneService droneService = DroneService();
  final BuyerService buyerService = BuyerService();
  final SellerService sellerService = SellerService();

  // FocusNodes para los campos de entrada
  final FocusNode _brandFocusNode = FocusNode();
  final FocusNode _modelFocusNode = FocusNode();
  final FocusNode _serialNumberFocusNode = FocusNode();
  final FocusNode _webPriceFocusNode = FocusNode();
  final FocusNode _customerPriceFocusNode = FocusNode();
  final FocusNode _commissionFocusNode = FocusNode();
  final FocusNode _followUpFocusNode = FocusNode();
  final FocusNode _contractNoFocusNode = FocusNode();

  // IDs de comprador y vendedor seleccionados para los dropdowns
  String? _selectedBuyerId;
  String? _selectedSellerId;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_sId == null || _bId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Selecciona tanto un comprador como un vendedor')),
        );
        return; // Salir si faltan campos requeridos
      }

      // Generar ID de dron usando la marca de tiempo actual
      String droneId = DateTime.now().millisecondsSinceEpoch.toString();

      Drone newDrone = Drone(
        dId: droneId, // Usar el ID generado
        sId: _sId!, // ID del vendedor
        bId: _bId!, // ID del comprador
        brand: _brand!,
        status: _status,
        model: _model!,
        serialNumber: _serialNumber!,
        webPrice: _webPrice!,
        customerPrice: _customerPrice!,
        commision: _commission!,
        followUp: _followUp ?? '', // Por defecto, vacío si no se proporciona
        soldDate: null, // Establecer soldDate a null inicialmente
        contractNo: _contractNo ?? '', // Por defecto, vacío si no se proporciona
      );

      // Agregar el dron a la base de datos
      droneService.addDrone(newDrone);

      Navigator.pop(context); // Volver después de agregar el dron
    }
  }

  @override
  void dispose() {
    // Eliminar FocusNodes
    _brandFocusNode.dispose();
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
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Agregar Dron'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // StreamBuilder para seleccionar Comprador
              StreamBuilder<List<Buyer>>(
                stream: buyerService.getAllBuyers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Llenar dropdown de compradores
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Seleccionar Comprador',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: _selectedBuyerId,
                    items: snapshot.data!.map((buyer) {
                      return DropdownMenuItem<String>(
                        value: buyer.id,
                        child: Text(buyer.buyer), // Mostrar nombre del comprador
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBuyerId = value; // Establecer ID del comprador seleccionado
                        _bId = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Selecciona un comprador' : null,
                  );
                },
              ),
              SizedBox(height: 20),

              // StreamBuilder para seleccionar Vendedor
              StreamBuilder<List<Seller>>(
                stream: sellerService.getAllSellers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Llenar dropdown de vendedores
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Seleccionar Vendedor',
                      prefixIcon: Icon(Icons.store_mall_directory),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: _selectedSellerId,
                    items: snapshot.data!.map((seller) {
                      return DropdownMenuItem<String>(
                        value: seller.id,
                        child: Text(seller.sellerName), // Mostrar nombre del vendedor
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSellerId = value; // Establecer ID del vendedor seleccionado
                        _sId = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Selecciona un vendedor' : null,
                  );
                },
              ),
              SizedBox(height: 20),

              // Campos de entrada con íconos y enfoque
              _buildTextFormField(
                label: 'Marca',
                icon: Icons.flight,
                focusNode: _brandFocusNode,
                validator: (value) => value!.isEmpty ? 'Ingresa la marca' : null,
                onSaved: (value) => _brand = value,
                nextFocusNode: _modelFocusNode,
              ),
              _buildTextFormField(
                label: 'Modelo',
                icon: Icons.airplanemode_active,
                focusNode: _modelFocusNode,
                validator: (value) => value!.isEmpty ? 'Ingresa el modelo' : null,
                onSaved: (value) => _model = value,
                nextFocusNode: _serialNumberFocusNode,
              ),
              _buildTextFormField(
                label: 'Número de Serie',
                icon: Icons.confirmation_number,
                focusNode: _serialNumberFocusNode,
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa el número de serie' : null,
                onSaved: (value) => _serialNumber = value,
                nextFocusNode: _webPriceFocusNode,
              ),
              _buildTextFormField(
                label: 'Precio Web',
                icon: Icons.monetization_on,
                focusNode: _webPriceFocusNode,
                validator: (value) => value!.isEmpty ? 'Ingresa el precio web' : null,
                onSaved: (value) => _webPrice = value!,
                keyboardType: TextInputType.number,
                nextFocusNode: _customerPriceFocusNode,
              ),
              _buildTextFormField(
                label: 'Precio al Cliente',
                icon: Icons.attach_money,
                focusNode: _customerPriceFocusNode,
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa el precio al cliente' : null,
                onSaved: (value) => _customerPrice = value!,
                keyboardType: TextInputType.number,
                nextFocusNode: _commissionFocusNode,
              ),
              _buildTextFormField(
                label: 'Comisión',
                icon: Icons.money,
                focusNode: _commissionFocusNode,
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa la comisión' : null,
                onSaved: (value) => _commission = value,
                nextFocusNode: _followUpFocusNode,
              ),
              _buildTextFormField(
                label: 'Seguimiento',
                icon: Icons.follow_the_signs,
                focusNode: _followUpFocusNode,
                onSaved: (value) => _followUp = value,
                nextFocusNode: _contractNoFocusNode,
                validator: (String? value) {},
              ),
              _buildTextFormField(
                label: 'Número de Contrato',
                icon: Icons.note,
                focusNode: _contractNoFocusNode,
                onSaved: (value) => _contractNo = value,
                validator: (String? value) {},
              ),
              SizedBox(height: 20),

              // Checkbox para el estado
              CheckboxListTile(
                title: Text('¿El dron está activo?'),
                value: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 20),

              // Botón de enviar
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Agregar Dron', style: TextStyle(fontSize: 18)),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ayudante para construir campos de formulario con íconos
  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required FocusNode focusNode,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
    FocusNode? nextFocusNode,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        focusNode: focusNode,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
        textInputAction:
            nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        onFieldSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}
