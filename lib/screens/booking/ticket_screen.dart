import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text("Mon Billet", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // CARTE DU BILLET
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))
                      ],
                      border: Border.all(color: AppColors.primaryYellow, width: 1), // Bordure jaune subtile
                    ),
                    child: Column(
                      children: [
                        // Partie Haute (Infos Vol)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryDark, // Tête verte
                            borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Abidjan (ABJ)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Icon(Icons.flight_takeoff, color: AppColors.primaryYellow),
                              Text("Paris (ORY)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),

                        // Partie Centrale (Détails)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              _buildTicketRow("Passager", "Kouassi Jean"),
                              const Divider(),
                              _buildTicketRow("Date", "22 Avr. 2024"),
                              const Divider(),
                              _buildTicketRow("Heure", "22:30"),
                              const Divider(),
                              _buildTicketRow("Siège", "12A (Fenêtre)"),
                              const Divider(),
                              _buildTicketRow("Classe", "Economique"),
                            ],
                          ),
                        ),

                        // Ligne pointillée (Simulation visuelle)
                        Row(
                          children: List.generate(30, (index) => Expanded(
                              child: Container(height: 1, color: index % 2 == 0 ? Colors.grey : Colors.white)
                          )),
                        ),

                        // Partie Basse (Code Barres)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              // Image du Code Barres (Asset)
                              Image.asset(
                                'assets/icons/Barcode.png', // Assure-toi d'avoir renommé ton image ainsi
                                height: 60,
                                width: 200,
                                fit: BoxFit.fill,
                                errorBuilder: (c,e,s) => Container(height: 50, width: 200, color: Colors.black), // Placeholder noir
                              ),
                              const SizedBox(height: 5),
                              const Text("1234 5678 9012", style: TextStyle(letterSpacing: 3, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Bouton Retour ou Télécharger
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Retour
                    },
                    icon: const Icon(Icons.download, color: AppColors.primaryDark),
                    label: const Text("Télécharger le PDF", style: TextStyle(color: AppColors.primaryDark)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryYellow,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  Widget _buildTicketRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}