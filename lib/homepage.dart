import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'contact_page.dart';
import 'info_page.dart';
import 'map_page.dart';
import 'booking_page.dart';
import 'scan_page.dart';

// Note: The static navbar classes are included at the end of this file.

class NewsArticle {
  final String title;
  final String date;
  final String imagePath;
  final String url;
  final String description;

  NewsArticle({
    required this.title,
    required this.date,
    required this.imagePath,
    required this.url,
    required this.description,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Home is selected by default
  final TextEditingController _platePart1Controller = TextEditingController();
  final TextEditingController _platePart2Controller = TextEditingController();
  final TextEditingController _platePart3Controller = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<NewsArticle> _newsArticles = [
    NewsArticle(
      title: 'Tegakkan Hukum Uji Emisi, Polda Metro Ambil Tindakan Edukatif - Represif',
      date: '09 Maret 2025',
      imagePath: 'assets/images/news1.jpg',
      url: 'https://lingkunganhidup.jakarta.go.id/detail-artikel/tegakkan-hukum-uji-emisi-polda-metro-ambil-tindakan-edukatif-represif',
      description: 'Polda Metro Jaya bersama Dinas Lingkungan Hidup DKI Jakarta mengadakan uji emisi gratis di area Komplek Gelora Bung Karno dalam rangka Operasi Zebra Jaya 2023.',
    ),
    NewsArticle(
      title: 'DLH DKI Larang Kendaraan Pegawai yang Belum Uji Emisi Masuki Area Kantor',
      date: '21 Agustus 2023',
      imagePath: 'assets/images/news2.jpg',
      url: 'https://lingkunganhidup.jakarta.go.id/detail-artikel/dlh-dki-larang-kendaraan-pegawai-yang-belum-uji-emisi-masuki-area-kantor',
      description: 'Dinas Lingkungan Hidup DKI Jakarta memberlakukan kebijakan baru untuk meningkatkan kepatuhan uji emisi di kalangan pegawai.',
    ),
    NewsArticle(
      title: 'DKI Jakarta Gelar Uji Emisi Akbar Gratis untuk Perbaikan Kualitas Udara',
      date: '15 Januari 2024',
      imagePath: 'assets/images/news3.jpg',
      url: 'https://lingkunganhidup.jakarta.go.id/detail-artikel/dki-jakarta-gelar-uji-emisi-akbar-gratis-untuk-perbaikan-kualitas-udara',
      description: 'Pemerintah Provinsi DKI Jakarta menyelenggarakan program uji emisi massal gratis sebagai upaya perbaikan kualitas udara Jakarta.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if(mounted) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _platePart1Controller.dispose();
    _platePart2Controller.dispose();
    _platePart3Controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0) { // Info Page tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InfoPage()),
      );
    } else if (index == 2) { // Contact Page tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ContactPage()),
      );
    }
    // For index 1 (Home), we don't need to do anything as we are already on the HomePage.
  }

  void _openNewsArticle(NewsArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsWebViewPage(
          url: article.url,
          title: article.title,
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showEmissionResult() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('Nomor Kendaraan', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text(
                        '${_platePart1Controller.text} ${_platePart2Controller.text} ${_platePart3Controller.text}'.toUpperCase(),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(color: const Color(0xFF0D65AA).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.directions_car, color: Color(0xFF0D65AA), size: 16),
                          ),
                          const SizedBox(width: 12),
                          const Text('Tipe/Jenis Kendaraan', style: TextStyle(fontSize: 14, color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 36),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Roda 2/Roda 4', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(color: const Color(0xFF0D65AA).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.calendar_today, color: Color(0xFF0D65AA), size: 16),
                          ),
                          const SizedBox(width: 12),
                          const Text('Berlaku Sampai', style: TextStyle(fontSize: 14, color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 36),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('Status Uji Emisi', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                        child: const Center(child: Text('TIDAK LULUS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildBannerCarousel(),
                    const SizedBox(height: 20),
                    _buildFeatureCards(),
                    const SizedBox(height: 20),
                    _buildMainActionCard(),
                    const SizedBox(height: 30),
                    _buildNewsSection(),
                    const SizedBox(height: 30),
                    _buildFooter(),
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
        backgroundColor: const Color(0xFF0D65AA),
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAppHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 50,
        child: Stack(
          children: [
            Positioned(
              left: 20, top: 0,
              child: Image.asset('assets/images/dlh.png', width: 50, height: 50, fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.eco, color: Color(0xFF0D65AA), size: 30),
              ),
            ),
            Positioned(
              right: 15, top: 0,
              child: Image.asset('assets/images/sielang.png', width: 100, height: 50, fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.location_city, color: Color(0xFF0D65AA), size: 150),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    final List<String> bannerImages = [
      'assets/images/banner_atas.jpg',
      'assets/images/banner_tengah.jpg',
      'assets/images/banner_bawah.jpg',
    ];

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: bannerImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(bannerImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(bannerImages.length, (index) => _buildDot(index)),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: _currentPage == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? const Color(0xFF0D65AA) : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildMainActionCard() {
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
        children: [
          const Text('CEK HASIL UJI EMISI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildPlateTextField(_platePart1Controller, 'XX'),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: _buildPlateTextField(_platePart2Controller, 'XXXX'),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _buildPlateTextField(_platePart3Controller, 'XXX'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showEmissionResult,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D65AA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('CARI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlateTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
      ],
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Row(
      children: [
        Expanded(child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage())), child: _buildFeatureCard(imagePath: 'assets/images/loc.png', title: 'Tempat\nUji Emisi'))),
        const SizedBox(width: 12),
        Expanded(child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingPage())), child: _buildFeatureCard(imagePath: 'assets/images/mobiluji.png', title: 'Pemesanan\nUji Emisi'))),
        const SizedBox(width: 12),
        Expanded(child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanPage())), child: _buildFeatureCard(imagePath: 'assets/images/qrcode.png', title: 'Scan Booking\nUji Emisi'))),
      ],
    );
  }

  Widget _buildFeatureCard({required String imagePath, required String title}) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(imagePath,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline, color: Color(0xFF0D65AA), size: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
      ],
    );
  }

  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('KEGIATAN UJI EMISI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0))),
        const SizedBox(height: 16),
        ..._newsArticles.map((article) => _buildNewsCard(article)).toList(),
      ],
    );
  }

  Widget _buildNewsCard(NewsArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: GestureDetector(
        onTap: () => _openNewsArticle(article),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: SizedBox(
                height: 160, width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(article.imagePath, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D65AA), Color(0xFF1E88E5)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                            child: Stack(children: [
                              Positioned.fill(child: CustomPaint(painter: NewsBackgroundPainter())),
                              const Center(child: Icon(Icons.article, color: Colors.white, size: 50)),
                            ]),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 16, left: 16, right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                            child: Text(article.date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0D65AA))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(article.description, style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFF0D65AA).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: const Text('Baca Selengkapnya', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0D65AA))),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF0D65AA)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
          children: [
            const TextSpan(text: 'Telah mencapai akhir halaman. Kunjungi juga '),
            TextSpan(
              text: 'website',
              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL('https://ujiemisi.jakarta.go.id/');
                },
            ),
            const TextSpan(text: ' kami!'),
          ],
        ),
      ),
    );
  }
}

class NewsBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.1)..strokeWidth = 2..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 20, paint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.7), 15, paint);
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width * 0.3, size.height * 0.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NewsWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const NewsWebViewPage({super.key, required this.url, required this.title});

  @override
  State<NewsWebViewPage> createState() => _NewsWebViewPageState();
}

class _NewsWebViewPageState extends State<NewsWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
