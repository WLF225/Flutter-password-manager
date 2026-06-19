import 'package:flutter/material.dart';

class AddAccountPage extends StatefulWidget{
    const AddAccountPage({super.key});

    @override
    State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage>{
   
  final TextEditingController _websiteNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  void _addNewAccount() async{
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new Account")),
      body: Container(
        padding: EdgeInsets.all(15),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            TextField(
              controller: _websiteNameController,
              decoration: InputDecoration(labelText: 'Website name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email or username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: _addNewAccount,
                child: Text("Add account"))
          ],
        ),
      ),
    );
  }
}