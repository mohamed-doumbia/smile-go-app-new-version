import 'package:flutter/material.dart';
// Note : Pas besoin de BottomBar ici car elle est gérée par le Dashboard,
// mais si tu veux l'afficher indépendamment, tu peux l'ajouter.

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Le contenu change, mais le Header reste (via Dashboard)
        // Si tu l'appelles depuis le Dashboard, le header est déjà là-haut.
        // Si cet écran est autonome, commenter la ligne suivante :
        // const CustomHeader(),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text("Historique", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // ITEM 1 : Vol Passé
              _buildHistoryItem(
                  "Vol Aller-Simple",
                  "Abidjan -> Paris",
                  "22 Avr. 2024",
                  "Succès",
                  Colors.green
              ),

              // ITEM 2 : Hôtel
              _buildHistoryItem(
                  "Réservation Hôtel",
                  "Hôtel Ivoire - 2 Nuits",
                  "10 Mars 2024",
                  "Terminé",
                  Colors.grey
              ),

              // ITEM 3 : Vol Annulé
              _buildHistoryItem(
                  "Vol Aller-Retour",
                  "Abidjan -> Dakar",
                  "01 Fév. 2024",
                  "Annulé",
                  Colors.red
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String subtitle, String date, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Gris clair
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 5),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}