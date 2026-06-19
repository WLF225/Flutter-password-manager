import 'package:finalproject/dao.dart';
import 'package:finalproject/user.dart';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';


class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
  
}

class _CreateAccountState extends State<CreateAccount> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _createAccount() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String email = _emailController.text;
    
    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All fields are required!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords does not match!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    Dao dao = Dao();

    password = BCrypt.hashpw(password, BCrypt.gensalt());
    if(!await dao.isUniqueUsername(username)){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This username is used!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if(!await dao.isUniqueEmail(email)){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This email is used!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    dao.addUser(User(username: username, password: password, email: email));
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account created successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
            height: double.infinity,
            width: double.infinity,
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _createAccount();
                },
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      );
  }
}