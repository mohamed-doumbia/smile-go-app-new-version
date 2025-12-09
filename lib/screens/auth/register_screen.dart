import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import 'security_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final prenomsController = TextEditingController();
  final pieceIdentiteController = TextEditingController();
  final paysController = TextEditingController();
  final villeController = TextEditingController();
  final telController = TextEditingController();
  final whatsappController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/icons/logo-face-removebg-preview.png', height: 35),
            const Spacer(),
            Image.asset('assets/icons/logo-smilgo-removebg-preview.png', height: 35),
          ],
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Inscrivez-vous",
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(width: 150, height: 3, color: AppColors.primaryYellow),
                ],
              ),
              const SizedBox(height: 30),

              // CHAMPS OBLIGATOIRES
              _buildInput("Nom", controller: nameController, required: true),
              _buildInput("Prénom(s)", controller: prenomsController, required: true),

              // CHAMPS OPTIONNELS
              _buildInput("Pièce d'identité",
                  controller: pieceIdentiteController,
                  suffixIcon: 'assets/icons/camera.png'),
              _buildInput("Pays",
                  controller: paysController,
                  suffixIcon: 'assets/icons/angle-circle-down.png'),
              _buildInput("Ville", controller: villeController),
              _buildInput("Numéro de tél.", controller: telController),
              _buildInput("Numéro whatsapp", controller: whatsappController),

              // EMAIL ET PASSWORD OBLIGATOIRES
              _buildInput("Adresse e-mail",
                  controller: emailController,
                  required: true,
                  keyboardType: TextInputType.emailAddress),
              _buildInput("Mot de passe",
                  controller: passwordController,
                  required: true,
                  isPassword: true),
              _buildInput("Confirmer mot de passe",
                  controller: passwordConfirmController,
                  required: true,
                  isPassword: true),

              const SizedBox(height: 10),
              const Text(
                "(*) recevez le code OTP pour valider votre compte smilgo via whatsapp",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // BOUTON VALIDER
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryYellow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          // Vérifier que les mots de passe correspondent
                          if (passwordController.text != passwordConfirmController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
                            );
                            return;
                          }

                          final success = await auth.register(
                            nom: nameController.text,
                            prenoms: prenomsController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            passwordConfirmation: passwordConfirmController.text,
                            pieceIdentite: pieceIdentiteController.text.isEmpty ? null : pieceIdentiteController.text,
                            pays: paysController.text.isEmpty ? null : paysController.text,
                            ville: villeController.text.isEmpty ? null : villeController.text,
                            tel: telController.text.isEmpty ? null : telController.text,
                            numWha: whatsappController.text.isEmpty ? null : whatsappController.text,
                          );

                          if (success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SecurityScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(auth.errorMessage ?? 'Erreur lors de l\'inscription')),
                            );
                          }
                        }
                      },
                      child: auth.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Valider",
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
      String label, {
        String? suffixIcon,
        TextEditingController? controller,
        bool required = false,
        bool isPassword = false,
        TextInputType? keyboardType,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isPassword,
              keyboardType: keyboardType,
              validator: required
                  ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est obligatoire';
                }
                if (label == "Adresse e-mail" && !value.contains('@')) {
                  return 'Email invalide';
                }
                if (label == "Mot de passe" && value.length < 8) {
                  return 'Le mot de passe doit contenir au moins 8 caractères';
                }
                return null;
              }
                  : null,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                suffixIcon: suffixIcon != null
                    ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(suffixIcon, width: 20, height: 20),
                )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    prenomsController.dispose();
    pieceIdentiteController.dispose();
    paysController.dispose();
    villeController.dispose();
    telController.dispose();
    whatsappController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }
}