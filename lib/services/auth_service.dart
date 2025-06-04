import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lokasi_app/models/user.dart';
import 'package:lokasi_app/services/api_service.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  // Key for storing the access token
  static const String _tokenKey = 'access_token';

  // Get the ApiService instance
  ApiService getApiService() {
    return _apiService;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  // Login user and store token
  Future<User> login(String username, String password) async {
    final user = await _apiService.login(username, password);
    await _storage.write(key: _tokenKey, value: user.accessToken);
    _apiService.setToken(user.accessToken);
    return user;
  }

  // Logout user
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  // Initialize API service with stored token
  Future<void> init() async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null) {
      _apiService.setToken(token);
    }
  }

  // Singleton instance
  static final AuthService _instance = AuthService._internal();

  // Factory constructor to return the singleton instance
  factory AuthService() {
    return _instance;
  }

  // Private constructor
  AuthService._internal();
}