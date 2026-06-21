import 'package:bcrypt/bcrypt.dart';
import 'package:finalproject/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:finalproject/account.dart';

class Dao {
  static final Dao _instance = Dao._internal();
  static Dao getInstance() => _instance;

  late Future<Isar> db;

  Dao._internal() {
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

  Future<bool> isUniqueUsername(String? username) async {
    User? user = await getUserByUsername(username!);
    return user == null;
  }

  Future<bool> isUniqueEmail(String? email) async {
    User? user = await getUserByEmail(email!);
    return user == null;
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

  Future<void> addAccount(Account account, User user) async {
    final isar = await db;
    account.user.value = user;
    await isar.writeTxn(() async {
      await isar.accounts.put(account);
      await account.user.save();
    });
  }

  Future<List<Account>> getAccountsByUser(User user) async {
    final isar = await db;
    return await isar.accounts
        .filter()
        .user((q) => q.idEqualTo(user.id))
        .findAll();
  }

  Future<void> updateAccount(Account account) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.accounts.put(account);
    });
  }

  Future<void> deleteAccount(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.accounts.delete(id);
    });
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [UserSchema, AccountSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}