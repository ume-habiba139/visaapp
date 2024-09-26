import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = await getDatabasesPath();
    final String databaseName = 'SharedDatabase.db';
    final String fullPath = join(path, databaseName);

    return await openDatabase(
      fullPath,
      version: 1,
      onCreate: (db, version) async {
        // Create the users table
        await db.execute(''' 
          CREATE TABLE users(
            firstName TEXT,
            lastName TEXT,
            email TEXT UNIQUE,
            password TEXT,
            confirmPassword TEXT,
            age INTEGER,
            gender TEXT
          )
        ''');

        // Create the visa_info table
        await db.execute(''' 
          CREATE TABLE visa_info(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            visaType TEXT,
            issueDate TEXT,
            expirationDate TEXT,
            authority TEXT,
            description TEXT,
            imagePath TEXT,
            userEmail TEXT
          )
        ''');

        // Create the apply_visa table
        await db.execute(''' 
  CREATE TABLE apply_visa(
    fullName TEXT,
    dateofBirth TEXT,
    PassportNumber TEXT UNIQUE,
    EmailAddress TEXT UNIQUE,
    PhoneNumber TEXT UNIQUE,
    CountryofResidence TEXT,
    Additional TEXT,
     visaType TEXT,
    imagePath TEXT
  )
''');

      },
    );
  }

  Future<void> applyVisainfo(ApplyVisa apply) async {
    final db = await database;
    try {
      await db.insert(
        'apply_visa',
        apply.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting apply visa info: $e");
    }
  }



  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertVisaInfo(VisaInfo visaInfo) async {
    final db = await database;
    await db.insert(
      'visa_info',
      visaInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);

    if (res.isNotEmpty) {
      return res.first;
    } else {
      return null;
    }
  }

  Future<int> updateVisaInfo(VisaInfo visaInfo) async {
    final db = await database;
    return await db.update(
      'visa_info',
      visaInfo.toMap(),
      where: 'id = ?',
      whereArgs: [visaInfo.id],
    );
  }

  Future<Map<String, dynamic>?> getAdminByEmail(String email) async {
    final db = await database;
    final res = await db.query('admin', where: 'adminEmail = ?', whereArgs: [email]);

    if (res.isNotEmpty) {
      return res.first;
    } else {
      return null;
    }
  }



  Future<List<ApplyVisa>> getapplyVisaInfo() async {
    final db = await database;

    // Querying the database to get all entries from the 'apply_visa' table
    final List<Map<String, dynamic>> maps = await db.query('apply_visa');

    // Debug to check the number of records fetched
    print("Number of visa applications fetched: ${maps.length}");

    // Generating a list of ApplyVisa objects from the retrieved maps
    return List.generate(maps.length, (i) {
      return ApplyVisa(
        fullName: maps[i]['fullName'] ?? '',
        dateofBirth: maps[i]['dateofBirth'] ?? '',
        PassportNumber: maps[i]['PassportNumber'] ?? '',
        EmailAddress: maps[i]['EmailAddress'] ?? '',
        PhoneNumber: maps[i]['PhoneNumber'] ?? '',
        CountryofResidence: maps[i]['CountryofResidence'] ?? '',
        Additional: maps[i]['Additional'] ?? '',
        visaType: maps[i]['visaType'] ?? '',
        imagePath: maps[i]['imagePath'] ?? '',
      );
    });
  }





  Future<List<VisaInfo>> getVisaInfoList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('visa_info');

    return List.generate(maps.length, (i) {
      return VisaInfo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        visaType: maps[i]['visaType'],
        issueDate: maps[i]['issueDate'],
        expirationDate: maps[i]['expirationDate'],
        authority: maps[i]['authority'],
        description: maps[i]['description'],
        imagePath: maps[i]['imagePath'],
        userEmail: maps[i]['userEmail'],
      );
    });
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

// User class
class User {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final int age;
  final String gender;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.age,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'age': age,
      'gender': gender,
    };
  }
}

// Admin class
class Admin {
  final String adminName;
  final String adminEmail;
  final String password;

  Admin({
    required this.adminName,
    required this.adminEmail,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'adminName': adminName,
      'adminEmail': adminEmail,
      'password': password,
    };
  }
}

// VisaInfo class
class VisaInfo {
  final int? id;
  final String title;
  final String visaType;
  final String issueDate;
  final String expirationDate;
  final String authority;
  final String description;
  final String? imagePath;
  final String? userEmail;

  VisaInfo({
    this.id,
    required this.title,
    required this.visaType,
    required this.issueDate,
    required this.expirationDate,
    required this.authority,
    required this.description,
    required this.imagePath,
    required this.userEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'visaType': visaType,
      'issueDate': issueDate,
      'expirationDate': expirationDate,
      'authority': authority,
      'description': description,
      'imagePath': imagePath,
      'userEmail': userEmail,
    };
  }
}

// ApplyVisa class
class ApplyVisa {
  final String fullName;
  final String dateofBirth;
  final String PassportNumber;
  final String EmailAddress;
  final String PhoneNumber;
  final String CountryofResidence;
  final String Additional;
  final String visaType;
  final String? imagePath;

  ApplyVisa({
    required this.fullName,
    required this.dateofBirth,
    required this.PassportNumber,
    required this.EmailAddress,
    required this.PhoneNumber,
    required this.CountryofResidence,
    required this.Additional,
    required this.visaType,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'dateofBirth': dateofBirth,
      'PassportNumber': PassportNumber,
      'EmailAddress': EmailAddress,
      'PhoneNumber': PhoneNumber,
      'CountryofResidence': CountryofResidence,
      'Additional': Additional,
      'visaType':visaType,
      'imagePath': imagePath,
    };
  }
}
