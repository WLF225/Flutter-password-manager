import 'package:finalproject/AddAccount.dart';
import 'package:finalproject/account.dart';
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

    List<Account> _items = [];

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
            SizedBox(height: 10),
            Expanded(child:
            _items.isEmpty?
            Center(child: Text("No items yet")):
            ListView.builder(
                itemBuilder: (context, index){
                  return ListTile(
                    leading: CircleAvatar(child: Text("${index + 1}")),
                    title: Text(_items[index].toString()),
                  );
                }
            )),
            SizedBox(height: 10),
            ElevatedButton(onPressed:(){ Navigator.push(
              context,
                MaterialPageRoute(
                    builder: (context) => const AddAccountPage())
            );},child: Text("Add account"))
          ],
        ),
      ),
    );
  }
}