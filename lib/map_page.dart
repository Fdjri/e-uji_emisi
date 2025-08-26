import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final WebViewController _controller;
  String _filter = 'car';

  // Embed queries for car and bike searches in Jakarta
  static const String _carQuery =
      'https://www.google.com/maps?q=uji%20emisi%20mobil%20jakarta&output=embed&z=12';
  static const String _bikeQuery =
      'https://www.google.com/maps?q=uji%20emisi%20motor%20jakarta&output=embed&z=12';

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
    });
    final String src = filter == 'bike' ? _bikeQuery : _carQuery;
    _controller.loadHtmlString(_buildEmbedHtml(src));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FD),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: WebViewWidget(controller: _controller),
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: _buildFilterToggle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        children: const [
          BackButton(color: Colors.black),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tempat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Uji Emisi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterToggle() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildChip(
            label: 'Car',
            icon: Icons.directions_car,
            selected: _filter == 'car',
            onTap: () => _setFilter('car'),
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Bike',
            icon: Icons.two_wheeler,
            selected: _filter == 'bike',
            onTap: () => _setFilter('bike'),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0D65AA) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF0D65AA)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? Colors.white : const Color(0xFF0D65AA)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF0D65AA),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
