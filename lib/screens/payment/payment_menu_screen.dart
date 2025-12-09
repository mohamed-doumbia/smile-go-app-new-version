import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'payment_list_screen.dart';
import 'alias_payment_screen.dart';

class PaymentMenuScreen extends StatelessWidget {
  const PaymentMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. HEADER avec "Paiement"
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
                      "Paiement",
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

          // 2. CONTENU
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LISTE DES MÉTHODES
                  _buildMethodItem(
                      context,
                      "Mobile money",
                      'assets/icons/Picto mobile money.png',
                          () => _goTo(context, PaymentListScreen(
                        title: "Mobile money",
                        items: const ["ORANGE money", "WAVE", "MTN Mobile", "MOOV money"],
                        bottomImage: "assets/images/Pub slide-Ecran 12.png",

                      ))
                  ),
                  _buildMethodItem(
                      context,
                      "Micro-finance",
                      'assets/icons/Picto Microfinance.png',
                          () => _goTo(context, PaymentListScreen(
                        title: "Micro finance",
                        items: const ["Baobab", "Atlantique Micro.", "Advans CI"],
                        bottomImage: "assets/images/Pub slide-Ecran 13.png",

                      ))
                  ),
                  _buildMethodItem(
                      context,
                      "Banque",
                      'assets/icons/Picto Banque.png',
                          () => _goTo(context, PaymentListScreen(
                        title: "Banque",
                        items: const ["SARA Banque", "Ecobank", "SIB", "SGBCI"],
                        bottomImage: "assets/images/pub-screen14.png",

                      ))
                  ),
                  _buildMethodItem(
                      context,
                      "Alias",
                      'assets/icons/Picto Alias.png',
                          () => _goTo(context, const AliasPaymentScreen())
                  ),

                  const SizedBox(height: 30),

                  // PUB DU BAS
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Container(height: 150, width: double.infinity, color: Colors.grey[300]),
                        Image.asset("assets/images/pub-ecran 11.png", fit: BoxFit.cover, height: 150, width: double.infinity),
                      ],
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

  void _goTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildMethodItem(BuildContext context, String title, String iconAsset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.asset(iconAsset, height: 30, width: 30),
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}