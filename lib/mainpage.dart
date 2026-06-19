import 'package:finalproject/AddAccount.dart';
import 'package:finalproject/account.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/user.dart';
import 'package:finalproject/dao.dart';
import 'package:finalproject/session.dart';

import 'accountcard.dart';

class MainPage extends StatefulWidget {
  final String email;

  const MainPage({super.key, required this.email});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User? user;
  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final result = await Dao.getInstance().getUserByEmail(widget.email);
    AppSession.getInstance().currentUser = result;
    setState(() {
      user = result;
    });
    if (result != null) {
      await loadAccounts();
    }
  }

  Future<void> loadAccounts() async {
    if (user == null) return;
    final result = await Dao.getInstance().getAccountsByUser(user!);
    setState(() {
      _accounts = result;
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
            Text("Username: ${user!.username}"),
            const SizedBox(height: 10),
            Text("Email: ${user!.email}"),
            const SizedBox(height: 10),
            Expanded(
              child: _accounts.isEmpty
                  ? const Center(child: Text("No items yet"))
                  : ListView.builder(
                itemCount: _accounts.length,
                itemBuilder: (context, index) {
                  return AccountCard(account: _accounts[index]);
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAccountPage(),
                  ),
                );
                await loadAccounts();
              },
              child: const Text("Add account"),
            ),
          ],
        ),
      ),
    );
  }
}