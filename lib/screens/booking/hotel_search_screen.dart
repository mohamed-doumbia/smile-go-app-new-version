import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';

// Importez les providers nécessaires (nous utiliserons BookingProvider pour simuler la recherche)
import '../../providers/booking_provider.dart';
import 'hotel_results_screen.dart';
// Importez l'écran de destination (à définir après la recherche)
// import 'hotel_results_screen.dart';

class HotelSearchScreen extends StatefulWidget {
  const HotelSearchScreen({super.key});

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  // Contrôleurs pour les champs (basés sur Screen 2)
  final TextEditingController destinationController = TextEditingController(text: "Dakar, Senegal");
  final TextEditingController checkInDateController = TextEditingController(text: "Mer. 19 nov.");
  final TextEditingController checkOutDateController = TextEditingController(text: "Jeu. 20 nov.");
  final TextEditingController roomsGuestsController = TextEditingController(text: "1 Adulte");

  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

  final List<String> countries = [
    "Abidjan, Côte d'Ivoire",
    "Paris, France",
    "New York, États-Unis",
    "Dakar, Senegal", // Ajouté pour le test
  ];

  @override
  Widget build(BuildContext context) {
    // Note: Utilisation du BookingProvider pour gérer l'état de chargement
    final booking = Provider.of<BookingProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. HEADER
          const CustomHeader(),

          // 2. CONTENU
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Hotels", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),

                  // 3. CARTE DESTINATION
                  _buildHotelInputCard(
                    label: "Destination",
                    valueController: destinationController,
                    onTap: () => _showCountryPicker(destinationController),
                  ),
                  const SizedBox(height: 20),

                  // 4. CARTE ENREGISTREMENT/DÉPART
                  _buildDatesCard(booking),
                  const SizedBox(height: 20),

                  // 5. CARTE CHAMBRE/ADULTE
                  _buildHotelInputCard(
                    label: "Chambre 1",
                    valueController: roomsGuestsController,
                    onTap: () {
                      // Logique pour sélectionner les chambres/adultes (ici on simule)
                      print("Ouvrir sélecteur chambre/adulte");
                    },
                  ),
                  const SizedBox(height: 30),

                  // 6. BOUTON AJOUTER UN VOL (simulé)
                  // Bien que l'image montre "Ajouter un vol", cela semble être une erreur visuelle ou une fonctionnalité avancée du même template
                  // Je l'implémente comme un bouton standard pour respecter le design.
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

  // --- WIDGETS SPÉCIFIQUES ---

  // Card générale pour Destination / Chambre
  Widget _buildHotelInputCard({required String label, required TextEditingController valueController, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Text(valueController.text, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // Card spécifique pour les Dates (Enregistrement -> Départ)
  Widget _buildDatesCard(BookingProvider booking) {
    return Container(
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
    // On lance la recherche (simulée ou réelle)
    booking.searchHotels(destinationController.text, checkInDateController.text);

    // Affichage du modal
    showDialog(
      context: context,
      barrierDismissible: false, // Empêche de fermer en cliquant à l'extérieur
      builder: (context) {
        return Consumer<BookingProvider>(
          builder: (context, booking, child) {
            // Si le chargement est terminé, fermer le modal
            if (!booking.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop(); // Ferme le modal
                // REDIRECTION après la recherche (vers les résultats d'hôtels, à définir)
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
                    // Spinner de chargement (visible sur l'image)
                    const CircularProgressIndicator(color: AppColors.primaryDark),
                    const SizedBox(height: 20),
                    const Text(
                      "Nous recherchons pour vous\nles meilleurs hôtels",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Détails de la recherche
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
        // Utilisation de DateFormat si vous avez importé intl
        controller.text = DateFormat('EEE. d MMM', 'fr').format(picked);
      });
    }
  }
}