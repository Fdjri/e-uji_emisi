import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'info_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int _selectedIndex = 2; // Contact is selected
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
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
      backgroundColor: const Color(0xFFE8F4FD), // Light blue background
      body: SafeArea(
        child: Column(
          children: [
            // App Header with translucent effect
            _buildAppHeader(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Contact Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Email Section
                          _buildContactSection(
                            icon: Icons.email,
                            iconColor: Colors.blue,
                            title: 'EMAIL',
                            subtitle: 'dinaslh@jakarta.go.id',
                            onTap: _launchEmail,
                          ),
                          const Divider(height: 1, color: Colors.grey),
                          
                          // Phone Section
                          _buildContactSection(
                            icon: Icons.phone,
                            iconColor: Colors.pink,
                            title: 'TELEPON',
                            subtitle: '(021) 8092744',
                            onTap: _launchPhone,
                          ),
                          const Divider(height: 1, color: Colors.grey),
                          
                          // Address Section
                          _buildContactSection(
                            icon: Icons.location_on,
                            iconColor: Colors.red,
                            title: 'ALAMAT',
                            subtitle: 'Jl. Mandala V No. 67 Jakarta Timur',
                            onTap: null,
                          ),
                          const Divider(height: 1, color: Colors.grey),
                          
                          // Website Section
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
                    
                    // Add some extra content to enable scrolling
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
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
                          _buildInfoRow('Senin - Jumat', '08:00 - 16:00'),
                          _buildInfoRow('Sabtu', '08:00 - 12:00'),
                          _buildInfoRow('Minggu & Hari Libur', 'Tutup'),
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
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
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
                    
                    const SizedBox(height: 100), // Extra space for scrolling
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppHeader() {
    // Calculate opacity based on scroll offset
    double opacity = 1.0;
    if (_scrollOffset > 50) {
      opacity = 0.8;
    }
    if (_scrollOffset > 100) {
      opacity = 0.6;
    }
    if (_scrollOffset > 150) {
      opacity = 0.4;
    }
    if (_scrollOffset > 200) {
      opacity = 0.2;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FD).withValues(alpha: opacity),
        boxShadow: _scrollOffset > 10 ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1 * opacity),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back, 
                color: Colors.black.withValues(alpha: opacity),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Call Center',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: opacity),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Uji Emisi',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: opacity),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
            // Icon with background
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            // Text content
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
            // Arrow icon if tappable
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

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          
          // Handle navigation based on selected index
          if (index == 0) { // Info tab
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InfoPage()),
            );
          } else if (index == 1) { // Home tab
            Navigator.pop(context);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0D65AA),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}
