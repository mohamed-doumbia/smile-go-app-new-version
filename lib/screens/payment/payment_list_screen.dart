import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smile_go/screens/payment/payment_contact.dart';
import '../../config/theme.dart';
import '../../providers/payment_provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'success_screen.dart';

class PaymentListScreen extends StatelessWidget {
  final String title;
  final List<String> items;
  final String bottomImage;

  const PaymentListScreen({
    super.key,
    required this.title,
    required this.items,
    required this.bottomImage,
  });

  // Couleurs pour chaque card
  final List<Color> _colors = const [
    Color(0xFFFF6B00), // Orange pour ORANGE money
    Color(0xFF00BCD4), // Cyan pour WAVE
    Color(0xFFFFEB3B), // Jaune pour MTN Mobile
    Color(0xFF1976D2), // Bleu pour MOOV money
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER avec titre
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
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LISTE DYNAMIQUE DES OPERATEURS avec rectangles colorés
                  ...items.asMap().entries.map((entry) {
                    int index = entry.key;
                    String name = entry.value;
                    return _buildOperatorItem(context, name, _colors[index % _colors.length]);
                  }),

                  const SizedBox(height: 20),

                  // BOUTON AJOUTER
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_circle_outline, color: Colors.grey, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Ajouter un compte $title ici",
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // IMAGE PUB SPÉCIFIQUE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      bottomImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  Widget _buildOperatorItem(BuildContext context, String name, Color borderColor) {
    return GestureDetector(
      onTap: () {
        // Passe le title (Mobile money, Micro finance, Banque)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentScreen(paymentType: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 30,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}