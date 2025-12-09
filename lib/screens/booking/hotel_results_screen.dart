import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';

class HotelResultsScreen extends StatelessWidget {
  const HotelResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. HEADER avec "Hotels"
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            child: Column(
              children: [
                const CustomHeader(),
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hotels",
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

          // 2. CORPS DE L'ÉCRAN (Zone Blanche, Contient les Résultats)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // NAVIGATION SPÉCIFIQUE DES RÉSULTATS (Flèche, Date, Crayon)
                  Row(
                    children: [
                      // Flèche Retour (Image/Asset)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/icons/picto_fleche_retour.png',
                          height: 24,
                          width: 24,
                          errorBuilder: (c, e, s) => const Icon(Icons.arrow_back, color: AppColors.primaryDark),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // TEXTE DATE ET RÉSULTATS
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sénégal, 19 nov. au 20 nov.",
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                            ),
                            Text(
                              "6 Résultat(s)",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      // ICONE CRAYON (Image/Asset pour Modifier la recherche)
                      GestureDetector(
                        onTap: () { /* Logique pour éditer la recherche */ },
                        child: Image.asset(
                          'assets/icons/pencil.png',
                          height: 20,
                          width: 20,
                          errorBuilder: (c, e, s) => const Icon(Icons.edit, color: AppColors.primaryDark),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // --- LISTE DES RÉSULTATS (Les cartes d'hôtels) ---

                  _buildHotelCard(
                    context,
                    hotelName: "Hôtel AZALAY Dakar, Sénégal",
                    location: "Rue Pz 75 Mermoz",
                    price: "XOF24, 514",
                    rating: 3.0,
                    imagePath: 'assets/images/Img illustr 1.png',
                  ),
                  const SizedBox(height: 15),

                  _buildHotelCard(
                    context,
                    hotelName: "Hôtel TERANGA",
                    location: "Avenue Lamine Guèye",
                    price: "XOF35, 900",
                    rating: 4.5,
                    imagePath: 'assets/images/Img illustr 2.png',
                  ),
                  const SizedBox(height: 15),
                  // ... autres cartes
                ],
              ),
            ),
          ),
        ],
      ),
      // 3. BOTTOM BAR
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  // --- WIDGET CARTE RÉSULTAT HÔTEL ---

  Widget _buildHotelCard(BuildContext context, {
    required String hotelName,
    required String location,
    required String price,
    required double rating,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. IMAGE PRINCIPALE
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(height: 180, width: double.infinity, color: AppColors.greyInput, child: const Center(child: Text("HÔTEL IMAGE PLACEHOLDER", style: TextStyle(color: Colors.grey)))),
                ),
              ),
              // Icône "de photos"
              // Positioned(
              //   top: 10, right: 10,
              //   child: Image.asset('assets/icons/picto_photos.png', height: 30, errorBuilder: (c,e,s) => const Icon(Icons.camera_alt, color: Colors.white)),
              // ),
            ],
          ),

          const SizedBox(height: 10),

          // 2. NOM ET LOCALISATION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hotelName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text(location, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 3. RATING ET PRIX
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Rating (3.0/5 Excellent)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${rating.toStringAsFixed(1)}/5', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                      const SizedBox(width: 5),
                      const Text("Excellent", style: TextStyle(color: AppColors.primaryDark, fontSize: 13)),
                    ],
                  ),
                  _buildStarRating(rating),
                ],
              ),

              // Bouton Réserver
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.primaryDark)),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () { /* Naviguer vers les détails de l'hôtel */ },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Réserver maintenant", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: AppColors.primaryYellow, size: 16);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: AppColors.primaryYellow, size: 16);
        } else {
          return const Icon(Icons.star_border, color: AppColors.primaryYellow, size: 16);
        }
      }),
    );
  }
}