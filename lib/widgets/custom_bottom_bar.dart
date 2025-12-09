import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nav_provider.dart';
import '../config/theme.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavProvider>(context);

    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Les labels en bas
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("Home", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                Text("Historique", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                Text("Paramètres", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
              ],
            ),
          ),

          // Les icônes en haut (débordent au-dessus)
          Positioned(
            top: -30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => nav.setIndex(0),
                  child: Image.asset('assets/icons/bouton_HOME_screen_6-removebg-preview.png', height: 60),
                ),
                GestureDetector(
                  onTap: () => nav.setIndex(1),
                  child: Image.asset('assets/icons/bouton HISTORIQUE screen 6.png', height: 60),
                ),
                GestureDetector(
                  onTap: () => nav.setIndex(2),
                  child: Image.asset('assets/icons/bouton Parame╠Çtre screen 6.png', height: 60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}