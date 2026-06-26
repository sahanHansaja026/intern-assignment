import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

// Import your Home screen here
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Start fade-in animation shortly after boot
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to Home Screen after 3.5 seconds
    Timer(const Duration(milliseconds: 30500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Modern gradient background tailored for an e-commerce brand
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1B2F), // Deep premium blue/indigo
              Color(0xFF161724), // Darker midnight shade
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: _opacity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Spacer to push content down
                  const SizedBox(height: 20),

                  // Middle Content: Branding & Illustration
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App Title / Brand Name
                      Text(
                        "E-Ship",
                        style: GoogleFonts.inriaSans(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // E-commerce Tagline
                      Text(
                        "Your Market, Delivered Anywhere",
                        style: GoogleFonts.inriaSans(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Main Splash Illustration
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.15),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "assets/images/splash_image.png",
                          width: 260,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),

                  // Bottom Content: Premium Progress indicator
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const SizedBox(
                          width: 140,
                          height: 4,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white10,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Securing Connection...",
                        style: GoogleFonts.inriaSans(
                          fontSize: 13,
                          color: Colors.white38,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
