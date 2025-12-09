
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smile_go/screens/payment/success_screen.dart';
import '../../config/theme.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';


class PaymentScreen extends StatefulWidget {
  final String paymentType; // "Mobile money", "Micro finance", "Banque"

  const PaymentScreen({
    super.key,
    required this.paymentType,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _destinataireController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER avec titre dynamique
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
                      "Payer par ${widget.paymentType.toLowerCase()}",
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

          // CONTENU
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Icône contact UNIQUEMENT pour Mobile money
                  if (widget.paymentType == "Mobile money")
                    GestureDetector(
                      onTap: _pickContact,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.contacts, color: Colors.grey),
                            SizedBox(width: 15),
                            Text(
                              "Recherche un contact",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (widget.paymentType == "Mobile money") const SizedBox(height: 15),

                  // Champ destinataire (N° tel ou IBAN)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _destinataireController,
                      keyboardType: widget.paymentType == "Banque"
                          ? TextInputType.text
                          : TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.paymentType == "Banque"
                            ? "IBAN du destinataire"
                            : "N° de tel. du destinataire",
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Champ montant
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

                  // Bouton Confirmer
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
                        if (_destinataireController.text.isNotEmpty &&
                            _amountController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SuccessScreen(amount: _amountController.text,)),
                          );
                        }
                      },
                      child: const Text(
                        "Confirmer",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
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

  // Fonction pour ouvrir les contacts du téléphone
  Future<void> _pickContact() async {
    if (await Permission.contacts.request().isGranted) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        final fullContact = await FlutterContacts.getContact(contact.id);
        if (fullContact != null && fullContact.phones.isNotEmpty) {
          setState(() {
            _destinataireController.text = fullContact.phones.first.number;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _destinataireController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}