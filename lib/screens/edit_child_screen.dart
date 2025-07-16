import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../services/api_service.dart';


class EditChildScreen extends StatefulWidget {
  final Child child;

  const EditChildScreen({super.key, required this.child});

  @override
  State<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  late TextEditingController _childNameController;
  late TextEditingController _playDateController;
  late TextEditingController _phoneNumberController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _childNameController = TextEditingController(text: widget.child.childName);
    _playDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(widget.child.playDate));
    _phoneNumberController = TextEditingController(text: widget.child.phoneNumber);
  }

  @override
  void dispose() {
    _childNameController.dispose();
    _playDateController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.child.playDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _playDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _updateChild() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final updatedChild = Child(
        id: widget.child.id,
        childName: _childNameController.text,
        playDate: DateTime.parse(_playDateController.text),
        phoneNumber: _phoneNumberController.text,
        cost: widget.child.cost, // Cost is not editable in this form
        userId: widget.child.userId,
      );

      bool success = await ApiService.updateChild(updatedChild);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data anak berhasil diubah.')),
          );
          Navigator.pop(context, true); // Pop with true to indicate success
        } else {
          _errorMessage = 'Gagal mengubah data.';
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
        title: const Text('Ubah Data Anak'),
        backgroundColor: const Color(0xFFFF6F61),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/anak.jpg'),
            fit: BoxFit.cover,
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
                    'Ubah Data Anak',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFFFF6F61),
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  TextField(
                    controller: _childNameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Anak',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: const Color(0xFFFFF0EF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _playDateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      labelText: 'Tanggal Bermain',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      prefixIcon: const Icon(Icons.calendar_today),
                      filled: true,
                      fillColor: const Color(0xFFFFF0EF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Nomor HP',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: const Color(0xFFFFF0EF),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _updateChild,
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
                            'Ubah Data',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Kembali ke Riwayat Bermain',
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