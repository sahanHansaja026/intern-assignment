import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  final List<Map<String, dynamic>> mockOrders = const [
    {
      "orderId": "ORD-2026-9482",
      "date": "June 24, 2026",
      "status": "In Transit",
      "statusColor": Colors.blueAccent,
      "totalItems": 3,
      "price": 14500.0,
    },
    {
      "orderId": "ORD-2026-8310",
      "date": "May 18, 2026",
      "status": "Delivered",
      "statusColor": Colors.greenAccent,
      "totalItems": 1,
      "price": 4200.0,
    },
    {
      "orderId": "ORD-2026-1104",
      "date": "January 05, 2026",
      "status": "Cancelled",
      "statusColor": Colors.redAccent,
      "totalItems": 2,
      "price": 8900.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161724),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Order History",
          style: GoogleFonts.inriaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.06), height: 1),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1B2F), Color(0xFF161724)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: mockOrders.length,
          itemBuilder: (context, index) {
            final order = mockOrders[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order["orderId"],
                        style: GoogleFonts.inriaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (order["statusColor"] as Color).withOpacity(
                            0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (order["statusColor"] as Color).withOpacity(
                              0.3,
                            ),
                          ),
                        ),
                        child: Text(
                          order["status"],
                          style: GoogleFonts.inriaSans(
                            color: order["statusColor"],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Placed on ${order["date"]}",
                    style: GoogleFonts.inriaSans(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Items: ${order["totalItems"]}",
                        style: GoogleFonts.inriaSans(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Rs. ${(order["price"] as double).toStringAsFixed(0)}",
                        style: GoogleFonts.inriaSans(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
