import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'history_screen.dart';

class QrisPaymentScreen extends StatelessWidget {
  const QrisPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran QRIS'),
        backgroundColor: const Color(0xFFFF6F61),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE9E7), Color(0xFFFFCCBC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6F61).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pembayaran QRIS',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFFFF6F61),
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Silakan lakukan pembayaran menggunakan QRIS.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6E3A37)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Scan QR Code di bawah ini untuk menyelesaikan pembayaran:',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6E3A37)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Image.asset(
                    'assets/images/qris.png', // Pastikan gambar ada di assets
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Setelah melakukan pembayaran, silakan kembali ke halaman Riwayat Pembayaran.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6E3A37)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoryScreen()),
                      );
                    },
                    child: const Text(
                      'Riwayat Pembayaran',
                      style: TextStyle(color: Color(0xFFFF6F61), fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                    child: const Text(
                      'Kembali ke Home',
                      style: TextStyle(color: Color(0xFFFF6F61), fontWeight: FontWeight.w600),
                    ),
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