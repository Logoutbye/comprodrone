import 'package:com_pro_drone/view/add_order_screen.dart';
import 'package:com_pro_drone/view/buyer_list.dart';
import 'package:com_pro_drone/view/contract_creation_screen.dart';
import 'package:com_pro_drone/view/order_list_screen.dart';
import 'package:com_pro_drone/view/seller_list.dart';
import 'package:com_pro_drone/view/supplier_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 800, // Limit the content width to 800 pixels
          ),
          child: Padding(
            padding: const EdgeInsets.all(40.0), // Larger padding for desktop
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'COMPRODRONE',
                      style: TextStyle(
                        fontSize: 50, // Larger font size for desktop
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Subtitle
                Text(
                  'REGISTRO GENERAL',
                  style: TextStyle(
                    fontSize: 28, // Increased font size
                    color: Color(0xFF29B6F6),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),

                // Buttons Layout with more spacing for desktop
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomButton(
                            text: 'COMPRADORES / Buyers',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BuyerListScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            text: 'VENDEDORES / Sellers',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SellerListScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(
                        width:
                            40), // Increase the space between columns for desktop
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomButton(
                            text: 'PROVEEDORES / Suppliers',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SupplierListScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            text: 'Crear contrato',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ContractCreationScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 200.0),
                  child: CustomButton(
                    text: 'Órdenes',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderListScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: SizedBox(
        width: double.infinity, // Button takes full width of the column
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                isHovered ? Colors.blueGrey[700] : Colors.grey[800],
            padding: EdgeInsets.symmetric(
                vertical: 20), // Increased padding for desktop
            elevation: isHovered ? 10 : 5, // Change elevation on hover
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18, // Slightly larger font for desktop
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
