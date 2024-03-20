import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tabapplication/model/mjpt/masterdata_response.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();



  static final _databaseName = 'myDatabase.db';
  static final _databaseVersion = 1;

  static final masterDataTable = 'masterData';

  // MASTER DATA

  static const String MasterdataId = 'id';
  static const String MasterdataEmailId = 'email_id';
  static const String MasterdataRoName = 'ro_name';
  static const String MasterdataGender = 'gender';
  static const String MasterdataGroupName = 'group_name';
  static const String MasterdataExtNo = 'ext_no';
  static const String MasterdataPhotopath = 'photopath';
  static const String MasterdataEmployeeId = 'employee_Id';
  static const String MasterdataEmpName = 'emp_name';
  static const String MasterdataMobileNo = 'mobile_no';
  static const String MasterdataBloodGroup = 'blood_group';
  static const String MasterdataEmpDesignation = 'emp_designation';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) async {
      //Table creation to Save OfficeCoordinates Location Master
      await db.execute('''
            CREATE TABLE $masterDataTable (
              $MasterdataEmailId TEXT NOT NULL,
              $MasterdataRoName TEXT NOT NULL,
              $MasterdataGender TEXT NOT NULL,
              $MasterdataGroupName INTEGER NOT NULL,
              $MasterdataExtNo TEXT NOT NULL,
              $MasterdataPhotopath INTEGER NOT NULL,
              $MasterdataEmployeeId TEXT NOT NULL,
              $MasterdataEmpName TEXT NOT NULL,
              $MasterdataMobileNo TEXT NOT NULL,
              $MasterdataBloodGroup TEXT NOT NULL,
              $MasterdataEmpDesignation TEXT NOT NULL
            )
          ''');
    });
  }

//Method for retrieving officeCoordinates from table
  Future<List<MasterData>> getMasterData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(masterDataTable);
    return List.generate(maps.length, (i) {
      return MasterData(
        emailId: maps[i]['email_id'],
        roName: maps[i]['ro_name'],
        gender: maps[i]['gender'],
        groupName: maps[i]['group_name'],
        extNo: maps[i]['ext_no'],
        photopath: maps[i]['photopath'],
        employeeId: maps[i]['employee_Id'],
        empName: maps[i]['emp_name'],
        mobileNo: maps[i]['mobile_no'],
        bloodGroup: maps[i]['blood_group'],
        empDesignation: maps[i]['emp_designation'],
      );
    });
  }

//Insertion of OfficeCoordinates to db
  Future<int> insertOfficeCoordinates(MasterData officeCoordinates) async {
    var dbClient = await database;
    return await dbClient.insert('masterData', officeCoordinates.toMap());
  }
   Future<List<Map>> getTableData(String tableName) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tableName');
  }

  Future<int> delete(String tablename) async {
    Database db = await database;
    return await db.delete(tablename);
  }

  Future<bool> isTableExists(String tableName) async {
    final db = await database;
    var result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [tableName]);

    return result.isNotEmpty;
  }
   Future<int> insertInto(Map<String, dynamic> row, String tableName) async {
    Database? db = await instance.database;
    return await db.insert(tableName, row);
  }
   
}
