import 'package:flutter/material.dart';
import 'package:lokasi_app/models/location.dart';
import 'package:lokasi_app/services/api_service.dart';
import 'package:lokasi_app/services/auth_service.dart';
import 'package:lokasi_app/screens/location_detail_screen.dart';
import 'package:lokasi_app/screens/login_screen.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key});

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  // Use the singleton instance
  final AuthService _authService = AuthService();
  late final ApiService _apiService;

  List<Location> _locations = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    // Get the initialized ApiService from the singleton AuthService
    _apiService = _authService.getApiService();
    _loadLocations();
  }

  Future<void> _loadLocations({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
      });
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.getLocations(page: _currentPage);

      setState(() {
        _locations = refresh
            ? result['locations'] as List<Location>
            : [..._locations, ...result['locations'] as List<Location>];
        _totalPages = result['totalPages'] as int;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load locations: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreLocations() async {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      await _loadLocations();
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _errorMessage != null
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
                    onPressed: () => _loadLocations(refresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _loadLocations(refresh: true),
              child: _locations.isEmpty && !_isLoading
                  ? const Center(child: Text('No locations found'))
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !_isLoading &&
                            _currentPage < _totalPages) {
                          _loadMoreLocations();
                          return true;
                        }
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: _locations.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _locations.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final location = _locations[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              title: Text(location.name),
                              subtitle: Text(
                                  'Area: ${location.area} - Region: ${location.region.name}'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LocationDetailScreen(
                                      locationId: location.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
    );
  }
}