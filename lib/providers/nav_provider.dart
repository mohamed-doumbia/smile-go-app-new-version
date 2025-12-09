import 'package:flutter/material.dart';

class NavProvider with ChangeNotifier {
  int _currentIndex = 0; // 0 = Home, 1 = Historique, 2 = Paramètres

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // Met à jour l'écran
  }
}