import 'package:flutter/material.dart';
import 'homepage.dart';

// The main entry point for the Flutter application.
void main() {
  runApp(const MyApp());
}

// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Sets the SplashScreen as the home page.
      home: SplashScreen(),
      // Hides the debug banner in the top-right corner.
      debugShowCheckedModeBanner: false,
    );
  }
}

// A stateful widget that builds the new splash screen UI based on the provided image.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Debug: Print available assets
    print('SplashScreen: Initializing...');
    print('SplashScreen: Checking if assets are available...');
    
    // Navigate to homepage after 5 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const HomePage())
      );
    });
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is a Container with a vertical gradient background.
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // These colors are estimated from the image you provided.
            colors: [
              Color(0xFFB0CDE8),
              Color(0xFFD8E6F5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // SafeArea ensures the UI doesn't overlap with system UI like the status bar.
        child: SafeArea(
          child: Column(
            // This column arranges the logo, text, and bottom icons vertically.
            children: [
              // Spacer pushes the content down from the top.
              const Spacer(flex: 2),
              // Container for the main logo.
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255), // Estimated logo background color
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                // The main logo image.
                // Replaced the placeholder Icon with an Image.asset widget.
                child: Center(
                  child: Image.asset(
                    // Using the sielang.png logo which exists in assets
                    'assets/images/sielang.png',
                    width: 400,
                    height: 400,
                    // Removed color property since sielang.png likely has its own colors
                    errorBuilder: (context, error, stackTrace) {
                      print('SplashScreen: Error loading sielang.png: $error');
                      return const Icon(
                        Icons.error_outline,
                        size: 100,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // The main text content from the image.
              const Text(
                'E-Uji Emisi\nSistem Uji Emisi\nLangit Biru\nJakarta Raya',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3A4F66),
                  height: 1.4, // Line height
                ),
              ),
              // Spacer pushes the bottom logos to the bottom of the screen.
              const Spacer(flex: 3),
              // A Row to hold the three logos at the bottom.
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Make sure you have added these assets to your pubspec.yaml file
                    Image.asset(
                      'assets/images/jayaraya.png', 
                      width: 60, 
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        print('SplashScreen: Error loading jayaraya.png: $error');
                        return const Icon(Icons.error_outline, size: 60, color: Colors.grey);
                      },
                    ),
                    Image.asset(
                      'assets/images/dlh.png', 
                      width: 60, 
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        print('SplashScreen: Error loading dlh.png: $error');
                        return const Icon(Icons.error_outline, size: 60, color: Colors.grey);
                      },
                    ),
                    Image.asset(
                      'assets/images/jakarta.png', 
                      width: 60, 
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        print('SplashScreen: Error loading jakarta.png: $error');
                        return const Icon(Icons.error_outline, size: 60, color: Colors.grey);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
