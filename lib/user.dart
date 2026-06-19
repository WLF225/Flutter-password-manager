import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String username;

  String password;

  @Index(unique: true)
  String email;

  User({
    required this.username,
    required this.password,
    required this.email,
  });

}