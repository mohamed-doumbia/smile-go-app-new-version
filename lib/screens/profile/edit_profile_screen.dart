import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Mon profil", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      // Petit Crayon (Edit Icon)
                      Image.asset('assets/icons/Edit_icon.png', height: 24, errorBuilder: (c,e,s) => const Icon(Icons.edit, color: AppColors.primaryYellow)),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Photo de profil (Placeholder)
                  Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primaryDark,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(color: AppColors.primaryYellow, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildInput("Nom", "Kouassi"),
                  _buildInput("Prénom", "Jean"),
                  _buildInput("E-mail", "jean.kouassi@email.com"),
                  _buildInput("Téléphone", "+225 07 07 07 07 07"),

                  const SizedBox(height: 40),

                  // BOUTON SAUVEGARDER
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryYellow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Retour aux paramètres
                      },
                      child: const Text("Sauvegarder", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
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

  Widget _buildInput(String label, String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.greyInput,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}