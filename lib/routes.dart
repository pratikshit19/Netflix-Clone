import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/details_screen.dart';
import 'screens/splash_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => SplashScreen(),
      '/home': (context) => HomeScreen(),
      '/search': (context) => SearchScreen(),
      '/details': (context) => DetailsScreen(),
    };
  }
}
