import 'package:flutter/material.dart';
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
  String _filter = 'car';
  EmissionTestLocation? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();

  final List<EmissionTestLocation> _carLocations = [
    EmissionTestLocation(
      id: 'KMT.22.0001',
      name: 'PRASARANA DAN SARANA',
      address: 'Jalan Mandala V No. 67 Cililitan Jakarta Timur',
      phone: '0218092744',
      description: 'Mendukung pengujian untuk umum',
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
  ];

  final List<EmissionTestLocation> _bikeLocations = [
    EmissionTestLocation(
      id: 'KMT.22.0006',
      name: 'Bengkel Motor Uji Emisi Jakarta Barat',
      address: 'Jl. Hayam Wuruk No. 12, Jakarta Barat',
      phone: '021-5550987',
      description: 'Mendukung pengujian untuk Roda 2',
      latitude: -6.1751,
      longitude: 106.8650,
      distance: 0.8,
    ),
  ];

  void _setFilter(String filter) {
    setState(() {
      _filter = filter;
      _selectedLocation = null;
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
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFilterControls(),
            Expanded(
              child: Stack(
                children: [
                  // Placeholder for the map
                  Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Text(
                        'Peta akan ditampilkan di sini',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  _buildLocationMarkers(),
                  if (_selectedLocation != null) _buildDetailOverlay(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                  'Temukan Lokasi',
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Cari lokasi...',
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
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilterButton('car', 'Mobil'),
          const SizedBox(width: 16),
          _buildFilterButton('bike', 'Motor'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter, String label) {
    final bool isSelected = _filter == filter;
    return GestureDetector(
      onTap: () => _setFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D65AA) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationMarkers() {
    final locations = _filteredLocations;
    
    return Stack(
      children: locations.asMap().entries.map((entry) {
        final index = entry.key;
        final location = entry.value;
        
        // Simple positioning logic for demonstration
        double left = 50 + (index * 100.0);
        double top = 100 + (index * 50.0);

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
    );
  }

  Widget _buildDetailOverlay() {
    if (_selectedLocation == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _selectedLocation!.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: _hideLocationDetail,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.location_on, 'Alamat', _selectedLocation!.address),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.phone, 'Telepon', _selectedLocation!.phone),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.info_outline, 'Keterangan', _selectedLocation!.description),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openMapsNavigation(_selectedLocation!),
                        icon: const Icon(Icons.directions, color: Colors.white),
                        label: const Text('Arahkan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D65AA),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
