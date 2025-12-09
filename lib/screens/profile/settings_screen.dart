import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../auth/forgot_password_screen.dart';
import '../auth/login.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text("Paramètres", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              // OPTION 1 : MON PROFIL
              _buildSettingItem(
                  context,
                  "Mon profil",
                  Icons.person,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                  }
              ),

              // OPTION 2 : CHANGER MOT DE PASSE
              _buildSettingItem(
                  context,
                  "Changer mot de passe",
                  Icons.lock_outline,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
                  }
              ),

              _buildSettingItem(context, "Notifications", Icons.notifications_none, onTap: () {}),
              _buildSettingItem(context, "Langue", Icons.language, onTap: () {}),
              _buildSettingItem(context, "Aide & Support", Icons.help_outline, onTap: () {}),

              const Divider(height: 40),

              // DÉCONNEXION
              _buildSettingItem(
                  context,
                  "Déconnexion",
                  Icons.exit_to_app,
                  color: Colors.red,
                  onTap: () async {
                    // Appel du logout
                    await Provider.of<AuthProvider>(context, listen: false).logout();

                    // Retour vers LoginScreen et supprime toutes les pages précédentes
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                    );
                  }
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
      BuildContext context,
      String title,
      IconData icon, {
        VoidCallback? onTap,
        Color color = AppColors.primaryDark
      }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color == Colors.red ? Colors.red : Colors.black
          )
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}