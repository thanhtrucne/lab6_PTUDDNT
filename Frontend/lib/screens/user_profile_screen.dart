import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/menu_button.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Section', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003380),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('User Methods', style: TextStyle(fontSize: 20, color: Colors.grey)),
            const SizedBox(height: 20),
            MenuButton(
              text: 'User Info',
              color: const Color(0xFF003380),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('User Info'),
                    content: Text('Name: ${user?.fullName}\nEmail: ${user?.email}\nRoles: ${user?.roles.join(", ")}'),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                  ),
                );
              },
            ),
            MenuButton(
              text: 'Edit Profile',
              color: const Color(0xFF003380),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
            ),
            MenuButton(
              text: 'Change Password',
              color: const Color(0xFF003380),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
            ),
            MenuButton(
              text: 'Delete Account',
              color: const Color(0xFF003380),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text('Are you sure you want to delete your account? This action is permanent.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () async {
                          try {
                            await apiService.deleteAccount();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                              (route) => false,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            MenuButton(
              text: 'Logout',
              color: const Color(0xFF003380),
              onPressed: () async {
                await auth.logout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
