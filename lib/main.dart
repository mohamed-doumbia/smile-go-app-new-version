import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';

// 1. IMPORTATION DE TOUS LES PROVIDERS (La Logique du Backend)
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/nav_provider.dart'; // Pour la Bottom Navigation Bar

// 2. IMPORTATION DU PREMIER ÉCRAN
import 'screens/intro/splash_screen.dart';

void main() {
  runApp(
    // 3. MULTIPROVIDER : On branche toutes les logiques ici
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => NavProvider()), // Indispensable pour l'Ecran 6
      ],
      child: const SmilgoApp(),
    ),
  );
}

class SmilgoApp extends StatelessWidget {
  const SmilgoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smilgo',
      theme: ThemeData(
        // Utilisation de ta couleur principale
        primaryColor: AppColors.primaryDark,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      // On démarre sur l'Ecran 1
      home: const SplashScreen(),
    );
  }
}