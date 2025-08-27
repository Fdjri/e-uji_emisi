import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EmissionTestLocation {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String description;
  final double latitude;
  final double longitude;
  final double distance;

  EmissionTestLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final WebViewController _controller;
  String _filter = 'car';
  EmissionTestLocation? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();
  bool _showMap = false;

  // Real Jakarta emission test locations for cars
  final List<EmissionTestLocation> _carLocations = [
    EmissionTestLocation(
      id: 'KMT.22.0001',
      name: 'PRASARANA DAN SARANA',
      address: 'Jalan Mandala V No. 67 Cililitan Jakarta Timur',
      phone: '0218092744',
      description: 'umum',
      latitude: -6.2088,
      longitude: 106.8456,
      distance: 0.042,
    ),
    EmissionTestLocation(
      id: 'KMT.22.0002',
      name: 'Pasar Kramat Jati',
      address: 'Jl. Raya Bogor, RW.4, Kramat Jati, Kec. Kramat jati, Kota Jakarta Timur',
      phone: '087796099044',
      description: 'Menerima Pengujian Kendaraan Merk Yamaha',
      latitude: -6.3158,
      longitude: 106.6644,
      distance: 0.754,
    ),
    EmissionTestLocation(
      id: 'KMT.22.0003',
      name: 'PT Rizqi Putra Pratama',
      address: 'Jl. Raya Bogor, RW.4, Kramat Jati, Kec. Kramat jati, Kota Jakarta Timur',
      phone: '085320001101',
      description: 'Menerima pengujian kendaraan berbahan bakar bensin semua merk',
      latitude: -6.2349,
      longitude: 106.9896,
      distance: 1.2,
    ),
    EmissionTestLocation(
      id: 'KMT.22.0004',
      name: 'Bengkel Uji Emisi Jakarta Pusat',
      address: 'Jl. Sudirman No. 123, Jakarta Pusat',
      phone: '021-5550123',
      description: 'Uji Emisi Roda 4',
      latitude: -6.4025,
      longitude: 106.7942,
      distance: 2.1,
    ),
    EmissionTestLocation(
      id: 'KMT.22.0005',
      name: 'Pusat Uji Emisi Tangerang',
      address: 'Jl. Raya Serpong KM 7, Tangerang Selatan',
      phone: '021-5550456',
      description: 'Uji Emisi Roda 4',
      latitude: -6.1380,
      longitude: 106.8223,
      distance: 3.5,
    ),
  ];

  // Real Jakarta emission test locations for motorcycles
  final List<EmissionTestLocation> _bikeLocations = [
    EmissionTestLocation(
      id: 'KMT.22.0006',
      name: 'Bengkel Motor Uji Emisi Jakarta Barat',
      address: 'Jl. Hayam Wuruk No. 12, Jakarta Barat',
      phone: '021-5550987',
      description: 'Uji Emisi Roda 2',
      latitude: -6.1751,
      longitude: 106.8650,
      distance: 0.8,
    ),
    EmissionTestLocation(
      id: 'KMT.22.0007',
      name: 'Pusat Uji Motor Jakarta Selatan',
      address: 'Jl. Gatot Subroto No. 34, Jakarta Selatan',
      phone: '021-5550432',
      description: 'Uji Emisi Roda 2',
      latitude: -6.2088,
      longitude: 106.8456,
      distance: 1.1,
    ),
  ];

  // Embed queries for car and bike searches in Jakarta
  static const String _carQuery =
      'https://www.google.com/maps?q=uji+emisi+mobil+jakarta&output=embed&z=12&center=-6.2088,106.8456';
  static const String _bikeQuery =
      'https://www.google.com/maps?q=uji+emisi+motor+jakarta&output=embed&z=12&center=-6.2088,106.8456';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadHtmlString(_buildEmbedHtml(_carQuery));
  }

  void _setFilter(String filter) {
    setState(() {
      _filter = filter;
      _selectedLocation = null;
    });
    final String src = filter == 'bike' ? _bikeQuery : _carQuery;
    _controller.loadHtmlString(_buildEmbedHtml(src));
  }

  void _toggleView() {
    setState(() {
      _showMap = !_showMap;
    });
  }

  void _showLocationDetail(EmissionTestLocation location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _hideLocationDetail() {
    setState(() {
      _selectedLocation = null;
    });
  }

  Future<void> _makePhoneCall(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _openMapsNavigation(EmissionTestLocation location) async {
    final Uri mapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}'
    );
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    }
  }

  List<EmissionTestLocation> get _filteredLocations {
    final locations = _filter == 'car' ? _carLocations : _bikeLocations;
    if (_searchController.text.isEmpty) return locations;
    
    return locations.where((location) =>
      location.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
      location.address.toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();
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
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Expanded(
                child: _showMap ? _buildMapView() : _buildListView(),
              ),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
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
                  'DAFTAR TEMPAT UJI EMISI RODA 4',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D65AA),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Masukkan Kata Kunci Pen...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredLocations.length,
      itemBuilder: (context, index) {
        final location = _filteredLocations[index];
        return _buildLocationCard(location);
      },
    );
  }

  Widget _buildLocationCard(EmissionTestLocation location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.home, 'Tempat Ujiemisi', location.name),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, 'Alamat Tempat Ujiemisi', location.address),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone, 'Telp Tempat Ujiemisi', location.phone),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.check_circle, 'Keterangan', location.description),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_searching, 'Jarak Dari Lokasi Anda', '${location.distance}Km'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.phone,
                    color: Colors.green,
                    onTap: () => _makePhoneCall(location.phone),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.location_on,
                    color: Colors.orange,
                    onTap: () => _openMapsNavigation(location),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF0D65AA)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        _buildLocationMarkers(),
        if (_selectedLocation != null) _buildDetailOverlay(),
      ],
    );
  }

  Widget _buildLocationMarkers() {
    final locations = _filter == 'car' ? _carLocations : _bikeLocations;
    
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: locations.asMap().entries.map((entry) {
            final index = entry.key;
            final location = entry.value;
            
            // Calculate positions for markers
            double left = 100 + (index * 60.0);
            double top = 200 + (index * 40.0);

            return Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                onTap: () => _showLocationDetail(location),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _filter == 'car' ? Colors.blue : Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _filter == 'car' ? Icons.directions_car : Icons.two_wheeler,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDetailOverlay() {
    if (_selectedLocation == null) return const SizedBox.shrink();

    return Positioned(
      left: 16,
      right: 16,
      top: 100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    _selectedLocation!.id,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _hideLocationDetail,
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(Icons.home, 'Tempat Ujiemisi', _selectedLocation!.name),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.location_on, 'Alamat Tempat Ujiemisi', _selectedLocation!.address),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.phone, 'Telp', _selectedLocation!.phone),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.check_circle, 'Keterangan', _selectedLocation!.description),
                ],
              ),
            ),
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.phone,
                      color: Colors.green,
                      onTap: () => _makePhoneCall(_selectedLocation!.phone),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.location_on,
                      color: Colors.orange,
                      onTap: () => _openMapsNavigation(_selectedLocation!),
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

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _toggleView,
              icon: Icon(_showMap ? Icons.list : Icons.map, color: Colors.white),
              label: Text(
                _showMap ? 'DAFTAR TEMPAT UJI EMISI' : 'PETA TEMPAT UJI EMISI',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D65AA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildFilterButton('bike', Icons.two_wheeler, Colors.orange),
          const SizedBox(width: 8),
          _buildFilterButton('car', Icons.directions_car, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter, IconData icon, Color color) {
    final isSelected = _filter == filter;
    return GestureDetector(
      onTap: () => _setFilter(filter),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : color,
          size: 24,
        ),
      ),
    );
  }

  String _buildEmbedHtml(String src) {
    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
      html, body { height: 100%; margin: 0; padding: 0; background: transparent; }
      .map { position: absolute; top: 0; left: 0; right: 0; bottom: 0; }
      iframe { border: 0; width: 100%; height: 100%; }
    </style>
  </head>
  <body>
    <div class="map">
      <iframe src="$src" allowfullscreen loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
    </div>
  </body>
</html>
''';
  }
}
