/// Model pour la réponse de l'API /api/flights/book
/// L'API retourne {"message": "Vol réservé"} après la réservation
class FlightBookingModel {
  final String? message;

  FlightBookingModel({this.message});

  /// Deserializer : Convertit le JSON reçu de l'API en objet Dart
  factory FlightBookingModel.fromJson(Map<String, dynamic> json) {
    return FlightBookingModel(
      message: json['message'],
    );
  }

  /// Serializer : Convertit l'objet Dart en JSON
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

/// Model pour les données d'un passager
/// Utilisé pour ENVOYER les infos à l'API /api/flights/book
class Passenger {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String passportNumber;

  Passenger({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.passportNumber,
  });

  /// Serializer : Convertit l'objet Passenger en JSON pour l'envoyer à l'API
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'passportNumber': passportNumber,
    };
  }
}