/// Model pour la réponse de l'API /api/flights/offers
/// Actuellement l'API retourne seulement {"message": "Flight offers"}
class FlightOfferModel {
  final String? message;

  FlightOfferModel({this.message});

  /// Deserializer : Convertit le JSON reçu de l'API en objet Dart
  factory FlightOfferModel.fromJson(Map<String, dynamic> json) {
    return FlightOfferModel(
      message: json['message'],
    );
  }

  /// Serializer : Convertit l'objet Dart en JSON (rarement utilisé pour ce model)
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}