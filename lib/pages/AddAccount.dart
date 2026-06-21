import 'package:flutter/material.dart';
import 'package:finalproject/models/account.dart';
import 'package:finalproject/data/dao.dart';
import 'package:finalproject/models/user.dart';

class AddAccountPage extends StatefulWidget {
  final User user;

  const AddAccountPage({super.key, required this.user});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final TextEditingController _websiteNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _addNewAccount() async {
    final website = _websiteNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (website.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final account = Account(
      websiteName: website,
      email: email,
      password: password,
    );

    await Dao.getInstance().addAccount(account, widget.user);

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _websiteNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new Account")),
      body: Container(
        padding: const EdgeInsets.all(15),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            TextField(
              controller: _websiteNameController,
              decoration: const InputDecoration(labelText: 'Website name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email or username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addNewAccount,
              child: const Text("Add account"),
            )
          ],
        ),
      ),
    );
  }
}