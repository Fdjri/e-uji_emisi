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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.repeat(reverse: true);

    // Navigate to homepage after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const HomePage())
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            // Main Logo with bounce effect
            ScaleTransition(
              scale: _animation,
              child: Center(
                child: Image.asset(
                  'assets/images/sielang.png',
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    print('SplashScreen: Error loading sielang.png: $error');
                    return const Icon(
                      Icons.error_outline,
                      size: 100,
                      color: Color.fromARGB(255, 255, 255, 255),
                    );
                  },
                ),
              ),
            ),
            const Spacer(flex: 4),
            // // Bottom Logos with bounce effect
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 30.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       ScaleTransition(
            //         scale: _animation,
            //         child: Image.asset(
            //           'assets/images/jayaraya.png', 
            //           width: 80, 
            //           height: 80,
            //           errorBuilder: (context, error, stackTrace) {
            //             print('SplashScreen: Error loading jayaraya.png: $error');
            //             return const Icon(Icons.error_outline, size: 60, color: Colors.grey);
            //           },
            //         ),
            //       ),
            //       ScaleTransition(
            //         scale: _animation,
            //         child: Image.asset(
            //           'assets/images/jakarta.png', 
            //           width: 80, 
            //           height: 80,
            //           errorBuilder: (context, error, stackTrace) {
            //             print('SplashScreen: Error loading jakarta.png: $error');
            //             return const Icon(Icons.error_outline, size: 60, color: Color.fromARGB(255, 255, 255, 255));
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
