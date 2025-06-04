import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lokasi_app/models/user.dart';
import 'package:lokasi_app/models/location.dart';

class ApiService {
  final String baseUrl = 'https://api-vatsubsoil-dev.ggfsystem.com';
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getLocations({int page = 1}) async {
    if (_token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/locations?page=$page'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final data = jsonData['data'];
      final locations = (data['locations'] as List)
          .map((location) => Location.fromJson(location))
          .toList();

      return {
        'locations': locations,
        'total': data['total'],
        'totalPages': data['totalPages'],
        'currentPage': data['currentPage'],
      };
    } else {
      throw Exception('Failed to load locations: ${response.body}');
    }
  }

  Future<Location> getLocationById(String id) async {
    if (_token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/locations/$id'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Location.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load location: ${response.body}');
    }
  }
}