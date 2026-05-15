import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/menu_button.dart';
import 'user_list_screen.dart';
import 'role_list_screen.dart';
import 'add_role_screen.dart';
import 'assign_role_screen.dart';
import 'register_screen.dart'; // Admin can add users via this
import 'login_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Section', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Admin Methods', style: TextStyle(fontSize: 20, color: Colors.grey)),
            const SizedBox(height: 20),
            MenuButton(
              text: 'Show Users',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserListScreen())),
            ),
            MenuButton(
              text: 'Add New Users',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
            ),
            MenuButton(
              text: 'Show Roles',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoleListScreen())),
            ),
            MenuButton(
              text: 'Add New Roles',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRoleScreen())),
            ),
            MenuButton(
              text: 'Change User Roles',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssignRoleScreen())),
            ),
            MenuButton(
              text: 'Edit Profile',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
            ),
            MenuButton(
              text: 'Change Password',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
            ),
            MenuButton(
              text: 'Logout',
              color: Colors.green.shade700,
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
