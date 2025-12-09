import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';

// Importez l'écran de destination (à créer : HotelPaymentScreen)
// import 'hotel_payment_screen.dart';

class HotelGuestFormScreen extends StatelessWidget {
  const HotelGuestFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. HEADER STANDARD (SANS PARAMÈTRE 'title')
          const CustomHeader(),

          // 2. CONTENU DU FORMULAIRE (Zone Blanche)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // TITRE "Hotels" PLACÉ MANUELLEMENT
                  const Text("Hotels", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // TITRE DE LA FORMULAIRE SPÉCIFIQUE
                  const Text(
                    "Suite classique x 1 chambre - invité: Adulte",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. LIGNE 1 : TITRE et SEXE (Champs en Colonnes)
                  Row(
                    children: [
                      Expanded(child: _buildDropDownField("Titre")),
                      const SizedBox(width: 15),
                      Expanded(child: _buildDropDownField("Sexe")),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // 4. CHAMPS EN PLEINE LARGEUR
                  _buildInputField("Nom de famille *"),
                  _buildInputField("Prénom *"),
                  _buildInputField("Deuxième Prénom"),
                  _buildInputField("Date de naissance*"),
                  const SizedBox(height: 15),

                  // 5. BLOC D'ALERTE JAUNE
                  _buildYellowAlertBox(context),
                  const SizedBox(height: 20),

                  // 6. CHAMPS ADRESSE ET CONTACT
                  _buildInputField("Courriel*"),
                  _buildInputField("Adresse*"),

                  // Champ Ville (Abidjan avec icône dropdown)
                  _buildDropDownField("Abidjan"),
                  const SizedBox(height: 15),

                  // 7. LIGNE 2 : CODE PAYS et TÉLÉPHONE
                  Row(
                    children: [
                      // Code Pays (avec flèche dropdown)
                      Expanded(
                        flex: 1,
                        child: _buildDropDownField("+225 (CI)"),
                      ),
                      const SizedBox(width: 15),
                      // Numéro de Téléphone
                      Expanded(
                        flex: 2,
                        child: _buildInputField("Téléphone*"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // 8. BOUTON SUIVANT
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryYellow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Naviguer vers l'écran de paiement
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => const HotelPaymentScreen()));
                        print("Naviguer vers l'écran de paiement hôtel.");
                      },
                      child: const Text("Suivant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      // 9. BOTTOM BAR
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  // --- WIDGETS UTILITAIRES ---

  // Champ d'entrée standard (Nom, Prénom, Email, etc.)
  Widget _buildInputField(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.greyInput, // Couleur grise du fond
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  // Champ avec icône de flèche (Titre, Sexe, Pays)
  Widget _buildDropDownField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.greyInput,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  // Bloc d'alerte jaune
  Widget _buildYellowAlertBox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryYellow,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.primaryDark), // Icône Ampoule
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "votre nom nous sera envoyé à l'adresse e-mail que vous avez fournie.",
              style: TextStyle(color: AppColors.primaryDark, fontSize: 13, fontWeight: FontWeight.w500),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}