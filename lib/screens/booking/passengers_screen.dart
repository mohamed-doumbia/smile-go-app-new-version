import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../payment/payment_menu_screen.dart';

class PassengersScreen extends StatefulWidget {
  const PassengersScreen({super.key});

  @override
  State<PassengersScreen> createState() => _PassengersScreenState();
}

class _PassengersScreenState extends State<PassengersScreen> {
  int _selectedClassIndex = 0;

  int _adults = 2;
  int _children = 0;
  int _babies = 1;

  final List<String> _classes = ["Economique", "Premium économique", "Affaire", "Première classe"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. HEADER avec "Passagers & classe"
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryDark, // Fond Vert du header
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
                      "Passagers & classe",
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SÉLECTIONNEZ CABINE
                  const Text(
                    "SÉLECTIONNEZ CABINE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Liste verticale des classes
                  GestureDetector(
                    onTap: () => setState(() => _selectedClassIndex = 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _selectedClassIndex == 0 ? AppColors.primaryYellow : const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        "Economique",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _selectedClassIndex == 0 ? FontWeight.w600 : FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => setState(() => _selectedClassIndex = 1),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _selectedClassIndex == 1 ? AppColors.primaryYellow : const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        "Premium économique",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _selectedClassIndex == 1 ? FontWeight.w600 : FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => setState(() => _selectedClassIndex = 2),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _selectedClassIndex == 2 ? AppColors.primaryYellow : const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        "Affaire",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _selectedClassIndex == 2 ? FontWeight.w600 : FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => setState(() => _selectedClassIndex = 3),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _selectedClassIndex == 3 ? AppColors.primaryYellow : const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        "Première classe",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _selectedClassIndex == 3 ? FontWeight.w600 : FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // RENSEIGNEMENTS SUR PASSAGERS
                  const Text(
                    "RENSEIGNEMENTS SUR PASSAGERS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Adultes
                  _buildPassengerRow("Adultes", "+12 ans", _adults, (val) => setState(() => _adults = val)),
                  const Divider(),

                  // Enfants
                  _buildPassengerRow("Enfants", "2 - 11 ans", _children, (val) => setState(() => _children = val)),
                  const Divider(),

                  // Bébés
                  _buildPassengerRow("Bébés", "- de 2 ans", _babies, (val) => setState(() => _babies = val)),

                  const SizedBox(height: 40),

                  // BOUTON PAYER
                  // Remplace le bouton PAYER par :

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Consumer<BookingProvider>(
                      builder: (context, booking, _) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryYellow,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            elevation: 0,
                          ),
                          onPressed: booking.isLoading
                              ? null
                              : () async {
                            // ⚠️ Utiliser l'offerId fictif temporaire
                            // TODO: Remplacer par l'offerId réel du backend
                            final offerId = booking.temporaryOfferId ?? "1";

                            // Appeler l'API de vérification du prix
                            final success = await booking.checkPricing(offerId);

                            if (success) {
                              // Afficher un message de succès
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Prix vérifié avec succès')),
                              );

                              // Naviguer vers l'écran de paiement
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PaymentMenuScreen()),
                              );
                            } else {
                              // Afficher l'erreur
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(booking.errorMessage ?? 'Erreur lors de la vérification du prix')),
                              );
                            }
                          },
                          child: booking.isLoading
                              ? const CircularProgressIndicator(color: AppColors.primaryDark)
                              : const Text("Payer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                        );
                      },
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

  Widget _buildPassengerRow(String title, String subtitle, int count, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text("$count", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (count > 0) onChanged(count - 1);
                  },
                  child: const Icon(Icons.remove_circle, size: 24, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}