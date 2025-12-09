import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: AppColors.primaryDark, // Fond Vert du header
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LOGO A GAUCHE
            Image.asset('assets/icons/logo-face-removebg-preview.png', height: 35),

            Image.asset('assets/icons/logo-smilgo-removebg-preview.png', height: 35),

            // ICONES METEO & ACTU A DROITE
            Row(
              children: [
                _buildHeaderIcon('assets/icons/picto meteo.png', "Météo"),
                const SizedBox(width: 15),
                _buildHeaderIcon('assets/icons/picto actu_jaune.png', "Actualités"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(String assetPath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(assetPath, height: 24),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        )
      ],
    );
  }
}