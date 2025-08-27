import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();

  String? _fuel; // bensin / solar
  String? _region; // wilayah
  String? _place; // tempat uji emisi

  final List<String> _fuelOptions = const ['Bensin', 'Solar'];
  final List<String> _regionOptions = const [
    'Jakarta Pusat',
    'Jakarta Timur',
    'Jakarta Selatan',
    'Jakarta Utara',
    'Jakarta Barat',
  ];

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      _dateController.text = _formatDate(picked);
      setState(() {});
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void _submit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 56),
              SizedBox(height: 12),
              Text(
                'Data Berhasil Disimpan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F4FD),
              Color(0xFFD1E9FB),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),

                // Nomor Kendaraan (Vehicle Number)
                const Text('Nomor Kendaraan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                _buildTextField(controller: _plateController, hint: 'Masukkan nomor kendaraan'),
                const SizedBox(height: 16),

                // Nomor Telp Pendaftar (Registrant Phone Number)
                const Text('Nomor Telp Pendaftar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                _buildTextField(controller: _phoneController, hint: 'Masukkan nomor telepon', keyboardType: TextInputType.phone),
                const SizedBox(height: 16),

                // Nama Pendaftar (Registrant Name)
                const Text('Nama Pendaftar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                _buildTextField(controller: _nameController, hint: 'Masukkan nama pendaftar'),
                const SizedBox(height: 16),

                // Bahan Bakar (Fuel Type)
                const Text('Bahan Bakar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                _buildDropdown<String>(
                  value: _fuel,
                  hint: 'Pilih Bahan Bakar',
                  items: _fuelOptions,
                  onChanged: (val) => setState(() => _fuel = val),
                ),
                const SizedBox(height: 16),

                // Tanggal Kunjungan (Visit Date)
                const Text('Tanggal Kunjungan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _dateController,
                  hint: 'Pilih Tanggal',
                  readOnly: true,
                  prefixIcon: Icons.calendar_today,
                  suffix: IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _dateController.clear();
                      setState(() {});
                    },
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),

                // Wilayah (Region)
                const Text('Wilayah', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                _buildDropdown<String>(
                  value: _region,
                  hint: 'Pilih Wilayah',
                  items: _regionOptions,
                  onChanged: (val) => setState(() => _region = val),
                ),
                const SizedBox(height: 16),

                // Tempat Uji Emisi (Emission Test Location)
                const Text('Tempat Uji Emisi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                _buildDropdown<String>(
                  value: _place,
                  hint: 'Pilih Tempat',
                  items: const ['Tempat A', 'Tempat B', 'Tempat C'],
                  onChanged: (val) => setState(() => _place = val),
                ),

                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D65AA),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Submit Pendaftaran', 
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pemesanan', 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black
                )
              ),
              Text(
                'Uji Emisi', 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.w600, 
                  color: Colors.black
                )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    bool readOnly = false,
    IconData? prefixIcon,
    Widget? suffix,
    GestureTapCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600]) : null,
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.grey[600])),
          items: items
              .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(e.toString()),
                  ))
              .toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ),
      ),
    );
  }
}
