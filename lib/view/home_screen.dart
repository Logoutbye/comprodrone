import 'package:com_pro_drone/view/buyer_list.dart';
import 'package:com_pro_drone/view/contract_creation_screen.dart';
import 'package:com_pro_drone/view/seller_list.dart';
import 'package:com_pro_drone/view/supplier_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and Title
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Placeholder for logo
                  // Image.network(
                  //   'https://via.placeholder.com/100', // Use your own logo URL here
                  //   height: 100,
                  // ),
                  // SizedBox(width: 10),
                  Text(
                    'COMPRODRONE',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Subtitle
              const Text(
                'REGISTRO GENERAL',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Color(0xFF29B6F6),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30),

              // Buttons Layout
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CustomButton(
                        text: 'COMPRADORES / Buyers',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BuyerListScreen(),
                              ));
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
                              ));
                        },
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        text: 'TASACION / Assessment',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BuyerListScreen(),
                              ));
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomButton(
                        text: 'PROVEEDORES / Suppliers',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupplierListScreen(),
                              ));
                        },
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        text: 'Crear contrato',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContractCreationScreen(),
                              ));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed; // Accepts a callback function

  const CustomButton({
    required this.text,
    required this.onPressed, // This is the new parameter
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: onPressed, // Assign the passed callback function
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
