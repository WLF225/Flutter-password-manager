import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  String username;
  String password;
  String email;

  User({
    required this.username,
    required this.password,
    required this.email,
  });

  String getUsername(){
    return username;
  }
  String getPassword(){
    return password;
  }
  String getEmail(){
    return email;
  }
}