import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../providers/booking_provider.dart';
import 'hotel_results_screen.dart'; // Écran de destination après la recherche

class HotelSearchScreen extends StatefulWidget {
  const HotelSearchScreen({super.key});

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  // Contrôleurs pour les champs
  final TextEditingController destinationController = TextEditingController(text: "Dakar, Senegal");
  final TextEditingController checkInDateController = TextEditingController(text: "Mer. 19 nov.");
  final TextEditingController checkOutDateController = TextEditingController(text: "Jeu. 20 nov.");
  final TextEditingController roomsGuestsController = TextEditingController(text: "1 Adulte");

  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

  final List<String> countries = [
    "Abidjan, Côte d'Ivoire",
    "Paris, France",
    "New York, États-Unis",
    "Dakar, Senegal",
  ];

  @override
  Widget build(BuildContext context) {
    final booking = Provider.of<BookingProvider>(context);

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

          // 2. CONTENU
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3. CARTE DESTINATION (Non-éditable, ouvre un modal de sélection)
                  _buildInputCard(
                    label: "Destination",
                    controller: destinationController,
                    onTap: () => _showCountryPicker(destinationController),
                    isEditable: false,
                  ),
                  const SizedBox(height: 20),

                  // 4. CARTE ENREGISTREMENT/DÉPART
                  _buildDatesCard(booking),
                  const SizedBox(height: 20),

                  // 5. CARTE CHAMBRE/ADULTE (Éditable, le texte se vide au clic)
                  _buildInputCard(
                    label: "Chambre 1",
                    controller: roomsGuestsController,
                    isEditable: true,
                  ),
                  const SizedBox(height: 30),

                  // 6. BOUTON AJOUTER UN VOL (simulé)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, color: AppColors.primaryYellow),
                      label: const Text("Ajouter un vol", style: TextStyle(color: AppColors.primaryYellow)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryYellow, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 7. BOUTONS CONFIRMER ET ANNULER
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryYellow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      onPressed: booking.isLoading ? null : () {
                        // Afficher le modal de chargement (Ecran 3)
                        _showLoadingModal(context, booking);
                      },
                      child: const Text("Confirmer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
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

  // --- WIDGET D'ENTRÉE GÉNÉRIQUE POUR L'HÔTEL (Gère Éditable et Non-éditable) ---
  Widget _buildInputCard({
    required String label,
    required TextEditingController controller,
    VoidCallback? onTap,
    bool isEditable = false,
  }) {

    // Si le champ n'est pas éditable (Destination, Dates)
    if (!isEditable) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity, // Toute la largeur
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(controller.text, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      );
    }

    // Si le champ est éditable (Chambre 1)
    return Container(
      width: double.infinity, // Toute la largeur
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            onTap: () {
              // Logique pour vider le texte au premier clic
              if (controller.text == "1 Adulte") {
                controller.clear();
              }
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Card spécifique pour les Dates (Enregistrement -> Départ)
  Widget _buildDatesCard(BookingProvider booking) {
    return Container(
      width: double.infinity, // Toute la largeur
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // ENREGISTREMENT (Arrivée)
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(checkInDateController),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Enregistrement", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(checkInDateController.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),

          // Flèche de séparation
          const Icon(Icons.arrow_forward, color: Colors.grey),

          // DÉPART
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(checkOutDateController),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Départ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(checkOutDateController.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIQUE MODAL DE CHARGEMENT (Screen 3) ---
  void _showLoadingModal(BuildContext context, BookingProvider booking) {
    booking.searchHotels(destinationController.text, checkInDateController.text);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Consumer<BookingProvider>(
          builder: (context, booking, child) {
            if (!booking.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
                // REDIRECTION vers Hotel Results Screen
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HotelResultsScreen()));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recherche terminée ! ')),
                );
              });
            }

            // CONTENU DU MODAL (Ecran 3 - Jaune)
            return AlertDialog(
              backgroundColor: AppColors.primaryYellow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: 200,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primaryDark),
                    const SizedBox(height: 20),
                    const Text(
                      "Nous recherchons pour vous\nles meilleurs hôtels",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${destinationController.text}\n${checkInDateController.text} au ${checkOutDateController.text}\n${roomsGuestsController.text}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.primaryDark, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- FONCTIONS UTILITAIRES (Réutilisées de FlightSearchScreen) ---

  // Afficher la liste des pays (réutilisée pour Destination)
  void _showCountryPicker(TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sélectionnez une destination", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.location_on, color: AppColors.primaryYellow),
                      title: Text(countries[index]),
                      onTap: () {
                        setState(() {
                          controller.text = countries[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Sélectionner une date (réutilisée)
  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryYellow,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        controller.text = DateFormat('EEE. d MMM', 'fr').format(picked);
      });
    }
  }
}