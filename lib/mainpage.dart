import 'package:flutter/material.dart';
import 'package:finalproject/user.dart';
import 'package:finalproject/dao.dart';

class MainPage extends StatefulWidget {
  final String email;

  const MainPage({super.key, required this.email});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final result = await Dao().getUserByEmail(widget.email);
    setState(() {
      user = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Page")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Username: ${user!.getUsername()}"),
            const SizedBox(height: 10),
            Text("Email: ${user!.getEmail()}"),
          ],
        ),
      ),
    );
  }
}