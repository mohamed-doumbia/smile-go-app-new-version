import 'package:flutter/material.dart';

class PaymentProvider with ChangeNotifier {
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  // Fonction pour simuler un paiement (via n'importe quelle méthode)
  Future<bool> processPayment(String method, String providerName) async {
    _isProcessing = true;
    notifyListeners();

    // Simulation d'attente (2 secondes)
    await Future.delayed(const Duration(seconds: 2));

    print("Paiement effectué via $method ($providerName)");

    _isProcessing = false;
    notifyListeners();
    return true; // Retourne vrai si succès
  }
}