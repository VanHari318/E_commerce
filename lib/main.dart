// main.dart
// TH4 - Nhóm 11: Mini E-Commerce App
// Entry point — sets up MultiProvider with CartProvider and HomeProvider,
// applies Shopee-inspired orange/red theme, and boots to HomeScreen.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/home_provider.dart';
import 'providers/order_provider.dart';
import 'screens/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Cart state — available app-wide (Screen 1, 2, 3, 4)
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // Home screen data (products, categories, pagination)
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        // Order history management
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(

        title: 'TH4 - Nhóm 11',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _buildTheme() {
    const primaryOrange = Color(0xFFEE4D2D); // Shopee red-orange

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryOrange,
        primary: primaryOrange,
        secondary: const Color(0xFFFF6633),
        surface: Colors.white,
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        surfaceTintColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      scaffoldBackgroundColor: Colors.grey.shade50,
      fontFamily: 'Roboto',
    );
  }
}
