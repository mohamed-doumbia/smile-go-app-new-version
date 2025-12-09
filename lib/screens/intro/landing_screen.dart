import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../auth/login.dart';
import '../auth/register_screen.dart'; // Vers Ecran 3
// import '../auth/login_screen.dart'; // Vers Login (si tu en as un séparé)

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. IMAGE DE FOND
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg-screen2.png',
              fit: BoxFit.cover, // Prend tout l'écran
            ),
          ),

          // 2. FILTRE VERT (Optionnel, si l'image est trop claire)
          Positioned.fill(
            child: Container(
              color: AppColors.primaryDark.withOpacity(0.4),
            ),
          ),

          // 3. CONTENU
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Texte d'accroche
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 40, height: 1.2, color: Colors.white),
                    children: [
                      TextSpan(text: "Avec "),
                      WidgetSpan(
                        child: Image.asset(
                          'assets/icons/logo-smilgo-removebg-preview.png',
                          height: 40,
                        ),
                      ),
                      TextSpan(text: ",\nréservez &\nvoyagez\nsans prise\nde tête"),
                    ],
                  ),
                ),

                const Spacer(),

                // BOUTON 1 : S'INSCRIRE
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()) // Vers Ecran 3
                      );
                    },
                    child: const Text(
                      "S'inscrire",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                const Center(child: Text("ou", style: TextStyle(color: Colors.white))),
                const SizedBox(height: 15),

                // BOUTON 2 : SE CONNECTER
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryYellow, // Même couleur selon image
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Logique de connexion ici
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()) // Vers Ecran 3
                      );
                    },
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}