import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'edit_child_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Child> _children = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _userRole = '';

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
    _loadChildren();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    _userRole = await AuthService.getUserRole() ?? 'user';
    setState(() {});
  }

  Future<void> _loadChildren() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _children = await ApiService.getChildren(search: _searchQuery);
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

  Future<void> _deleteChild(int childId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data', style: TextStyle(color: neonPink)),
        content: const Text('Anda yakin ingin menghapus data ini?', style: TextStyle(color: Colors.white70)),
        backgroundColor: darkBackground,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Batal', style: TextStyle(color: neonGreen)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Hapus', style: TextStyle(color: neonPink)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        bool success = await ApiService.deleteChild(childId);
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data anak berhasil dihapus. 🗑️', style: TextStyle(color: Colors.white)),
                backgroundColor: neonGreen,
              ),
            );
            _loadChildren(); // Reload data
          } else {
            _errorMessage = 'Gagal menghapus data anak.';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Bermain Anak',
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
            colors: [darkBackground, Color(0xFF0F0F1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/gambar3.jpg'), // Gambar background cyberpunk
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken), // Darken the image
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: lightSurface,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      offset: const Offset(6, 6),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      offset: const Offset(-6, -6),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                    BoxShadow(
                      color: neonBlue.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(color: neonPink.withOpacity(0.3), width: 1.5),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onSubmitted: (value) => _loadChildren(),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  cursorColor: neonPink,
                  decoration: InputDecoration(
                    hintText: 'Cari berdasarkan nama anak...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: neonGreen),
                      onPressed: _loadChildren,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: neonBlue.withOpacity(0.3), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: neonBlue, width: 2),
                    ),
                    filled: true,
                    fillColor: darkBackground.withOpacity(0.7),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator(color: neonPink)))
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: neonPink, fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else if (_children.isEmpty)
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Tidak ada riwayat bermain.',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightSurface,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            offset: const Offset(8, 8),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            offset: const Offset(-8, -8),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: neonBlue.withOpacity(0.5),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(color: neonPink.withOpacity(0.3), width: 2),
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(1.5),
                          4: FlexColumnWidth(2),
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
                              _buildTableHeader('Tanggal Bermain'),
                              _buildTableHeader('Nomor HP'),
                              _buildTableHeader('Biaya'),
                              _buildTableHeader('Aksi'),
                            ],
                          ),
                          ..._children.map((child) {
                            final isEvenRow = _children.indexOf(child) % 2 == 0;
                            return TableRow(
                              decoration: BoxDecoration(
                                color: isEvenRow ? tableRowEvenColor : tableRowOddColor,
                              ),
                              children: [
                                _buildTableCell(child.childName),
                                _buildTableCell(DateFormat('yyyy-MM-dd').format(child.playDate)),
                                _buildTableCell(child.phoneNumber),
                                _buildTableCell('Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(child.cost)}'),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _buildActionButton(
                                          'Ubah',
                                          Icons.edit,
                                          neonBlue,
                                          () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditChildScreen(child: child),
                                              ),
                                            );
                                            _loadChildren(); // Reload after edit
                                          },
                                        ),
                                        if (_userRole == 'admin') ...[
                                          const SizedBox(width: 8),
                                          _buildActionButton(
                                            'Hapus',
                                            Icons.delete,
                                            neonPink,
                                            () => _deleteChild(child.id!),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
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
            ),
          ],
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

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 0.5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        icon: Icon(icon, size: 18),
        label: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}