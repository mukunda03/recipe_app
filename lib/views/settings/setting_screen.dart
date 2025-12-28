import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/core/constants/text_styles.dart';
import 'package:recipe_app/providers/current_user_provider.dart';
import 'package:recipe_app/views/auth/auth_gate.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isEditing = false;
  bool notificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        foregroundColor: AppColors.textDark,
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (user) {
          if (user == null) {
            return const Center(child: Text("No user data"));
          }

          _nameController.text = user.fullName;
          _phoneController.text = user.phone;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage(
                        'assets/images/user_icon.png',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Your Profile",
                      style: TextStyles.h1(AppColors.textDark),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _sectionTitle("Profile"),
                _infoCard("Name", _nameController, isEditing),
                _infoCard("Email", null, false, value: user.email),
                _infoCard("Phone", _phoneController, isEditing),

                const SizedBox(height: 20),
                // Edit profile
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primartTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _saveProfile(user.uid),
                    child: Text(
                      isEditing ? "Save Profile" : "Edit Profile",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                //logout
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      showLogoutDialog(context);
                    },
                    child: Text(
                      "Logout",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Text(title, style: TextStyles.h2(AppColors.textDark)),
      ),
    );
  }

  Widget _infoCard(
    String label,
    TextEditingController? controller,
    bool enabled, {
    String? value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          // ignore: deprecated_member_use
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyles.subtitleText(AppColors.textDark)),
          TextField(
            controller: controller,
            enabled: enabled,
            style: TextStyles.h3(Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: value,
              hintStyle: enabled
                  ? TextStyle(color: Colors.black)
                  : TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.logout_rounded, color: AppColors.primartTeal),
              const SizedBox(width: 8),
              const Text(
                "Logout",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontSize: 15),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          actions: [
            ///  CANCEL
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "No",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ///  LOGOUT
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // close dialog
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthGate()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primartTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Yes, Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= ACTIONS =================

  Future<void> _saveProfile(String uid) async {
    if (isEditing) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fullName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      });

      ref.invalidate(currentUserProvider);
    }

    setState(() => isEditing = !isEditing);
  }
}
