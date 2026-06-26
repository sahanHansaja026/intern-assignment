import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

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
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // Navigate to Login Page after 3.5 seconds
    Timer(const Duration(milliseconds: 3500), () {
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
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1B2F), Color(0xFF11121C)],
          ),
        ),
        child: SafeArea(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: _opacity,
            child: Row(
              children: [
                // LEFT ACCENT SIDE BAR
                Container(
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withOpacity(0.07),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Icon(
                          Icons.all_inclusive_rounded,
                          color: Colors.blueAccent,
                          size: 24,
                        ),
                      ),
                      // text inside the bar
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          "PREMIUM EST. 2026",
                          style: GoogleFonts.inriaSans(
                            color: Colors.white24,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                //MAIN CONTENT AREA
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Header Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "E-Ship",
                              style: GoogleFonts.inriaSans(
                                fontSize: 46,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Your Market, Delivered Anywhere",
                              style: GoogleFonts.inriaSans(
                                fontSize: 15,
                                color: Colors.white60,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),

                        Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.12),
                                  blurRadius: 50,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              "assets/images/splash_image.png",
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.local_shipping_outlined,
                                  size: 100,
                                  color: Colors.white12,
                                );
                              },
                            ),
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: const SizedBox(
                                width: 100,
                                height: 3,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.white10,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Securing Connection...",
                              style: GoogleFonts.inriaSans(
                                fontSize: 12,
                                color: Colors.white38,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
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
