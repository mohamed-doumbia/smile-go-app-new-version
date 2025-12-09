/// Model pour la réponse de l'API /api/flights/pricing
/// Actuellement l'API retourne seulement {"message": "Flight pricing"}
class FlightPricingModel {
  final String? message;

  FlightPricingModel({this.message});

  /// Deserializer : Convertit le JSON reçu de l'API en objet Dart
  factory FlightPricingModel.fromJson(Map<String, dynamic> json) {
    return FlightPricingModel(
      message: json['message'],
    );
  }

  /// Serializer : Convertit l'objet Dart en JSON
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}