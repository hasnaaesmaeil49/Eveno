import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  LatLng selectedLocation = LatLng(30.033333, 31.233334); // القاهرة

  void _onTapMap(LatLng latlng) {
    setState(() {
      selectedLocation = latlng;
    });
  }

  void _onConfirmLocation() {
    Navigator.pop(context, selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر الموقع'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: selectedLocation, // الموقع الافتراضي
              zoom: 13.0, // تكبير الخريطة
              onTap: (_, LatLng latlng) => _onTapMap(latlng), // تنفيذ دالة عند الضغط على الخريطة
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedLocation, // الموقع المحدد
                    width: 40.0,  // عرض المارك
                    height: 40.0, // ارتفاع المارك
                    child: const Icon(Icons.location_on, color: Colors.red, size: 40), // الأيقونة
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _onConfirmLocation,
              child: const Text('تأكيد الموقع'),
            ),
          ),
        ],
      ),
    );
  }
}