import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'homepage.dart'; // Import for popping back to home
import 'info_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int _selectedIndex = 2; // Contact is selected
  final ScrollController _scrollController = ScrollController();

  void _onItemTapped(int index) {
    if (index == 1) { // Home tab
      Navigator.pop(context);
    } else if (index == 0) { // Info tab
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InfoPage()),
      );
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'dinaslh@jakarta.go.id',
    );
    if (!await launchUrl(emailUri)) {
      throw Exception('Could not launch email');
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '0218092744',
    );
    if (!await launchUrl(phoneUri)) {
      throw Exception('Could not launch phone');
    }
  }

  Future<void> _launchWebsite() async {
    const String websiteUrl = 'https://ujiemisi.jakarta.go.id/';
    final Uri websiteUri = Uri.parse(websiteUrl);
    if (!await launchUrl(websiteUri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch website');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppHeader(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildContactSection(
                            icon: Icons.email,
                            iconColor: Colors.blue,
                            title: 'EMAIL',
                            subtitle: 'dinaslh@jakarta.go.id',
                            onTap: _launchEmail,
                          ),
                          const Divider(height: 1, color: Colors.grey),
                          _buildContactSection(
                            icon: Icons.phone,
                            iconColor: Colors.pink,
                            title: 'TELEPON',
                            subtitle: '(021) 8092744',
                            onTap: _launchPhone,
                          ),
                          const Divider(height: 1, color: Colors.grey),
                          _buildContactSection(
                            icon: Icons.location_on,
                            iconColor: Colors.red,
                            title: 'ALAMAT',
                            subtitle: 'Jl. Mandala V No. 67 Jakarta Timur',
                            onTap: null,
                          ),
                          const Divider(height: 1, color: Colors.grey),
                          _buildContactSection(
                            icon: Icons.language,
                            iconColor: Colors.green,
                            title: 'WEBSITE',
                            subtitle: 'ujiemisi.jakarta.go.id',
                            onTap: _launchWebsite,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jam Operasional',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Senin - Kamis', '08:00 - 16:00'),
                          _buildInfoRow('Jumat', '08:00 - 15:00'),
                          _buildInfoRow('Sabtu, Minggu & Hari Libur', 'Tutup'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Layanan Uji Emisi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Kendaraan Roda 2', 'Motor & Skuter'),
                          _buildInfoRow('Kendaraan Roda 4', 'Mobil & SUV'),
                          _buildInfoRow('Kendaraan Komersial', 'Truk & Bus'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0 ? const Color(0xFF0D65AA) : Colors.grey,
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.contact_phone_outlined),
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2 ? const Color(0xFF0D65AA) : Colors.grey,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(1),
        backgroundColor: const Color(0xFF4DB6AC),
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAppHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Call Center',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Uji Emisi',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48.0),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
