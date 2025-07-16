import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'add_child_screen.dart';
import 'admin_screen.dart';
import 'calculator_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import 'top_scores_screen.dart';
import 'user_recap_screen.dart';
import 'block_game_screen.dart';
 // Import game screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  String _role = '';

  // Warna Neon dan Background untuk tema Cyberpunk
  static const Color neonBlue = Color(0xFF00FFFF); // Cyan
  static const Color neonPink = Color(0xFFFF00FF); // Magenta
  static const Color neonGreen = Color(0xFF00FF00); // Lime Green
  static const Color neonPurple = Color(0xFF8A2BE2); // Blue Violet
  static const Color darkBackground = Color(0xFF1A1A2E); // Dark Blue/Purple
  static const Color lightSurface = Color(0xFF2C2C4A); // Slightly lighter surface

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Pengguna';
      _role = prefs.getString('role') ?? 'user';
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(30.0),
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
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                                    // Header dengan ikon dan teks yang lebih menarik
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60, // Sesuaikan dengan ukuran logo Anda
                        height: 60, // Sesuaikan dengan ukuran logo Anda
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
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover, // Memastikan gambar mengisi lingkaran
                            // Menghapus properti 'color' dan 'colorBlendMode'
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Flexible(
                        child: Text(
                          '🎉 Selamat Datang di Yummaland! 🚀',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: neonBlue, // Neon color for title
                                fontWeight: FontWeight.w900, // Lebih tebal
                                fontSize: 28, // Ukuran lebih besar
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Halo, $_username ($_role)!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[400], // Lighter grey for dark background
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tempat terbaik untuk bermain dan belajar anak-anak penuh warna dan tawa.',
                    style: TextStyle(fontSize: 17, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ayo pilih menu seru di bawah ini!',
                    style: TextStyle(fontSize: 17, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildMenuItem(
                        context,
                        'Tambah Anak',
                        Icons.child_care, // Ikon yang relevan
                        const AddChildScreen(),
                        const LinearGradient(colors: [neonPink, neonBlue]), // Neon gradient
                      ),
                      _buildMenuItem(
                        context,
                        'Riwayat Bermain',
                        Icons.history,
                        const HistoryScreen(),
                        const LinearGradient(colors: [neonBlue, neonGreen]), // Neon gradient
                      ),
                      _buildMenuItem(
                        context,
                        'Rekap Data Anda',
                        Icons.bar_chart,
                        const UserRecapScreen(),
                        const LinearGradient(colors: [neonGreen, neonPurple]), // Neon gradient
                      ),
                      _buildMenuItem(
                        context,
                        'Kalkulator',
                        Icons.calculate,
                        const CalculatorScreen(),
                        const LinearGradient(colors: [neonPurple, neonPink]), // Neon gradient
                      ),
                      _buildMenuItem(
                        context,
                        'Top Skor Anak',
                        Icons.emoji_events,
                        const TopScoresScreen(),
                        const LinearGradient(colors: [neonPink, neonGreen]), // Neon gradient
                      ),
                      if (_role == 'admin')
                        _buildMenuItem(
                          context,
                          'Rekap Data (Admin)',
                          Icons.admin_panel_settings,
                          const AdminScreen(),
                          const LinearGradient(colors: [neonGreen, neonBlue]), // Neon gradient
                        ),
                      if (_role == 'admin')
                        _buildMenuItem(
                          context,
                          'Lihat User (Admin)',
                          Icons.people,
                          const AdminScreen(),
                          const LinearGradient(colors: [neonBlue, neonPurple]), // Neon gradient
                        ),
                      if (_role == 'admin')
                        _buildMenuItem(
                          context,
                          'Game Block Blast',
                          Icons.gamepad,
                          const BlockGameScreen(),
                          const LinearGradient(colors: [neonPurple, neonPink]), // Neon gradient
                        ),
                      _buildMenuItem(
                        context,
                        'Keluar',
                        Icons.logout,
                        null, // Null for logout
                        const LinearGradient(colors: [Color(0xFFFF6347), Color(0xFFDC143C)]), // Red for logout
                        onTap: _logout,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Aplikasi ini projek pertama percobaan vito.',
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, Widget? screen, Gradient gradient,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (screen != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            }
          },
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: lightSurface, // Base color for neumorphic element
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            // Darker shadow for depth
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              offset: const Offset(6, 6),
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
            // Lighter shadow for highlight
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: const Offset(-6, -6),
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
            // Neon glow effect from the gradient
            BoxShadow(
              color: (gradient.colors.first).withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(color: (gradient.colors.last).withOpacity(0.3), width: 1.5), // Subtle neon border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(bounds),
              child: Icon(
                icon,
                color: Colors.white, // Icon color will be masked by the shader
                size: 40,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                shadows: [
                  Shadow(
                    color: (gradient.colors.first).withOpacity(0.7),
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}