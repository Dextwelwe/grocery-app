import 'dart:io';
import 'package:epicerie/models/grocery.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class Db {
  Db();

  Db._privateConstructor();
  static final Db db = Db._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, 'fav_grocery.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE grocery (id TEXT PRIMARY KEY,
                    name TEXT,
                    date TEXT NOT NULL,
                    items TEXT,
                    completed INTEGER,
                    clients TEXT,
                    favourite INTEGER
                                         )
                                          ''');
  }
  

Future<int> add(Grocery grocery)async{
  Database db1 = await db.database;
  return await db1.insert('grocery', grocery.toMap());
}

Future<List<Grocery>> getFavouriteGrocery()async{
  List<Grocery> listGroceries = [];
  try{
   Database db1 = await db.database;
    final result =
        await db1.rawQuery("SELECT * FROM grocery");  
        if (result.isNotEmpty){
    listGroceries.add(Grocery.fromDatabase(result[0]));
        }
      return listGroceries;
  } on Exception catch(e){
    if (kDebugMode) {
      print(e);
    }
     return listGroceries;
  }
}
Future<void> getAll()async{
  Database db1 = await db.database;
   final result =
        await db1.rawQuery("SELECT * FROM grocery");
  if (kDebugMode) {
    print(result);
  }
}

// 1 epicerie seulement
deleteAll() async {
    Database db1 = await db.database;
    db1.delete('grocery');
  }
}