import 'package:finalproject/user.dart';
import 'package:isar/isar.dart';

part 'account.g.dart';

@collection
class Account {
  Id id = Isar.autoIncrement;
  String websiteName;
  String email;
  String password;
  final user = IsarLink<User>();

  Account({
    required this.websiteName,
    required this.email,
    required this.password,
  });
}