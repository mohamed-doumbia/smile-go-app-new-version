import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'passengers_screen.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  final TextEditingController departureController = TextEditingController(text: "Sélectionnez un départ");
  final TextEditingController arrivalController = TextEditingController(text: "Sélectionnez une destination");
  final TextEditingController departDateController = TextEditingController(text: "Mer. 12 nov");
  final TextEditingController returnDateController = TextEditingController(text: "Lun. 20 nov");
  final TextEditingController passengersController = TextEditingController(text: "Économique, 1 adulte");

  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

  // Liste des pays
  final List<String> countries = [
    "Abidjan, Côte d'Ivoire",
    "Paris, France",
    "New York, États-Unis",
    "Tokyo, Japon",
    "Londres, Royaume-Uni",
    "Dubai, Émirats arabes unis",
    "Dakar, Sénégal",
    "Lagos, Nigeria",
    "Accra, Ghana",
    "Casablanca, Maroc",
  ];

  @override
  Widget build(BuildContext context) {
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
                  const Text("Billet d'avion", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // 3. LES ONGLETS
                  Row(
                    children: [
                      Expanded(child: _buildTab(context, 0, "Aller simple", booking)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTab(context, 1, "Aller-retour", booking)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTab(context, 2, "Multi villes", booking)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 4. LE FORMULAIRE
                  if (booking.tripType == 2)
                    _buildMultiCityForm(context)
                  else
                    _buildStandardForm(context, booking),

                  const SizedBox(height: 30),

                  // 5. BOUTON RECHERCHER
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Consumer<BookingProvider>(
                      builder: (context, booking, _) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryYellow,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          onPressed: booking.isLoading
                              ? null // Désactive le bouton pendant le chargement
                              : () async {
                            // Validation : Vérifier que les champs sont remplis
                            if (departureController.text.isEmpty ||
                                departureController.text == "Sélectionnez un départ") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Veuillez sélectionner un départ')),
                              );
                              return;
                            }

                            if (arrivalController.text.isEmpty ||
                                arrivalController.text == "Sélectionnez une destination") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Veuillez sélectionner une destination')),
                              );
                              return;
                            }

                            if (departDateController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Veuillez sélectionner une date de départ')),
                              );
                              return;
                            }

                            // Extraire seulement le nom de la ville (avant la virgule)
                            String origin = departureController.text.split(',')[0].trim();
                            String destination = arrivalController.text.split(',')[0].trim();

                            // Convertir la date au format API (DD/MM/YYYY)
                            String departureDate = _convertDateToAPIFormat(departDateController.text);

                            // Appel de l'API de recherche
                            final success = await booking.searchFlights(
                              origin: origin,
                              destination: destination,
                              departureDate: departureDate,
                            );

                            // Si la recherche réussit
                            if (success) {
                              // Naviguer vers l'écran des passagers
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PassengersScreen()),
                              );
                            } else {
                              // Afficher le message d'erreur
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(booking.errorMessage ?? 'Erreur lors de la recherche')),
                              );
                            }
                          },
                          child: booking.isLoading
                              ? const CircularProgressIndicator(color: AppColors.primaryDark)
                              : const Text("Rechercher", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
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

  // --- TABS ---
  Widget _buildTab(BuildContext context, int index, String label, BookingProvider booking) {
    final isSelected = booking.tripType == index;
    return GestureDetector(
      onTap: () => booking.setTripType(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryYellow : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primaryYellow : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(15.0),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primaryDark : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  // Formulaire pour Aller Simple et Aller-Retour
  Widget _buildStandardForm(BuildContext context, BookingProvider booking) {
    return Column(
      children: [
        // Ligne DE / VERS avec bouton SWAP
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                _buildGreyInput("De", departureController, icon: Icons.flight_takeoff, onTap: () => _showCountryPicker(true)),
                const SizedBox(height: 10),
                _buildGreyInput("Vers", arrivalController, icon: Icons.flight_land, onTap: () => _showCountryPicker(false)),
              ],
            ),
            // Bouton SWAP au milieu
            Positioned(
              right: 20,
              child: GestureDetector(
                onTap: () {
                  final temp = departureController.text;
                  departureController.text = arrivalController.text;
                  arrivalController.text = temp;
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)]),
                  child: Image.asset(
                    'assets/icons/Picto_Aller_Retour-removebg-preview.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            )
          ],
        ),

        const SizedBox(height: 15),

        // Ligne DATES
        Row(
          children: [
            Expanded(child: _buildGreyInput("Départ", departDateController, icon: Icons.calendar_today, onTap: () => _selectDate(departDateController))),
            if (booking.tripType == 1) ...[
              const SizedBox(width: 10),
              Image.asset(
                'assets/icons/picto_fleche-removebg-preview.png',
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 10),
              Expanded(child: _buildGreyInput("Retour", returnDateController, icon: Icons.calendar_today, onTap: () => _selectDate(returnDateController))),
            ]
          ],
        ),

        const SizedBox(height: 15),
        _buildGreyInput("Passagers et classe", passengersController, icon: Icons.person, clearOnTap: true),
      ],
    );
  }

  // Formulaire pour Multi-villes
  Widget _buildMultiCityForm(BuildContext context) {
    return Column(
      children: [
        // Passagers - Card en haut
        _buildGreyInput("Passager", passengersController, clearOnTap: true),

        const SizedBox(height: 15),

        // VOYAGE 1
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // VOYAGE 1 avec dotted à côté
            Row(
              children: [
                const Text(
                  "VOYAGE 1",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DottedLine(
                    dashLength: 5,
                    dashGapLength: 5,
                    dashColor: Colors.grey[300]!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // De -> Vers
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("De", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      SizedBox(height: 4),
                      Text("ABJ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Image.asset(
                    'assets/icons/picto_fleche-removebg-preview.png',
                    height: 30,
                    width: 30,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Vers", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      SizedBox(height: 4),
                      Text("DKR", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Date et Classe
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Merc. 12 nov.", style: TextStyle(fontSize: 15)),
                  Text("Economique", style: TextStyle(fontSize: 15, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // VOYAGE 2
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // VOYAGE 2 avec dotted à côté
            Row(
              children: [
                const Text(
                  "VOYAGE 2",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DottedLine(
                    dashLength: 5,
                    dashGapLength: 5,
                    dashColor: Colors.grey[300]!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // De -> Vers
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("De", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      SizedBox(height: 4),
                      Text("ABJ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Image.asset(
                    'assets/icons/picto_fleche-removebg-preview.png',
                    height: 30,
                    width: 30,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Vers", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      SizedBox(height: 4),
                      Text("DKR", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Date et Classe
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Merc. 12 nov.", style: TextStyle(fontSize: 15)),
                  Text("Economique", style: TextStyle(fontSize: 15, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Bouton Ajouter un vol
        GestureDetector(
          onTap: () {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle_outline, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Text(
                "Ajouter un vol",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGreyInput(String hint, TextEditingController? controller, {IconData? icon, VoidCallback? onTap, bool clearOnTap = false}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (clearOnTap && controller != null) {
          controller.clear(); // Efface le texte
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hint,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.grey, size: 20),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: onTap == null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Afficher la liste des pays
  void _showCountryPicker(bool isDeparture) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDeparture ? "Sélectionnez un départ" : "Sélectionnez une destination",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
                          if (isDeparture) {
                            departureController.text = countries[index];
                          } else {
                            arrivalController.text = countries[index];
                          }
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

  // Sélectionner une date
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
        controller.text = _formatDate(picked);
      });
    }
  }

  // Formater la date
  String _formatDate(DateTime date) {
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final months = ['jan', 'fév', 'mar', 'avr', 'mai', 'jun', 'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'];
    return "${days[date.weekday - 1]}. ${date.day} ${months[date.month - 1]}";
  }

  /// Convertir "Mer. 12 nov" en "12/11/2025"
  String _convertDateToAPIFormat(String displayDate) {
    final parts = displayDate.split(' ');
    if (parts.length < 3) return '';

    final day = parts[1];
    final monthAbbr = parts[2];

    // Mapping des mois
    final months = {
      'jan': '01', 'fév': '02', 'mar': '03', 'avr': '04',
      'mai': '05', 'jun': '06', 'jul': '07', 'aoû': '08',
      'sep': '09', 'oct': '10', 'nov': '11', 'déc': '12',
    };

    final month = months[monthAbbr] ?? '01';
    final year = DateTime.now().year.toString();

    return '$day/$month/$year';
  }
}