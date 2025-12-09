import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'success_screen.dart';

class AliasPaymentScreen extends StatefulWidget {
  const AliasPaymentScreen({super.key});

  @override
  State<AliasPaymentScreen> createState() => _AliasPaymentScreenState();
}

class _AliasPaymentScreenState extends State<AliasPaymentScreen> {
  final TextEditingController _aliasController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
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
                      "Alias",
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

          // CONTENU
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // CHAMP ALIAS
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _aliasController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Coller ou saisir l'Alias",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/icons/file_16866408.png',
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // CHAMP MONTANT
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Saisir le montant",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // BOUTON VALIDER
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryYellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_amountController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SuccessScreen(
                                amount: _amountController.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Valider",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // CRÉER UN ALIAS
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigation vers création d'alias
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add_circle_outline, color: Colors.grey, size: 18),
                        SizedBox(width: 5),
                        Text(
                          "Créer un Alias",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
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

  @override
  void dispose() {
    _aliasController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}