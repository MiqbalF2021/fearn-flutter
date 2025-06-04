import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:lokasi_app/models/location.dart';
import 'package:lokasi_app/services/api_service.dart';
import 'package:lokasi_app/services/auth_service.dart';

class LocationDetailScreen extends StatefulWidget {
  final String locationId;

  const LocationDetailScreen({super.key, required this.locationId});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen>
    with SingleTickerProviderStateMixin {
  // Use the singleton instance
  late final ApiService _apiService;
  Location? _location;
  bool _isLoading = true;
  String? _errorMessage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Get the initialized ApiService from the singleton AuthService
    _apiService = AuthService().getApiService();
    _loadLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final location = await _apiService.getLocationById(widget.locationId);
      setState(() {
        _location = location;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load location: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_location?.name ?? 'Location Detail'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Coordinates', icon: Icon(Icons.list)),
            Tab(text: 'Map', icon: Icon(Icons.map)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLocation,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : TabBarView(
        controller: _tabController,
        children: [
          _buildCoordinatesTab(),
          _buildMapTab(),
        ],
      ),
    );
  }

  Widget _buildCoordinatesTab() {
    if (_location == null) {
      return const Center(child: Text('No location data available'));
    }

    final coordinates = _location!.polygon.coordinates[0];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location: ${_location!.name}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Area: ${_location!.area} hectares'),
                  Text('Region: ${_location!.region.name}'),
                  Text('Plantation Group: ${_location!.region.plantationGroup.name}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Coordinates:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: coordinates.length,
              itemBuilder: (context, index) {
                final coordinate = coordinates[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      'Longitude: ${coordinate[0]}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Latitude: ${coordinate[1]}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapTab() {
    if (_location == null) {
      return const Center(child: Text('No location data available'));
    }

    final coordinates = _location!.polygon.coordinates[0];
    final points = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();

    // Calculate center of polygon for map centering
    double sumLat = 0;
    double sumLng = 0;
    for (var point in points) {
      sumLat += point.latitude;
      sumLng += point.longitude;
    }
    final center = LatLng(sumLat / points.length, sumLng / points.length);

    return fm.FlutterMap(
      options: fm.MapOptions(
        center: center,
        zoom: 14,
      ),
      children: [
        fm.TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.lokasi_app',
        ),
        fm.PolygonLayer(
          polygons: [
            fm.Polygon(
              points: points,
              color: Colors.blue.withOpacity(0.4),
              borderColor: Colors.blue,
              borderStrokeWidth: 2,
              isFilled: true,
            ),
          ],
        ),
        fm.MarkerLayer(
          markers: [
            for (int i = 0; i < points.length; i++)
              fm.Marker(
                point: points[i],
                width: 40,
                height: 40,
                child: Tooltip(
                  message: 'Point ${i + 1}',
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}