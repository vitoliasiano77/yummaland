import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'edit_child_screen.dart';
import 'edit_user_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<User> _users = [];
  List<Child> _children = [];
  bool _isLoadingUsers = true;
  bool _isLoadingChildren = false;
  String? _errorMessageUsers;
  String? _errorMessageChildren;
  User? _selectedUser;
  DateTime? _startDate;
  DateTime? _endDate;
  int _totalIncomeSelectedUser = 0;

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
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoadingUsers = true;
      _errorMessageUsers = null;
    });
    try {
      _users = await ApiService.getAllUsers();
    } catch (e) {
      setState(() {
        _errorMessageUsers = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoadingUsers = false;
      });
    }
  }

  Future<void> _loadChildrenForSelectedUser() async {
    if (_selectedUser == null) return;

    setState(() {
      _isLoadingChildren = true;
      _errorMessageChildren = null;
      _totalIncomeSelectedUser = 0; // Reset total income
    });

    try {
      // Memanggil ApiService.getChildren dengan userId
      List<Child> allChildren = await ApiService.getChildren(userId: _selectedUser!.id);

      _children = allChildren.where((child) {
        bool matchesStartDate = _startDate == null || child.playDate.isAfter(_startDate!) || child.playDate.isAtSameMomentAs(_startDate!);
        bool matchesEndDate = _endDate == null || child.playDate.isBefore(_endDate!) || child.playDate.isAtSameMomentAs(_endDate!);
        return matchesStartDate && matchesEndDate;
      }).toList();

      for (var child in _children) {
        _totalIncomeSelectedUser += child.cost;
      }
    } catch (e) {
      setState(() {
        _errorMessageChildren = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoadingChildren = false;
      });
    }
  }

  Future<void> _deleteUser(int userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkBackground, // Cyberpunk background for dialog
        title: Text('Hapus User', style: TextStyle(color: neonPink)),
        content: const Text('Anda yakin ingin menghapus user ini?', style: TextStyle(color: Colors.white70)),
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
        _isLoadingUsers = true;
      });
      try {
        bool success = await ApiService.deleteUser(userId);
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User berhasil dihapus. 🗑️', style: TextStyle(color: Colors.white)),
                backgroundColor: neonGreen,
              ),
            );
            _loadUsers(); // Reload users
            // Jika user yang dihapus adalah user yang sedang dipilih, reset tampilan riwayat
            if (_selectedUser?.id == userId) {
              setState(() {
                _selectedUser = null;
                _children = [];
                _totalIncomeSelectedUser = 0;
              });
            }
          } else {
            _errorMessageUsers = 'Gagal menghapus user.';
          }
        }
      } catch (e) {
        setState(() {
          _errorMessageUsers = e.toString().replaceFirst('Exception: ', '');
        });
      } finally {
        setState(() {
          _isLoadingUsers = false;
        });
      }
    }
  }

  Future<void> _deleteChild(int childId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkBackground, // Cyberpunk background for dialog
        title: Text('Hapus Data Anak', style: TextStyle(color: neonPink)),
        content: const Text('Anda yakin ingin menghapus data anak ini?', style: TextStyle(color: Colors.white70)),
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
        _isLoadingChildren = true;
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
            _loadChildrenForSelectedUser(); // Reload children for selected user
          } else {
            _errorMessageChildren = 'Gagal menghapus data anak.';
          }
        }
      } catch (e) {
        setState(() {
          _errorMessageChildren = e.toString().replaceFirst('Exception: ', '');
        });
      } finally {
        setState(() {
          _isLoadingChildren = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar User',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: neonGreen,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: neonGreen.withOpacity(0.8),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
              ),
              const SizedBox(height: 10),
              if (_isLoadingUsers)
                const Center(child: CircularProgressIndicator(color: neonPink))
              else if (_errorMessageUsers != null)
                Center(
                  child: Text(
                    _errorMessageUsers!,
                    style: const TextStyle(color: neonPink, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              else if (_users.isEmpty)
                const Center(
                  child: Text(
                    'Tidak ada pengguna terdaftar.',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                )
              else
                Container(
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300), // Increased height
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(0.5),
                          1: FlexColumnWidth(1.5),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1.5),
                          4: FlexColumnWidth(1.5),
                          5: FlexColumnWidth(2),
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
                              _buildTableHeader('ID'),
                              _buildTableHeader('Username'),
                              _buildTableHeader('Role'),
                              _buildTableHeader('Login Time'),
                              _buildTableHeader('Riwayat'),
                              _buildTableHeader('Aksi'),
                            ],
                          ),
                          ..._users.map((user) {
                            final isEvenRow = _users.indexOf(user) % 2 == 0;
                            return TableRow(
                              decoration: BoxDecoration(
                                color: isEvenRow ? tableRowEvenColor : tableRowOddColor,
                              ),
                              children: [
                                _buildTableCell(user.id.toString()),
                                _buildTableCell(user.username),
                                _buildTableCell(user.role),
                                _buildTableCell(user.loginTime ?? '-'),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: _buildActionButton(
                                      'Lihat',
                                      Icons.visibility,
                                      neonBlue,
                                      () {
                                        setState(() {
                                          _selectedUser = user;
                                          _startDate = null; // Reset dates
                                          _endDate = null;
                                        });
                                        _loadChildrenForSelectedUser();
                                      },
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _buildActionButton(
                                          'Ubah',
                                          Icons.edit,
                                          neonGreen,
                                          () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditUserScreen(user: user),
                                              ),
                                            );
                                            _loadUsers(); // Reload users after edit
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        _buildActionButton(
                                          'Hapus',
                                          Icons.delete,
                                          neonPink,
                                          () => _deleteUser(user.id),
                                        ),
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
              const SizedBox(height: 30),
              if (_selectedUser != null) ...[
                Text(
                  'Riwayat Bermain User: ${_selectedUser!.username}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: neonGreen,
                        fontWeight: FontWeight.bold,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildDateField(
                        controller: TextEditingController(text: _startDate == null ? '' : DateFormat('yyyy-MM-dd').format(_startDate!)),
                        labelText: 'Tanggal Mulai',
                        icon: Icons.calendar_today,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: neonPink,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.white,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: neonGreen,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              _startDate = picked;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDateField(
                        controller: TextEditingController(text: _endDate == null ? '' : DateFormat('yyyy-MM-dd').format(_endDate!)),
                        labelText: 'Tanggal Akhir',
                        icon: Icons.calendar_today,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: neonPink,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.white,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: neonGreen,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              _endDate = picked;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildActionButton(
                      'Filter',
                      Icons.filter_list,
                      neonBlue,
                      _loadChildrenForSelectedUser,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total Pendapatan: Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(_totalIncomeSelectedUser)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: neonPink,
                      shadows: [
                        Shadow(
                          color: neonPink.withOpacity(0.8),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_isLoadingChildren)
                  const Center(child: CircularProgressIndicator(color: neonPink))
                else if (_errorMessageChildren != null)
                  Center(
                    child: Text(
                      _errorMessageChildren!,
                      style: const TextStyle(color: neonPink, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                else if (_children.isEmpty)
                  const Center(
                    child: Text(
                      'Tidak ada riwayat bermain untuk user ini pada tanggal yang dipilih.',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  )
                else
                  Container(
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
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
                              _buildTableHeader('Tanggal Bermain'),
                              _buildTableHeader('Nama Anak'),
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
                                _buildTableCell(DateFormat('yyyy-MM-dd').format(child.playDate)),
                                _buildTableCell(child.childName),
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
                                          neonGreen,
                                          () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditChildScreen(child: child),
                                              ),
                                            );
                                            _loadChildrenForSelectedUser(); // Reload after edit
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        _buildActionButton(
                                          'Hapus',
                                          Icons.delete,
                                          neonPink,
                                          () => _deleteChild(child.id!),
                                        ),
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
              ],
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

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed, {EdgeInsetsGeometry? padding}) {
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
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
}