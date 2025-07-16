import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/child.dart';
import '../services/api_service.dart';
import 'payment_method_screen.dart';


class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _playDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  int _selectedCost = 25000; // Default cost
  bool _isLoading = false;
  String? _errorMessage;

  // Warna Neon dan Background untuk tema Cyberpunk
  static const Color neonBlue = Color(0xFF00FFFF); // Cyan
  static const Color neonPink = Color(0xFFFF00FF); // Magenta
  static const Color neonGreen = Color(0xFF00FF00); // Lime Green
  static const Color darkBackground = Color(0xFF1A1A2E); // Dark Blue/Purple
  static const Color lightSurface = Color(0xFF2C2C4A); // Slightly lighter surface

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith( // Menggunakan tema gelap untuk kalender
            colorScheme: ColorScheme.dark(
              primary: neonPink, // Warna utama kalender (Neon Pink)
              onPrimary: Colors.white, // Warna teks di header kalender
              onSurface: Colors.white, // Warna teks di tanggal
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: neonGreen, // Warna teks tombol (Neon Green)
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _playDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _addChild() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Validasi input
    if (_childNameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Nama Anak tidak boleh kosong.';
        _isLoading = false;
      });
      return;
    }
    if (_playDateController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Tanggal Bermain tidak boleh kosong.';
        _isLoading = false;
      });
      return;
    }
    if (!RegExp(r'^\d{10,15}$').hasMatch(_phoneNumberController.text)) {
      setState(() {
        _errorMessage = 'Nomor HP tidak valid. Harus terdiri dari 10-15 digit.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Pastikan format tanggal sesuai sebelum parsing
      DateTime parsedPlayDate = DateFormat('yyyy-MM-dd').parse(_playDateController.text);

      final newChild = Child(
        childName: _childNameController.text,
        playDate: parsedPlayDate,
        phoneNumber: _phoneNumberController.text,
        cost: _selectedCost,
      );

      bool success = await ApiService.addChild(newChild);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data anak berhasil ditambahkan! 🎉'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PaymentMethodScreen()),
          );
        } else {
          _errorMessage = 'Gagal menambahkan data. Silakan coba lagi.';
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
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
        title: Text(
          'Daftarkan Si Kecil!',
          style: TextStyle(
            color: neonBlue,
            shadows: [
              Shadow(
                color: neonBlue.withOpacity(0.8),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        backgroundColor: darkBackground,
        foregroundColor: neonBlue,
        elevation: 0, // Hilangkan shadow AppBar
      ),
      body: Container( // Mengubah Stack menjadi Container
        decoration: const BoxDecoration(
          color: darkBackground, // Mengatur warna latar belakang langsung
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: lightSurface, // Base color for neumorphic element
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  // Darker shadow for depth
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    offset: const Offset(8, 8),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  // Lighter shadow for highlight
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    offset: const Offset(-8, -8),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  // Neon glow effect
                  BoxShadow(
                    color: neonBlue.withOpacity(0.5),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(color: neonPink.withOpacity(0.3), width: 2), // Subtle neon border
              ),
              constraints: const BoxConstraints(maxWidth: 450), // Lebarkan sedikit
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Yuk, Daftarkan Anak Anda!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: neonGreen, // Neon Green
                          fontWeight: FontWeight.w900, // Lebih tebal
                          fontSize: 26,
                          shadows: [
                            Shadow(
                              color: neonGreen.withOpacity(0.8),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Isi formulir di bawah ini dengan senyum ceria!',
                    style: TextStyle(
                      color: Colors.grey[400], // Lighter grey for dark background
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.withOpacity(0.7)),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  _buildTextField(
                    controller: _childNameController,
                    labelText: 'Nama Anak Ceria',
                    icon: Icons.face_retouching_natural,
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    controller: _playDateController,
                    labelText: 'Tanggal Bermain Seru',
                    icon: Icons.calendar_today,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneNumberController,
                    labelText: 'Nomor HP Orang Tua',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    value: _selectedCost,
                    items: [
                      DropdownMenuItem(value: 25000, child: Text('Rp 25.000 (Paket Ceria)', style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(value: 35000, child: Text('Rp 35.000 (Paket Super Seru)', style: TextStyle(color: Colors.white))),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCost = value!;
                      });
                    },
                    labelText: 'Pilih Paket Bermain',
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? CircularProgressIndicator(color: neonPink)
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [neonPink, neonBlue], // Neon gradient for button
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: neonPink.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _addChild,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, // Make button transparent to show gradient
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // Tombol lebih bulat
                              ),
                              elevation: 0, // Remove default elevation
                            ),
                            icon: const Icon(Icons.check_circle_outline, size: 28),
                            label: const Text(
                              'Daftar Sekarang! ✨',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: neonGreen),
                    label: Text(
                      'Kembali ke Beranda',
                      style: TextStyle(color: neonGreen, fontWeight: FontWeight.w600, fontSize: 16, shadows: [
                        Shadow(
                          color: neonGreen.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 0),
                        ),
                      ]),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 16), // White text for input
      cursorColor: neonPink,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Sudut lebih bulat
          borderSide: BorderSide.none, // Hilangkan border default
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonBlue.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonBlue, width: 2),
        ),
        filled: true,
        fillColor: darkBackground.withOpacity(0.7), // Darker fill for input
        prefixIcon: Icon(icon, color: neonPink), // Neon icon
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: neonPink,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonBlue.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonBlue, width: 2),
        ),
        filled: true,
        fillColor: darkBackground.withOpacity(0.7),
        prefixIcon: Icon(icon, color: neonPink),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String labelText,
    required IconData icon,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonBlue.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonBlue, width: 2),
        ),
        filled: true,
        fillColor: darkBackground.withOpacity(0.7),
        prefixIcon: Icon(icon, color: neonPink),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      items: items,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 16, color: Colors.white), // White text for dropdown value
      dropdownColor: darkBackground.withOpacity(0.9), // Darker dropdown background
      iconEnabledColor: neonGreen, // Neon Green for dropdown icon
    );
  }
}