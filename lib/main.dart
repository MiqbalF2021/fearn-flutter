import 'package:flutter/material.dart';
import 'package:lokasi_app/screens/login_screen.dart';
import 'package:lokasi_app/screens/location_list_screen.dart';
import 'package:lokasi_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the auth service
  final authService = AuthService();
  await authService.init();
  
  // Check if user is already logged in
  final isLoggedIn = await authService.isLoggedIn();
  
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lokasi App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const LocationListScreen() : const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
