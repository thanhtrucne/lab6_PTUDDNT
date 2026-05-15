import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AssignRoleScreen extends StatefulWidget {
  const AssignRoleScreen({super.key});

  @override
  State<AssignRoleScreen> createState() => _AssignRoleScreenState();
}

class _AssignRoleScreenState extends State<AssignRoleScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<User>> _usersFuture;
  late Future<List<String>> _rolesFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _apiService.getUsers();
    _rolesFuture = _apiService.getRoles();
  }

  void _showAssignRoleDialog(User user, List<String> roles) {
    String selectedRole = roles.first;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Assign Role to ${user.fullName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a new role:'),
              DropdownButton<String>(
                value: selectedRole,
                isExpanded: true,
                items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (val) => setDialogState(() => selectedRole = val!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                try {
                  await _apiService.assignRole(user.id, selectedRole);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Operation successful')));
                    setState(() { _usersFuture = _apiService.getUsers(); });
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change User Roles'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: FutureBuilder(
        future: Future.wait([_usersFuture, _rolesFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          List<User> users = snapshot.data![0];
          List<String> roles = snapshot.data![1];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(child: Text(user.fullName[0])),
                title: Text(user.fullName),
                subtitle: Text('Current Roles: ${user.roles.join(", ")}'),
                trailing: const Icon(Icons.edit_note),
                onTap: () => _showAssignRoleDialog(user, roles),
              );
            },
          );
        },
      ),
    );
  }
}
