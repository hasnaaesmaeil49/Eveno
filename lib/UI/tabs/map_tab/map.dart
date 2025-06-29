import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  final LatLng selectedLocation = const LatLng(30.033333, 31.233334);
  bool isMapReady = false;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
      markerId: const MarkerId('initial'),
      position: selectedLocation,
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      isMapReady = true;
    });
  }

  void _onTapMap(LatLng latlng) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: latlng,
        ),

      };
    });
    print(latlng);
  }

  void _onConfirmLocation() {
    Navigator.pop(context, _markers.first.position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر الموقع')),
      body: Stack(
        children: [
          if (!isMapReady)
            const Center(child: CircularProgressIndicator()),

          Opacity(
            opacity: isMapReady ? 1.0 : 0.0,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _onTapMap,
              initialCameraPosition: CameraPosition(
                target: selectedLocation,
                zoom: 13,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
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
