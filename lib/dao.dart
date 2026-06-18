import 'package:bcrypt/bcrypt.dart';
import 'package:finalproject/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

class Dao {
  late Future<Isar> db;

  Dao() {
    db = openDB();
  }

  Future<void> addUser(User user) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
  }

  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  Future<User?> getUserByUsername(String username) async {
    final isar = await db;
    return await isar.users.filter().usernameEqualTo(username).findFirst();
  }

  Future<User?> getUserByEmail(String email) async {
    final isar = await db;
    return await isar.users.filter().emailEqualTo(email).findFirst();
  }

  Future<void> updatePassword(String username, String newPassword) async {
    final isar = await db;
    final user = await isar.users
        .filter()
        .usernameEqualTo(username)
        .findFirst();
    if (user != null) {
      String encNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
      user.password = encNewPassword;
      await isar.writeTxn(() async {
        await isar.users.put(user);
      });
    }
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [UserSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
