import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi otomatis ke HomeScreen setelah delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color neonBlue = Color(0xFF00FFFF);
    const Color darkBackground = Color(0xFF1A1A2E);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBackground, Color(0xFF0F0F1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Bulat dengan warna asli
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/yumma.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                color: neonBlue,
                strokeWidth: 5,
              ),
              const SizedBox(height: 20),
              Text(
                'Memuat Dunia Yummaland...',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: neonBlue,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      shadows: [
                        Shadow(
                          color: neonBlue.withOpacity(0.8),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
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