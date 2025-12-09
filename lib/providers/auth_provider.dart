import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _token;
  String? get token => _token;

  final _storage = const FlutterSecureStorage();

  // Vérifier si l'utilisateur est connecté au démarrage
  Future<void> checkAuth() async {
    _token = await _storage.read(key: 'auth_token');
    if (_token != null) {
      // Tu peux appeler une API pour récupérer les infos user si besoin
    }
    notifyListeners();
  }

  // 1. Register API
  Future<bool> register({
    required String nom,
    required String prenoms,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? pieceIdentite,
    String? pays,
    String? ville,
    String? tel,
    String? numWha,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://go.smil-app.com/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nom': nom,
          'prenoms': prenoms,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'piece_identite': pieceIdentite,
          'pays': pays,
          'ville': ville,
          'tel': tel,
          'num_wha': numWha,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _user = UserModel.fromJson(data['user']);

        // Stocker le token
        if (data['token'] != null) {
          _token = data['token'];
          await _storage.write(key: 'auth_token', value: _token!);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _errorMessage = error['message'] ?? 'Erreur lors de l\'inscription';
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

  // 2. Login API
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://go.smil-app.com/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = UserModel.fromJson(data['user']);

        // Stocker le token
        if (data['token'] != null) {
          _token = data['token'];
          await _storage.write(key: 'auth_token', value: _token!);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _errorMessage = error['message'] ?? 'Email ou mot de passe incorrect';
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

  // 3. Logout
  Future<void> logout() async {
    _user = null;
    _token = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }

  // 5. Update Password
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('https://go.smil-app.com/api/auth/update-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _errorMessage = error['message'] ?? 'Erreur lors de la modification';
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

  // 6. Reset Password (Mot de passe oublié)
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://go.smil-app.com/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _errorMessage = error['message'] ?? 'Erreur lors de la réinitialisation';
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


  // 4. Méthode pour faire des requêtes authentifiées
  Future<http.Response> authenticatedRequest(String url, {String method = 'GET', Map<String, dynamic>? body}) async {
    if (_token == null) {
      throw Exception('Non authentifié');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    if (method == 'POST') {
      return await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    } else {
      return await http.get(Uri.parse(url), headers: headers);
    }
  }
}