import 'package:flutter/material.dart';
import 'package:yummaland_app/screens/qris_payment_screen.dart'; // Corrected import
// import '../services/api_service.dart'; // Removed - unused import
import 'home_screen.dart'; // Changed to navigate to home after cash payment

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedMethod;
  bool _isLoading = false;

  Future<void> _processPayment() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Dalam aplikasi nyata, Anda akan meneruskan child_id di sini.
      // Untuk kesederhanaan, kita akan mengasumsikan anak terakhir yang ditambahkan perlu pembayaran.
      // Pendekatan yang lebih baik adalah meneruskan child_id dari AddChildScreen.
      // Untuk saat ini, kita hanya akan mensimulasikan proses pembayaran.

      if (_selectedMethod == 'qris') {
        // Jika Anda ingin memanggil API untuk QRIS, aktifkan baris ini:
        // bool success = await ApiService.processPayment(lastChildId, 'qris');
        // if (!success) throw Exception('Gagal memproses pembayaran QRIS.');

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const QrisPaymentScreen()),
          );
        }
      } else if (_selectedMethod == 'cash') {
        // Jika Anda ingin memanggil API untuk Cash, aktifkan baris ini:
        // bool success = await ApiService.processPayment(lastChildId, 'cash');
        // if (!success) throw Exception('Gagal memproses pembayaran Cash.');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Silakan lakukan pembayaran ke kasir.')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()), // Navigasi ke Home
            (route) => false,
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses pembayaran: ${e.toString().replaceFirst('Exception: ', '')}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metode Pembayaran'),
        backgroundColor: const Color(0xFFFF6F61),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient( // Added const
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
                    color: const Color(0xFFFF6F61).withAlpha((255 * 0.3).round()), // Fixed withOpacity
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
                    'Pilih Metode Pembayaran',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFFFF6F61),
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  RadioListTile<String>( // Removed const here as value changes
                    title: const Text('QRIS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFB3473C))),
                    value: 'qris',
                    groupValue: _selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value;
                      });
                    },
                    activeColor: const Color(0xFFFF6F61),
                  ),
                  RadioListTile<String>( // Removed const here as value changes
                    title: const Text('Cash', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFB3473C))),
                    value: 'cash',
                    groupValue: _selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value;
                      });
                    },
                    activeColor: const Color(0xFFFF6F61),
                  ),
                  const SizedBox(height: 25),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _processPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6F61),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Bayar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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