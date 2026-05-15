import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddRoleScreen extends StatefulWidget {
  const AddRoleScreen({super.key});

  @override
  State<AddRoleScreen> createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  final _roleNameController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _addRole() async {
    if (_roleNameController.text.isNotEmpty) {
      setState(() => _isLoading = true);
      try {
        await _apiService.createRole(_roleNameController.text.trim());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Role created successfully')));
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Role')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _roleNameController,
              decoration: const InputDecoration(labelText: 'Role Name'),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addRole,
                    child: const Text('Create Role'),
                  ),
          ],
        ),
      ),
    );
  }
}
