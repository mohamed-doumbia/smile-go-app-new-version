import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../core/dashboard_screen.dart'; // Vers Ecran 6 (Home)

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc selon image
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/icons/logo-face-removebg-preview.png', height: 35),
            const Spacer(),

            Image.asset('assets/icons/logo-smilgo-removebg-preview.png', height: 35)
          ],
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 1. TITRE
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Créez votre code\nde sécurité",
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 26,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Container(width: 200, height: 3, color: AppColors.primaryYellow),
              ],
            ),

            const SizedBox(height: 40),

            // 2. PREMIÈRE SÉRIE DE CASES (Création)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) => _buildCodeBox()),
            ),

            const SizedBox(height: 20),
            const Text(
              "Confirmez votre code de sécurité",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),

            // 3. DEUXIÈME SÉRIE DE CASES (Confirmation)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) => _buildCodeBox()),
            ),

            const SizedBox(height: 30),

            // 4. TOUCH ID
            Row(
              children: [
                Image.asset('assets/icons/fingerprint.png', height: 40),
                const SizedBox(width: 15),
                const Text(
                  "S'enregistrer avec\nla touche ID",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),

            const SizedBox(height: 50),

            // 5. BOUTON VALIDER
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () {
                  // Une fois le code créé, on va vers le Dashboard (Ecran 6)
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardScreen()),
                          (route) => false // On efface l'historique pour ne pas revenir à l'inscription
                  );
                },
                child: const Text(
                  "Valider",
                  style: TextStyle(color: AppColors.primaryDark, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour une case de code (Carré avec bordure noire arrondie)
  Widget _buildCodeBox() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          obscureText: true, // Cache le chiffre (point ou étoile)
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}