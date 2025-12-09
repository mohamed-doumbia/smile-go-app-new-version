import 'package:flutter/material.dart';

class AppColors {
  // Codes couleurs extraits de tes images
  static const Color primaryDark = Color(0xFF1B4F5C); // Le Vert Foncé du fond
  static const Color primaryYellow = Color(0xFFFFD600); // Le Jaune Smilgo
  static const Color white = Colors.white;
  static const Color greyInput = Color(0xFFF5F5F5); // Pour les champs de texte
  static const Color textDark = Color(0xFF1D1D1D);
  static const Color primaryGreen = Color(0XFFF5F5F5);
}

// Styles de texte prédéfinis pour aller vite
class AppTextStyles {
  static const TextStyle title = TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white
  );
  static const TextStyle label = TextStyle(
      fontSize: 14, color: AppColors.primaryDark
  );


}