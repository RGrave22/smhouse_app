
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:smhouse_app/Data/Casa.dart';
import 'package:smhouse_app/Data/Device.dart';
import 'package:smhouse_app/Data/Division.dart';
import 'package:smhouse_app/Data/Light.dart';
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
      await txn.execute('CREATE TABLE users (username TEXT PRIMARY KEY, password TEXT, email TEXT, casa TEXT)');
      await txn.execute('CREATE TABLE session (username TEXT PRIMARY KEY, password TEXT, email TEXT, casa TEXT)');
      await txn.execute('CREATE TABLE casa (houseName TEXT PRIMARY KEY, houseTemp TEXT, houseOn INTEGER)');
      await txn.execute('CREATE TABLE division (divName TEXT PRIMARY KEY, houseName TEXT, divON INTEGER, divTemp)');
      await txn.execute('CREATE TABLE device (devName TEXT PRIMARY KEY, divName TEXT, houseName TEXT, isOn INTEGER, type TEXT)');
      await txn.execute('CREATE TABLE light (lightName TEXT PRIMARY KEY, houseName TEXT, divName TEXT, isOn INTEGER, color TEXT)');
      await txn.execute('CREATE TABLE ac (acName TEXT PRIMARY KEY, houseName TEXT, divName TEXT, isOn INTEGER, acMode TEXT, acTimer TEXT, swingModeOn INTEGER, airDirection INTEGER, acTemp INTEGER)');
      await txn.execute('CREATE TABLE virtualAssist (vaName TEXT PRIMARY KEY, houseName TEXT, divName TEXT, isOn INTEGER, volume INTEGER, isPlaying INTEGER, music TEXT, isMuted INTEGER, alarm INTEGER)');
      await txn.execute('CREATE TABLE divRestriction (restrictionName TEXT PRIMARY KEY, username TEXT, hours TEXT)');
      await txn.execute('CREATE TABLE deviceRestriction (restrictionName TEXT PRIMARY KEY, username TEXT, hours TEXT)');
    });

  }

  Future<void> insertDefaultUsers() async {
    final db = await initDB();

    User user1 = User(username: 'user1', password: 'password1', email: 'user1@example.com', casa: 'user1:UsersHouse');
    User user2 = User(username: 'user2', password: 'password2', email: 'user2@example.com', casa: 'user1:UsersHouse');
    User user3 = User(username: 'user3', password: 'password3', email: 'user3@example.com', casa: 'user1:UsersHouse');
    User user4 = User(username: '1', password: '1', email: '1', casa: 'user1:UsersHouse');
    await db.insert('users', user1.toMap());
    await db.insert('users', user2.toMap());
    await db.insert('users', user3.toMap());
    await db.insert('users', user4.toMap());

    Casa usersHouse = Casa(houseName: 'user1:UsersHouse', houseTemp: "16", houseOn: 0);
    await db.insert('casa', usersHouse.toMap());

    Division kitchen = Division(divName: "user1:UsersHouse:kitchen", houseName: "user1:UsersHouse", divON: 0, divTemp: "16");
    Division alexandersBedroom = Division(divName: "user1:UsersHouse:alexandersBedroom", houseName: "user1:UsersHouse", divON: 0, divTemp: "16");
    await db.insert('division', kitchen.toMap());
    await db.insert('division', alexandersBedroom.toMap());

    Light alexandersLight = Light(lightName: "AlexandersLight", houseName: "user1:UsersHouse", divName: "user1:UsersHouse:alexandersBedroom", isOn: 0, color: "");
    Device alexandersLightDev = Device(devName: "AlexandersLight", isOn: 0, type: "light", divName: "user1:UsersHouse:alexandersBedroom", houseName: "user1:UsersHouse");
    Light kitchenMainLight = Light(lightName: "kitchenMainLight", houseName: "user1:UsersHouse", divName: "user1:UsersHouse:kitchen", isOn: 0, color: "");
    Device kitchenMainLightDev = Device(devName: "kitchenMainLight", isOn: 0, type: "light", divName: "user1:UsersHouse:kitchen", houseName: "user1:UsersHouse");

    await db.insert('light', alexandersLight.toMap());
    await db.insert('light', kitchenMainLight.toMap());
    await db.insert('device', alexandersLightDev.toMap());
    await db.insert('device', kitchenMainLightDev.toMap());

    print('Default users inserted.');
  }


  Future<bool> login(String username, String password) async {
    try {
      final db = await initDB();

      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (result.isEmpty) {

        return false;
      }


      String storedPassword = result[0]['password'];


      if (storedPassword == password) {

        User user = User.fromMap(result[0]);
        loginUser(user);
        print('Login successful');

        return true;
      } else {

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

  Future<String> getLoginUsername() async {
    final db = await initDB();
    List<Map<String, Object?>> usernameQuery = await db.rawQuery('SELECT username FROM session');
    final username = usernameQuery.first.values.first.toString();
    print(username);
    return username;
  }

  Future<User> getLoginUser() async {
    final db = await initDB();
    List<Map<String, Object?>> usernameQuery = await db.rawQuery('SELECT * FROM session');
    User user = usernameQuery.map((map) => User.fromMap(map)).toList().first;
    print(user);
    return user;
  }

  Future<List<Division>> getDivisions(String houseName) async {
    final db = await initDB();

    List<Map<String, Object?>> result = await db.query(
        'division',
        where: 'houseName = ?',
        whereArgs: [houseName]
    );

    List<Division> divisions = result.map((map) => Division.fromMap(map)).toList();

    return divisions;
  }

  Future<List<User>> getFamily(String houseName) async {
    final db = await initDB();

    List<Map<String, Object?>> result = await db.query(
        'users',
        where: 'casa = ?',
        whereArgs: [houseName]
    );

    print(result);
    List<User> family = result.map((map) => User.fromMap(map)).toList();

    return family;
  }

  Future<void> addDivision(Division div) async {
    final db = await initDB();
    await db.insert('division', div.toMap());
    print("DIVISION ADDED TO DB");
  }

  Future<int> countDevicesOnInDivision(String divName) async {
    final db = await initDB();

    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM device WHERE divName = ? AND isOn = ?',
        [divName, 1] // 1 indicates the device is on
    );

    int count = result.first['count'] as int;
    print('Number of devices ON in division $divName: $count');

    return count;
  }

  Future<List<Device>> getDevicesOfDivision(String divName) async {
    final db = await initDB();


    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM device WHERE divName = ?',
      [divName],
    );

    List<Device> devices = result.map((deviceMap) {
      return Device.fromMap(deviceMap);
    }).toList();

    print('Devices in division $divName: ${devices.length}');

    return devices;
  }

  Future<Division> getDivision(String divName) async {
    final db = await initDB();


    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM division WHERE divName = ?',
      [divName],
    );

    Division division = result.map((divMap) {
      return Division.fromMap(divMap);
    }).toList().first;

    return division;
  }

  Future<void> updateDeviceStatus(String devName, int status) async {
    final db = await initDB();
    await db.rawUpdate(
      'UPDATE device SET isOn = ? WHERE devName = ?',
      [status, devName],
    );
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
      if (existingTables.contains('casa')) {
        print("DELETANIS A casa");
        await txn.delete('casa');
      }
      if (existingTables.contains('division')) {
        print("DELETANIS A division");
        await txn.delete('division');
      }
      if (existingTables.contains('device')) {
        print("DELETANIS A device");
        await txn.delete('device');
      }
      if (existingTables.contains('light')) {
        print("DELETANIS A light");
        await txn.delete('light');
      }
      if (existingTables.contains('ac')) {
        print("DELETANIS A ac");
        await txn.delete('ac');
      }
      if (existingTables.contains('virtualAssist')) {
        print("DELETANIS A virtualAssist");
        await txn.delete('virtualAssist');
      }
      if (existingTables.contains('divRestriction')) {
        print("DELETANIS A divRestriction");
        await txn.delete('divRestriction');
      }
      if (existingTables.contains('deviceRestriction')) {
        print("DELETANIS A deviceRestriction");
        await txn.delete('deviceRestriction');
      }
      //  await txn.delete('openPolls');
      //   await txn.delete('closedPolls');
      //  await txn.delete('pollToVote');
    });

    print('Table users deleted');
  }


}
