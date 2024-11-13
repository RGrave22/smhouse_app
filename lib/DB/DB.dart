
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Data/User.dart';



class LocalDB {
  late final String databaseName;
  late Database db;

  LocalDB(this.databaseName);


  Future<Database> initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    print("ENTRAMOS NO INIT");
    String path = await getDatabasesPath();

    db = await openDatabase(
      join(path, databaseName),
      onCreate: _onCreate,
      version: 1,
    );

    return db;
  }


  Future<void> _onCreate(Database db, int version) async {
    print('onCreate');
    await db.transaction((txn) async {
      await txn.execute('CREATE TABLE users (username TEXT PRIMARY KEY, password TEXT, email TEXT)');
      await txn.execute('CREATE TABLE session (username TEXT PRIMARY KEY, password TEXT, email TEXT)');
    });

  }

  Future<void> insertDefaultUsers() async {
    final db = await initDB();

    User user1 = User(username: 'user1', password: 'password1', email: 'user1@example.com');
    User user2 = User(username: 'user2', password: 'password2', email: 'user2@example.com');
    User user3 = User(username: 'user3', password: 'password3', email: 'user3@example.com');

    await db.insert('users', user1.toMap());
    await db.insert('users', user2.toMap());
    await db.insert('users', user3.toMap());

    print('Default users inserted.');
  }


  Future<bool> login(String username, String password) async {
    try {
      final db = await initDB();
      // Query the session table to check if the user exists
      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (result.isEmpty) {
        // No user found with that username
        return false;
      }

      // Get the stored password
      String storedPassword = result[0]['password'];

      // Here you should use a proper password hash comparison,
      // for simplicity, we will just compare the plain text password
      if (storedPassword == password) {
        // Login successful, you can add session logic or user-specific actions here
        User user = User.fromMap(result[0]);
        loginUser(user);
        print('Login successful');

        return true;
      } else {
        // Password mismatch
        print('Incorrect password');
        return false;
      }
    } catch (e) {
      print("Error during login: $e");
      return false;
    }
  }

  Future<void> loginUser(User user) async {
    final db = await initDB();
    await db.insert('session', user.toMap());
  }

  Future<bool> userExist(String username) async {
    final db = await initDB();

    List<Map<String, dynamic>> existingUsers = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return existingUsers.isNotEmpty;
  }



  Future<void> registerUser(User user) async {
    final db = await initDB();
    await db.insert('users', user.toMap());
  }
  Future<String> getUsername() async {
    final db = await initDB();
    List<Map<String, Object?>> usernameQuery = await db.rawQuery('SELECT username FROM tokens');
    final username = usernameQuery.first.values.first.toString();
    print(username);
    return username;
  }



  Future<List<Map<String, Object?>>> getGroupMessages(String groupName) async {
    final db = await initDB();
    try {
      List<Map<String, Object?>> usernameQuery = await db.rawQuery("SELECT * FROM messages WHERE groupName LIKE '$groupName'");
      return usernameQuery;
    } catch (e) {
      print('Error retrieving messages: $e');
      return []; // Return an empty list or handle the error in another way
    }
  }

  Future<String> getToken() async {
    final db = await initDB();
    List<Map<String, Object?>> usernameQuery = await db.rawQuery('SELECT token FROM tokens');
    final token = usernameQuery.first.values.first.toString();
    print(token);
    return token;
  }

  Future<void> deleteToken() async {
    final db = await initDB();
    await db.rawDelete('DELETE FROM users');
    print('Token deleted');
  }

  Future<List<Map<String, Object?>>> getGroups() async {
    final db = await initDB();
    List<Map<String, Object?>> groups = await db.rawQuery('SELECT * FROM groups');
    print(groups);
    return groups;
  }

  Future<List<Map<String, Object?>>> getGroup(String groupName) async {
    final db = await initDB();
    List<Map<String, Object?>> groups = await db.rawQuery("SELECT * FROM groups where groupName LIKE '$groupName'");
    print(groups);
    return groups;
  }

  Future<List<String>> getGroupsOfOwner(String username) async {
    final db = await initDB();
    List<Map<String, Object?>> groups = await db.rawQuery("SELECT groupName FROM groups where groupOwner LIKE '$username'");
    List<String> groupNames = groups.map((group) => group['groupName'] as String).toList();
    print(groupNames);
    return groupNames;
  }

  Future<void> deleteGroup(String groupName) async {
    final db = await initDB();
    await db.delete(
      'groups',
      where: 'groupName = ?',
      whereArgs: [groupName],
    );
    print('Group $groupName deleted successfully');
  }

  Future<List<Map<String, Object?>>> getUsers() async {
    final db = await initDB();
    List<Map<String, Object?>> users = await db.rawQuery('SELECT * FROM users');
    print(users);
    return users;
  }

  Future<List<Map<String, Object?>>> getGroupsInfo(username) async {
    final db = await initDB();
    List<Map<String, Object?>> groupsInfo = await db.rawQuery("SELECT * FROM groupsInfo WHERE username LIKE '$username'");
    print(groupsInfo);
    return groupsInfo;
  }

  Future<int> countGroupInfos() async {
    final db = await initDB();
    List<Map> list = await db.rawQuery('SELECT * FROM groupsInfo');
    print("Number of GroupsInfo: ${list.length}");

    return list.length;
  }

  Future<bool> groupExists(String groupName) async {
    final db = await initDB();
    List<Map> list = await db.rawQuery("SELECT groupName FROM groups where groupName LIKE '$groupName'");
    return list.isNotEmpty;
  }

  Future<int> countUsers() async {
    final db = await initDB();
    List<Map> list = await db.rawQuery('SELECT * FROM tokens');
    print("Number of users: ${list.length}");

    return list.length;
  }

  Future<void> listAllTables() async {
    final db = await initDB();
    final tables = await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    print(tables);
  }

  Future<void> deleteDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();
    await deleteDatabase(join(path, databaseName));
  }

  /*Future<void> deleteUsersAndTokensTables() async {
    final db = await initDB();

    // Verifica se as tabelas existem
    List<Map<String, Object?>> tableList = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table" AND name IN ("users", "tokens", "groups", "groupsInfo")');

    // Cria um set de tabelas existentes
    Set<String> existingTables = tableList.map((table) => table['name'].toString()).toSet();

    await db.transaction((txn) async {
      // Deleta registros apenas se a tabela existir
      if (existingTables.contains('users')) {
        await txn.delete('users');
      }
      if (existingTables.contains('tokens')) {
        await txn.delete('tokens');
      }
      if (existingTables.contains('groups')) {
        await txn.delete('groups');
      }
      if (existingTables.contains('groupsInfo')) {
        await txn.delete('groupsInfo');
      }
    });
    print('Tables users and tokens deleted');
  }*/

  Future<void> deleteTables() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, databaseName);
    await deleteDatabase(dbPath); // Delete the existing database
    print('Database deleted at $dbPath');

    final db = await initDB();
    // Verifica se as tabelas existem
    List<Map<String, Object?>> tableList = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table" AND name IN ("users")');

    // Cria um set de tabelas existentes
    Set<String> existingTables = tableList.map((table) => table['name'].toString()).toSet();

    await db.transaction((txn) async {
      // Deleta registros apenas se a tabela existir
      if (existingTables.contains('users')) {
        print("DELETANIS A USER");
        await txn.delete('users');
      }
      if (existingTables.contains('session')) {
        print("DELETANIS A SESSION");
        await txn.delete('session');
      }
      //  await txn.delete('openPolls');
      //   await txn.delete('closedPolls');
      //  await txn.delete('pollToVote');
    });

    print('Table users deleted');
  }


}
