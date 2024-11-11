import 'package:flutter/material.dart';

import 'routes.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark, // Dark theme to resemble Netflix
      ),
      initialRoute: '/',
      routes: AppRoutes.getRoutes(), // Using a separate routes file
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}
