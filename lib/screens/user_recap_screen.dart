import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../services/api_service.dart';
import 'package:excel/excel.dart' as excel; // Added alias
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class UserRecapScreen extends StatefulWidget {
  const UserRecapScreen({super.key});

  @override
  State<UserRecapScreen> createState() => _UserRecapScreenState();
}

class _UserRecapScreenState extends State<UserRecapScreen> {
  List<Child> _children = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _totalIncome = 0;

  // Cyberpunk color scheme
  static const Color neonBlue = Color(0xFF00FFFF);
  static const Color neonPink = Color(0xFFFF00FF);
  static const Color neonGreen = Color(0xFF00FF00);
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color lightSurface = Color(0xFF2C2C4A);
  static const Color tableHeaderColor = Color(0xFF4A004A);
  static const Color tableRowEvenColor = Color(0xFF3A003A);
  static const Color tableRowOddColor = Color(0xFF2A002A);

  @override
  void initState() {
    super.initState();
    _loadUserChildren();
  }

  Future<void> _loadUserChildren() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _totalIncome = 0;
    });
    try {
      _children = await ApiService.getChildren();
      for (var child in _children) {
        _totalIncome += child.cost;
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        debugPrint('Error loading user children: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadExcel() async {
    if (_children.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada data untuk diunduh.')),
        );
      }
      return;
    }

    try {
      var excelFile = excel.Excel.createExcel(); // Using the alias
      excel.Sheet sheetObject = excelFile['Rekap Data Anak'];

      // Add headers
      sheetObject.appendRow([
        excel.TextCellValue('Nama Anak'),
        excel.TextCellValue('Tanggal Bermain'),
        excel.TextCellValue('Nomor HP'),
        excel.TextCellValue('Biaya'),
      ]);

      // Add data rows
      for (var child in _children) {
        sheetObject.appendRow([
          excel.TextCellValue(child.childName),
          excel.TextCellValue(DateFormat('yyyy-MM-dd').format(child.playDate)),
          excel.TextCellValue(child.phoneNumber),
          excel.TextCellValue('Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(child.cost)}'),
        ]);
      }

      // Add total income
      sheetObject.appendRow([
        excel.TextCellValue(''),
        excel.TextCellValue(''),
        excel.TextCellValue('Total Pendapatan'),
        excel.TextCellValue('Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(_totalIncome)}'),
      ]);

      // Save the file
      var fileBytes = excelFile.save();
      if (fileBytes != null) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/rekap_data_anak.xlsx';
        final file = File(path);
        await file.writeAsBytes(fileBytes);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File disimpan di: $path')),
          );
          try {
            await OpenFile.open(path);
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal membuka file: ${e.toString()}')),
              );
            }
            debugPrint('Error opening file: $e');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan file: ${e.toString()}')),
        );
      }
      debugPrint('Error in _downloadExcel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rekap Data Anak Anda',
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
        ),
        child: Column(
          children: [
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
                      'Tidak ada data rekap untuk Anda.',
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
                    padding: const EdgeInsets.all(16.0),
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
                              ],
                            );
                          }).toList(),
                          TableRow(
                            decoration: BoxDecoration(
                              color: neonPink.withOpacity(0.3),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            children: [
                              _buildTableCell('', isTotal: true),
                              _buildTableCell('', isTotal: true),
                              _buildTableCell('Total Pendapatan', isTotal: true),
                              _buildTableCell('Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(_totalIncome)}', isTotal: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                      onPressed: _downloadExcel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.download, size: 24),
                      label: const Text('Download Excel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [neonPink, neonBlue],
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.home, size: 24),
                      label: const Text('Kembali ke Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
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

  Widget _buildTableCell(String text, {bool isTotal = false}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? neonPink : Colors.white70,
            shadows: isTotal ? [
              Shadow(
                color: neonPink.withOpacity(0.5),
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ] : null,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}