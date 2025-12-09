import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/flight_offer_model.dart';
import '../models/flight_pricing_model.dart';
import '../models/flight_booking_model.dart';

class BookingProvider with ChangeNotifier {
  // Type de voyage : 0 = Aller simple, 1 = Aller-retour, 2 = Multi villes
  int _tripType = 0;
  int get tripType => _tripType;

  // Indicateur de chargement pour afficher le loader
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Message d'erreur en cas de problème avec l'API
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Résultat de l'API /api/flights/offers
  FlightOfferModel? _flightOffers;
  FlightOfferModel? get flightOffers => _flightOffers;

  // Résultat de l'API /api/flights/pricing
  FlightPricingModel? _flightPricing;
  FlightPricingModel? get flightPricing => _flightPricing;

  // Résultat de l'API /api/flights/book
  FlightBookingModel? _flightBooking;
  FlightBookingModel? get flightBooking => _flightBooking;

  // ⚠️ TEMPORAIRE : offerId fictif en attendant que le backend le retourne
  // TODO: Supprimer cette ligne quand le backend retournera l'offerId
  String? _temporaryOfferId = "1"; // ID fictif par défaut
  String? get temporaryOfferId => _temporaryOfferId;

  // Contrôleurs pour les champs de texte (Départ et Arrivée)
  final departureController = TextEditingController();
  final arrivalController = TextEditingController();

  /// Change le type de voyage (Aller simple, Aller-retour, Multi villes)
  void setTripType(int index) {
    _tripType = index;
    notifyListeners(); // Informe les widgets que l'état a changé
  }

  /// Inverse les villes de départ et d'arrivée
  void swapLocations() {
    final temp = departureController.text;
    departureController.text = arrivalController.text;
    arrivalController.text = temp;
    notifyListeners();
  }


  /// Recherche d'hôtels disponibles
  /// Endpoint : (À DÉFINIR PAR LE BACKEND)
  Future<bool> searchHotels(String destination, String checkInDate) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();


    try {
      await Future.delayed(const Duration(seconds: 3)); // Simule le temps de recherche (3s)

      // TODO: REMPLACER PAR L'APPEL HTTP RÉEL (ex: GET /api/hotels/offers)
      // final url = 'https://go.smil-app.com/api/hotels/offers?destination=...';
      // final response = await http.get(Uri.parse(url));

      // Pour la simulation, nous supposons le succès
      print("Recherche d'hôtels terminée pour $destination.");

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _errorMessage = 'Erreur lors de la recherche d\'hôtels.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// API 1 : Recherche de vols disponibles
  /// Endpoint : GET /api/flights/offers
  /// Paramètres requis : origin, destination, departureDate
  Future<bool> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Encoder les paramètres pour l'URL (remplace les espaces par %20, etc.)
      final encodedOrigin = Uri.encodeComponent(origin);
      final encodedDestination = Uri.encodeComponent(destination);
      final encodedDate = Uri.encodeComponent(departureDate);

      // Construire l'URL complète
      final url = 'https://go.smil-app.com/api/flights/offers?origin=$encodedOrigin&destination=$encodedDestination&departureDate=$encodedDate';

      // Appel GET à l'API
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      // Si la requête réussit (code 200)
      if (response.statusCode == 200) {
        // Décoder la réponse JSON
        final data = jsonDecode(response.body);

        // Convertir le JSON en objet FlightOfferModel
        _flightOffers = FlightOfferModel.fromJson(data);

        // ⚠️ TEMPORAIRE : L'API ne retourne pas d'offerId, donc on utilise "1"
        // TODO: Remplacer par l'offerId réel quand le backend le retournera
        _temporaryOfferId = "1";

        _isLoading = false;
        notifyListeners();
        return true; // Succès
      } else {
        // En cas d'erreur (code 400, 500, etc.)
        final error = jsonDecode(response.body);
        _errorMessage = error['message'] ?? 'Erreur lors de la recherche';
        _isLoading = false;
        notifyListeners();
        return false; // Échec
      }
    } catch (e) {
      // En cas d'erreur réseau (pas de connexion, timeout, etc.)
      _errorMessage = 'Erreur de connexion: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// API 2 : Vérification du prix d'une offre
  /// Endpoint : GET /api/flights/pricing
  /// Paramètre requis : offerId
  Future<bool> checkPricing(String offerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Construire l'URL avec l'offerId
      final url = 'https://go.smil-app.com/api/flights/pricing?offerId=$offerId';

      // Appel GET à l'API
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      // Si la requête réussit
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _flightPricing = FlightPricingModel.fromJson(data);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _errorMessage = error['message'] ?? 'Erreur lors de la vérification du prix';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur de connexion: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// API 3 : Réservation d'un vol
  /// Endpoint : POST /api/flights/book
  /// Body requis : offerId, passengers[]
  Future<bool> bookFlight({
    required String offerId,
    required List<Passenger> passengers,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = 'https://go.smil-app.com/api/flights/book';

      // Appel POST à l'API avec le body JSON
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'offerId': offerId,
          // Convertir chaque passager en JSON
          'passengers': passengers.map((p) => p.toJson()).toList(),
        }),
      );

      // Si la réservation réussit (code 200 ou 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _flightBooking = FlightBookingModel.fromJson(data);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _errorMessage = error['message'] ?? 'Erreur lors de la réservation';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur de connexion: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}