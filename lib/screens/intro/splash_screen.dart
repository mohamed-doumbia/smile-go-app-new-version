import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'landing_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark, // Fond Vert Foncé
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // 1. TEXTE BIENVENUE
            const Text(
              "Bienvenue",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w300,
              ),
            ),

            const SizedBox(height: 40),

            // 2. LOGO CENTRAL
            Center(
              child: Image.asset(
                'assets/icons/logo-face-removebg-preview.png', // Ton image
                height: 150, // Ajuste la taille selon ton besoin
                width: 150,

              ),
            ),



            Center(
              child:Image.asset(
                'assets/icons/logo-smilgo-removebg-preview.png', // Ton image
                height: 100, // Ajuste la taille selon ton besoin
                width: 150,
              ),
            ),

            // Sous-titre du logo (s'il n'est pas dans l'image)
            const Text(
              "simplifiez vos voyages",
              style: TextStyle(color: AppColors.primaryYellow, fontSize: 16),
            ),

            const Spacer(),

            // 3. BOUTON "GO" (Rond et Jaune)
            GestureDetector(
              onTap: () {
                // Navigation vers Ecran 2
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LandingScreen())
                );
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: AppColors.primaryYellow,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "GO",
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50), // Marge du bas
          ],
        ),
      ),
    );
  }
}