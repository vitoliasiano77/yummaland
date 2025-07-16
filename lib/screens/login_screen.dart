import 'package:flutter/material.dart';
import '../services/auth_service.dart';
// import 'home_screen.dart'; // Ini akan tetap ada, tapi tidak langsung dipanggil
import 'register_screen.dart';
import 'loading_screen.dart'; // Import LoadingScreen yang baru dibuat

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await AuthService.login(_usernameController.text, _passwordController.text);
      if (mounted) {
        // Navigasi ke LoadingScreen setelah login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoadingScreen()),
        );
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
    // Warna Neon
    const Color neonBlue = Color(0xFF00FFFF); // Cyan
    const Color neonPink = Color(0xFFFF00FF); // Magenta
    const Color darkBackground = Color(0xFF1A1A2E); // Dark Blue/Purple
    const Color lightSurface = Color(0xFF2C2C4A); // Slightly lighter surface

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBackground, Color(0xFF0F0F1A)], // Darker gradient for cyberpunk feel
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // Optional: Add a cyberpunk background image here if available
          // image: DecorationImage(
          //   image: AssetImage('assets/images/cyberpunk_city.jpg'),
          //   fit: BoxFit.cover,
          //   colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
          // ),
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
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Perubahan di sini untuk logo
                  Container(
                    width: 120, // Sesuaikan dengan ukuran logo Anda
                    height: 120, // Sesuaikan dengan ukuran logo Anda
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Membuat bentuk lingkaran
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipOval( // Memastikan gambar terpotong menjadi lingkaran
                      child: Image.asset(
                        'assets/images/yumma.png', // Ikon aplikasi yang lucu
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover, // Memastikan gambar mengisi lingkaran
                        // Menghapus properti 'color' dan 'colorBlendMode'
                        // color: neonPink, // Tint icon with neon color
                        // colorBlendMode: BlendMode.modulate,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selamat Datang di Yummaland! 🚀',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: neonBlue, // Neon color for title
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                          shadows: [
                            Shadow(
                              color: neonBlue.withOpacity(0.8),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Yuk, masuk dan mulai petualangan!',
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
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white, fontSize: 16), // White text for input
                    cursorColor: neonPink,
                    decoration: InputDecoration(
                      labelText: 'Nama Pengguna',
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
                      fillColor: darkBackground.withOpacity(0.7), // Darker fill for input
                      prefixIcon: Icon(Icons.person, color: neonPink), // Neon icon
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    cursorColor: neonPink,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
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
                      prefixIcon: Icon(Icons.lock, color: neonPink),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator(color: neonPink)
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
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, // Make button transparent to show gradient
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0, // Remove default elevation
                            ),
                            icon: const Icon(Icons.login, size: 28),
                            label: const Text(
                              'Ayo Masuk! ✨',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    icon: Icon(Icons.person_add, color: neonBlue),
                    label: Text(
                      'Belum punya akun? Daftar di sini yuk! 🚀',
                      style: TextStyle(
                        color: neonBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: neonBlue.withOpacity(0.5),
                            blurRadius: 5,
                            offset: const Offset(0, 0),
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
      ),
    );
  }
}