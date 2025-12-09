import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/nav_provider.dart';
import '../../widgets/custom_bottom_bar.dart';

// Import des écrans pour la navigation du bas
import '../../widgets/custom_header.dart';
import '../booking/flight_search_screen.dart'; // Pour aller vers Ecran 7
import '../booking/hotel_search_screen.dart';
import '../profile/history_screen.dart';       // Ecran 17
import '../profile/settings_screen.dart';      // Ecran 18

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // On écoute le NavProvider pour savoir quel écran afficher au centre
    final navIndex = Provider.of<NavProvider>(context).currentIndex;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,  // Même couleur que CustomHeader
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            child: Column(
              children: [
                const CustomHeader(),
                // Réservation collé en dessous
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Réservation",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. LE CONTENU (Change selon le clic en bas)
          Expanded(
            child: _getBody(navIndex, context),
          ),
        ],
      ),
      // 3. LA BARRE DU BAS
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  // Fonction qui choisit le contenu à afficher
  Widget _getBody(int index, BuildContext context) {
    switch (index) {
      case 0:
        return _buildHomeContent(context);
      case 1:
        return const HistoryScreen();
      case 2:
        return const SettingsScreen();
      default:
        return _buildHomeContent(context);
    }
  }

  // --- CONTENU DE L'ECRAN 6 (HOME) ---
  Widget _buildHomeContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. LES 3 GROS BOUTONS (Vol, Hotels, Bons plans) avec fond gris clair
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBigButton(context, "Vol", 'assets/icons/vol.png', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FlightSearchScreen()));
                }),
                _buildBigButton(context, "Hôtels", 'assets/icons/hotels.png', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HotelSearchScreen()));
                }),
                _buildBigButton(context, "Bons plans", 'assets/icons/plan.png', () {}),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // 2. DESTINATIONS POPULAIRES
          const Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primaryYellow, size: 20),
              SizedBox(width: 5),
              Text(
                "Destinations populaires",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildDestinationItem("New York", "22 avr. - 30 avr.", "250 \$"),
          const SizedBox(height: 10),
          _buildDestinationItem("Tokyo", "5 mai - 12 mai", "320 \$"),

          const SizedBox(height: 25),

          // 3. NOS OFFRES SPÉCIALES avec flèches
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.star, color: AppColors.primaryYellow, size: 20),
                  SizedBox(width: 5),
                  Text(
                    "Nos offres spéciales",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              // Flèches de navigation
              // Row(
              //   children: [
                  // Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey),
                  // SizedBox(width: 8),
                  // Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                // ],
              // ),
            ],
          ),
          // const SizedBox(height: 12),

          // Carte Offre (Abidjan -> Paris)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryYellow, width: 2),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Tour Eiffel
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(

                    color: Colors.grey[300],
                    // TODO: Mettre image Paris ici
                    child: Image.asset('assets/icons/tourefel-removebg-preview.png', fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo compagnie aérienne en haut à droite
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Aller/retour",
                            style: TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                          // Logo compagnie
                          Image.asset(
                            'assets/icons/logo-b-removebg-preview.png',
                            height: 40,
                            width: 40,
                          ),
                        ],
                      ),
                      const Text(
                        "Abidjan → Paris",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Payez:",
                        style: TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                      const Text(
                        "300 100 FCFA",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Logo carte + Prix + Bouton
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo carte bancaire + Prix
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/logo-b2-removebg-preview.png',
                                  height: 40,
                                  width: 40,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "84028 FCFA",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Bouton Réservez
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                padding: const EdgeInsets.all(5.0),
                                minimumSize: Size.zero,
                              ),

                              onPressed: () {},
                              child: const Text(
                                "Réservez",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour les gros boutons gris carrés
  Widget _buildBigButton(BuildContext context, String label, String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(asset, height: 35),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour une ligne de destination - AVEC POINT NOIR GRAS
  Widget _buildDestinationItem(String city, String date, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ville et date avec point noir bien visible
          Flexible(
            child: Row(
              children: [
                Text(
                  city,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    "•",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Prix dans une card blanche séparée
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    );
  }
}