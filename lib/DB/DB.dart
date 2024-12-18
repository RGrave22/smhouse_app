
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:smhouse_app/Data/Ac.dart';
import 'package:smhouse_app/Data/Casa.dart';
import 'package:smhouse_app/Data/Device.dart';
import 'package:smhouse_app/Data/DivRestriction.dart';
import 'package:smhouse_app/Data/Division.dart';
import 'package:smhouse_app/Data/Light.dart';
import 'package:smhouse_app/Data/VirtualAssist.dart';
import 'package:sqflite/sqflite.dart';

import '../Data/DevRestriction.dart';
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
      await txn.execute('CREATE TABLE division (divName TEXT PRIMARY KEY, houseName TEXT, divON INTEGER, divTemp )');
      await txn.execute('CREATE TABLE device (devName TEXT PRIMARY KEY, divName TEXT, houseName TEXT, isOn INTEGER, type TEXT)');
      await txn.execute('CREATE TABLE light (lightName TEXT PRIMARY KEY, houseName TEXT, divName TEXT, isOn INTEGER, color TEXT, intensity INTEGER)');
      await txn.execute('CREATE TABLE ac (acName TEXT PRIMARY KEY, houseName TEXT, divName TEXT, isOn INTEGER, acMode TEXT, acHoursTimer INTEGER, acMinutesTimer INTEGER, swingModeOn INTEGER, airDirection INTEGER, acTemp INTEGER)');
      await txn.execute('CREATE TABLE virtualAssist (vaName TEXT PRIMARY KEY, houseName TEXT, divName TEXT, isOn INTEGER, volume INTEGER, isPlaying INTEGER, music TEXT, isMuted INTEGER, alarmHours INTEGER, alarmMinutes INTEGER)');
      await txn.execute('CREATE TABLE divRestriction (restrictionName TEXT PRIMARY KEY, divName TEXT,  username TEXT)');
      await txn.execute('CREATE TABLE devRestriction (restrictionName TEXT PRIMARY KEY, deviceName TEXT, username TEXT, deviceRoomName TEXT, startingTimeHour INTEGER, startingTimeMinute INTEGER, endTimeHour INTEGER, endTimeMinute INTEGER, isAllDay INTEGER)');
    });

  }

  Future<void> insertDefaultUsers() async {
    final db = await initDB();

    User user1 = User(username: 'Ricardo', password: 'ricardo1', email: 'ricardo@gmail.com', casa: 'Ricardo:Casa Ricardo');
    User user2 = User(username: 'Sílvia', password: 'silvia1', email: 'silvinha@gmail.com', casa: 'Ricardo:Casa Ricardo');
    User user3 = User(username: 'Mário', password: 'mario1', email: 'marinho@hotmail.com', casa: 'Ricardo:Casa Ricardo');
    User user4 = User(username: 'Jojo', password: 'jojo1', email: 'jojo@gmail.com', casa: 'Ricardo:Casa Ricardo');
    User user5 = User(username: 'Felipe', password: 'felipe1', email: 'felipe@agros.com', casa: '');
    await db.insert('users', user1.toMap());
    await db.insert('users', user2.toMap());
    await db.insert('users', user3.toMap());
    await db.insert('users', user4.toMap());
    await db.insert('users', user5.toMap());

    Casa usersHouse = Casa(houseName: 'Ricardo:Casa Ricardo', houseTemp: "16", houseOn: 0);
    await db.insert('casa', usersHouse.toMap());

    Division kitchen = Division(divName: "Ricardo:Casa Ricardo:Kitchen", houseName: "Ricardo:Casa Ricardo", divON: 0, divTemp: "20");
    Division alexandersBedroom = Division(divName: "Ricardo:Casa Ricardo:Quarto do Jojo", houseName: "Ricardo:Casa Ricardo", divON: 0, divTemp: "16");
    await db.insert('division', kitchen.toMap());
    await db.insert('division', alexandersBedroom.toMap());

    Light alexandersLight = Light(lightName: "Luz do Jojo", houseName: "Ricardo:Casa Ricardo", divName: "Ricardo:Casa Ricardo:Quarto do Jojo", isOn: 0, color: "", intensity: 0);
    Device alexandersLightDev = Device(devName: "Luz do Jojo", isOn: 0, type: "light", divName: "Ricardo:Casa Ricardo:Quarto do Jojo", houseName: "Ricardo:Casa Ricardo");
    Light kitchenMainLight = Light(lightName: "Luz da cozinha", houseName: "Ricardo:Casa Ricardo", divName: "Ricardo:Casa Ricardo:Kitchen", isOn: 0, color: "",  intensity: 0);
    Device kitchenMainLightDev = Device(devName: "Luz da cozinha", isOn: 0, type: "light", divName: "Ricardo:Casa Ricardo:Kitchen", houseName: "Ricardo:Casa Ricardo");
    AC kitchenAC = AC(acName: "AC da cozinha", houseName: "Ricardo:Casa Ricardo", divName: "Ricardo:Casa Ricardo:Kitchen", isOn: 0, acMode: "Cool", acHoursTimer: 0, acMinutesTimer: 0, swingModeOn: 0, airDirection: 0, acTemp: 0);
    Device kitchenACDev = Device(devName: "AC da cozinha", isOn: 0, type: "ac", divName: "Ricardo:Casa Ricardo:Kitchen", houseName: "Ricardo:Casa Ricardo");
    VirtualAssist kitchenVa = VirtualAssist(vaName: "Alexa", houseName: "Ricardo:Casa Ricardo", divName: "Ricardo:Casa Ricardo:Kitchen", isOn: 0, volume: 0, isPlaying: 0, music: "", isMuted: 0, alarmHours: 0, alarmMinutes: 0);
    Device kitchenVaDev = Device(devName: "Alexa", isOn: 0, type: "virtualAssist", divName: "Ricardo:Casa Ricardo:Kitchen", houseName: "Ricardo:Casa Ricardo");

    await db.insert('light', alexandersLight.toMap());
    await db.insert('light', kitchenMainLight.toMap());
    await db.insert('ac', kitchenAC.toMap());
    await db.insert('virtualAssist', kitchenVa.toMap());
    await db.insert('device', alexandersLightDev.toMap());
    await db.insert('device', kitchenMainLightDev.toMap());
    await db.insert('device', kitchenACDev.toMap());
    await db.insert('device', kitchenVaDev.toMap());

    DivRestriction user2DivRestriction = DivRestriction(restrictionName: "Sílvia:Kitchen", username: "Sílvia", divName: "Kitchen");
    DevRestriction user2DevRestriction = DevRestriction(restrictionName: "Sílvia:Luz do Jojo", deviceName: "Luz do Jojo", username: "Sílvia", deviceRoomName: "Ricardo:Casa Ricardo:Quarto do Jojo", startingTimeHour: 3, startingTimeMinute: 0, endTimeHour: 4, endTimeMinute: 0, isAllDay: true);
    await db.insert("divRestriction", user2DivRestriction.toMap());
    await db.insert("devRestriction", user2DevRestriction.toMap());

    print('Default users inserted.');
  }


  Future<bool> login(String email, String password) async {
    try {
      final db = await initDB();

      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
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

  Future<bool> userExist(String email) async {
    final db = await initDB();

    List<Map<String, dynamic>> existingUsers = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
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



  Future<Light> getLight(String lightName) async {
    final db = await initDB();

    List<Map<String, Object?>> result = await db.query(
        'light',
        where: 'lightName = ?',
        whereArgs: [lightName]
    );

    print(result);
    Light light = result.map((map) => Light.fromMap(map)).toList().first;

    return light;
  }

  Future<Division> getDiv(String divName) async {
    final db = await initDB();

    List<Map<String, Object?>> result = await db.query(
        'division',
        where: 'divName = ?',
        whereArgs: [divName]
    );

    print(result);
    Division div = result.map((map) => Division.fromMap(map)).toList().first;

    return div;
  }

  Future<AC> getAC(String acName) async {
    final db = await initDB();

    List<Map<String, Object?>> result = await db.query(
        'ac',
        where: 'acName = ?',
        whereArgs: [acName]
    );

    print(result);
    AC ac = result.map((map) => AC.fromMap(map)).toList().first;

    return ac;
  }

  Future<VirtualAssist> getVa(String vaName) async {
    final db = await initDB();

    List<Map<String, Object?>> result = await db.query(
        'virtualAssist',
        where: 'vaName = ?',
        whereArgs: [vaName]
    );

    print(result);
    VirtualAssist ac = result.map((map) => VirtualAssist.fromMap(map)).toList().first;

    return ac;
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

  Future<bool> addDivision(Division div) async {
    final db = await initDB();
    try {
      await getDivision(div.divName);
    } on StateError {
      await db.insert('division', div.toMap());
      print("DIVISION ADDED TO DB");
      return true;
    }

    print("DIVISION ALREADY EXISTS ON DB");
    return false;
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

  Future<void> updateDeviceName(Device dev, String newName) async {
    final db = await initDB();
    String devName =  dev.devName;
    String type = dev.type;
    String divName = dev.divName;
    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE device SET divName = ? WHERE devName = ?',
        [divName, devName],
      );
      await txn.rawUpdate(
        'UPDATE device SET devName = ? WHERE devName = ?',
        [newName, devName],
      );

      switch (type) {
        case 'ac':
          await txn.rawUpdate(
            'UPDATE ac SET divName = ? WHERE acName = ? ',
            [divName, devName],
          );
          await txn.rawUpdate(
            'UPDATE ac SET acName = ? WHERE acName = ? ',
            [newName, devName],
          );
          break;
        case 'virtualAssist':
          await txn.rawUpdate(
            'UPDATE virtualAssist SET divName = ? WHERE vaName = ? ',
            [divName, devName],
          );
          await txn.rawUpdate(
            'UPDATE virtualAssist SET vaName = ? WHERE vaName = ?',
            [newName, devName],
          );
          break;
        case 'light':
          await txn.rawUpdate(
            'UPDATE light SET divName = ? WHERE lightName = ? ',
            [divName, devName],
          );
          await txn.rawUpdate(
            'UPDATE light SET lightName = ? WHERE lightName = ?',
            [newName, devName],
          );
          break;
        default:
      }
    });
  }

  Future<void> updateDeviceStatus(Device dev, int status) async {
    final db = await initDB();
    String devName =  dev.devName;
    String type = dev.type;
    String divName = dev.divName;
    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE device SET isOn = ? WHERE devName = ? and divName = ?',
        [status, devName, divName],
      );

      switch (type) {
        case 'ac':
          await txn.rawUpdate(
            'UPDATE ac SET isOn = ? WHERE acName = ? and divName = ?',
            [status, devName, divName],
          );
          break;
        case 'virtualAssist':
          await txn.rawUpdate(
            'UPDATE virtualAssist SET isOn = ? WHERE vaName = ? and divName = ?',
            [status, devName, divName],
          );
          break;
        case 'light':
          await txn.rawUpdate(
            'UPDATE light SET isOn = ? WHERE lightName = ? and divName = ?',
            [status, devName, divName],
          );
          break;
        default:
      }
    });
  }

  Future<void> updateDivName(String divName, String oldName) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE division SET divName = ? WHERE divName = ?',
        [divName, oldName],
      );

      await txn.rawUpdate(
        'UPDATE device SET divName = ? WHERE divName = ?',
        [divName, oldName],
      );
      await txn.rawUpdate(
        'UPDATE light SET divName = ? WHERE divName = ?',
        [divName, oldName],
      );
      await txn.rawUpdate(
        'UPDATE ac SET divName = ? WHERE divName = ?',
        [divName, oldName],
      );
      await txn.rawUpdate(
        'UPDATE virtualAssist SET divName = ? WHERE divName = ?',
        [divName, oldName],
      );
    });
  }

  Future<void> updateLightColor(String lightName, String color) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE light SET color = ? WHERE lightName = ?',
        [color, lightName],
      );
    });
  }

  Future<void> updateLightIntensity(String lightName, int intensity) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE light SET intensity = ? WHERE lightName = ?',
        [intensity, lightName],
      );
    });
  }

  Future<void> updateVaVolume(String vaName, int vol) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE virtualAssist SET volume = ? WHERE vaName = ?',
        [vol, vaName],
      );
    });
  }

  Future<void> updateUserHouse(String userId) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE users SET casa = ? WHERE username = ?',
        ["", userId],
      );
    });
  }



  Future<void> updateACAirDirection(String acName, int airDirection) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE ac SET airDirection = ? WHERE acName = ?',
        [airDirection, acName],
      );
    });
  }

  Future<void> updateACMode(String acName, String acMode) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE ac SET acMode = ? WHERE acName = ?',
        [acMode, acName],
      );
    });
  }

  Future<void> updateACTimer(String acName, int acHoursTimer, int acMinutesTimer) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE ac SET acHoursTimer = ? WHERE acName = ?',
        [acHoursTimer, acName],
      );
      await txn.rawUpdate(
        'UPDATE ac SET acMinutesTimer = ? WHERE acName = ?',
        [acMinutesTimer, acName],
      );
    });
  }
  Future<void> updateACSwingMode(AC ac, bool swingMode) async {
    final db = await initDB();

    int newMode = swingMode ? 1 : 0;
    print(newMode);
    print(ac);
    await db.transaction((txn) async {
      if (swingMode) {
        await txn.rawUpdate(
          'UPDATE ac SET swingModeOn = ? WHERE acName = ?',
          [newMode, ac.acName],
        );
      } else {
        await txn.rawUpdate(
          'UPDATE ac SET swingModeOn = ? WHERE acName = ?',
          [newMode, ac.acName],
        );
      }
    });
  }

  Future<bool> createDevice(Device device) async {
    final db = await initDB();

    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM device WHERE divName = ? and devName = ?',
      [device.divName, device.devName],
    );

    if (result.isNotEmpty) {
      print("device with the same name exists");
      return false;
    }

    await db.insert('device', device.toMap());

    switch (device.type) {
      case 'ac':
        db.insert('ac', AC(acName: device.devName, houseName: device.houseName, divName: device.divName, isOn: 0, acMode: "Cool", acHoursTimer: 0, acMinutesTimer: 0, swingModeOn: 0, airDirection: 50, acTemp: 16).toMap());
        print("inserted ac");
        break;
      case 'virtualAssist':
        db.insert("virtualAssist", VirtualAssist(vaName: device.devName, houseName: device.houseName, divName: device.divName, isOn: 0, volume: 0, isPlaying: 0, music: "", isMuted: 0, alarmHours: 0, alarmMinutes: 0).toMap());
        print("inserted virtual");
        break;
      case 'light':
        db.insert("light", Light(lightName: device.devName, houseName: device.houseName, divName: device.divName, isOn: 0, color: "", intensity: 0).toMap());
        print("inserted Light");
        break;
      default:
    }
    return true;
  }


  Future<void> deleteDevice(Device device) async {
    final db = await initDB();

    await db.delete(
      'device',
      where: 'devName = ? and divName = ?',
      whereArgs: [device.devName, device.divName],
    );

    switch (device.type) {
      case 'ac':
        db.delete('ac',
        where: 'acName = ? and divName = ?',
        whereArgs: [device.devName, device.divName]);
        print("deleted ac");
        break;
      case 'virtualAssist':
        db.delete('virtualAssist',
            where: 'vaName = ? and divName = ?',
            whereArgs: [device.devName, device.divName]);
        print("deleted ac");
        break;
      case 'light':
        db.delete('light',
            where: 'lightName = ? and divName = ?',
            whereArgs: [device.devName, device.divName]);
        print("deleted ac");
        break;
      default:
    }

    print('Device ${device.devName} deleted successfully');
  }

  Future<void> deleteDivision(Division div) async {
    final db = await initDB();

    await db.delete(
      'division',
      where: 'divName = ?',
      whereArgs: [div.divName],
    );

    await db.delete(
      'device',
      where: 'divName = ?',
      whereArgs: [div.divName],
    );

    await db.delete('ac',
        where: 'divName = ?',
        whereArgs: [div.divName]);


    await db.delete('virtualAssist',
        where: 'divName = ?',
        whereArgs: [div.divName]);

    await db.delete('light',
        where: 'and divName = ?',
        whereArgs: [div.divName]);

    print('Division ${div.divName} deleted successfully');
  }

  Future<void> updateTemperature(int newTemp, AC ac) async {
    final db = await initDB();

    print(ac);
    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE ac SET acTemp = ? WHERE acName = ?',
        [newTemp, ac.acName],
      );

      final List<Map<String, dynamic>> acList = await txn.rawQuery(
        'SELECT acTemp FROM ac WHERE divName = ? AND isOn = 1',
        [ac.divName],
      );

      if (acList.isEmpty) {
        print("No ACs found in this division");
        return;
      }

      int totalTemp = 0;
      for (var ac in acList) {
        totalTemp += ac['acTemp'] as int;
      }

      double meanTemp = totalTemp / acList.length;
      print("MEAN TEMP: $meanTemp");

      await txn.rawUpdate(
        'UPDATE division SET divTemp = ? WHERE divName = ?',
        [meanTemp.round().toString(), ac.divName],
      );

    });
  }

  Future<void> updateVaAlarm(String vaName, int alarmHours, int alarmMinutes) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE virtualAssist SET alarmHours = ? WHERE vaName = ?',
        [alarmHours, vaName],
      );
      await txn.rawUpdate(
        'UPDATE virtualAssist SET alarmMinutes = ? WHERE vaName = ?',
        [alarmMinutes, vaName],
      );
    });
  }

  Future<void> updateVaMusic(String vaName, String newMusic ) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE virtualAssist SET music = ? WHERE vaName = ?',
        [newMusic, vaName],
      );
    });
  }

  Future<void> updateVaPlayingStatus(String vaName, int isPlaying ) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE virtualAssist SET isPlaying = ? WHERE vaName = ?',
        [isPlaying, vaName],
      );
    });
  }

  Future<void> updateVaMuteStatus(String vaName, int isMuted ) async {
    final db = await initDB();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE virtualAssist SET isMuted = ? WHERE vaName = ?',
        [isMuted, vaName],
      );
    });
  }

  //await txn.execute('CREATE TABLE divRestriction (restrictionName TEXT PRIMARY KEY, username TEXT, divName TEXT)');
  Future<void> updateDivRestriction(String divName, String userName, bool isAdding) async{
    final db = await initDB();
    DivRestriction dr = new DivRestriction(restrictionName: "$userName:$divName", username: userName, divName: divName);
    if(isAdding){
      await db.insert("divRestriction", dr.toMap());
    }else{
      await db.delete(
        "divRestriction",
        where: "restrictionName = ?",
        whereArgs: ["$userName:$divName"]
      );
    }
  }
  
  Future<void> addUserToFamilyWithUserName(String userName, String houseName) async {
    final db = await initDB();

    db.rawUpdate(
      'UPDATE users SET casa = ? WHERE username = ?',
      [houseName, userName],
    );
  }

  Future<void> addUserToFamilyWithEmail(String email, String houseName) async {
    final db = await initDB();

    db.rawUpdate(
      'UPDATE users SET casa = ? WHERE email = ?',
      [houseName, email],
    );
  }

  Future<List<DivRestriction>> getUserRestrictedDivs(String memberName) async {
    final db = await initDB();
    List<Map<String, Object?>> result = await db.query("divRestriction",
      where: "username = ?",
      whereArgs: [memberName]
    );

    List<DivRestriction> dr = result.map((map) => DivRestriction.fromMap(map)).toList();
    return dr;
  }

  //await txn.execute('CREATE TABLE devRestriction (restrictionName TEXT PRIMARY KEY, deviceName TEXT, username TEXT, deviceRoomName TEXT, startingTimeHour INTEGER, startingTimeMinute INTEGER, endTimeHour INTEGER, endTimeMinute INTEGER, isAllDay INTEGER)');
  Future<void> updateDevRestriction(String devName, String userName, String deviceRoomName, int startTimeHour, int startTimeMinute, int endTimeHour, int endTimeMinute, bool isAllDay, bool isAdding) async{
    final db = await initDB();
    DevRestriction dr = DevRestriction(restrictionName: "$userName:$devName", deviceName: devName, username: userName, deviceRoomName: deviceRoomName,
        startingTimeHour: startTimeHour, startingTimeMinute: startTimeMinute, endTimeHour: endTimeHour, endTimeMinute: endTimeMinute, isAllDay: isAllDay);

    if(isAdding){
      await db.insert("devRestriction", dr.toMap());
    }else{
      await db.update("devRestriction", dr.toMap());
    }
  }

  Future<void> deleteDevRestriction(String devRestrictionName) async{
    await db.delete("devRestriction", where: "restrictionName = ?", whereArgs: [devRestrictionName]);
  }

  Future<List<DevRestriction>> getUserRestrictedDevs(String memberName) async{
    final db = await initDB();
    List<Map<String, Object?>> result = await db.query("devRestriction",
        where: "username = ?",
        whereArgs: [memberName]
    );

    List<DevRestriction> dr = result.map((map) => DevRestriction.fromMap(map)).toList();
    return dr;
  }



  //TODO: Clean DB.dart
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
      if (existingTables.contains('devRestriction')) {
        print("DELETANIS A devRestriction");
        await txn.delete('devRestriction');
      }
    });

    print('Table users deleted');
  }






}
