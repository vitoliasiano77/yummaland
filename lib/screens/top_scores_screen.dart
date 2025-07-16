import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TopScoresScreen extends StatefulWidget {
  const TopScoresScreen({super.key});

  @override
  State<TopScoresScreen> createState() => _TopScoresScreenState();
}

class _TopScoresScreenState extends State<TopScoresScreen> {
  List<Map<String, dynamic>> _topScores = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Warna Neon dan Background untuk tema Cyberpunk
  static const Color neonBlue = Color(0xFF00FFFF); // Cyan
  static const Color neonPink = Color(0xFFFF00FF); // Magenta
  static const Color neonGreen = Color(0xFF00FF00); // Lime Green
  static const Color darkBackground = Color(0xFF1A1A2E); // Dark Blue/Purple
  static const Color lightSurface = Color(0xFF2C2C4A); // Slightly lighter surface
  static const Color tableHeaderColor = Color(0xFF4A004A); // Darker purple for table header
  static const Color tableRowEvenColor = Color(0xFF3A003A); // Even row color
  static const Color tableRowOddColor = Color(0xFF2A002A); // Odd row color


  @override
  void initState() {
    super.initState();
    _loadTopScores();
  }

  Future<void> _loadTopScores() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _topScores = await ApiService.getTopScores();
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
          'Top Skor Anak',
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
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBackground, Color(0xFF0F0F1A)], // Darker gradient for cyberpunk feel
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/gambar5.jpg'), // Gambar background cyberpunk
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken), // Darken the image
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Top Skor Anak',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: neonGreen, // Neon color for title
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
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
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator(color: neonPink)
                else if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: neonPink, fontSize: 16),
                    textAlign: TextAlign.center,
                  )
                else if (_topScores.isEmpty)
                  const Text(
                    'Tidak ada data top skor.',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  )
                else
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                    },
                    border: TableBorder.all(
                      color: neonBlue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: tableHeaderColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        children: [
                          _buildTableHeader('Nama Anak'),
                          _buildTableHeader('Jumlah Permainan'),
                        ],
                      ),
                      ..._topScores.map((score) {
                        final isEvenRow = _topScores.indexOf(score) % 2 == 0;
                        return TableRow(
                          decoration: BoxDecoration(
                            color: isEvenRow ? tableRowEvenColor : tableRowOddColor,
                          ),
                          children: [
                            _buildTableCell(score['child_name']),
                            _buildTableCell(score['play_count'].toString()),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [neonGreen, neonBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: neonGreen.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.home, size: 28),
                    label: const Text('Kembali ke Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          text,
          style: TextStyle(
            color: neonGreen,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            shadows: [
              Shadow(
                color: neonGreen.withOpacity(0.8),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}