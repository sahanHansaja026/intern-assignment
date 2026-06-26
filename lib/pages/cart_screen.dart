import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart'; // Ensure correct path to your product model

class CartScreen extends StatefulWidget {
  // Pass the initial list of items added from the product details screen
  final List<Map<String, dynamic>> initialCartItems;

  const CartScreen({super.key, required this.initialCartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    // Localize the pass-in list so we can mutate quantities smoothly
    cartItems = List.from(widget.initialCartItems);
  }

  // Calculate the live combined total price of all cart lines
  double get _calculateTotal {
    double total = 0.0;
    for (var item in cartItems) {
      final Product product = item['product'];
      final int quantity = item['quantity'];
      total += product.price * quantity;
    }
    return total;
  }

  void _updateQuantity(int index, bool increment) {
    setState(() {
      if (increment) {
        cartItems[index]['quantity']++;
      } else {
        if (cartItems[index]['quantity'] > 1) {
          cartItems[index]['quantity']--;
        }
      }
    });
  }

  void _removeItem(int index) {
    final removedItemName = (cartItems[index]['product'] as Product).name;
    setState(() {
      cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$removedItemName removed from cart"),
        backgroundColor: Colors.redAccent.withOpacity(0.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161724), // Premium Midnight Base
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Your Cart",
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
        child: SafeArea(
          child: cartItems.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    Expanded(child: _buildCartItemList()),
                    _buildOrderSummaryPanel(),
                  ],
                ),
        ),
      ),
    );
  }

  // Clean empty state wrapper fallback if nothing remains in cart
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text(
            "Your cart is empty",
            style: GoogleFonts.inriaSans(color: Colors.white60, fontSize: 18),
          ),
        ],
      ),
    );
  }

  // Infinite Scrollable list parsing each individual cart item
  Widget _buildCartItemList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> item = cartItems[index];
        final Product product = item['product'];
        final int quantity = item['quantity'];

        return Dismissible(
          key: Key(product.name + index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
          onDismissed: (direction) => _removeItem(index),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              children: [
                // Item Image Preview Square
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    product.image,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),

                // Item Details Center Meta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inriaSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rs. ${product.price.toStringAsFixed(0)}",
                        style: GoogleFonts.inriaSans(
                          color: Colors.blueAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Interactive Counter controls & Delete Stacked Vertical
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white30,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _removeItem(index),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _updateQuantity(index, false),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white60,
                                size: 16,
                              ),
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: GoogleFonts.inriaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _updateQuantity(index, true),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Sticky Bottom Calculation Drawer with Subtotal and Checkout Button
  Widget _buildOrderSummaryPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2F),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: GoogleFonts.inriaSans(
                  color: Colors.white38,
                  fontSize: 14,
                ),
              ),
              Text(
                "Rs. ${_calculateTotal.toStringAsFixed(0)}",
                style: GoogleFonts.inriaSans(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                // Future implementation step for operational payment gateways
              },
              child: Text(
                "Proceed to Checkout",
                style: GoogleFonts.inriaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
