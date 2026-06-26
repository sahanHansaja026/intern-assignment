import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/cart_screen.dart';

import 'package:flutter_application_1/pages/product_details.dart';
import 'package:flutter_application_1/pages/orders_screen.dart'; // Ensure this import matches your file path
import 'package:google_fonts/google_fonts.dart';

import '../models/product.dart';
import '../models/profile.dart';

class Home_Screeen extends StatefulWidget {
  const Home_Screeen({super.key});

  @override
  State<Home_Screeen> createState() => _Home_ScreeenState();
}

class _Home_ScreeenState extends State<Home_Screeen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  Profile? profile;

  // Global cart state initialized locally inside the home screen state tree
  List<Map<String, dynamic>> globalCart = [];

  // Search & Category State
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";

  // Premium Categories
  final List<String> _categories = [
    "All",
    "Trending",
    "Electronics",
    "Fashion",
    "Beauty",
  ];

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadProfile();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // load the product info
  Future<void> loadProducts() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/products.json',
      );
      final List<dynamic> data = jsonDecode(response);

      setState(() {
        allProducts = data.map((item) => Product.fromJson(item)).toList();
        filteredProducts = allProducts;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading products: $e");
      setState(() => isLoading = false);
    }
  }

  // load the profile info
  Future<void> loadProfile() async {
    try {
      final String response = await rootBundle.loadString(
        "assets/data/profile.json",
      );

      final data = jsonDecode(response);

      setState(() {
        profile = Profile.fromJson(data);
      });
    } catch (e) {
      debugPrint("Profile Error : $e");
    }
  }

  // Filter Algorithm based on search query and selected category
  void _filterProducts() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      filteredProducts = allProducts.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == "All";
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161724),
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
          bottom: false,
          child: Column(
            children: [
              _buildHeaderSection(),
              _buildCategoryRow(),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      )
                    : _buildProductGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // profile section
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color(0xFF1A1B2F),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 24),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFF1A1B2F),
                            backgroundImage: profile != null
                                ? AssetImage(profile!.image)
                                : null,
                            child: profile == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            profile?.name ?? "Loading...",
                            style: GoogleFonts.inriaSans(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            profile?.email ?? "",
                            style: GoogleFonts.inriaSans(
                              color: Colors.white38,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Colors.white10),
                          ListTile(
                            leading: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              "My Orders",
                              style: GoogleFonts.inriaSans(color: Colors.white),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white24,
                              size: 14,
                            ),
                            onTap: () {
                              Navigator.pop(context); // Close sheet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OrdersScreen(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.white60,
                            ),
                            title: Text(
                              "Shipping Addresses",
                              style: GoogleFonts.inriaSans(color: Colors.white),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white24,
                              size: 14,
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF1A1B2F),
                    backgroundImage: profile != null
                        ? AssetImage(profile!.image)
                        : null,
                    child: profile == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ),
              ),

              // Cart Screen Navigator Trigger
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CartScreen(initialCartItems: globalCart),
                      ),
                    ).then((updatedCart) {
                      if (updatedCart != null) {
                        setState(() {
                          globalCart = updatedCart;
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            "Discover",
            style: GoogleFonts.inriaSans(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            "Our premium product collections",
            style: GoogleFonts.inriaSans(fontSize: 14, color: Colors.white38),
          ),
          const SizedBox(height: 20),

          // Search Bar Textfield
          TextField(
            controller: _searchController,
            onChanged: (value) => _filterProducts(),
            style: GoogleFonts.inriaSans(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: "Search items, brands...",
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white38,
                size: 22,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white38,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _filterProducts();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white.withOpacity(0.03),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Category Selector Row
  Widget _buildCategoryRow() {
    return Container(
      height: 42,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                  _filterProducts();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blueAccent
                      : Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.blueAccent
                        : Colors.white.withOpacity(0.08),
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: GoogleFonts.inriaSans(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Product Cards View Grid
  Widget _buildProductGrid() {
    if (filteredProducts.isEmpty) {
      return Center(
        child: Text(
          "No products matches found.",
          style: GoogleFonts.inriaSans(color: Colors.white38, fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      itemCount: filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.70,
      ),
      itemBuilder: (context, index) {
        final product = filteredProducts[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                  product: product,
                  onAddToCart: (selectedProduct, quantity) {
                    setState(() {
                      final existingIndex = globalCart.indexWhere(
                        (element) =>
                            element['product'].name == selectedProduct.name,
                      );

                      if (existingIndex != -1) {
                        globalCart[existingIndex]['quantity'] += quantity;
                      } else {
                        globalCart.add({
                          'product': selectedProduct,
                          'quantity': quantity,
                        });
                      }
                    });
                  },
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Image.asset(
                        product.image,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black38],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inriaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rs. ${product.price.toStringAsFixed(0)}",
                            style: GoogleFonts.inriaSans(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                product.rating.toString(),
                                style: GoogleFonts.inriaSans(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
