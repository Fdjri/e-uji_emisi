import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contact_page.dart';

// Note: The CustomBottomNavBarWithLogic and NavBarClipper classes are included at the end of this file.

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  int _selectedIndex = 0; // Info is selected

  // --- NEW: Navigation logic for the custom navbar ---
  void _onItemTapped(int index) {
    if (index == 1) { // Home tab
      // Pop back to the previous screen (which should be HomePage)
      Navigator.pop(context);
    } else if (index == 2) { // Contact tab
      // Replace the current page with ContactPage to avoid stacking
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactPage()),
      );
    }
    // If index is 0 (the current page), do nothing.
  }

  Future<void> _downloadRegulation() async {
    final Uri url = Uri.parse('https://ujiemisi.jakarta.go.id/__assets/dokumen/cf818990ddfbd2b2d86ef41a97393a6e.pdf');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
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
            // App Header
            _buildAppHeader(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Step 1
                    _buildStepCard(
                      stepNumber: 1,
                      icon: Icons.science,
                      iconColor: Colors.orange,
                      title: 'Petugas melakukan pengujian emisi kendaraan Anda',
                    ),
                    const SizedBox(height: 16),
                    
                    // Step 2
                    _buildStepCard(
                      stepNumber: 2,
                      icon: Icons.verified_user,
                      iconColor: Colors.green,
                      title: 'Petugas melakukan verifikasi data kendaraan Anda',
                    ),
                    const SizedBox(height: 16),
                    
                    // Step 3
                    _buildStepCard(
                      stepNumber: 3,
                      icon: Icons.computer,
                      iconColor: Colors.red,
                      title: 'Hasil pengujian akan diinput ke dalam database uji emisi',
                    ),
                    const SizedBox(height: 16),
                    
                    // Step 4
                    _buildStepCard(
                      stepNumber: 4,
                      icon: Icons.print,
                      iconColor: Colors.orange,
                      title: 'Hasil uji emisi akan dicetak setelah proses pengujian selesai',
                    ),
                    const SizedBox(height: 20),
                    
                    // Regulation Card
                    _buildRegulationCard(),
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
            const SizedBox(width: 40), // Spacer for the FAB
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
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          // Centered title
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Alur & Peraturan',
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
          // Spacer to balance the back button and center the title
          const SizedBox(width: 48.0), // IconButton's default width is 48
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required int stepNumber,
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
      child: Row(
        children: [
          // Step number badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0D65AA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Icon with background
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
          
          // Text content
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegulationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
          Row(
            children: [
              // Document icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.description,
                  color: Colors.grey,
                  size: 25,
                ),
              ),
              const SizedBox(width: 16),
              
              // Regulation text
              const Expanded(
                child: Text(
                  'Undang-Undang Nomor 22 tahun 2009 tentang Lalu Lintas dan Angkutan Jalan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Download button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _downloadRegulation,
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text(
                'UNDUH PERATURAN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D65AA),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
