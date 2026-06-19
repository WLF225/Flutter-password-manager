import 'package:finalproject/user.dart';

class AppSession {
  static final AppSession _instance = AppSession._internal();
  static AppSession getInstance() => _instance;
  AppSession._internal();

  User? currentUser;
}