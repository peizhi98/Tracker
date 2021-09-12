import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracker/model/record.dart';

class TrackerDatabase {
  static final _dbName = 'tracker.db';
  static final _dbVersion = 1;

  static final instance = TrackerDatabase._init();

  TrackerDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _iniDatabaseDirectory();
    return _database!;
  }

  Future<Database> _iniDatabaseDirectory() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _dbName);
    Database db =
        await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    _alterTable(db);
    return db;
  }

  //for development
  Future _alterTable(Database db) async {
    // await db.execute('''
    //     DROP TABLE IF EXISTS $_record
    //     ''');
    // await db.execute('''
    //     CREATE TABLE $_record(
    //     $id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     $datetime DATETIME NOT NULL)
    //     ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
        CREATE TABLE ${Record.TABLE_NAME}(
        ${Record.ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Record.DATE_TIME} DATETIME NOT NULL)
        ''');
  }

  Future<int> insert(DateTime dateTime) async {
    Database db = await instance.database;
    final record = Record(dateTime: dateTime.add(Duration(days: 0)));
    //test
    this.testInsert(dateTime);
    //test
    final id = await db.insert(Record.TABLE_NAME, record.toJson());
    return id;
  }

  Future testInsert(DateTime dateTime) async {
    // Database db = await instance.database;
    // for (int i = 0; i < 30; i++) {
    //   Record testRecord =
    //       Record(dateTime: dateTime.subtract(Duration(days: i + 1)));
    //   await db.insert(Record.TABLE_NAME, testRecord.toJson());
    // }
  }

  Future<List<Record>> queryAll() async {
    Database db = await instance.database;
    final result = await db.query(Record.TABLE_NAME);
    return result.map((json) => Record.fromJson(json)).toList();
  }

  Future<List<Record>> queryDate(DateTime dateTime) async {
    DateTime dayAfter = dateTime.add(Duration(days: 1));
    DateTime start = DateTime(dateTime.year, dateTime.month, dateTime.day);
    DateTime end = DateTime(dayAfter.year, dayAfter.month, dayAfter.day);
    return await queryBetween(start, end);
  }

  Future<List<Record>> queryBetween(
      DateTime includeFrom, DateTime excludeTo) async {
    Database db = await instance.database;
    final result = await db.rawQuery('''SELECT * FROM ${Record.TABLE_NAME} 
        WHERE ${Record.DATE_TIME} >= '${includeFrom.toIso8601String()}' AND ${Record.DATE_TIME} < '${excludeTo.toIso8601String()}'
        ORDER BY ${Record.DATE_TIME}
        ''');
    return result.map((json) => Record.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(Record.TABLE_NAME, where: ' ${Record.ID}=?', whereArgs: [id]);
  }
}
